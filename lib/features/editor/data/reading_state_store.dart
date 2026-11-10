import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers.dart';
import '../../../core/storage/app_database.dart';

/// 노트 하나의 읽던 위치.
class ReadingPosition {
  const ReadingPosition({
    this.previewOffset = 0,
    this.editOffset = 0,
    this.preview = true,
  });

  /// 보기(미리보기) 모드 스크롤 위치(px).
  final double previewOffset;

  /// 편집 모드 스크롤 위치(px).
  final double editOffset;

  /// 마지막으로 보던 모드가 보기 모드였는지.
  final bool preview;

  String encode() => jsonEncode({
    'p': previewOffset,
    'e': editOffset,
    'm': preview ? 'p' : 'e',
  });

  static ReadingPosition? decode(String? raw) {
    if (raw == null) return null;
    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      return ReadingPosition(
        previewOffset: (map['p'] as num?)?.toDouble() ?? 0,
        editOffset: (map['e'] as num?)?.toDouble() ?? 0,
        preview: map['m'] != 'e',
      );
    } on Object {
      return null;
    }
  }
}

/// "보던 문서 · 보던 위치"를 기억한다.
///
/// - 마지막으로 열어둔 노트: 편집 화면이 떠 있는 동안만 기록되고, 사용자가
///   목록으로 돌아가면 지워진다. 앱이 꺼졌다 켜지면 그 노트를 다시 연다.
/// - 노트별 스크롤 위치: 노트를 다시 열 때마다 복원한다.
class ReadingStateStore {
  ReadingStateStore(this._db);

  static const _kLastOpen = 'last_open_file_id';
  static const _kPositionPrefix = 'reading_pos:';

  final AppDatabase _db;

  String? _lastOpen;
  bool _resumeTaken = false;

  /// 지금 화면에 떠 있는 노트를 기록한다.
  void setLastOpen(String fileId) {
    if (_lastOpen == fileId) return;
    _lastOpen = fileId;
    _db.setSetting(_kLastOpen, fileId);
  }

  /// [fileId] 편집 화면이 닫혔을 때 호출한다. 그 사이 다른 노트가 기록됐다면
  /// (위키링크로 이동 후 복귀 등) 건드리지 않는다.
  void clearLastOpenIf(String fileId) {
    if (_lastOpen != fileId) return;
    _lastOpen = null;
    _db.deleteSetting(_kLastOpen);
  }

  /// 앱 시작 후 이어서 열 노트 id. 프로세스당 한 번만 값을 돌려준다.
  /// 노트가 더 이상 없거나 다른 Vault의 것이면 null.
  Future<String?> takeResumeTarget(String vaultId) async {
    if (_resumeTaken) return null;
    _resumeTaken = true;
    final fileId = await _db.getSetting(_kLastOpen);
    if (fileId == null) return null;
    final file = await _db.getFile(fileId);
    if (file == null || file.vaultId != vaultId || file.isDeletedLocally) {
      await _db.deleteSetting(_kLastOpen);
      return null;
    }
    return fileId;
  }

  Future<ReadingPosition?> position(String fileId) async =>
      ReadingPosition.decode(await _db.getSetting('$_kPositionPrefix$fileId'));

  Future<void> savePosition(String fileId, ReadingPosition position) =>
      _db.setSetting('$_kPositionPrefix$fileId', position.encode());
}

final readingStateStoreProvider = Provider<ReadingStateStore>(
  (ref) => ReadingStateStore(ref.watch(databaseProvider)),
);

/// 마지막 스크롤 위치를 스스로 기억하는 컨트롤러.
///
/// 보기↔편집 전환으로 스크롤 뷰가 새로 붙을 때도 직전 위치에서 시작하고,
/// [lastOffset]을 미리 넣어두면 첫 프레임부터 그 위치로 그려진다.
class ResumableScrollController extends ScrollController {
  ResumableScrollController() : super(keepScrollOffset: false) {
    addListener(_track);
  }

  double lastOffset = 0;

  void _track() {
    // 스크롤 뷰가 교체되는 프레임에는 잠깐 두 개가 붙어 있을 수 있다.
    if (positions.length == 1) lastOffset = position.pixels;
  }

  @override
  double get initialScrollOffset => lastOffset;
}
