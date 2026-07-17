/// SHA 기반 충돌 판단 로직.
class ConflictDetector {
  const ConflictDetector._();

  /// 업로드 직전 충돌 여부를 판단한다.
  ///
  /// [baseSha] 파일을 마지막으로 읽었을 때의 서버 SHA (새 파일이면 null)
  /// [serverSha] 업로드 직전 조회한 현재 서버 SHA (서버에 없으면 null)
  static bool isConflict({
    required String? baseSha,
    required String? serverSha,
  }) {
    // 새 로컬 파일인데 서버에 같은 경로 파일이 이미 존재 → 충돌
    if (baseSha == null) return serverSha != null;
    // 서버에서 파일이 삭제됨 → 충돌
    if (serverSha == null) return true;
    return baseSha != serverSha;
  }
}
