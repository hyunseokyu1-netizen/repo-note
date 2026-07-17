/// 스토어 스크린샷 전용 엔트리포인트. 절대 배포 빌드에 사용하지 않는다.
///
/// 실행:
///   flutter run -t lib/screenshots/main_screenshots.dart \
///     --dart-define=SCREENSHOT_LOCALE=ko
library;

import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../app/app.dart';
import '../core/providers.dart';
import '../core/storage/app_database.dart';
import '../core/storage/secure_token_storage.dart';
import 'fake_github_api.dart';

const _locale = String.fromEnvironment('SCREENSHOT_LOCALE', defaultValue: 'ko');

const _koTree = <String, List<String>>{
  '': ['dir:아이디어', 'dir:프로젝트', 'dir:회의록', 'dir:공부', '오늘 할 일.md', '독서 노트.md'],
  '아이디어': ['돈 버는 방법.md', '앱 아이디어.md'],
  '프로젝트': ['RepoNote 개선사항.md', '블로그 자동화.md'],
  '회의록': ['주간 회의.md'],
  '공부': ['AI 관련 유튜브.md', '독일어 진도율.md'],
};

const _koContents = <String, String>{
  '오늘 할 일.md': '''# 오늘 할 일

## 오전
- [x] 이메일 정리
- [x] 주간 회의 준비
- [ ] 블로그 초안 마무리

## 오후
- [ ] RepoNote 아이콘 다듬기
- [ ] 독일어 강의 1강
- [ ] 운동 30분

> 메모는 GitHub에 자동으로 커밋됩니다.
저장 걱정 없이 쓰기만 하세요.

관련 노트: [[독서 노트]] [[앱 아이디어]]
''',
  '독서 노트.md': '# 독서 노트\n\n- 아주 작은 습관의 힘\n- 프로그래머의 뇌\n',
};

const _enTree = <String, List<String>>{
  '': [
    'dir:Ideas',
    'dir:Projects',
    'dir:Meetings',
    'dir:Study',
    'Today.md',
    'Reading notes.md',
  ],
  'Ideas': ['Side project ideas.md', 'App ideas.md'],
  'Projects': ['RepoNote improvements.md', 'Blog automation.md'],
  'Meetings': ['Weekly sync.md'],
  'Study': ['AI YouTube list.md', 'German progress.md'],
};

const _enContents = <String, String>{
  'Today.md': '''# Today

## Morning
- [x] Inbox zero
- [x] Prepare weekly sync
- [ ] Finish blog draft

## Afternoon
- [ ] Polish RepoNote icon
- [ ] German lesson 1
- [ ] Workout 30 min

> Your notes are committed to GitHub automatically.
Just write — saving is handled for you.

Related: [[Reading notes]] [[App ideas]]
''',
  'Reading notes.md':
      '# Reading notes\n\n- Atomic Habits\n- The Programmer\'s Brain\n',
};

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final isKo = _locale == 'ko';
  final api = FakeGitHubApiClient(
    tree: isKo ? _koTree : _enTree,
    contents: isKo ? _koContents : _enContents,
  );

  // 데모 세션 시드: 토큰 + 사용자 + Vault
  final tokenStorage = SecureTokenStorage();
  await tokenStorage.writeToken('demo');

  final db = AppDatabase();
  await db.setSetting('user_id', '1');
  await db.setSetting('user_login', 'demo-user');
  await db.setSetting('user_avatar', '');
  const vaultId = 'demo-vault';
  final now = DateTime.now();
  await db.upsertVault(
    VaultConfigsCompanion(
      id: const Value(vaultId),
      owner: const Value('demo-user'),
      repository: const Value('obsidian-notes'),
      repositoryId: const Value(1),
      branch: const Value('main'),
      rootPath: const Value(''),
      createdAt: Value(now),
      updatedAt: Value(now),
    ),
  );
  await db.setSetting('active_vault_id', vaultId);

  runApp(
    ProviderScope(
      overrides: [
        gitHubApiClientProvider.overrideWithValue(api),
        databaseProvider.overrideWithValue(db),
        secureTokenStorageProvider.overrideWithValue(tokenStorage),
      ],
      child: RepoNoteApp(localeOverride: Locale(_locale)),
    ),
  );
}
