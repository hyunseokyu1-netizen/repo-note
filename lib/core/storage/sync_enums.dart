/// 파일 동기화 상태.
enum SyncStatus {
  synced,
  localOnly,
  pendingUpload,
  uploading,
  pendingDelete,
  conflict,
  failed,
}

/// 동기화 작업 종류.
enum SyncOperation { upload, delete }
