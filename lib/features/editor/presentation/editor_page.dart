import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/errors/app_failure.dart';
import '../../../core/errors/failure_messages.dart';
import '../../../core/providers.dart';
import '../../../core/storage/app_database.dart';
import '../../../core/storage/sync_enums.dart';
import '../../../core/utils/debouncer.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../../auth/presentation/session_controller.dart';
import '../../file_browser/data/notes_repository.dart';
import '../../settings/presentation/settings_controller.dart';
import '../../sync/data/sync_coordinator.dart';
import '../../sync/domain/sync_result.dart';
import '../data/reading_state_store.dart';
import 'find_in_note.dart';
import 'mode_scroll_sync.dart';
import 'wiki_link_markdown.dart';

/// 편집 화면 저장 상태.
enum EditorStatus {
  saved,
  savingLocal,
  pendingSync,
  syncing,
  offline,
  conflict,
  syncFailed,
}

class EditorPage extends ConsumerStatefulWidget {
  const EditorPage({super.key, required this.fileId, this.resume = false});

  final String fileId;

  /// 앱 재시작 후 "이어서 보기"로 열린 경우. 보던 모드(보기/편집)까지 복원한다.
  final bool resume;

  @override
  ConsumerState<EditorPage> createState() => _EditorPageState();
}

