import '../../../core/storage/app_database.dart';
import '../../../core/storage/sync_enums.dart';

/// 편집기에서 열린 노트.
class OpenedNote {
  const OpenedNote({
    required this.file,
    required this.content,
    required this.baseSha,
    required this.status,
    required this.fromLocal,
  });

  final NoteFile file;
  final String content;
  final String? baseSha;
  final SyncStatus status;

  /// true면 로컬 초안/캐시에서 로드됨 (오프라인 등).
  final bool fromLocal;
}
