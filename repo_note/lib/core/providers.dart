import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'network/github_api_client.dart';
import 'storage/app_database.dart';
import 'storage/local_file_cache.dart';
import 'storage/secure_token_storage.dart';

final secureTokenStorageProvider = Provider<SecureTokenStorage>(
  (ref) => SecureTokenStorage(),
);

final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

final localFileCacheProvider = Provider<LocalFileCache>(
  (ref) => LocalFileCache(),
);

final gitHubApiClientProvider = Provider<GitHubApiClient>((ref) {
  final storage = ref.watch(secureTokenStorageProvider);
  return GitHubApiClient(tokenProvider: storage.readToken);
});

/// 현재 네트워크 연결 여부. 실제 인터넷 가능 여부는 API 실패 처리로 보완한다.
final connectivityProvider = StreamProvider<bool>((ref) async* {
  final connectivity = Connectivity();
  final initial = await connectivity.checkConnectivity();
  yield !initial.contains(ConnectivityResult.none);
  await for (final results in connectivity.onConnectivityChanged) {
    yield !results.contains(ConnectivityResult.none);
  }
});