class _EditorPageState extends ConsumerState<EditorPage>
    with WidgetsBindingObserver {
  final _textController = FindHighlightController();
  final _saveDebouncer = Debouncer(const Duration(milliseconds: 600));
  Debouncer? _syncDebouncer;

  // 읽던 위치 기억: 보기/편집 모드 각각의 스크롤 위치를 따로 추적한다.
  final _previewScroll = ResumableScrollController();
  final _editScroll = ResumableScrollController();
  final _positionDebouncer = Debouncer(const Duration(milliseconds: 400));
  late final ReadingStateStore _readingStore;

  // dispose()에서는 ref를 쓸 수 없어, 마지막 저장에 필요한 것을 미리 잡아 둔다.
  late final NotesRepository _notes;
  VaultConfig? _openedVault;
  String _lastSavedPosition = '';

  // 문서에서 찾기
  final _findField = TextEditingController();
  final _editFieldKey = GlobalKey();

  // 보기↔편집 전환 시 읽던 곳 맞추기
  final _previewAreaKey = GlobalKey();
  final _previewBodyKey = GlobalKey();

  /// 전환 직후 위치를 맞추는 한 프레임 동안 true. 그동안은 내용을 숨겨
  /// 엉뚱한 위치가 잠깐 보이는 깜빡임을 막는다.
  bool _aligning = false;
  bool _finding = false;
  String _findQuery = '';
  int _findCount = 0;
  int _findIndex = -1;

  NoteFile? _file;
  EditorStatus _status = EditorStatus.saved;

  /// 기본은 보기(미리보기) 모드. 빈 노트는 편집 모드로 시작한다.
  bool _preview = true;
  bool _loading = true;
  String? _loadError;
  String _lastSavedText = '';

  VaultConfig? get _vault => ref.read(sessionControllerProvider).value?.vault;

  AppLocalizations get _l10n => AppLocalizations.of(context);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _readingStore = ref.read(readingStateStoreProvider);
    _notes = ref.read(notesRepositoryProvider);
    _previewScroll.addListener(_onScrolled);
    _editScroll.addListener(_onScrolled);
    Future.microtask(_open);
  }

  void _onScrolled() => _positionDebouncer.run(_savePosition);

  /// 현재 스크롤 위치·모드를 저장한다. 앱이 언제 죽어도 이어 볼 수 있게
  /// 스크롤이 멈출 때마다, 그리고 백그라운드 전환·화면 종료 시 호출된다.
  void _savePosition() {
    if (_loading || _loadError != null) return;
    final position = ReadingPosition(
      previewOffset: _previewScroll.lastOffset,
      editOffset: _editScroll.lastOffset,
      preview: _preview,
    );
    final encoded = position.encode();
    if (encoded == _lastSavedPosition) return;
    _lastSavedPosition = encoded;
    _readingStore.savePosition(widget.fileId, position);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _saveDebouncer.cancel();
    _syncDebouncer?.cancel();
    _positionDebouncer.cancel();
    _savePosition();
    // 목록으로 돌아갔으니 다음 실행 때는 이 노트를 자동으로 열지 않는다.
    _readingStore.clearLastOpenIf(widget.fileId);
    _previewScroll.dispose();
    _editScroll.dispose();
    // 마지막 변경사항을 유실 없이 저장 (fire-and-forget)
    final vault = _openedVault;
    final text = _textController.text;
    if (vault != null && text != _lastSavedText) {
      _notes.saveDraft(vault, widget.fileId, text).ignore();
    }
    _textController.dispose();
    _findField.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // 백그라운드 전환 시 로컬 저장을 즉시 수행한다.
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      _saveDebouncer.cancel();
      _persistIfChanged();
      _positionDebouncer.cancel();
      _savePosition();
    }
  }

  Future<void> _open() async {
    final vault = _vault;
    if (vault == null) return;
    _openedVault = vault;
    try {
      final note = await ref
          .read(notesRepositoryProvider)
          .openFile(vault, widget.fileId);
      final saved = await _readingStore.position(widget.fileId);
      if (!mounted) return;
      _readingStore.setLastOpen(widget.fileId);
      setState(() {
        if (saved != null) {
          _previewScroll.lastOffset = saved.previewOffset;
          _editScroll.lastOffset = saved.editOffset;
          _lastSavedPosition = saved.encode();
          // 평소엔 보기 모드로 열고, 이어서 보기일 때만 보던 모드를 복원한다.
          if (widget.resume) _preview = saved.preview;
        }
        _file = note.file;
        _textController.text = note.content;
        _lastSavedText = note.content;
        _loading = false;
        // 내용이 없는 새 노트는 바로 쓸 수 있게 편집 모드로 연다.
        if (note.content.trim().isEmpty) _preview = false;
        _status = switch (note.status) {
          SyncStatus.conflict => EditorStatus.conflict,
          SyncStatus.failed => EditorStatus.syncFailed,
          SyncStatus.pendingUpload || SyncStatus.localOnly =>
            note.fromLocal ? EditorStatus.pendingSync : EditorStatus.saved,
          _ => EditorStatus.saved,
        };
      });
    } on AppFailure catch (e) {
      if (mounted) {
        setState(() {
          _loading = false;
          _loadError = failureMessage(context, e);
        });
      }
    }
  }

  // ---------- 문서에서 찾기 ----------

  void _openFind() => setState(() => _finding = true);

  void _closeFind() {
    _findField.clear();
    _textController.setHighlights(const [], -1);
    setState(() {
      _finding = false;
      _findQuery = '';
      _findCount = 0;
      _findIndex = -1;
    });
  }

  void _onFindQueryChanged(String query) {
    setState(() => _findQuery = query);
    // 보기 모드는 PreviewFindLayer가 렌더링 결과에서 직접 찾는다.
    if (!_preview) _refreshEditFind(fromViewport: true);
  }

  void _findStep(int delta) {
    if (_findCount == 0) return;
    final next = (_findIndex + delta) % _findCount;
    setState(() => _findIndex = next < 0 ? next + _findCount : next);
    if (!_preview) {
      _textController.setHighlights(_textController.matches, _findIndex);
      _revealEditMatch();
    }
  }

  void _onPreviewFindResults(int count, int index) {
    if (!mounted || (count == _findCount && index == _findIndex)) return;
    setState(() {
      _findCount = count;
      _findIndex = index;
    });
  }

  RenderEditable? get _renderEditable {
    RenderEditable? found;
    void visit(Element element) {
      if (found != null) return;
      final renderObject = element.renderObject;
      if (element is RenderObjectElement && renderObject is RenderEditable) {
        found = renderObject;
        return;
      }
      element.visitChildren(visit);
    }

    _editFieldKey.currentContext?.visitChildElements(visit);
    return found;
  }

  /// 편집 모드 찾기 결과를 다시 계산한다. [fromViewport]면 지금 보고 있는
  /// 위치 이후의 첫 항목을, 아니면 기존 선택을 유지한다.
  void _refreshEditFind({required bool fromViewport}) {
    final matches = findMatches(_textController.text, _findQuery);
    int index;
    if (matches.isEmpty) {
      index = -1;
    } else if (fromViewport) {
      final editable = _renderEditable;
      final topOffset = editable == null || !editable.hasSize
          ? 0
          : editable
                .getPositionForPoint(editable.localToGlobal(Offset.zero))
                .offset;
      index = firstMatchFrom(matches, (m) => m.start >= topOffset);
    } else {
      index = _findIndex.clamp(0, matches.length - 1);
    }
    _textController.setHighlights(matches, index);
    setState(() {
      _findCount = matches.length;
      _findIndex = index;
    });
    if (fromViewport) _revealEditMatch();
  }

  void _revealEditMatch() {
    final editable = _renderEditable;
    final matches = _textController.matches;
    if (editable == null ||
        !editable.hasSize ||
        !_editScroll.hasClients ||
        _findIndex < 0 ||
        _findIndex >= matches.length) {
      return;
    }
    // 캐럿 사각형은 화면(뷰포트) 기준이라 현재 스크롤 값을 더해 준다.
    final caret = editable.getLocalRectForCaret(
      TextPosition(offset: matches[_findIndex].start),
    );
    final scrolled = _editScroll.position.pixels;
    revealInScrollView(
      _editScroll,
      caret.top + scrolled,
      caret.bottom + scrolled,
    );
  }

  static double _fraction(ScrollController controller) {
    if (!controller.hasClients) return 0;
    final position = controller.position;
    final max = position.maxScrollExtent;
    return max <= 0 ? 0 : (position.pixels / max).clamp(0.0, 1.0);
  }

  static void _jumpClamped(ScrollController controller, double target) {
    if (!controller.hasClients) return;
    final position = controller.position;
    controller.jumpTo(
      target.clamp(position.minScrollExtent, position.maxScrollExtent),
    );
  }

  /// 보기↔편집을 전환하면서, 읽던 곳이 반대 모드에서도 같은 자리에 오게 한다.
  ///
  /// 두 모드는 글자 크기와 마크다운 기호 유무가 달라 스크롤 값이 서로 통하지
  /// 않는다. 그래서 전환 직전 화면 맨 위 근처의 글자를 단서로 잡아 두고,
  /// 전환 후 반대 모드에서 그 글자를 찾아 스크롤한다. 못 찾으면 진행률로 맞춘다.
  void _toggleMode() {
    final toEdit = _preview;
    var anchors = const <ScrollAnchor>[];
    var fraction = 0.0;

    if (toEdit) {
      fraction = _fraction(_previewScroll);
      final area = _previewAreaKey.currentContext?.findRenderObject();
      if (area is RenderBox && area.hasSize) anchors = previewAnchors(area);
    } else {
      fraction = _fraction(_editScroll);
      final editable = _renderEditable;
      if (editable != null && editable.hasSize) {
        final top = editable
            .getPositionForPoint(editable.localToGlobal(Offset.zero))
            .offset;
        anchors = editAnchors(
          _textController.text,
          top,
          editable.size.height,
          (offset) =>
              editable.getLocalRectForCaret(TextPosition(offset: offset)).top,
        );
      }
    }

    setState(() {
      _preview = !_preview;
      _aligning = true;
    });

    // 반대 모드가 배치된 뒤에야 글자 위치를 알 수 있다.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (toEdit) {
        _alignEdit(anchors, fraction);
      } else {
        _alignPreview(anchors, fraction);
      }
      setState(() => _aligning = false);
      _savePosition();
      if (_finding && !_preview) _refreshEditFind(fromViewport: true);
    });
  }

  void _alignEdit(List<ScrollAnchor> anchors, double fraction) {
    final editable = _renderEditable;
    if (editable == null || !editable.hasSize || !_editScroll.hasClients) {
      return;
    }
    final match = locateInSource(_textController.text, anchors, fraction);
    if (match == null) {
      _jumpClamped(
        _editScroll,
        fraction * _editScroll.position.maxScrollExtent,
      );
      return;
    }
    final caret = editable.getLocalRectForCaret(
      TextPosition(offset: match.offset),
    );
    _jumpClamped(
      _editScroll,
      caret.top + _editScroll.position.pixels - match.dy,
    );
  }

  void _alignPreview(List<ScrollAnchor> anchors, double fraction) {
    final body = _previewBodyKey.currentContext?.findRenderObject();
    if (body is! RenderBox || !body.hasSize || !_previewScroll.hasClients) {
      return;
    }
    final target = locateInPreview(body, anchors, fraction);
    _jumpClamped(
      _previewScroll,
      target == null
          ? fraction * _previewScroll.position.maxScrollExtent
          // 본문 위 여백(16)만큼 스크롤 콘텐츠 좌표가 밀려 있다.
          : target + 16,
    );
  }

  PreferredSizeWidget _buildFindBar(BuildContext context) {
    final theme = Theme.of(context);
    return AppBar(
      leading: IconButton(
        tooltip: _l10n.findClose,
        icon: const Icon(Icons.close),
        onPressed: _closeFind,
      ),
      titleSpacing: 0,
      title: TextField(
        controller: _findField,
        autofocus: true,
        textInputAction: TextInputAction.search,
        onChanged: _onFindQueryChanged,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: _l10n.findHint,
        ),
      ),
      actions: [
        if (_findQuery.isNotEmpty)
          Center(
            child: Text(
              '${_findIndex + 1}/$_findCount',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: _findCount == 0
                    ? theme.colorScheme.error
                    : theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        IconButton(
          tooltip: _l10n.findPrevious,
          icon: const Icon(Icons.keyboard_arrow_up),
          onPressed: _findCount == 0 ? null : () => _findStep(-1),
        ),
        IconButton(
          tooltip: _l10n.findNext,
          icon: const Icon(Icons.keyboard_arrow_down),
          onPressed: _findCount == 0 ? null : () => _findStep(1),
        ),
      ],
    );
  }

  Widget _buildPreview(BuildContext context) {
    final builders = {
      'wikilink': WikiLinkBuilder(
        colorScheme: Theme.of(context).colorScheme,
        onTap: _openWikiLink,
      ),
    };
    final Widget content;
    if (!_finding && !_aligning) {
      content = Markdown(
        data: _textController.text,
        controller: _previewScroll,
        padding: const EdgeInsets.all(16),
        inlineSyntaxes: [WikiLinkSyntax()],
        builders: builders,
      );
    } else {
      // 찾기 중이거나 편집에서 막 넘어온 프레임에는 글자 위치를 알아야 하므로
      // 문서 전체를 한 번에 배치한다. 블록 구성이 같아 스크롤 위치는 그대로
      // 이어진다.
      final Widget body = KeyedSubtree(
        key: _previewBodyKey,
        child: MarkdownBody(
          data: _textController.text,
          inlineSyntaxes: [WikiLinkSyntax()],
          builders: builders,
        ),
      );
      content = SingleChildScrollView(
        controller: _previewScroll,
        padding: const EdgeInsets.all(16),
        child: _finding
            ? PreviewFindLayer(
                query: _findQuery,
                data: _textController.text,
                index: _findIndex,
                scrollController: _previewScroll,
                topInset: 16,
                onResults: _onPreviewFindResults,
                child: body,
              )
            : body,
      );
    }
    // 보기 모드에서도 길게 눌러 글자를 선택·복사할 수 있다.
    return SelectionArea(
      child: KeyedSubtree(key: _previewAreaKey, child: content),
    );
  }

  void _onChanged(String text) {
    if (_status != EditorStatus.conflict) {
      setState(() => _status = EditorStatus.savingLocal);
    }
    if (_finding) _refreshEditFind(fromViewport: false);
    _saveDebouncer.run(_persistIfChanged);
  }

  Future<void> _persistIfChanged() async {
    final vault = _vault;
    final text = _textController.text;
    if (vault == null || text == _lastSavedText) {
      if (mounted && _status == EditorStatus.savingLocal) {
        setState(() => _status = EditorStatus.saved);
      }
      return;
    }
    try {
      await ref
          .read(notesRepositoryProvider)
          .saveDraft(vault, widget.fileId, text);
      _lastSavedText = text;
      if (mounted) {
        setState(() {
          if (_status != EditorStatus.conflict) {
            _status = EditorStatus.pendingSync;
          }
        });
        _scheduleAutoSync();
      }
    } on AppFailure {
      if (mounted) setState(() => _status = EditorStatus.syncFailed);
    }
  }

  void _scheduleAutoSync() {
    final settings = ref.read(settingsControllerProvider);
    if (!settings.autoSyncEnabled) return;
    _syncDebouncer ??= Debouncer(
      Duration(seconds: settings.autoSyncDelaySeconds),
    );
    _syncDebouncer!.run(() => _sync(manual: false));
  }

  Future<void> _sync({required bool manual}) async {
    final vault = _vault;
    if (vault == null || _status == EditorStatus.conflict) return;
    final online = ref.read(connectivityProvider).value ?? true;
    if (!online) {
      if (mounted) setState(() => _status = EditorStatus.offline);
      return;
    }
    // 현재 편집 내용을 먼저 로컬 저장
    _saveDebouncer.cancel();
    await _persistIfChanged();

    if (mounted) setState(() => _status = EditorStatus.syncing);
    final result = await ref
        .read(syncCoordinatorProvider)
        .syncFile(vault, widget.fileId);
    if (!mounted) return;
    setState(() {
      _status = switch (result) {
        SyncResult.uploaded || SyncResult.upToDate => EditorStatus.saved,
        SyncResult.conflict => EditorStatus.conflict,
        SyncResult.failed => EditorStatus.syncFailed,
        SyncResult.deleted || SyncResult.skipped => _status,
      };
    });
    if (result == SyncResult.conflict && manual) {
      _openConflict();
    }
  }

  /// 미리보기에서 [[위키링크]] 칩을 탭하면 해당 노트로 이동한다.
  Future<void> _openWikiLink(String target) async {
    final vault = _vault;
    if (vault == null) return;
    final file = await ref
        .read(notesRepositoryProvider)
        .findByWikiName(vault, target);
    if (!mounted) return;
    if (file == null) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(_l10n.wikiLinkNotFound(target))));
      return;
    }
    if (file.id == widget.fileId) return; // 자기 자신이면 무시
    await context.push('/editor?fileId=${file.id}');
    // 링크로 열었던 노트에서 돌아왔으니 다시 이 노트가 "보던 문서"다.
    if (mounted) _readingStore.setLastOpen(widget.fileId);
  }

  /// 선택 텍스트 툴바를 직접 구성한다.
  ///
  /// 1) "전체 선택"을 누르면 안드로이드 기본 동작은 선택만 갱신하고 툴바를
  ///    다시 띄우지 않아 곧바로 복사·잘라내기를 못 한다. 선택 반영 다음
  ///    프레임에 툴바를 강제로 다시 열어 해결한다.
  /// 2) 전체 선택 상태에서는 선택 영역이 화면 아래까지 걸쳐 툴바가 키보드에
  ///    가려지므로, 앵커를 화면 상단으로 옮겨 항상 잘 보이게 한다. 상단으로
  ///    옮기면 ⋮(더보기) 목록도 아래로 펼칠 공간이 충분해, 번역·AI 앱이
  ///    많아도 Flutter 기본 오버플로 메뉴가 그대로 잘 보인다.
  Widget _buildContextMenu(
    BuildContext context,
    EditableTextState editableTextState,
  ) {
    final value = editableTextState.textEditingValue;
    final selection = value.selection;
    final isSelectAll =
        selection.isValid &&
        selection.start == 0 &&
        selection.end == value.text.length &&
        value.text.isNotEmpty;

    // "전체 선택" 버튼만 눌렀을 때 툴바를 다시 열도록 감싸고, 나머지 항목은
    // 그대로 둔다. 넘치는 항목은 Flutter 기본 오버플로(⋮)가 처리한다.
    final items = editableTextState.contextMenuButtonItems.map((item) {
      if (item.type != ContextMenuButtonType.selectAll) return item;
      return ContextMenuButtonItem(
        label: item.label,
        type: item.type,
        onPressed: () {
          item.onPressed?.call();
          Future.delayed(const Duration(milliseconds: 50), () {
            if (editableTextState.mounted) editableTextState.showToolbar();
          });
        },
      );
    }).toList();

    // 전체 선택 시에는 툴바를 앱바 바로 아래(화면 상단)에 고정한다.
    final TextSelectionToolbarAnchors anchors;
    if (isSelectAll) {
      final media = MediaQuery.of(context);
      final topY = media.viewPadding.top + kToolbarHeight + 12;
      anchors = TextSelectionToolbarAnchors(
        primaryAnchor: Offset(media.size.width / 2, topY),
      );
    } else {
      anchors = editableTextState.contextMenuAnchors;
    }

    return AdaptiveTextSelectionToolbar.buttonItems(
      anchors: anchors,
      buttonItems: items,
    );
  }

  Future<void> _openConflict() async {
    await context.push('/conflict?fileId=${widget.fileId}');
    if (mounted) {
      setState(() => _loading = true);
      await _open();
    }
  }

  String _statusLabel(EditorStatus status) => switch (status) {
    EditorStatus.saved => _l10n.statusSaved,
    EditorStatus.savingLocal => _l10n.statusSavingLocal,
    EditorStatus.pendingSync => _l10n.statusPendingSync,
    EditorStatus.syncing => _l10n.statusSyncing,
    EditorStatus.offline => _l10n.statusOffline,
    EditorStatus.conflict => _l10n.statusConflict,
    EditorStatus.syncFailed => _l10n.statusSyncFailed,
  };

  Color _statusColor(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return switch (_status) {
      EditorStatus.conflict || EditorStatus.syncFailed => scheme.error,
      EditorStatus.offline => scheme.tertiary,
      _ => scheme.onSurfaceVariant,
    };
  }

  @override
  Widget build(BuildContext context) {
    final file = _file;
    final dirPath = () {
      if (file == null) return '';
      final idx = file.path.lastIndexOf('/');
      return idx < 0 ? '/' : '/${file.path.substring(0, idx)}';
    }();

    return PopScope(
      // 찾기 중 뒤로 가기는 화면을 닫지 않고 찾기만 닫는다.
      canPop: !_finding,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && _finding) _closeFind();
      },
      child: Scaffold(
        appBar: _finding
            ? _buildFindBar(context)
            : AppBar(
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      file?.name ?? '…',
                      style: const TextStyle(fontSize: 16),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '$dirPath · ${_statusLabel(_status)}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: _statusColor(context),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                actions: [
                  IconButton(
                    tooltip: _preview
                        ? _l10n.editTooltip
                        : _l10n.previewTooltip,
                    icon: Icon(
                      _preview
                          ? Icons.edit_outlined
                          : Icons.visibility_outlined,
                    ),
                    onPressed: _toggleMode,
                  ),
                  IconButton(
                    tooltip: _l10n.syncNow,
                    icon: const Icon(Icons.sync),
                    onPressed: () => _sync(manual: true),
                  ),
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      switch (value) {
                        case 'find':
                          _openFind();
                        case 'keyboard':
                          FocusScope.of(context).unfocus();
                        case 'conflict':
                          _openConflict();
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'find',
                        child: Text(_l10n.findInNote),
                      ),
                      PopupMenuItem(
                        value: 'keyboard',
                        child: Text(_l10n.closeKeyboard),
                      ),
                      if (_status == EditorStatus.conflict)
                        PopupMenuItem(
                          value: 'conflict',
                          child: Text(_l10n.resolveConflict),
                        ),
                    ],
                  ),
                ],
              ),
        body: SafeArea(
          child: _loading
              ? const Center(child: CircularProgressIndicator())
              : _loadError != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(_loadError!),
                  ),
                )
              : Column(
                  children: [
                    if (_status == EditorStatus.conflict)
                      MaterialBanner(
                        content: Text(_l10n.conflictBanner),
                        leading: const Icon(Icons.warning_amber),
                        actions: [
                          TextButton(
                            onPressed: _openConflict,
                            child: Text(_l10n.resolveConflict),
                          ),
                        ],
                      ),
                    Expanded(
                      child: Opacity(
                        opacity: _aligning ? 0 : 1,
                        child: _preview
                            ? _buildPreview(context)
                            : Padding(
                                // 편집 캔버스는 키보드 위까지 자연스럽게 채운다.
                                // 전체 선택 시 툴바 가림 문제는 상단 앵커로
                                // 해결하므로 하단에 별도 여백을 두지 않는다.
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                child: TextField(
                                  key: _editFieldKey,
                                  controller: _textController,
                                  scrollController: _editScroll,
                                  onChanged: _onChanged,
                                  maxLines: null,
                                  expands: true,
                                  textAlignVertical: TextAlignVertical.top,
                                  keyboardType: TextInputType.multiline,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    height: 1.5,
                                  ),
                                  contextMenuBuilder: _buildContextMenu,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: _l10n.memoHint,
                                  ),
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
