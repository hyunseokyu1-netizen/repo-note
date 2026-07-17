// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $VaultConfigsTable extends VaultConfigs
    with TableInfo<$VaultConfigsTable, VaultConfig> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VaultConfigsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ownerMeta = const VerificationMeta('owner');
  @override
  late final GeneratedColumn<String> owner = GeneratedColumn<String>(
    'owner',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _repositoryMeta = const VerificationMeta(
    'repository',
  );
  @override
  late final GeneratedColumn<String> repository = GeneratedColumn<String>(
    'repository',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _repositoryIdMeta = const VerificationMeta(
    'repositoryId',
  );
  @override
  late final GeneratedColumn<int> repositoryId = GeneratedColumn<int>(
    'repository_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _branchMeta = const VerificationMeta('branch');
  @override
  late final GeneratedColumn<String> branch = GeneratedColumn<String>(
    'branch',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rootPathMeta = const VerificationMeta(
    'rootPath',
  );
  @override
  late final GeneratedColumn<String> rootPath = GeneratedColumn<String>(
    'root_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    owner,
    repository,
    repositoryId,
    branch,
    rootPath,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'vault_configs';
  @override
  VerificationContext validateIntegrity(
    Insertable<VaultConfig> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('owner')) {
      context.handle(
        _ownerMeta,
        owner.isAcceptableOrUnknown(data['owner']!, _ownerMeta),
      );
    } else if (isInserting) {
      context.missing(_ownerMeta);
    }
    if (data.containsKey('repository')) {
      context.handle(
        _repositoryMeta,
        repository.isAcceptableOrUnknown(data['repository']!, _repositoryMeta),
      );
    } else if (isInserting) {
      context.missing(_repositoryMeta);
    }
    if (data.containsKey('repository_id')) {
      context.handle(
        _repositoryIdMeta,
        repositoryId.isAcceptableOrUnknown(
          data['repository_id']!,
          _repositoryIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_repositoryIdMeta);
    }
    if (data.containsKey('branch')) {
      context.handle(
        _branchMeta,
        branch.isAcceptableOrUnknown(data['branch']!, _branchMeta),
      );
    } else if (isInserting) {
      context.missing(_branchMeta);
    }
    if (data.containsKey('root_path')) {
      context.handle(
        _rootPathMeta,
        rootPath.isAcceptableOrUnknown(data['root_path']!, _rootPathMeta),
      );
    } else if (isInserting) {
      context.missing(_rootPathMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  VaultConfig map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VaultConfig(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      owner: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}owner'],
      )!,
      repository: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}repository'],
      )!,
      repositoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}repository_id'],
      )!,
      branch: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}branch'],
      )!,
      rootPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}root_path'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $VaultConfigsTable createAlias(String alias) {
    return $VaultConfigsTable(attachedDatabase, alias);
  }
}

