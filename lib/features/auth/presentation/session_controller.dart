import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/providers.dart';
import '../../../core/storage/app_database.dart';
import '../data/github_auth_repository_impl.dart';
import '../domain/github_auth_repository.dart';
import '../domain/github_user.dart';

final gitHubAuthRepositoryProvider = Provider<GitHubAuthRepository>((ref) {
  return GitHubAuthRepositoryImpl(
    tokenStorage: ref.watch(secureTokenStorageProvider),
    apiClient: ref.watch(gitHubApiClientProvider),
  );
});

/// 로그인 사용자와 활성 Vault를 포함한 세션 상태.
class SessionState {
  const SessionState({this.hasToken = false, this.user, this.vault});

  final bool hasToken;
  final GitHubUser? user;
  final VaultConfig? vault;

  bool get isReady => hasToken && vault != null;

  SessionState copyWith({
    bool? hasToken,
    GitHubUser? user,
    VaultConfig? vault,
    bool clearVault = false,
  }) => SessionState(
    hasToken: hasToken ?? this.hasToken,
    user: user ?? this.user,
    vault: clearVault ? null : (vault ?? this.vault),
  );
}

class SessionController extends AsyncNotifier<SessionState> {
  static const _kUserId = 'user_id';
  static const _kUserLogin = 'user_login';
  static const _kUserAvatar = 'user_avatar';
  static const _kActiveVaultId = 'active_vault_id';

  AppDatabase get _db => ref.read(databaseProvider);

  @override
  Future<SessionState> build() async {
    final auth = ref.read(gitHubAuthRepositoryProvider);
    final token = await auth.getToken();
    if (token == null || token.isEmpty) return const SessionState();

    GitHubUser? user;
    final idText = await _db.getSetting(_kUserId);
    final login = await _db.getSetting(_kUserLogin);
    if (idText != null && login != null) {
      user = GitHubUser(
        id: int.tryParse(idText) ?? 0,
        login: login,
        avatarUrl: await _db.getSetting(_kUserAvatar) ?? '',
      );
    }

    VaultConfig? vault;
    final vaultId = await _db.getSetting(_kActiveVaultId);
    if (vaultId != null) vault = await _db.getVault(vaultId);

    return SessionState(hasToken: true, user: user, vault: vault);
  }

  /// Token 검증 후 저장한다. 실패 시 AppFailure를 던진다.
  Future<void> registerToken(String token) async {
    final auth = ref.read(gitHubAuthRepositoryProvider);
    final user = await auth.validateToken(token);
    await auth.saveToken(token);
    await _db.setSetting(_kUserId, user.id.toString());
    await _db.setSetting(_kUserLogin, user.login);
    await _db.setSetting(_kUserAvatar, user.avatarUrl);
    final current = state.value ?? const SessionState();
    state = AsyncData(current.copyWith(hasToken: true, user: user));
  }

  /// 저장소/브랜치/Vault Root 선택을 완료하고 활성 Vault로 저장한다.
  Future<void> setVault({
    required String owner,
    required String repository,
    required int repositoryId,
    required String branch,
    required String rootPath,
  }) async {
    final now = DateTime.now();
    final id = const Uuid().v4();
    await _db.upsertVault(
      VaultConfigsCompanion(
        id: Value(id),
        owner: Value(owner),
        repository: Value(repository),
        repositoryId: Value(repositoryId),
        branch: Value(branch),
        rootPath: Value(rootPath),
        createdAt: Value(now),
        updatedAt: Value(now),
      ),
    );
    await _db.setSetting(_kActiveVaultId, id);
    final vault = await _db.getVault(id);
    final current = state.value ?? const SessionState();
    state = AsyncData(current.copyWith(vault: vault));
  }

  /// 로그아웃: Token, 사용자 설정, 로컬 데이터를 삭제한다.
  Future<void> logout() async {
    final auth = ref.read(gitHubAuthRepositoryProvider);
    await auth.deleteToken();
    await _db.clearEverything();
    await ref.read(localFileCacheProvider).clearAll();
    state = const AsyncData(SessionState());
  }
}

final sessionControllerProvider =
    AsyncNotifierProvider<SessionController, SessionState>(
      SessionController.new,
    );
