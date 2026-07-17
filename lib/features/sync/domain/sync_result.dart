/// 개별 파일 동기화 결과.
enum SyncResult { uploaded, deleted, upToDate, conflict, failed, skipped }

/// 전체 동기화 요약. 사용자 메시지는 UI 계층에서 언어에 맞게 구성한다.
class SyncSummary {
  const SyncSummary({
    this.uploaded = 0,
    this.deleted = 0,
    this.conflicts = 0,
    this.failed = 0,
    this.skipped = 0,
  });

  final int uploaded;
  final int deleted;
  final int conflicts;
  final int failed;
  final int skipped;

  int get total => uploaded + deleted + conflicts + failed + skipped;

  bool get hasChanges =>
      uploaded > 0 || deleted > 0 || conflicts > 0 || failed > 0;
}