class VaultConfig extends DataClass implements Insertable<VaultConfig> {
  final String id;
  final String owner;
  final String repository;
  final int repositoryId;
  final String branch;
  final String rootPath;
  final DateTime createdAt;
  final DateTime updatedAt;
  const VaultConfig({
    required this.id,
    required this.owner,
    required this.repository,
    required this.repositoryId,
    required this.branch,
    required this.rootPath,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['owner'] = Variable<String>(owner);
    map['repository'] = Variable<String>(repository);
    map['repository_id'] = Variable<int>(repositoryId);
    map['branch'] = Variable<String>(branch);
    map['root_path'] = Variable<String>(rootPath);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  VaultConfigsCompanion toCompanion(bool nullToAbsent) {
    return VaultConfigsCompanion(
      id: Value(id),
      owner: Value(owner),
      repository: Value(repository),
      repositoryId: Value(repositoryId),
      branch: Value(branch),
      rootPath: Value(rootPath),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory VaultConfig.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VaultConfig(
      id: serializer.fromJson<String>(json['id']),
      owner: serializer.fromJson<String>(json['owner']),
      repository: serializer.fromJson<String>(json['repository']),
      repositoryId: serializer.fromJson<int>(json['repositoryId']),
      branch: serializer.fromJson<String>(json['branch']),
      rootPath: serializer.fromJson<String>(json['rootPath']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'owner': serializer.toJson<String>(owner),
      'repository': serializer.toJson<String>(repository),
      'repositoryId': serializer.toJson<int>(repositoryId),
      'branch': serializer.toJson<String>(branch),
      'rootPath': serializer.toJson<String>(rootPath),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  VaultConfig copyWith({
    String? id,
    String? owner,
    String? repository,
    int? repositoryId,
    String? branch,
    String? rootPath,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => VaultConfig(
    id: id ?? this.id,
    owner: owner ?? this.owner,
    repository: repository ?? this.repository,
    repositoryId: repositoryId ?? this.repositoryId,
    branch: branch ?? this.branch,
    rootPath: rootPath ?? this.rootPath,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  VaultConfig copyWithCompanion(VaultConfigsCompanion data) {
    return VaultConfig(
      id: data.id.present ? data.id.value : this.id,
      owner: data.owner.present ? data.owner.value : this.owner,
      repository: data.repository.present
          ? data.repository.value
          : this.repository,
      repositoryId: data.repositoryId.present
          ? data.repositoryId.value
          : this.repositoryId,
      branch: data.branch.present ? data.branch.value : this.branch,
      rootPath: data.rootPath.present ? data.rootPath.value : this.rootPath,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VaultConfig(')
          ..write('id: $id, ')
          ..write('owner: $owner, ')
          ..write('repository: $repository, ')
          ..write('repositoryId: $repositoryId, ')
          ..write('branch: $branch, ')
          ..write('rootPath: $rootPath, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    owner,
    repository,
    repositoryId,
    branch,
    rootPath,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VaultConfig &&
          other.id == this.id &&
          other.owner == this.owner &&
          other.repository == this.repository &&
          other.repositoryId == this.repositoryId &&
          other.branch == this.branch &&
          other.rootPath == this.rootPath &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class VaultConfigsCompanion extends UpdateCompanion<VaultConfig> {
  final Value<String> id;
  final Value<String> owner;
  final Value<String> repository;
  final Value<int> repositoryId;
  final Value<String> branch;
  final Value<String> rootPath;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const VaultConfigsCompanion({
    this.id = const Value.absent(),
    this.owner = const Value.absent(),
    this.repository = const Value.absent(),
    this.repositoryId = const Value.absent(),
    this.branch = const Value.absent(),
    this.rootPath = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  VaultConfigsCompanion.insert({
    required String id,
    required String owner,
    required String repository,
    required int repositoryId,
    required String branch,
    required String rootPath,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       owner = Value(owner),
       repository = Value(repository),
       repositoryId = Value(repositoryId),
       branch = Value(branch),
       rootPath = Value(rootPath),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<VaultConfig> custom({
    Expression<String>? id,
    Expression<String>? owner,
    Expression<String>? repository,
    Expression<int>? repositoryId,
    Expression<String>? branch,
    Expression<String>? rootPath,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (owner != null) 'owner': owner,
      if (repository != null) 'repository': repository,
      if (repositoryId != null) 'repository_id': repositoryId,
      if (branch != null) 'branch': branch,
      if (rootPath != null) 'root_path': rootPath,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  VaultConfigsCompanion copyWith({
    Value<String>? id,
    Value<String>? owner,
    Value<String>? repository,
    Value<int>? repositoryId,
    Value<String>? branch,
    Value<String>? rootPath,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return VaultConfigsCompanion(
      id: id ?? this.id,
      owner: owner ?? this.owner,
      repository: repository ?? this.repository,
      repositoryId: repositoryId ?? this.repositoryId,
      branch: branch ?? this.branch,
      rootPath: rootPath ?? this.rootPath,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (owner.present) {
      map['owner'] = Variable<String>(owner.value);
    }
    if (repository.present) {
      map['repository'] = Variable<String>(repository.value);
    }
    if (repositoryId.present) {
      map['repository_id'] = Variable<int>(repositoryId.value);
    }
    if (branch.present) {
      map['branch'] = Variable<String>(branch.value);
    }
    if (rootPath.present) {
      map['root_path'] = Variable<String>(rootPath.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VaultConfigsCompanion(')
          ..write('id: $id, ')
          ..write('owner: $owner, ')
          ..write('repository: $repository, ')
          ..write('repositoryId: $repositoryId, ')
          ..write('branch: $branch, ')
          ..write('rootPath: $rootPath, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $NoteFilesTable extends NoteFiles
    with TableInfo<$NoteFilesTable, NoteFile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NoteFilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _vaultIdMeta = const VerificationMeta(
    'vaultId',
  );
  @override
  late final GeneratedColumn<String> vaultId = GeneratedColumn<String>(
    'vault_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pathMeta = const VerificationMeta('path');
  @override
  late final GeneratedColumn<String> path = GeneratedColumn<String>(
    'path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _remoteShaMeta = const VerificationMeta(
    'remoteSha',
  );
  @override
  late final GeneratedColumn<String> remoteSha = GeneratedColumn<String>(
    'remote_sha',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _localContentPathMeta = const VerificationMeta(
    'localContentPath',
  );
  @override
  late final GeneratedColumn<String> localContentPath = GeneratedColumn<String>(
    'local_content_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _remoteUpdatedAtMeta = const VerificationMeta(
    'remoteUpdatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> remoteUpdatedAt =
      GeneratedColumn<DateTime>(
        'remote_updated_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _localUpdatedAtMeta = const VerificationMeta(
    'localUpdatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> localUpdatedAt =
      GeneratedColumn<DateTime>(
        'local_updated_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  @override
  late final GeneratedColumnWithTypeConverter<SyncStatus, int> syncStatus =
      GeneratedColumn<int>(
        'sync_status',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<SyncStatus>($NoteFilesTable.$convertersyncStatus);
  static const VerificationMeta _isDeletedLocallyMeta = const VerificationMeta(
    'isDeletedLocally',
  );
  @override
  late final GeneratedColumn<bool> isDeletedLocally = GeneratedColumn<bool>(
    'is_deleted_locally',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted_locally" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    vaultId,
    path,
    name,
    remoteSha,
    localContentPath,
    remoteUpdatedAt,
    localUpdatedAt,
    syncStatus,
    isDeletedLocally,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'note_files';
  @override
  VerificationContext validateIntegrity(
    Insertable<NoteFile> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('vault_id')) {
      context.handle(
        _vaultIdMeta,
        vaultId.isAcceptableOrUnknown(data['vault_id']!, _vaultIdMeta),
      );
    } else if (isInserting) {
      context.missing(_vaultIdMeta);
    }
    if (data.containsKey('path')) {
      context.handle(
        _pathMeta,
        path.isAcceptableOrUnknown(data['path']!, _pathMeta),
      );
    } else if (isInserting) {
      context.missing(_pathMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('remote_sha')) {
      context.handle(
        _remoteShaMeta,
        remoteSha.isAcceptableOrUnknown(data['remote_sha']!, _remoteShaMeta),
      );
    }
    if (data.containsKey('local_content_path')) {
      context.handle(
        _localContentPathMeta,
        localContentPath.isAcceptableOrUnknown(
          data['local_content_path']!,
          _localContentPathMeta,
        ),
      );
    }
    if (data.containsKey('remote_updated_at')) {
      context.handle(
        _remoteUpdatedAtMeta,
        remoteUpdatedAt.isAcceptableOrUnknown(
          data['remote_updated_at']!,
          _remoteUpdatedAtMeta,
        ),
      );
    }
    if (data.containsKey('local_updated_at')) {
      context.handle(
        _localUpdatedAtMeta,
        localUpdatedAt.isAcceptableOrUnknown(
          data['local_updated_at']!,
          _localUpdatedAtMeta,
        ),
      );
    }
    if (data.containsKey('is_deleted_locally')) {
      context.handle(
        _isDeletedLocallyMeta,
        isDeletedLocally.isAcceptableOrUnknown(
          data['is_deleted_locally']!,
          _isDeletedLocallyMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  NoteFile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NoteFile(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      vaultId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}vault_id'],
      )!,
      path: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}path'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      remoteSha: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}remote_sha'],
      ),
      localContentPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_content_path'],
      ),
      remoteUpdatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}remote_updated_at'],
      ),
      localUpdatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}local_updated_at'],
      ),
      syncStatus: $NoteFilesTable.$convertersyncStatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}sync_status'],
        )!,
      ),
      isDeletedLocally: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted_locally'],
      )!,
    );
  }

  @override
  $NoteFilesTable createAlias(String alias) {
    return $NoteFilesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<SyncStatus, int, int> $convertersyncStatus =
      const EnumIndexConverter<SyncStatus>(SyncStatus.values);
}

class NoteFile extends DataClass implements Insertable<NoteFile> {
  final String id;
  final String vaultId;
  final String path;
  final String name;
  final String? remoteSha;
  final String? localContentPath;
  final DateTime? remoteUpdatedAt;
  final DateTime? localUpdatedAt;
  final SyncStatus syncStatus;
  final bool isDeletedLocally;
  const NoteFile({
    required this.id,
    required this.vaultId,
    required this.path,
    required this.name,
    this.remoteSha,
    this.localContentPath,
    this.remoteUpdatedAt,
    this.localUpdatedAt,
    required this.syncStatus,
    required this.isDeletedLocally,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['vault_id'] = Variable<String>(vaultId);
    map['path'] = Variable<String>(path);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || remoteSha != null) {
      map['remote_sha'] = Variable<String>(remoteSha);
    }
    if (!nullToAbsent || localContentPath != null) {
      map['local_content_path'] = Variable<String>(localContentPath);
    }
    if (!nullToAbsent || remoteUpdatedAt != null) {
      map['remote_updated_at'] = Variable<DateTime>(remoteUpdatedAt);
    }
    if (!nullToAbsent || localUpdatedAt != null) {
      map['local_updated_at'] = Variable<DateTime>(localUpdatedAt);
    }
    {
      map['sync_status'] = Variable<int>(
        $NoteFilesTable.$convertersyncStatus.toSql(syncStatus),
      );
    }
    map['is_deleted_locally'] = Variable<bool>(isDeletedLocally);
    return map;
  }

  NoteFilesCompanion toCompanion(bool nullToAbsent) {
    return NoteFilesCompanion(
      id: Value(id),
      vaultId: Value(vaultId),
      path: Value(path),
      name: Value(name),
      remoteSha: remoteSha == null && nullToAbsent
          ? const Value.absent()
          : Value(remoteSha),
      localContentPath: localContentPath == null && nullToAbsent
          ? const Value.absent()
          : Value(localContentPath),
      remoteUpdatedAt: remoteUpdatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(remoteUpdatedAt),
      localUpdatedAt: localUpdatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(localUpdatedAt),
      syncStatus: Value(syncStatus),
      isDeletedLocally: Value(isDeletedLocally),
    );
  }

  factory NoteFile.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NoteFile(
      id: serializer.fromJson<String>(json['id']),
      vaultId: serializer.fromJson<String>(json['vaultId']),
      path: serializer.fromJson<String>(json['path']),
      name: serializer.fromJson<String>(json['name']),
      remoteSha: serializer.fromJson<String?>(json['remoteSha']),
      localContentPath: serializer.fromJson<String?>(json['localContentPath']),
      remoteUpdatedAt: serializer.fromJson<DateTime?>(json['remoteUpdatedAt']),
      localUpdatedAt: serializer.fromJson<DateTime?>(json['localUpdatedAt']),
      syncStatus: $NoteFilesTable.$convertersyncStatus.fromJson(
        serializer.fromJson<int>(json['syncStatus']),
      ),
      isDeletedLocally: serializer.fromJson<bool>(json['isDeletedLocally']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'vaultId': serializer.toJson<String>(vaultId),
      'path': serializer.toJson<String>(path),
      'name': serializer.toJson<String>(name),
      'remoteSha': serializer.toJson<String?>(remoteSha),
      'localContentPath': serializer.toJson<String?>(localContentPath),
      'remoteUpdatedAt': serializer.toJson<DateTime?>(remoteUpdatedAt),
      'localUpdatedAt': serializer.toJson<DateTime?>(localUpdatedAt),
      'syncStatus': serializer.toJson<int>(
        $NoteFilesTable.$convertersyncStatus.toJson(syncStatus),
      ),
      'isDeletedLocally': serializer.toJson<bool>(isDeletedLocally),
    };
  }

  NoteFile copyWith({
    String? id,
    String? vaultId,
    String? path,
    String? name,
    Value<String?> remoteSha = const Value.absent(),
    Value<String?> localContentPath = const Value.absent(),
    Value<DateTime?> remoteUpdatedAt = const Value.absent(),
    Value<DateTime?> localUpdatedAt = const Value.absent(),
    SyncStatus? syncStatus,
    bool? isDeletedLocally,
  }) => NoteFile(
    id: id ?? this.id,
    vaultId: vaultId ?? this.vaultId,
    path: path ?? this.path,
    name: name ?? this.name,
    remoteSha: remoteSha.present ? remoteSha.value : this.remoteSha,
    localContentPath: localContentPath.present
        ? localContentPath.value
        : this.localContentPath,
    remoteUpdatedAt: remoteUpdatedAt.present
        ? remoteUpdatedAt.value
        : this.remoteUpdatedAt,
    localUpdatedAt: localUpdatedAt.present
        ? localUpdatedAt.value
        : this.localUpdatedAt,
    syncStatus: syncStatus ?? this.syncStatus,
    isDeletedLocally: isDeletedLocally ?? this.isDeletedLocally,
  );
  NoteFile copyWithCompanion(NoteFilesCompanion data) {
    return NoteFile(
      id: data.id.present ? data.id.value : this.id,
      vaultId: data.vaultId.present ? data.vaultId.value : this.vaultId,
      path: data.path.present ? data.path.value : this.path,
      name: data.name.present ? data.name.value : this.name,
      remoteSha: data.remoteSha.present ? data.remoteSha.value : this.remoteSha,
      localContentPath: data.localContentPath.present
          ? data.localContentPath.value
          : this.localContentPath,
      remoteUpdatedAt: data.remoteUpdatedAt.present
          ? data.remoteUpdatedAt.value
          : this.remoteUpdatedAt,
      localUpdatedAt: data.localUpdatedAt.present
          ? data.localUpdatedAt.value
          : this.localUpdatedAt,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      isDeletedLocally: data.isDeletedLocally.present
          ? data.isDeletedLocally.value
          : this.isDeletedLocally,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NoteFile(')
          ..write('id: $id, ')
          ..write('vaultId: $vaultId, ')
          ..write('path: $path, ')
          ..write('name: $name, ')
          ..write('remoteSha: $remoteSha, ')
          ..write('localContentPath: $localContentPath, ')
          ..write('remoteUpdatedAt: $remoteUpdatedAt, ')
          ..write('localUpdatedAt: $localUpdatedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('isDeletedLocally: $isDeletedLocally')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    vaultId,
    path,
    name,
    remoteSha,
    localContentPath,
    remoteUpdatedAt,
    localUpdatedAt,
    syncStatus,
    isDeletedLocally,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NoteFile &&
          other.id == this.id &&
          other.vaultId == this.vaultId &&
          other.path == this.path &&
          other.name == this.name &&
          other.remoteSha == this.remoteSha &&
          other.localContentPath == this.localContentPath &&
          other.remoteUpdatedAt == this.remoteUpdatedAt &&
          other.localUpdatedAt == this.localUpdatedAt &&
          other.syncStatus == this.syncStatus &&
          other.isDeletedLocally == this.isDeletedLocally);
}

class NoteFilesCompanion extends UpdateCompanion<NoteFile> {
  final Value<String> id;
  final Value<String> vaultId;
  final Value<String> path;
  final Value<String> name;
  final Value<String?> remoteSha;
  final Value<String?> localContentPath;
  final Value<DateTime?> remoteUpdatedAt;
  final Value<DateTime?> localUpdatedAt;
  final Value<SyncStatus> syncStatus;
  final Value<bool> isDeletedLocally;
  final Value<int> rowid;
  const NoteFilesCompanion({
    this.id = const Value.absent(),
    this.vaultId = const Value.absent(),
    this.path = const Value.absent(),
    this.name = const Value.absent(),
    this.remoteSha = const Value.absent(),
    this.localContentPath = const Value.absent(),
    this.remoteUpdatedAt = const Value.absent(),
    this.localUpdatedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.isDeletedLocally = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  NoteFilesCompanion.insert({
    required String id,
    required String vaultId,
    required String path,
    required String name,
    this.remoteSha = const Value.absent(),
    this.localContentPath = const Value.absent(),
    this.remoteUpdatedAt = const Value.absent(),
    this.localUpdatedAt = const Value.absent(),
    required SyncStatus syncStatus,
    this.isDeletedLocally = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       vaultId = Value(vaultId),
       path = Value(path),
       name = Value(name),
       syncStatus = Value(syncStatus);
  static Insertable<NoteFile> custom({
    Expression<String>? id,
    Expression<String>? vaultId,
    Expression<String>? path,
    Expression<String>? name,
    Expression<String>? remoteSha,
    Expression<String>? localContentPath,
    Expression<DateTime>? remoteUpdatedAt,
    Expression<DateTime>? localUpdatedAt,
    Expression<int>? syncStatus,
    Expression<bool>? isDeletedLocally,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (vaultId != null) 'vault_id': vaultId,
      if (path != null) 'path': path,
      if (name != null) 'name': name,
      if (remoteSha != null) 'remote_sha': remoteSha,
      if (localContentPath != null) 'local_content_path': localContentPath,
      if (remoteUpdatedAt != null) 'remote_updated_at': remoteUpdatedAt,
      if (localUpdatedAt != null) 'local_updated_at': localUpdatedAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (isDeletedLocally != null) 'is_deleted_locally': isDeletedLocally,
      if (rowid != null) 'rowid': rowid,
    });
  }

  NoteFilesCompanion copyWith({
    Value<String>? id,
    Value<String>? vaultId,
    Value<String>? path,
    Value<String>? name,
    Value<String?>? remoteSha,
    Value<String?>? localContentPath,
    Value<DateTime?>? remoteUpdatedAt,
    Value<DateTime?>? localUpdatedAt,
    Value<SyncStatus>? syncStatus,
    Value<bool>? isDeletedLocally,
    Value<int>? rowid,
  }) {
    return NoteFilesCompanion(
      id: id ?? this.id,
      vaultId: vaultId ?? this.vaultId,
      path: path ?? this.path,
      name: name ?? this.name,
      remoteSha: remoteSha ?? this.remoteSha,
      localContentPath: localContentPath ?? this.localContentPath,
      remoteUpdatedAt: remoteUpdatedAt ?? this.remoteUpdatedAt,
      localUpdatedAt: localUpdatedAt ?? this.localUpdatedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      isDeletedLocally: isDeletedLocally ?? this.isDeletedLocally,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (vaultId.present) {
      map['vault_id'] = Variable<String>(vaultId.value);
    }
    if (path.present) {
      map['path'] = Variable<String>(path.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (remoteSha.present) {
      map['remote_sha'] = Variable<String>(remoteSha.value);
    }
    if (localContentPath.present) {
      map['local_content_path'] = Variable<String>(localContentPath.value);
    }
    if (remoteUpdatedAt.present) {
      map['remote_updated_at'] = Variable<DateTime>(remoteUpdatedAt.value);
    }
    if (localUpdatedAt.present) {
      map['local_updated_at'] = Variable<DateTime>(localUpdatedAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<int>(
        $NoteFilesTable.$convertersyncStatus.toSql(syncStatus.value),
      );
    }
    if (isDeletedLocally.present) {
      map['is_deleted_locally'] = Variable<bool>(isDeletedLocally.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NoteFilesCompanion(')
          ..write('id: $id, ')
          ..write('vaultId: $vaultId, ')
          ..write('path: $path, ')
          ..write('name: $name, ')
          ..write('remoteSha: $remoteSha, ')
          ..write('localContentPath: $localContentPath, ')
          ..write('remoteUpdatedAt: $remoteUpdatedAt, ')
          ..write('localUpdatedAt: $localUpdatedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('isDeletedLocally: $isDeletedLocally, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $NoteDraftsTable extends NoteDrafts
    with TableInfo<$NoteDraftsTable, NoteDraft> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NoteDraftsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _fileIdMeta = const VerificationMeta('fileId');
  @override
  late final GeneratedColumn<String> fileId = GeneratedColumn<String>(
    'file_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _baseShaMeta = const VerificationMeta(
    'baseSha',
  );
  @override
  late final GeneratedColumn<String> baseSha = GeneratedColumn<String>(
    'base_sha',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isDirtyMeta = const VerificationMeta(
    'isDirty',
  );
  @override
  late final GeneratedColumn<bool> isDirty = GeneratedColumn<bool>(
    'is_dirty',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_dirty" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    fileId,
    content,
    baseSha,
    updatedAt,
    isDirty,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'note_drafts';
  @override
  VerificationContext validateIntegrity(
    Insertable<NoteDraft> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('file_id')) {
      context.handle(
        _fileIdMeta,
        fileId.isAcceptableOrUnknown(data['file_id']!, _fileIdMeta),
      );
    } else if (isInserting) {
      context.missing(_fileIdMeta);
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('base_sha')) {
      context.handle(
        _baseShaMeta,
        baseSha.isAcceptableOrUnknown(data['base_sha']!, _baseShaMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('is_dirty')) {
      context.handle(
        _isDirtyMeta,
        isDirty.isAcceptableOrUnknown(data['is_dirty']!, _isDirtyMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {fileId};
  @override
  NoteDraft map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NoteDraft(
      fileId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_id'],
      )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      )!,
      baseSha: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}base_sha'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      isDirty: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_dirty'],
      )!,
    );
  }

  @override
  $NoteDraftsTable createAlias(String alias) {
    return $NoteDraftsTable(attachedDatabase, alias);
  }
}

class NoteDraft extends DataClass implements Insertable<NoteDraft> {
  final String fileId;
  final String content;
  final String? baseSha;
  final DateTime updatedAt;
  final bool isDirty;
  const NoteDraft({
    required this.fileId,
    required this.content,
    this.baseSha,
    required this.updatedAt,
    required this.isDirty,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['file_id'] = Variable<String>(fileId);
    map['content'] = Variable<String>(content);
    if (!nullToAbsent || baseSha != null) {
      map['base_sha'] = Variable<String>(baseSha);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['is_dirty'] = Variable<bool>(isDirty);
    return map;
  }

  NoteDraftsCompanion toCompanion(bool nullToAbsent) {
    return NoteDraftsCompanion(
      fileId: Value(fileId),
      content: Value(content),
      baseSha: baseSha == null && nullToAbsent
          ? const Value.absent()
          : Value(baseSha),
      updatedAt: Value(updatedAt),
      isDirty: Value(isDirty),
    );
  }

  factory NoteDraft.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NoteDraft(
      fileId: serializer.fromJson<String>(json['fileId']),
      content: serializer.fromJson<String>(json['content']),
      baseSha: serializer.fromJson<String?>(json['baseSha']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      isDirty: serializer.fromJson<bool>(json['isDirty']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'fileId': serializer.toJson<String>(fileId),
      'content': serializer.toJson<String>(content),
      'baseSha': serializer.toJson<String?>(baseSha),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'isDirty': serializer.toJson<bool>(isDirty),
    };
  }

  NoteDraft copyWith({
    String? fileId,
    String? content,
    Value<String?> baseSha = const Value.absent(),
    DateTime? updatedAt,
    bool? isDirty,
  }) => NoteDraft(
    fileId: fileId ?? this.fileId,
    content: content ?? this.content,
    baseSha: baseSha.present ? baseSha.value : this.baseSha,
    updatedAt: updatedAt ?? this.updatedAt,
    isDirty: isDirty ?? this.isDirty,
  );
  NoteDraft copyWithCompanion(NoteDraftsCompanion data) {
    return NoteDraft(
      fileId: data.fileId.present ? data.fileId.value : this.fileId,
      content: data.content.present ? data.content.value : this.content,
      baseSha: data.baseSha.present ? data.baseSha.value : this.baseSha,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      isDirty: data.isDirty.present ? data.isDirty.value : this.isDirty,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NoteDraft(')
          ..write('fileId: $fileId, ')
          ..write('content: $content, ')
          ..write('baseSha: $baseSha, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isDirty: $isDirty')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(fileId, content, baseSha, updatedAt, isDirty);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NoteDraft &&
          other.fileId == this.fileId &&
          other.content == this.content &&
          other.baseSha == this.baseSha &&
          other.updatedAt == this.updatedAt &&
          other.isDirty == this.isDirty);
}

class NoteDraftsCompanion extends UpdateCompanion<NoteDraft> {
  final Value<String> fileId;
  final Value<String> content;
  final Value<String?> baseSha;
  final Value<DateTime> updatedAt;
  final Value<bool> isDirty;
  final Value<int> rowid;
  const NoteDraftsCompanion({
    this.fileId = const Value.absent(),
    this.content = const Value.absent(),
    this.baseSha = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isDirty = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  NoteDraftsCompanion.insert({
    required String fileId,
    required String content,
    this.baseSha = const Value.absent(),
    required DateTime updatedAt,
    this.isDirty = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : fileId = Value(fileId),
       content = Value(content),
       updatedAt = Value(updatedAt);
  static Insertable<NoteDraft> custom({
    Expression<String>? fileId,
    Expression<String>? content,
    Expression<String>? baseSha,
    Expression<DateTime>? updatedAt,
    Expression<bool>? isDirty,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (fileId != null) 'file_id': fileId,
      if (content != null) 'content': content,
      if (baseSha != null) 'base_sha': baseSha,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (isDirty != null) 'is_dirty': isDirty,
      if (rowid != null) 'rowid': rowid,
    });
  }

  NoteDraftsCompanion copyWith({
    Value<String>? fileId,
    Value<String>? content,
    Value<String?>? baseSha,
    Value<DateTime>? updatedAt,
    Value<bool>? isDirty,
    Value<int>? rowid,
  }) {
    return NoteDraftsCompanion(
      fileId: fileId ?? this.fileId,
      content: content ?? this.content,
      baseSha: baseSha ?? this.baseSha,
      updatedAt: updatedAt ?? this.updatedAt,
      isDirty: isDirty ?? this.isDirty,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (fileId.present) {
      map['file_id'] = Variable<String>(fileId.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (baseSha.present) {
      map['base_sha'] = Variable<String>(baseSha.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (isDirty.present) {
      map['is_dirty'] = Variable<bool>(isDirty.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NoteDraftsCompanion(')
          ..write('fileId: $fileId, ')
          ..write('content: $content, ')
          ..write('baseSha: $baseSha, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isDirty: $isDirty, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncJobsTable extends SyncJobs with TableInfo<$SyncJobsTable, SyncJob> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncJobsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fileIdMeta = const VerificationMeta('fileId');
  @override
  late final GeneratedColumn<String> fileId = GeneratedColumn<String>(
    'file_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<SyncOperation, int> operation =
      GeneratedColumn<int>(
        'operation',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<SyncOperation>($SyncJobsTable.$converteroperation);
  static const VerificationMeta _retryCountMeta = const VerificationMeta(
    'retryCount',
  );
  @override
  late final GeneratedColumn<int> retryCount = GeneratedColumn<int>(
    'retry_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastErrorCodeMeta = const VerificationMeta(
    'lastErrorCode',
  );
  @override
  late final GeneratedColumn<String> lastErrorCode = GeneratedColumn<String>(
    'last_error_code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nextRetryAtMeta = const VerificationMeta(
    'nextRetryAt',
  );
  @override
  late final GeneratedColumn<DateTime> nextRetryAt = GeneratedColumn<DateTime>(
    'next_retry_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    fileId,
    operation,
    retryCount,
    lastErrorCode,
    createdAt,
    nextRetryAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_jobs';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncJob> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('file_id')) {
      context.handle(
        _fileIdMeta,
        fileId.isAcceptableOrUnknown(data['file_id']!, _fileIdMeta),
      );
    } else if (isInserting) {
      context.missing(_fileIdMeta);
    }
    if (data.containsKey('retry_count')) {
      context.handle(
        _retryCountMeta,
        retryCount.isAcceptableOrUnknown(data['retry_count']!, _retryCountMeta),
      );
    }
    if (data.containsKey('last_error_code')) {
      context.handle(
        _lastErrorCodeMeta,
        lastErrorCode.isAcceptableOrUnknown(
          data['last_error_code']!,
          _lastErrorCodeMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('next_retry_at')) {
      context.handle(
        _nextRetryAtMeta,
        nextRetryAt.isAcceptableOrUnknown(
          data['next_retry_at']!,
          _nextRetryAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SyncJob map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncJob(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      fileId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_id'],
      )!,
      operation: $SyncJobsTable.$converteroperation.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}operation'],
        )!,
      ),
      retryCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}retry_count'],
      )!,
      lastErrorCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_error_code'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      nextRetryAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}next_retry_at'],
      ),
    );
  }

  @override
  $SyncJobsTable createAlias(String alias) {
    return $SyncJobsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<SyncOperation, int, int> $converteroperation =
      const EnumIndexConverter<SyncOperation>(SyncOperation.values);
}

class SyncJob extends DataClass implements Insertable<SyncJob> {
  final String id;
  final String fileId;
  final SyncOperation operation;
  final int retryCount;
  final String? lastErrorCode;
  final DateTime createdAt;
  final DateTime? nextRetryAt;
  const SyncJob({
    required this.id,
    required this.fileId,
    required this.operation,
    required this.retryCount,
    this.lastErrorCode,
    required this.createdAt,
    this.nextRetryAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['file_id'] = Variable<String>(fileId);
    {
      map['operation'] = Variable<int>(
        $SyncJobsTable.$converteroperation.toSql(operation),
      );
    }
    map['retry_count'] = Variable<int>(retryCount);
    if (!nullToAbsent || lastErrorCode != null) {
      map['last_error_code'] = Variable<String>(lastErrorCode);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || nextRetryAt != null) {
      map['next_retry_at'] = Variable<DateTime>(nextRetryAt);
    }
    return map;
  }

  SyncJobsCompanion toCompanion(bool nullToAbsent) {
    return SyncJobsCompanion(
      id: Value(id),
      fileId: Value(fileId),
      operation: Value(operation),
      retryCount: Value(retryCount),
      lastErrorCode: lastErrorCode == null && nullToAbsent
          ? const Value.absent()
          : Value(lastErrorCode),
      createdAt: Value(createdAt),
      nextRetryAt: nextRetryAt == null && nullToAbsent
          ? const Value.absent()
          : Value(nextRetryAt),
    );
  }

  factory SyncJob.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncJob(
      id: serializer.fromJson<String>(json['id']),
      fileId: serializer.fromJson<String>(json['fileId']),
      operation: $SyncJobsTable.$converteroperation.fromJson(
        serializer.fromJson<int>(json['operation']),
      ),
      retryCount: serializer.fromJson<int>(json['retryCount']),
      lastErrorCode: serializer.fromJson<String?>(json['lastErrorCode']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      nextRetryAt: serializer.fromJson<DateTime?>(json['nextRetryAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'fileId': serializer.toJson<String>(fileId),
      'operation': serializer.toJson<int>(
        $SyncJobsTable.$converteroperation.toJson(operation),
      ),
      'retryCount': serializer.toJson<int>(retryCount),
      'lastErrorCode': serializer.toJson<String?>(lastErrorCode),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'nextRetryAt': serializer.toJson<DateTime?>(nextRetryAt),
    };
  }

  SyncJob copyWith({
    String? id,
    String? fileId,
    SyncOperation? operation,
    int? retryCount,
    Value<String?> lastErrorCode = const Value.absent(),
    DateTime? createdAt,
    Value<DateTime?> nextRetryAt = const Value.absent(),
  }) => SyncJob(
    id: id ?? this.id,
    fileId: fileId ?? this.fileId,
    operation: operation ?? this.operation,
    retryCount: retryCount ?? this.retryCount,
    lastErrorCode: lastErrorCode.present
        ? lastErrorCode.value
        : this.lastErrorCode,
    createdAt: createdAt ?? this.createdAt,
    nextRetryAt: nextRetryAt.present ? nextRetryAt.value : this.nextRetryAt,
  );
  SyncJob copyWithCompanion(SyncJobsCompanion data) {
    return SyncJob(
      id: data.id.present ? data.id.value : this.id,
      fileId: data.fileId.present ? data.fileId.value : this.fileId,
      operation: data.operation.present ? data.operation.value : this.operation,
      retryCount: data.retryCount.present
          ? data.retryCount.value
          : this.retryCount,
      lastErrorCode: data.lastErrorCode.present
          ? data.lastErrorCode.value
          : this.lastErrorCode,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      nextRetryAt: data.nextRetryAt.present
          ? data.nextRetryAt.value
          : this.nextRetryAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncJob(')
          ..write('id: $id, ')
          ..write('fileId: $fileId, ')
          ..write('operation: $operation, ')
          ..write('retryCount: $retryCount, ')
          ..write('lastErrorCode: $lastErrorCode, ')
          ..write('createdAt: $createdAt, ')
          ..write('nextRetryAt: $nextRetryAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    fileId,
    operation,
    retryCount,
    lastErrorCode,
    createdAt,
    nextRetryAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncJob &&
          other.id == this.id &&
          other.fileId == this.fileId &&
          other.operation == this.operation &&
          other.retryCount == this.retryCount &&
          other.lastErrorCode == this.lastErrorCode &&
          other.createdAt == this.createdAt &&
          other.nextRetryAt == this.nextRetryAt);
}

class SyncJobsCompanion extends UpdateCompanion<SyncJob> {
  final Value<String> id;
  final Value<String> fileId;
  final Value<SyncOperation> operation;
  final Value<int> retryCount;
  final Value<String?> lastErrorCode;
  final Value<DateTime> createdAt;
  final Value<DateTime?> nextRetryAt;
  final Value<int> rowid;
  const SyncJobsCompanion({
    this.id = const Value.absent(),
    this.fileId = const Value.absent(),
    this.operation = const Value.absent(),
    this.retryCount = const Value.absent(),
    this.lastErrorCode = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.nextRetryAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncJobsCompanion.insert({
    required String id,
    required String fileId,
    required SyncOperation operation,
    this.retryCount = const Value.absent(),
    this.lastErrorCode = const Value.absent(),
    required DateTime createdAt,
    this.nextRetryAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       fileId = Value(fileId),
       operation = Value(operation),
       createdAt = Value(createdAt);
  static Insertable<SyncJob> custom({
    Expression<String>? id,
    Expression<String>? fileId,
    Expression<int>? operation,
    Expression<int>? retryCount,
    Expression<String>? lastErrorCode,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? nextRetryAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (fileId != null) 'file_id': fileId,
      if (operation != null) 'operation': operation,
      if (retryCount != null) 'retry_count': retryCount,
      if (lastErrorCode != null) 'last_error_code': lastErrorCode,
      if (createdAt != null) 'created_at': createdAt,
      if (nextRetryAt != null) 'next_retry_at': nextRetryAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncJobsCompanion copyWith({
    Value<String>? id,
    Value<String>? fileId,
    Value<SyncOperation>? operation,
    Value<int>? retryCount,
    Value<String?>? lastErrorCode,
    Value<DateTime>? createdAt,
    Value<DateTime?>? nextRetryAt,
    Value<int>? rowid,
  }) {
    return SyncJobsCompanion(
      id: id ?? this.id,
      fileId: fileId ?? this.fileId,
      operation: operation ?? this.operation,
      retryCount: retryCount ?? this.retryCount,
      lastErrorCode: lastErrorCode ?? this.lastErrorCode,
      createdAt: createdAt ?? this.createdAt,
      nextRetryAt: nextRetryAt ?? this.nextRetryAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (fileId.present) {
      map['file_id'] = Variable<String>(fileId.value);
    }
    if (operation.present) {
      map['operation'] = Variable<int>(
        $SyncJobsTable.$converteroperation.toSql(operation.value),
      );
    }
    if (retryCount.present) {
      map['retry_count'] = Variable<int>(retryCount.value);
    }
    if (lastErrorCode.present) {
      map['last_error_code'] = Variable<String>(lastErrorCode.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (nextRetryAt.present) {
      map['next_retry_at'] = Variable<DateTime>(nextRetryAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncJobsCompanion(')
          ..write('id: $id, ')
          ..write('fileId: $fileId, ')
          ..write('operation: $operation, ')
          ..write('retryCount: $retryCount, ')
          ..write('lastErrorCode: $lastErrorCode, ')
          ..write('createdAt: $createdAt, ')
          ..write('nextRetryAt: $nextRetryAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AppSettingsTableTable extends AppSettingsTable
    with TableInfo<$AppSettingsTableTable, AppSettingsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppSettingsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  AppSettingsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSettingsTableData(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $AppSettingsTableTable createAlias(String alias) {
    return $AppSettingsTableTable(attachedDatabase, alias);
  }
}

class AppSettingsTableData extends DataClass
    implements Insertable<AppSettingsTableData> {
  final String key;
  final String value;
  const AppSettingsTableData({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  AppSettingsTableCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsTableCompanion(key: Value(key), value: Value(value));
  }

  factory AppSettingsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSettingsTableData(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  AppSettingsTableData copyWith({String? key, String? value}) =>
      AppSettingsTableData(key: key ?? this.key, value: value ?? this.value);
  AppSettingsTableData copyWithCompanion(AppSettingsTableCompanion data) {
    return AppSettingsTableData(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsTableData(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSettingsTableData &&
          other.key == this.key &&
          other.value == this.value);
}

class AppSettingsTableCompanion extends UpdateCompanion<AppSettingsTableData> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const AppSettingsTableCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppSettingsTableCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<AppSettingsTableData> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppSettingsTableCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return AppSettingsTableCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsTableCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RecentFilesTable extends RecentFiles
    with TableInfo<$RecentFilesTable, RecentFile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecentFilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _fileIdMeta = const VerificationMeta('fileId');
  @override
  late final GeneratedColumn<String> fileId = GeneratedColumn<String>(
    'file_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _openedAtMeta = const VerificationMeta(
    'openedAt',
  );
  @override
  late final GeneratedColumn<DateTime> openedAt = GeneratedColumn<DateTime>(
    'opened_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [fileId, openedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recent_files';
  @override
  VerificationContext validateIntegrity(
    Insertable<RecentFile> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('file_id')) {
      context.handle(
        _fileIdMeta,
        fileId.isAcceptableOrUnknown(data['file_id']!, _fileIdMeta),
      );
    } else if (isInserting) {
      context.missing(_fileIdMeta);
    }
    if (data.containsKey('opened_at')) {
      context.handle(
        _openedAtMeta,
        openedAt.isAcceptableOrUnknown(data['opened_at']!, _openedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_openedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {fileId};
  @override
  RecentFile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RecentFile(
      fileId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_id'],
      )!,
      openedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}opened_at'],
      )!,
    );
  }

  @override
  $RecentFilesTable createAlias(String alias) {
    return $RecentFilesTable(attachedDatabase, alias);
  }
}

class RecentFile extends DataClass implements Insertable<RecentFile> {
  final String fileId;
  final DateTime openedAt;
  const RecentFile({required this.fileId, required this.openedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['file_id'] = Variable<String>(fileId);
    map['opened_at'] = Variable<DateTime>(openedAt);
    return map;
  }

  RecentFilesCompanion toCompanion(bool nullToAbsent) {
    return RecentFilesCompanion(
      fileId: Value(fileId),
      openedAt: Value(openedAt),
    );
  }

  factory RecentFile.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RecentFile(
      fileId: serializer.fromJson<String>(json['fileId']),
      openedAt: serializer.fromJson<DateTime>(json['openedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'fileId': serializer.toJson<String>(fileId),
      'openedAt': serializer.toJson<DateTime>(openedAt),
    };
  }

  RecentFile copyWith({String? fileId, DateTime? openedAt}) => RecentFile(
    fileId: fileId ?? this.fileId,
    openedAt: openedAt ?? this.openedAt,
  );
  RecentFile copyWithCompanion(RecentFilesCompanion data) {
    return RecentFile(
      fileId: data.fileId.present ? data.fileId.value : this.fileId,
      openedAt: data.openedAt.present ? data.openedAt.value : this.openedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RecentFile(')
          ..write('fileId: $fileId, ')
          ..write('openedAt: $openedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(fileId, openedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RecentFile &&
          other.fileId == this.fileId &&
          other.openedAt == this.openedAt);
}

class RecentFilesCompanion extends UpdateCompanion<RecentFile> {
  final Value<String> fileId;
  final Value<DateTime> openedAt;
  final Value<int> rowid;
  const RecentFilesCompanion({
    this.fileId = const Value.absent(),
    this.openedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RecentFilesCompanion.insert({
    required String fileId,
    required DateTime openedAt,
    this.rowid = const Value.absent(),
  }) : fileId = Value(fileId),
       openedAt = Value(openedAt);
  static Insertable<RecentFile> custom({
    Expression<String>? fileId,
    Expression<DateTime>? openedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (fileId != null) 'file_id': fileId,
      if (openedAt != null) 'opened_at': openedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RecentFilesCompanion copyWith({
    Value<String>? fileId,
    Value<DateTime>? openedAt,
    Value<int>? rowid,
  }) {
    return RecentFilesCompanion(
      fileId: fileId ?? this.fileId,
      openedAt: openedAt ?? this.openedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (fileId.present) {
      map['file_id'] = Variable<String>(fileId.value);
    }
    if (openedAt.present) {
      map['opened_at'] = Variable<DateTime>(openedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecentFilesCompanion(')
          ..write('fileId: $fileId, ')
          ..write('openedAt: $openedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ConflictsTable extends Conflicts
    with TableInfo<$ConflictsTable, Conflict> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ConflictsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _fileIdMeta = const VerificationMeta('fileId');
  @override
  late final GeneratedColumn<String> fileId = GeneratedColumn<String>(
    'file_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _serverShaMeta = const VerificationMeta(
    'serverSha',
  );
  @override
  late final GeneratedColumn<String> serverSha = GeneratedColumn<String>(
    'server_sha',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _serverContentMeta = const VerificationMeta(
    'serverContent',
  );
  @override
  late final GeneratedColumn<String> serverContent = GeneratedColumn<String>(
    'server_content',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _detectedAtMeta = const VerificationMeta(
    'detectedAt',
  );
  @override
  late final GeneratedColumn<DateTime> detectedAt = GeneratedColumn<DateTime>(
    'detected_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    fileId,
    serverSha,
    serverContent,
    detectedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'conflicts';
  @override
  VerificationContext validateIntegrity(
    Insertable<Conflict> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('file_id')) {
      context.handle(
        _fileIdMeta,
        fileId.isAcceptableOrUnknown(data['file_id']!, _fileIdMeta),
      );
    } else if (isInserting) {
      context.missing(_fileIdMeta);
    }
    if (data.containsKey('server_sha')) {
      context.handle(
        _serverShaMeta,
        serverSha.isAcceptableOrUnknown(data['server_sha']!, _serverShaMeta),
      );
    } else if (isInserting) {
      context.missing(_serverShaMeta);
    }
    if (data.containsKey('server_content')) {
      context.handle(
        _serverContentMeta,
        serverContent.isAcceptableOrUnknown(
          data['server_content']!,
          _serverContentMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_serverContentMeta);
    }
    if (data.containsKey('detected_at')) {
      context.handle(
        _detectedAtMeta,
        detectedAt.isAcceptableOrUnknown(data['detected_at']!, _detectedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_detectedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {fileId};
  @override
  Conflict map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Conflict(
      fileId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_id'],
      )!,
      serverSha: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}server_sha'],
      )!,
      serverContent: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}server_content'],
      )!,
      detectedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}detected_at'],
      )!,
    );
  }

  @override
  $ConflictsTable createAlias(String alias) {
    return $ConflictsTable(attachedDatabase, alias);
  }
}

class Conflict extends DataClass implements Insertable<Conflict> {
  final String fileId;
  final String serverSha;
  final String serverContent;
  final DateTime detectedAt;
  const Conflict({
    required this.fileId,
    required this.serverSha,
    required this.serverContent,
    required this.detectedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['file_id'] = Variable<String>(fileId);
    map['server_sha'] = Variable<String>(serverSha);
    map['server_content'] = Variable<String>(serverContent);
    map['detected_at'] = Variable<DateTime>(detectedAt);
    return map;
  }

  ConflictsCompanion toCompanion(bool nullToAbsent) {
    return ConflictsCompanion(
      fileId: Value(fileId),
      serverSha: Value(serverSha),
      serverContent: Value(serverContent),
      detectedAt: Value(detectedAt),
    );
  }

  factory Conflict.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Conflict(
      fileId: serializer.fromJson<String>(json['fileId']),
      serverSha: serializer.fromJson<String>(json['serverSha']),
      serverContent: serializer.fromJson<String>(json['serverContent']),
      detectedAt: serializer.fromJson<DateTime>(json['detectedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'fileId': serializer.toJson<String>(fileId),
      'serverSha': serializer.toJson<String>(serverSha),
      'serverContent': serializer.toJson<String>(serverContent),
      'detectedAt': serializer.toJson<DateTime>(detectedAt),
    };
  }

  Conflict copyWith({
    String? fileId,
    String? serverSha,
    String? serverContent,
    DateTime? detectedAt,
  }) => Conflict(
    fileId: fileId ?? this.fileId,
    serverSha: serverSha ?? this.serverSha,
    serverContent: serverContent ?? this.serverContent,
    detectedAt: detectedAt ?? this.detectedAt,
  );
  Conflict copyWithCompanion(ConflictsCompanion data) {
    return Conflict(
      fileId: data.fileId.present ? data.fileId.value : this.fileId,
      serverSha: data.serverSha.present ? data.serverSha.value : this.serverSha,
      serverContent: data.serverContent.present
          ? data.serverContent.value
          : this.serverContent,
      detectedAt: data.detectedAt.present
          ? data.detectedAt.value
          : this.detectedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Conflict(')
          ..write('fileId: $fileId, ')
          ..write('serverSha: $serverSha, ')
          ..write('serverContent: $serverContent, ')
          ..write('detectedAt: $detectedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(fileId, serverSha, serverContent, detectedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Conflict &&
          other.fileId == this.fileId &&
          other.serverSha == this.serverSha &&
          other.serverContent == this.serverContent &&
          other.detectedAt == this.detectedAt);
}

class ConflictsCompanion extends UpdateCompanion<Conflict> {
  final Value<String> fileId;
  final Value<String> serverSha;
  final Value<String> serverContent;
  final Value<DateTime> detectedAt;
  final Value<int> rowid;
  const ConflictsCompanion({
    this.fileId = const Value.absent(),
    this.serverSha = const Value.absent(),
    this.serverContent = const Value.absent(),
    this.detectedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ConflictsCompanion.insert({
    required String fileId,
    required String serverSha,
    required String serverContent,
    required DateTime detectedAt,
    this.rowid = const Value.absent(),
  }) : fileId = Value(fileId),
       serverSha = Value(serverSha),
       serverContent = Value(serverContent),
       detectedAt = Value(detectedAt);
  static Insertable<Conflict> custom({
    Expression<String>? fileId,
    Expression<String>? serverSha,
    Expression<String>? serverContent,
    Expression<DateTime>? detectedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (fileId != null) 'file_id': fileId,
      if (serverSha != null) 'server_sha': serverSha,
      if (serverContent != null) 'server_content': serverContent,
      if (detectedAt != null) 'detected_at': detectedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ConflictsCompanion copyWith({
    Value<String>? fileId,
    Value<String>? serverSha,
    Value<String>? serverContent,
    Value<DateTime>? detectedAt,
    Value<int>? rowid,
  }) {
    return ConflictsCompanion(
      fileId: fileId ?? this.fileId,
      serverSha: serverSha ?? this.serverSha,
      serverContent: serverContent ?? this.serverContent,
      detectedAt: detectedAt ?? this.detectedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (fileId.present) {
      map['file_id'] = Variable<String>(fileId.value);
    }
    if (serverSha.present) {
      map['server_sha'] = Variable<String>(serverSha.value);
    }
    if (serverContent.present) {
      map['server_content'] = Variable<String>(serverContent.value);
    }
    if (detectedAt.present) {
      map['detected_at'] = Variable<DateTime>(detectedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ConflictsCompanion(')
          ..write('fileId: $fileId, ')
          ..write('serverSha: $serverSha, ')
          ..write('serverContent: $serverContent, ')
          ..write('detectedAt: $detectedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $VaultConfigsTable vaultConfigs = $VaultConfigsTable(this);
  late final $NoteFilesTable noteFiles = $NoteFilesTable(this);
  late final $NoteDraftsTable noteDrafts = $NoteDraftsTable(this);
  late final $SyncJobsTable syncJobs = $SyncJobsTable(this);
  late final $AppSettingsTableTable appSettingsTable = $AppSettingsTableTable(
    this,
  );
  late final $RecentFilesTable recentFiles = $RecentFilesTable(this);
  late final $ConflictsTable conflicts = $ConflictsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    vaultConfigs,
    noteFiles,
    noteDrafts,
    syncJobs,
    appSettingsTable,
    recentFiles,
    conflicts,
  ];
}

typedef $$VaultConfigsTableCreateCompanionBuilder =
    VaultConfigsCompanion Function({
      required String id,
      required String owner,
      required String repository,
      required int repositoryId,
      required String branch,
      required String rootPath,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$VaultConfigsTableUpdateCompanionBuilder =
    VaultConfigsCompanion Function({
      Value<String> id,
      Value<String> owner,
      Value<String> repository,
      Value<int> repositoryId,
      Value<String> branch,
      Value<String> rootPath,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$VaultConfigsTableFilterComposer
    extends Composer<_$AppDatabase, $VaultConfigsTable> {
  $$VaultConfigsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get owner => $composableBuilder(
    column: $table.owner,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get repository => $composableBuilder(
    column: $table.repository,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get repositoryId => $composableBuilder(
    column: $table.repositoryId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get branch => $composableBuilder(
    column: $table.branch,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rootPath => $composableBuilder(
    column: $table.rootPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$VaultConfigsTableOrderingComposer
    extends Composer<_$AppDatabase, $VaultConfigsTable> {
  $$VaultConfigsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get owner => $composableBuilder(
    column: $table.owner,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get repository => $composableBuilder(
    column: $table.repository,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get repositoryId => $composableBuilder(
    column: $table.repositoryId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get branch => $composableBuilder(
    column: $table.branch,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rootPath => $composableBuilder(
    column: $table.rootPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$VaultConfigsTableAnnotationComposer
    extends Composer<_$AppDatabase, $VaultConfigsTable> {
  $$VaultConfigsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get owner =>
      $composableBuilder(column: $table.owner, builder: (column) => column);

  GeneratedColumn<String> get repository => $composableBuilder(
    column: $table.repository,
    builder: (column) => column,
  );

  GeneratedColumn<int> get repositoryId => $composableBuilder(
    column: $table.repositoryId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get branch =>
      $composableBuilder(column: $table.branch, builder: (column) => column);

  GeneratedColumn<String> get rootPath =>
      $composableBuilder(column: $table.rootPath, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$VaultConfigsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $VaultConfigsTable,
          VaultConfig,
          $$VaultConfigsTableFilterComposer,
          $$VaultConfigsTableOrderingComposer,
          $$VaultConfigsTableAnnotationComposer,
          $$VaultConfigsTableCreateCompanionBuilder,
          $$VaultConfigsTableUpdateCompanionBuilder,
          (
            VaultConfig,
            BaseReferences<_$AppDatabase, $VaultConfigsTable, VaultConfig>,
          ),
          VaultConfig,
          PrefetchHooks Function()
        > {
  $$VaultConfigsTableTableManager(_$AppDatabase db, $VaultConfigsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VaultConfigsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VaultConfigsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VaultConfigsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> owner = const Value.absent(),
                Value<String> repository = const Value.absent(),
                Value<int> repositoryId = const Value.absent(),
                Value<String> branch = const Value.absent(),
                Value<String> rootPath = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => VaultConfigsCompanion(
                id: id,
                owner: owner,
                repository: repository,
                repositoryId: repositoryId,
                branch: branch,
                rootPath: rootPath,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String owner,
                required String repository,
                required int repositoryId,
                required String branch,
                required String rootPath,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => VaultConfigsCompanion.insert(
                id: id,
                owner: owner,
                repository: repository,
                repositoryId: repositoryId,
                branch: branch,
                rootPath: rootPath,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$VaultConfigsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $VaultConfigsTable,
      VaultConfig,
      $$VaultConfigsTableFilterComposer,
      $$VaultConfigsTableOrderingComposer,
      $$VaultConfigsTableAnnotationComposer,
      $$VaultConfigsTableCreateCompanionBuilder,
      $$VaultConfigsTableUpdateCompanionBuilder,
      (
        VaultConfig,
        BaseReferences<_$AppDatabase, $VaultConfigsTable, VaultConfig>,
      ),
      VaultConfig,
      PrefetchHooks Function()
    >;
typedef $$NoteFilesTableCreateCompanionBuilder =
    NoteFilesCompanion Function({
      required String id,
      required String vaultId,
      required String path,
      required String name,
      Value<String?> remoteSha,
      Value<String?> localContentPath,
      Value<DateTime?> remoteUpdatedAt,
      Value<DateTime?> localUpdatedAt,
      required SyncStatus syncStatus,
      Value<bool> isDeletedLocally,
      Value<int> rowid,
    });
typedef $$NoteFilesTableUpdateCompanionBuilder =
    NoteFilesCompanion Function({
      Value<String> id,
      Value<String> vaultId,
      Value<String> path,
      Value<String> name,
      Value<String?> remoteSha,
      Value<String?> localContentPath,
      Value<DateTime?> remoteUpdatedAt,
      Value<DateTime?> localUpdatedAt,
      Value<SyncStatus> syncStatus,
      Value<bool> isDeletedLocally,
      Value<int> rowid,
    });

class $$NoteFilesTableFilterComposer
    extends Composer<_$AppDatabase, $NoteFilesTable> {
  $$NoteFilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get vaultId => $composableBuilder(
    column: $table.vaultId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get path => $composableBuilder(
    column: $table.path,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get remoteSha => $composableBuilder(
    column: $table.remoteSha,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localContentPath => $composableBuilder(
    column: $table.localContentPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get remoteUpdatedAt => $composableBuilder(
    column: $table.remoteUpdatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get localUpdatedAt => $composableBuilder(
    column: $table.localUpdatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<SyncStatus, SyncStatus, int> get syncStatus =>
      $composableBuilder(
        column: $table.syncStatus,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<bool> get isDeletedLocally => $composableBuilder(
    column: $table.isDeletedLocally,
    builder: (column) => ColumnFilters(column),
  );
}

class $$NoteFilesTableOrderingComposer
    extends Composer<_$AppDatabase, $NoteFilesTable> {
  $$NoteFilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get vaultId => $composableBuilder(
    column: $table.vaultId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get path => $composableBuilder(
    column: $table.path,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get remoteSha => $composableBuilder(
    column: $table.remoteSha,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localContentPath => $composableBuilder(
    column: $table.localContentPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get remoteUpdatedAt => $composableBuilder(
    column: $table.remoteUpdatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get localUpdatedAt => $composableBuilder(
    column: $table.localUpdatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeletedLocally => $composableBuilder(
    column: $table.isDeletedLocally,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$NoteFilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $NoteFilesTable> {
  $$NoteFilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get vaultId =>
      $composableBuilder(column: $table.vaultId, builder: (column) => column);

  GeneratedColumn<String> get path =>
      $composableBuilder(column: $table.path, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get remoteSha =>
      $composableBuilder(column: $table.remoteSha, builder: (column) => column);

  GeneratedColumn<String> get localContentPath => $composableBuilder(
    column: $table.localContentPath,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get remoteUpdatedAt => $composableBuilder(
    column: $table.remoteUpdatedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get localUpdatedAt => $composableBuilder(
    column: $table.localUpdatedAt,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<SyncStatus, int> get syncStatus =>
      $composableBuilder(
        column: $table.syncStatus,
        builder: (column) => column,
      );

  GeneratedColumn<bool> get isDeletedLocally => $composableBuilder(
    column: $table.isDeletedLocally,
    builder: (column) => column,
  );
}

class $$NoteFilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $NoteFilesTable,
          NoteFile,
          $$NoteFilesTableFilterComposer,
          $$NoteFilesTableOrderingComposer,
          $$NoteFilesTableAnnotationComposer,
          $$NoteFilesTableCreateCompanionBuilder,
          $$NoteFilesTableUpdateCompanionBuilder,
          (NoteFile, BaseReferences<_$AppDatabase, $NoteFilesTable, NoteFile>),
          NoteFile,
          PrefetchHooks Function()
        > {
  $$NoteFilesTableTableManager(_$AppDatabase db, $NoteFilesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NoteFilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NoteFilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NoteFilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> vaultId = const Value.absent(),
                Value<String> path = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> remoteSha = const Value.absent(),
                Value<String?> localContentPath = const Value.absent(),
                Value<DateTime?> remoteUpdatedAt = const Value.absent(),
                Value<DateTime?> localUpdatedAt = const Value.absent(),
                Value<SyncStatus> syncStatus = const Value.absent(),
                Value<bool> isDeletedLocally = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => NoteFilesCompanion(
                id: id,
                vaultId: vaultId,
                path: path,
                name: name,
                remoteSha: remoteSha,
                localContentPath: localContentPath,
                remoteUpdatedAt: remoteUpdatedAt,
                localUpdatedAt: localUpdatedAt,
                syncStatus: syncStatus,
                isDeletedLocally: isDeletedLocally,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String vaultId,
                required String path,
                required String name,
                Value<String?> remoteSha = const Value.absent(),
                Value<String?> localContentPath = const Value.absent(),
                Value<DateTime?> remoteUpdatedAt = const Value.absent(),
                Value<DateTime?> localUpdatedAt = const Value.absent(),
                required SyncStatus syncStatus,
                Value<bool> isDeletedLocally = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => NoteFilesCompanion.insert(
                id: id,
                vaultId: vaultId,
                path: path,
                name: name,
                remoteSha: remoteSha,
                localContentPath: localContentPath,
                remoteUpdatedAt: remoteUpdatedAt,
                localUpdatedAt: localUpdatedAt,
                syncStatus: syncStatus,
                isDeletedLocally: isDeletedLocally,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$NoteFilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $NoteFilesTable,
      NoteFile,
      $$NoteFilesTableFilterComposer,
      $$NoteFilesTableOrderingComposer,
      $$NoteFilesTableAnnotationComposer,
      $$NoteFilesTableCreateCompanionBuilder,
      $$NoteFilesTableUpdateCompanionBuilder,
      (NoteFile, BaseReferences<_$AppDatabase, $NoteFilesTable, NoteFile>),
      NoteFile,
      PrefetchHooks Function()
    >;
typedef $$NoteDraftsTableCreateCompanionBuilder =
    NoteDraftsCompanion Function({
      required String fileId,
      required String content,
      Value<String?> baseSha,
      required DateTime updatedAt,
      Value<bool> isDirty,
      Value<int> rowid,
    });
typedef $$NoteDraftsTableUpdateCompanionBuilder =
    NoteDraftsCompanion Function({
      Value<String> fileId,
      Value<String> content,
      Value<String?> baseSha,
      Value<DateTime> updatedAt,
      Value<bool> isDirty,
      Value<int> rowid,
    });

class $$NoteDraftsTableFilterComposer
    extends Composer<_$AppDatabase, $NoteDraftsTable> {
  $$NoteDraftsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get fileId => $composableBuilder(
    column: $table.fileId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get baseSha => $composableBuilder(
    column: $table.baseSha,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDirty => $composableBuilder(
    column: $table.isDirty,
    builder: (column) => ColumnFilters(column),
  );
}

class $$NoteDraftsTableOrderingComposer
    extends Composer<_$AppDatabase, $NoteDraftsTable> {
  $$NoteDraftsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get fileId => $composableBuilder(
    column: $table.fileId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get baseSha => $composableBuilder(
    column: $table.baseSha,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDirty => $composableBuilder(
    column: $table.isDirty,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$NoteDraftsTableAnnotationComposer
    extends Composer<_$AppDatabase, $NoteDraftsTable> {
  $$NoteDraftsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get fileId =>
      $composableBuilder(column: $table.fileId, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<String> get baseSha =>
      $composableBuilder(column: $table.baseSha, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get isDirty =>
      $composableBuilder(column: $table.isDirty, builder: (column) => column);
}

class $$NoteDraftsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $NoteDraftsTable,
          NoteDraft,
          $$NoteDraftsTableFilterComposer,
          $$NoteDraftsTableOrderingComposer,
          $$NoteDraftsTableAnnotationComposer,
          $$NoteDraftsTableCreateCompanionBuilder,
          $$NoteDraftsTableUpdateCompanionBuilder,
          (
            NoteDraft,
            BaseReferences<_$AppDatabase, $NoteDraftsTable, NoteDraft>,
          ),
          NoteDraft,
          PrefetchHooks Function()
        > {
  $$NoteDraftsTableTableManager(_$AppDatabase db, $NoteDraftsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NoteDraftsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NoteDraftsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NoteDraftsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> fileId = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<String?> baseSha = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> isDirty = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => NoteDraftsCompanion(
                fileId: fileId,
                content: content,
                baseSha: baseSha,
                updatedAt: updatedAt,
                isDirty: isDirty,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String fileId,
                required String content,
                Value<String?> baseSha = const Value.absent(),
                required DateTime updatedAt,
                Value<bool> isDirty = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => NoteDraftsCompanion.insert(
                fileId: fileId,
                content: content,
                baseSha: baseSha,
                updatedAt: updatedAt,
                isDirty: isDirty,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$NoteDraftsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $NoteDraftsTable,
      NoteDraft,
      $$NoteDraftsTableFilterComposer,
      $$NoteDraftsTableOrderingComposer,
      $$NoteDraftsTableAnnotationComposer,
      $$NoteDraftsTableCreateCompanionBuilder,
      $$NoteDraftsTableUpdateCompanionBuilder,
      (NoteDraft, BaseReferences<_$AppDatabase, $NoteDraftsTable, NoteDraft>),
      NoteDraft,
      PrefetchHooks Function()
    >;
typedef $$SyncJobsTableCreateCompanionBuilder =
    SyncJobsCompanion Function({
      required String id,
      required String fileId,
      required SyncOperation operation,
      Value<int> retryCount,
      Value<String?> lastErrorCode,
      required DateTime createdAt,
      Value<DateTime?> nextRetryAt,
      Value<int> rowid,
    });
typedef $$SyncJobsTableUpdateCompanionBuilder =
    SyncJobsCompanion Function({
      Value<String> id,
      Value<String> fileId,
      Value<SyncOperation> operation,
      Value<int> retryCount,
      Value<String?> lastErrorCode,
      Value<DateTime> createdAt,
      Value<DateTime?> nextRetryAt,
      Value<int> rowid,
    });

class $$SyncJobsTableFilterComposer
    extends Composer<_$AppDatabase, $SyncJobsTable> {
  $$SyncJobsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fileId => $composableBuilder(
    column: $table.fileId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<SyncOperation, SyncOperation, int>
  get operation => $composableBuilder(
    column: $table.operation,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastErrorCode => $composableBuilder(
    column: $table.lastErrorCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get nextRetryAt => $composableBuilder(
    column: $table.nextRetryAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncJobsTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncJobsTable> {
  $$SyncJobsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fileId => $composableBuilder(
    column: $table.fileId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get operation => $composableBuilder(
    column: $table.operation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastErrorCode => $composableBuilder(
    column: $table.lastErrorCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get nextRetryAt => $composableBuilder(
    column: $table.nextRetryAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncJobsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncJobsTable> {
  $$SyncJobsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get fileId =>
      $composableBuilder(column: $table.fileId, builder: (column) => column);

  GeneratedColumnWithTypeConverter<SyncOperation, int> get operation =>
      $composableBuilder(column: $table.operation, builder: (column) => column);

  GeneratedColumn<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lastErrorCode => $composableBuilder(
    column: $table.lastErrorCode,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get nextRetryAt => $composableBuilder(
    column: $table.nextRetryAt,
    builder: (column) => column,
  );
}

class $$SyncJobsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncJobsTable,
          SyncJob,
          $$SyncJobsTableFilterComposer,
          $$SyncJobsTableOrderingComposer,
          $$SyncJobsTableAnnotationComposer,
          $$SyncJobsTableCreateCompanionBuilder,
          $$SyncJobsTableUpdateCompanionBuilder,
          (SyncJob, BaseReferences<_$AppDatabase, $SyncJobsTable, SyncJob>),
          SyncJob,
          PrefetchHooks Function()
        > {
  $$SyncJobsTableTableManager(_$AppDatabase db, $SyncJobsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncJobsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncJobsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncJobsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> fileId = const Value.absent(),
                Value<SyncOperation> operation = const Value.absent(),
                Value<int> retryCount = const Value.absent(),
                Value<String?> lastErrorCode = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> nextRetryAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncJobsCompanion(
                id: id,
                fileId: fileId,
                operation: operation,
                retryCount: retryCount,
                lastErrorCode: lastErrorCode,
                createdAt: createdAt,
                nextRetryAt: nextRetryAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String fileId,
                required SyncOperation operation,
                Value<int> retryCount = const Value.absent(),
                Value<String?> lastErrorCode = const Value.absent(),
                required DateTime createdAt,
                Value<DateTime?> nextRetryAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncJobsCompanion.insert(
                id: id,
                fileId: fileId,
                operation: operation,
                retryCount: retryCount,
                lastErrorCode: lastErrorCode,
                createdAt: createdAt,
                nextRetryAt: nextRetryAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncJobsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncJobsTable,
      SyncJob,
      $$SyncJobsTableFilterComposer,
      $$SyncJobsTableOrderingComposer,
      $$SyncJobsTableAnnotationComposer,
      $$SyncJobsTableCreateCompanionBuilder,
      $$SyncJobsTableUpdateCompanionBuilder,
      (SyncJob, BaseReferences<_$AppDatabase, $SyncJobsTable, SyncJob>),
      SyncJob,
      PrefetchHooks Function()
    >;
typedef $$AppSettingsTableTableCreateCompanionBuilder =
    AppSettingsTableCompanion Function({
      required String key,
      required String value,
      Value<int> rowid,
    });
typedef $$AppSettingsTableTableUpdateCompanionBuilder =
    AppSettingsTableCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<int> rowid,
    });

class $$AppSettingsTableTableFilterComposer
    extends Composer<_$AppDatabase, $AppSettingsTableTable> {
  $$AppSettingsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppSettingsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $AppSettingsTableTable> {
  $$AppSettingsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppSettingsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppSettingsTableTable> {
  $$AppSettingsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$AppSettingsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppSettingsTableTable,
          AppSettingsTableData,
          $$AppSettingsTableTableFilterComposer,
          $$AppSettingsTableTableOrderingComposer,
          $$AppSettingsTableTableAnnotationComposer,
          $$AppSettingsTableTableCreateCompanionBuilder,
          $$AppSettingsTableTableUpdateCompanionBuilder,
          (
            AppSettingsTableData,
            BaseReferences<
              _$AppDatabase,
              $AppSettingsTableTable,
              AppSettingsTableData
            >,
          ),
          AppSettingsTableData,
          PrefetchHooks Function()
        > {
  $$AppSettingsTableTableTableManager(
    _$AppDatabase db,
    $AppSettingsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AppSettingsTableCompanion(
                key: key,
                value: value,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                Value<int> rowid = const Value.absent(),
              }) => AppSettingsTableCompanion.insert(
                key: key,
                value: value,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppSettingsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppSettingsTableTable,
      AppSettingsTableData,
      $$AppSettingsTableTableFilterComposer,
      $$AppSettingsTableTableOrderingComposer,
      $$AppSettingsTableTableAnnotationComposer,
      $$AppSettingsTableTableCreateCompanionBuilder,
      $$AppSettingsTableTableUpdateCompanionBuilder,
      (
        AppSettingsTableData,
        BaseReferences<
          _$AppDatabase,
          $AppSettingsTableTable,
          AppSettingsTableData
        >,
      ),
      AppSettingsTableData,
      PrefetchHooks Function()
    >;
typedef $$RecentFilesTableCreateCompanionBuilder =
    RecentFilesCompanion Function({
      required String fileId,
      required DateTime openedAt,
      Value<int> rowid,
    });
typedef $$RecentFilesTableUpdateCompanionBuilder =
    RecentFilesCompanion Function({
      Value<String> fileId,
      Value<DateTime> openedAt,
      Value<int> rowid,
    });

class $$RecentFilesTableFilterComposer
    extends Composer<_$AppDatabase, $RecentFilesTable> {
  $$RecentFilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get fileId => $composableBuilder(
    column: $table.fileId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get openedAt => $composableBuilder(
    column: $table.openedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RecentFilesTableOrderingComposer
    extends Composer<_$AppDatabase, $RecentFilesTable> {
  $$RecentFilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get fileId => $composableBuilder(
    column: $table.fileId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get openedAt => $composableBuilder(
    column: $table.openedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RecentFilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecentFilesTable> {
  $$RecentFilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get fileId =>
      $composableBuilder(column: $table.fileId, builder: (column) => column);

  GeneratedColumn<DateTime> get openedAt =>
      $composableBuilder(column: $table.openedAt, builder: (column) => column);
}

class $$RecentFilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RecentFilesTable,
          RecentFile,
          $$RecentFilesTableFilterComposer,
          $$RecentFilesTableOrderingComposer,
          $$RecentFilesTableAnnotationComposer,
          $$RecentFilesTableCreateCompanionBuilder,
          $$RecentFilesTableUpdateCompanionBuilder,
          (
            RecentFile,
            BaseReferences<_$AppDatabase, $RecentFilesTable, RecentFile>,
          ),
          RecentFile,
          PrefetchHooks Function()
        > {
  $$RecentFilesTableTableManager(_$AppDatabase db, $RecentFilesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecentFilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RecentFilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RecentFilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> fileId = const Value.absent(),
                Value<DateTime> openedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RecentFilesCompanion(
                fileId: fileId,
                openedAt: openedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String fileId,
                required DateTime openedAt,
                Value<int> rowid = const Value.absent(),
              }) => RecentFilesCompanion.insert(
                fileId: fileId,
                openedAt: openedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RecentFilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RecentFilesTable,
      RecentFile,
      $$RecentFilesTableFilterComposer,
      $$RecentFilesTableOrderingComposer,
      $$RecentFilesTableAnnotationComposer,
      $$RecentFilesTableCreateCompanionBuilder,
      $$RecentFilesTableUpdateCompanionBuilder,
      (
        RecentFile,
        BaseReferences<_$AppDatabase, $RecentFilesTable, RecentFile>,
      ),
      RecentFile,
      PrefetchHooks Function()
    >;
typedef $$ConflictsTableCreateCompanionBuilder =
    ConflictsCompanion Function({
      required String fileId,
      required String serverSha,
      required String serverContent,
      required DateTime detectedAt,
      Value<int> rowid,
    });
typedef $$ConflictsTableUpdateCompanionBuilder =
    ConflictsCompanion Function({
      Value<String> fileId,
      Value<String> serverSha,
      Value<String> serverContent,
      Value<DateTime> detectedAt,
      Value<int> rowid,
    });

class $$ConflictsTableFilterComposer
    extends Composer<_$AppDatabase, $ConflictsTable> {
  $$ConflictsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get fileId => $composableBuilder(
    column: $table.fileId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get serverSha => $composableBuilder(
    column: $table.serverSha,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get serverContent => $composableBuilder(
    column: $table.serverContent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get detectedAt => $composableBuilder(
    column: $table.detectedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ConflictsTableOrderingComposer
    extends Composer<_$AppDatabase, $ConflictsTable> {
  $$ConflictsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get fileId => $composableBuilder(
    column: $table.fileId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get serverSha => $composableBuilder(
    column: $table.serverSha,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get serverContent => $composableBuilder(
    column: $table.serverContent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get detectedAt => $composableBuilder(
    column: $table.detectedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ConflictsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ConflictsTable> {
  $$ConflictsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get fileId =>
      $composableBuilder(column: $table.fileId, builder: (column) => column);

  GeneratedColumn<String> get serverSha =>
      $composableBuilder(column: $table.serverSha, builder: (column) => column);

  GeneratedColumn<String> get serverContent => $composableBuilder(
    column: $table.serverContent,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get detectedAt => $composableBuilder(
    column: $table.detectedAt,
    builder: (column) => column,
  );
}

class $$ConflictsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ConflictsTable,
          Conflict,
          $$ConflictsTableFilterComposer,
          $$ConflictsTableOrderingComposer,
          $$ConflictsTableAnnotationComposer,
          $$ConflictsTableCreateCompanionBuilder,
          $$ConflictsTableUpdateCompanionBuilder,
          (Conflict, BaseReferences<_$AppDatabase, $ConflictsTable, Conflict>),
          Conflict,
          PrefetchHooks Function()
        > {
  $$ConflictsTableTableManager(_$AppDatabase db, $ConflictsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ConflictsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ConflictsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ConflictsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> fileId = const Value.absent(),
                Value<String> serverSha = const Value.absent(),
                Value<String> serverContent = const Value.absent(),
                Value<DateTime> detectedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ConflictsCompanion(
                fileId: fileId,
                serverSha: serverSha,
                serverContent: serverContent,
                detectedAt: detectedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String fileId,
                required String serverSha,
                required String serverContent,
                required DateTime detectedAt,
                Value<int> rowid = const Value.absent(),
              }) => ConflictsCompanion.insert(
                fileId: fileId,
                serverSha: serverSha,
                serverContent: serverContent,
                detectedAt: detectedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ConflictsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ConflictsTable,
      Conflict,
      $$ConflictsTableFilterComposer,
      $$ConflictsTableOrderingComposer,
      $$ConflictsTableAnnotationComposer,
      $$ConflictsTableCreateCompanionBuilder,
      $$ConflictsTableUpdateCompanionBuilder,
      (Conflict, BaseReferences<_$AppDatabase, $ConflictsTable, Conflict>),
      Conflict,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$VaultConfigsTableTableManager get vaultConfigs =>
      $$VaultConfigsTableTableManager(_db, _db.vaultConfigs);
  $$NoteFilesTableTableManager get noteFiles =>
      $$NoteFilesTableTableManager(_db, _db.noteFiles);
  $$NoteDraftsTableTableManager get noteDrafts =>
      $$NoteDraftsTableTableManager(_db, _db.noteDrafts);
  $$SyncJobsTableTableManager get syncJobs =>
      $$SyncJobsTableTableManager(_db, _db.syncJobs);
  $$AppSettingsTableTableTableManager get appSettingsTable =>
      $$AppSettingsTableTableTableManager(_db, _db.appSettingsTable);
  $$RecentFilesTableTableManager get recentFiles =>
      $$RecentFilesTableTableManager(_db, _db.recentFiles);
  $$ConflictsTableTableManager get conflicts =>
      $$ConflictsTableTableManager(_db, _db.conflicts);
}
