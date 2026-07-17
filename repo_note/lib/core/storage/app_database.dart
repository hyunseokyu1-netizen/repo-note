import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'sync_enums.dart';

part 'app_database.g.dart';

class VaultConfigs extends Table {
  TextColumn get id => text()();
  TextColumn get owner => text()();
  TextColumn get repository => text()();
  IntColumn get repositoryId => integer()();
  TextColumn get branch => text()();
  TextColumn get rootPath => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class NoteFiles extends Table {
  TextColumn get id => text()();
  TextColumn get vaultId => text()();
  TextColumn get path => text()();
  TextColumn get name => text()();
  TextColumn get remoteSha => text().nullable()();
  TextColumn get localContentPath => text().nullable()();
  DateTimeColumn get remoteUpdatedAt => dateTime().nullable()();
  DateTimeColumn get localUpdatedAt => dateTime().nullable()();
  IntColumn get syncStatus => intEnum<SyncStatus>()();
  BoolColumn get isDeletedLocally =>
      boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

class NoteDrafts extends Table {
  TextColumn get fileId => text()();
  TextColumn get content => text()();
  TextColumn get baseSha => text().nullable()();
  DateTimeColumn get updatedAt => dateTime()();
  BoolColumn get isDirty => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {fileId};
}

class SyncJobs extends Table {
  TextColumn get id => text()();
  TextColumn get fileId => text()();
  IntColumn get operation => intEnum<SyncOperation>()();
  IntColumn get retryCount => integer().withDefault(const Constant(0))();
  TextColumn get lastErrorCode => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get nextRetryAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class AppSettingsTable extends Table {
  @override
  String get tableName => 'app_settings';

  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}

class RecentFiles extends Table {
  TextColumn get fileId => text()();
  DateTimeColumn get openedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {fileId};
}

class Conflicts extends Table {
  TextColumn get fileId => text()();
  TextColumn get serverSha => text()();
  TextColumn get serverContent => text()();
  DateTimeColumn get detectedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {fileId};
}

@DriftDatabase(
  tables: [
    VaultConfigs,
    NoteFiles,
    NoteDrafts,
    SyncJobs,
    AppSettingsTable,
    RecentFiles,
    Conflicts,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 1;

  // ---- 설정 ----

  Future<String?> getSetting(String key) async {
    final row = await (select(
      appSettingsTable,
    )..where((t) => t.key.equals(key))).getSingleOrNull();
    return row?.value;
  }

  Future<void> setSetting(String key, String value) =>
      into(appSettingsTable).insertOnConflictUpdate(
        AppSettingsTableCompanion.insert(key: key, value: value),
      );

  Future<void> deleteSetting(String key) =>
      (delete(appSettingsTable)..where((t) => t.key.equals(key))).go();

  // ---- Vault ----

  Future<VaultConfig?> getVault(String id) =>
      (select(vaultConfigs)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<void> upsertVault(VaultConfigsCompanion vault) =>
      into(vaultConfigs).insertOnConflictUpdate(vault);

  // ---- 파일 ----

  Future<NoteFile?> getFile(String id) =>
      (select(noteFiles)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<NoteFile?> getFileByPath(String vaultId, String path) =>
      (select(noteFiles)
            ..where((t) => t.vaultId.equals(vaultId) & t.path.equals(path)))
          .getSingleOrNull();

  Future<List<NoteFile>> filesInVault(String vaultId) =>
      (select(noteFiles)..where((t) => t.vaultId.equals(vaultId))).get();

  Future<void> upsertFile(NoteFilesCompanion file) =>
      into(noteFiles).insertOnConflictUpdate(file);

  Future<void> updateFileStatus(String id, SyncStatus status) =>
      (update(noteFiles)..where((t) => t.id.equals(id))).write(
        NoteFilesCompanion(syncStatus: Value(status)),
      );

  Future<void> deleteFileRow(String id) =>
      (delete(noteFiles)..where((t) => t.id.equals(id))).go();

  /// 업로드/삭제 대기 중인 파일 목록.
  Future<List<NoteFile>> pendingFiles(String vaultId) =>
      (select(noteFiles)..where(
            (t) =>
                t.vaultId.equals(vaultId) &
                t.syncStatus.isIn([
                  SyncStatus.pendingUpload.index,
                  SyncStatus.pendingDelete.index,
                  SyncStatus.failed.index,
                  SyncStatus.localOnly.index,
                ]),
          ))
          .get();

  // ---- 초안 ----

  Future<NoteDraft?> getDraft(String fileId) => (select(
    noteDrafts,
  )..where((t) => t.fileId.equals(fileId))).getSingleOrNull();

  Future<void> upsertDraft(NoteDraftsCompanion draft) =>
      into(noteDrafts).insertOnConflictUpdate(draft);

  Future<void> deleteDraft(String fileId) =>
      (delete(noteDrafts)..where((t) => t.fileId.equals(fileId))).go();

  Future<List<NoteDraft>> dirtyDrafts() =>
      (select(noteDrafts)..where((t) => t.isDirty.equals(true))).get();

  // ---- Sync Job ----

  Future<SyncJob?> jobForFile(String fileId) => (select(
    syncJobs,
  )..where((t) => t.fileId.equals(fileId))).getSingleOrNull();

  Future<void> upsertJob(SyncJobsCompanion job) =>
      into(syncJobs).insertOnConflictUpdate(job);

  Future<void> deleteJobsForFile(String fileId) =>
      (delete(syncJobs)..where((t) => t.fileId.equals(fileId))).go();

  Future<List<SyncJob>> allJobs() => select(syncJobs).get();

  // ---- 충돌 ----

  Future<Conflict?> getConflict(String fileId) => (select(
    conflicts,
  )..where((t) => t.fileId.equals(fileId))).getSingleOrNull();

  Future<void> upsertConflict(ConflictsCompanion conflict) =>
      into(conflicts).insertOnConflictUpdate(conflict);

  Future<void> deleteConflict(String fileId) =>
      (delete(conflicts)..where((t) => t.fileId.equals(fileId))).go();

  // ---- 최근 파일 ----

  Future<void> touchRecent(String fileId) =>
      into(recentFiles).insertOnConflictUpdate(
        RecentFilesCompanion.insert(fileId: fileId, openedAt: DateTime.now()),
      );

  // ---- 초기화 ----

  /// 로그아웃: 모든 데이터를 삭제한다.
  Future<void> clearEverything() async {
    await transaction(() async {
      for (final table in allTables) {
        await delete(table).go();
      }
    });
  }

  /// 캐시 정리: 동기화된 파일 메타데이터만 삭제하고 미동기화 초안은 유지한다.
  Future<void> clearSyncedFiles(String vaultId) async {
    final dirtyIds = (await dirtyDrafts()).map((d) => d.fileId).toSet();
    final files = await filesInVault(vaultId);
    for (final f in files) {
      if (!dirtyIds.contains(f.id) && f.syncStatus == SyncStatus.synced) {
        await deleteDraft(f.id);
        await deleteFileRow(f.id);
      }
    }
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'repo_note.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
