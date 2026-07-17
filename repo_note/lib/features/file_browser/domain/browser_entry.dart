import '../../../core/storage/sync_enums.dart';

/// 파일 탐색 화면용 항목. GitHub DTO를 화면에서 직접 사용하지 않는다.
class BrowserEntry {
  const BrowserEntry({
    required this.name,
    required this.fullPath,
    required this.isDir,
    this.fileId,
    this.syncStatus,
    this.localUpdatedAt,
  });

  final String name;

  /// 저장소 루트 기준 전체 경로.
  final String fullPath;
  final bool isDir;
  final String? fileId;
  final SyncStatus? syncStatus;
  final DateTime? localUpdatedAt;

  bool get hasConflict => syncStatus == SyncStatus.conflict;
}
