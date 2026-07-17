// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTagline => 'GitHub 저장소 메모장';

  @override
  String get ok => '확인';

  @override
  String get cancel => '취소';

  @override
  String get delete => '삭제';

  @override
  String get proceed => '진행';

  @override
  String get retry => '다시 시도';

  @override
  String get confirmTitle => '확인';

  @override
  String get githubConnect => 'GitHub 연결';

  @override
  String get tokenGuideBody =>
      '메모로 사용할 저장소에만 접근할 수 있는 Token 사용을 권장합니다.\n필요 권한: Repository contents (Read and write), Metadata (Read-only)';

  @override
  String get tokenLabel => 'GitHub Token';

  @override
  String get tokenEmpty => 'Token을 입력해 주세요.';

  @override
  String get verifyConnection => '연결 확인';

  @override
  String get tokenIssueGuide => 'GitHub Token 설정 페이지 열기';

  @override
  String get tokenGuideDetailTitle => 'Token 권한 설정 방법';

  @override
  String get tokenGuideDetail =>
      '권한 설정은 생성하는 토큰 종류에 따라 달라집니다.\n\n1. Fine-grained Token (세분화된 토큰) — 가장 추천\n특정 저장소에만 권한을 제한할 수 있어 안전합니다.\n• Resource owner: 본인 계정 선택\n• Repository access: Only select repositories 선택 → 메모 저장소 지정\n• Repository permissions:\n   - Contents: Read and write (커밋 조회·푸시에 필수)\n   - Metadata: Read-only (기본 설정)\n\n2. Personal access token (classic)\n• Select scopes에서 repo 항목 체크\n• repo를 체크하면 하위 항목(repo:status, public_repo 등)이 자동으로 함께 선택됩니다';

  @override
  String get reRegisterToken => 'Token 다시 등록';

  @override
  String get securityNotice =>
      '보안 안내\n• Token은 이 기기의 보안 저장소에만 저장됩니다.\n• Token은 로그나 외부 서비스로 전송되지 않습니다.\n• 로그아웃 시 Token이 즉시 삭제됩니다.';

  @override
  String get selectRepository => '저장소 선택';

  @override
  String get searchRepositoryHint => '저장소 검색';

  @override
  String get publicLabel => 'Public';

  @override
  String get privateLabel => 'Private';

  @override
  String get selectBranch => '브랜치 선택';

  @override
  String get selectRepoFirst => '저장소를 먼저 선택해 주세요.';

  @override
  String get branchLabel => '브랜치';

  @override
  String currentLocation(String path) {
    return '현재 위치: /$path';
  }

  @override
  String get vaultRootHint => '이 폴더를 Vault Root로 사용하려면 아래 버튼을 누르세요.';

  @override
  String get goUpFolder => '상위 폴더로';

  @override
  String get noSubfolders => '하위 폴더가 없습니다.';

  @override
  String get selectRootAsVault => '저장소 루트(/)를 Vault로 선택';

  @override
  String selectFolderAsVault(String path) {
    return '/$path 폴더를 Vault로 선택';
  }

  @override
  String get syncStarting => '동기화를 시작합니다…';

  @override
  String get newMemo => '새 메모';

  @override
  String get newMemoFileNameHint => '파일명 (.md 자동 추가)';

  @override
  String get newFolder => '새 폴더';

  @override
  String get folderNameHint => '폴더명';

  @override
  String get renameTitle => '이름 변경';

  @override
  String get newFileNameHint => '새 파일명';

  @override
  String get renameDone => '이름을 변경했습니다.';

  @override
  String get deleteFileTitle => '파일 삭제';

  @override
  String deleteFileConfirm(String name) {
    return '$name 파일을 삭제할까요?\n다음 동기화 때 GitHub에서도 삭제됩니다.';
  }

  @override
  String get newMemoInFolder => '이 폴더에 새 메모';

  @override
  String get newFolderInFolder => '이 폴더에 새 폴더';

  @override
  String get copyPath => '경로 복사';

  @override
  String get pathCopied => '경로를 복사했습니다.';

  @override
  String get markdownOnly => 'Markdown 파일만 편집할 수 있습니다.';

  @override
  String get offlineBanner => '오프라인 상태입니다. 로컬 파일을 표시합니다.';

  @override
  String get emptyFilesMessage => '파일이 없습니다.\n아래 버튼으로 새 메모를 만들어 보세요.';

  @override
  String get statusSaved => '저장됨';

  @override
  String get statusSavingLocal => '로컬 저장 중';

  @override
  String get statusPendingSync => '동기화 대기';

  @override
  String get statusSyncing => '동기화 중';

  @override
  String get statusOffline => '오프라인';

  @override
  String get statusConflict => '충돌 발생';

  @override
  String get statusSyncFailed => '동기화 실패';

  @override
  String get editTooltip => '편집';

  @override
  String get previewTooltip => '미리보기';

  @override
  String get syncNow => '지금 동기화';

  @override
  String get closeKeyboard => '키보드 닫기';

  @override
  String get resolveConflict => '충돌 해결';

  @override
  String get conflictBanner => '서버 파일이 변경되어 충돌이 발생했습니다. 내용은 로컬에 안전하게 저장됩니다.';

  @override
  String get memoHint => '메모를 입력하세요…';

  @override
  String get searchHint => '파일명 또는 내용 검색';

  @override
  String get noResults => '검색 결과가 없습니다.';

  @override
  String get enterQuery => '검색어를 입력해 주세요.';

  @override
  String get conflictNotFound => '충돌 정보를 찾을 수 없습니다.';

  @override
  String serverVersionTab(String time) {
    return '서버 버전\n$time 확인';
  }

  @override
  String localVersionTab(String time) {
    return '내 버전\n$time 수정';
  }

  @override
  String get serverContentMissing => '(서버에서 파일이 삭제되었거나 내용을 가져오지 못했습니다)';

  @override
  String get useServerVersion => '서버 버전 사용';

  @override
  String get overwriteWithMine => '내 버전으로 덮어쓰기';

  @override
  String get keepBothVersions => '두 버전을 별도 파일로 보존';

  @override
  String get resolveLater => '나중에 처리';

  @override
  String get useServerConfirm => '서버 버전으로 교체합니다. 내 로컬 수정 내용은 사라집니다.';

  @override
  String get useMineConfirm => '내 버전으로 서버 파일을 덮어씁니다.';

  @override
  String get keepBothConfirm => '내 버전을 충돌 사본 파일로 저장하고, 원본은 서버 버전으로 되돌립니다.';

  @override
  String get settingsTitle => '설정';

  @override
  String get githubAccount => 'GitHub 계정';

  @override
  String get changeToken => 'Token 변경';

  @override
  String get changeVaultTitle => '저장소 · 브랜치 · Vault Root 변경';

  @override
  String get autoSync => '자동 동기화';

  @override
  String get autoSyncDelay => '자동 동기화 지연시간';

  @override
  String autoSyncDelayDesc(int n) {
    return '입력 정지 후 $n초';
  }

  @override
  String secondsLabel(int n) {
    return '$n초';
  }

  @override
  String get showHiddenFiles => '숨김 파일 표시';

  @override
  String get showHiddenFilesDesc => '.obsidian 등 숨김 폴더 포함';

  @override
  String get showNonMarkdown => '.md 외 파일 표시';

  @override
  String get themeTitle => '테마';

  @override
  String get themeSystem => '시스템';

  @override
  String get themeLight => '라이트';

  @override
  String get themeDark => '다크';

  @override
  String get clearCacheTitle => '캐시 삭제';

  @override
  String get clearCacheDesc => '미동기화 초안은 유지됩니다';

  @override
  String get clearCacheConfirmClean => '동기화된 문서 캐시를 삭제합니다. 계속할까요?';

  @override
  String get clearCacheConfirmDirty =>
      '아직 동기화되지 않은 초안이 있습니다!\n동기화된 문서 캐시만 삭제하고 미동기화 초안은 유지합니다. 계속할까요?';

  @override
  String get cacheCleared => '캐시를 삭제했습니다.';

  @override
  String get logoutTitle => '로그아웃';

  @override
  String get logoutConfirmClean => 'Token과 로컬 데이터를 모두 삭제합니다. 계속할까요?';

  @override
  String get logoutConfirmDirty =>
      '아직 동기화되지 않은 초안이 있습니다!\n로그아웃하면 Token과 모든 로컬 데이터(미동기화 초안 포함)가 삭제됩니다.';

  @override
  String get appVersion => '앱 버전';

  @override
  String get syncNoChanges => '동기화할 변경사항이 없습니다.';

  @override
  String syncUploadedCount(int n) {
    return '업로드 $n건';
  }

  @override
  String syncDeletedCount(int n) {
    return '삭제 $n건';
  }

  @override
  String syncConflictCount(int n) {
    return '충돌 $n건';
  }

  @override
  String syncFailedCount(int n) {
    return '실패 $n건';
  }

  @override
  String get errNetwork => '인터넷 연결을 확인해 주세요.';

  @override
  String get errUnauthorized => 'Token이 올바르지 않습니다. 다시 확인해 주세요.';

  @override
  String get errPermission => '선택한 저장소에 대한 권한이 없습니다.';

  @override
  String get errRateLimit => 'GitHub API 요청 한도에 도달했습니다. 잠시 후 다시 시도해 주세요.';

  @override
  String get errNotFound => '요청한 항목을 찾을 수 없습니다.';

  @override
  String get errConflict => '서버의 파일이 변경되어 충돌이 발생했습니다.';

  @override
  String get errLocalStorage => '로컬 저장 중 오류가 발생했습니다.';

  @override
  String get errUnknown => '알 수 없는 오류가 발생했습니다.';

  @override
  String get errNameEmpty => '파일명을 입력해 주세요.';

  @override
  String get errNameSlash => '파일명에 \"/\"를 사용할 수 없습니다.';

  @override
  String get errNameDots => '파일명에 \"..\"을 사용할 수 없습니다.';

  @override
  String get errNameSpecial => '파일명에 \\ : * ? \" < > | 문자를 사용할 수 없습니다.';

  @override
  String get errNameDuplicate => '같은 이름의 파일이 이미 존재합니다.';

  @override
  String get errRenamePartial =>
      '새 파일은 만들었지만 기존 파일 삭제에 실패했습니다. 동기화에서 다시 시도합니다.';
}
