# Obsidian Git 모바일 메모 앱 작업 지시서 — Flutter 버전

## 1. 프로젝트 개요

모바일에서 Obsidian Vault로 사용하는 GitHub 저장소의 Markdown 파일을 간편하게 조회하고, 작성하고, 수정하고, GitHub에 커밋하는 개인용 메모 앱을 개발한다.

이 프로젝트의 목적은 Obsidian 전체 기능을 모바일에 재현하는 것이 아니다.

> GitHub 저장소에 보관된 Markdown 문서를 모바일에서 일반 메모장처럼 빠르게 작성하고 자동으로 동기화하는 Flutter 앱

초기 버전에서는 실제 Git CLI, 저장소 전체 Clone, SSH 인증을 사용하지 않는다. GitHub REST API를 사용하여 저장소의 파일을 조회하고 파일 생성·수정·삭제 요청을 커밋 단위로 처리한다.

---

## 2. 개발 원칙

1. Android와 iOS를 하나의 Flutter 코드베이스로 지원한다.
2. MVP에서는 기능보다 안정적인 편집과 동기화를 우선한다.
3. 사용자가 입력한 내용은 네트워크 요청보다 먼저 로컬에 저장한다.
4. GitHub API와 UI를 직접 결합하지 않는다.
5. 인증, 저장소 접근, 로컬 캐시, 동기화 로직을 계층별로 분리한다.
6. 토큰과 사용자 문서 내용을 로그에 출력하지 않는다.
7. GitHub 요청 실패가 문서 유실로 이어지지 않아야 한다.
8. 자동 병합보다 명확한 충돌 감지를 우선한다.

---

## 3. MVP 핵심 목표

- GitHub Fine-grained Personal Access Token 등록
- Token 유효성 검사
- 접근 가능한 GitHub 저장소 목록 조회
- 저장소, 브랜치, Vault 루트 폴더 선택
- 폴더 및 Markdown 파일 탐색
- Markdown 파일 열기
- 일반 텍스트 기반 Markdown 편집
- 로컬 자동 저장
- GitHub 자동 커밋 및 수동 동기화
- 새 Markdown 파일 생성
- 파일명 변경
- 파일 삭제
- 파일 검색
- 동기화 상태 표시
- SHA 기반 충돌 감지
- 충돌 시 서버 버전과 로컬 버전 비교
- `.obsidian` 폴더 기본 숨김
- 다크 모드 지원

---

## 4. MVP 비대상 기능

초기 버전에는 다음 기능을 구현하지 않는다.

- Obsidian 플러그인 실행
- Graph View
- Canvas 편집
- Git CLI Clone, Pull, Push
- SSH 키 인증
- 자동 Git Merge
- 실시간 공동 편집
- 이미지 첨부 및 업로드
- PDF 또는 Office 문서 편집
- 여러 Git 공급자 지원
- AI 요약 및 AI 글쓰기
- GitHub OAuth
- 백그라운드 상시 동기화
- 여러 Vault 동시 연결

---

## 5. 대상 플랫폼

우선순위:

1. Android
2. iOS

Flutter 최신 Stable 채널을 사용한다. 개발 시작 시점의 Flutter 및 Dart 최신 Stable 버전을 기준으로 패키지 호환성을 확인한다.

---

## 6. 권장 기술 스택

### 6.1 애플리케이션

- Flutter
- Dart
- Material 3

### 6.2 상태 관리

- `flutter_riverpod` 권장
- 비동기 데이터에는 `AsyncNotifier` 또는 `Notifier` 사용
- 화면 내부의 단순 UI 상태는 `StatefulWidget` 또는 Hook 사용 가능

Provider가 지나치게 세분화되지 않도록 기능 단위로 구성한다.

### 6.3 라우팅

- `go_router`

필요 라우트 예시:

```text
/splash
/setup/token
/setup/repository
/setup/branch
/files
/editor
/search
/conflict
/settings
```

### 6.4 네트워크

- `dio`
- GitHub REST API 직접 연동

공통 Interceptor에서 다음을 처리한다.

- Authorization Header
- GitHub API Version Header
- 공통 timeout
- HTTP 오류 변환
- Rate Limit Header 수집

### 6.5 안전한 인증정보 저장

- `flutter_secure_storage`

GitHub Token은 Secure Storage에만 저장한다.

### 6.6 로컬 데이터베이스

- `drift` + `sqlite3_flutter_libs` 권장

저장 대상:

- 앱 설정
- 선택한 저장소 정보
- 파일 메타데이터
- 로컬 초안
- 동기화 상태
- 충돌 정보
- 최근 파일

단순 구현을 우선할 경우 `sqflite`도 허용하지만, 타입 안정성과 마이그레이션을 위해 Drift를 우선한다.

### 6.7 파일 캐시

- `path_provider`
- `dart:io`
- 필요 시 `path`

Markdown 원문은 앱 Documents 또는 Support 디렉터리에 저장할 수 있다. 파일명 충돌 방지를 위해 저장소, 브랜치, 경로를 해시한 내부 경로를 사용한다.

### 6.8 연결 상태

- `connectivity_plus`

단, 연결 상태가 Wi-Fi 또는 Mobile이라고 해서 실제 인터넷이 가능한 것은 아니므로 API 요청 실패 처리를 반드시 별도로 구현한다.

### 6.9 Markdown

- 편집: Flutter 기본 `TextField` 또는 `EditableText`
- 미리보기: `flutter_markdown`

MVP에서는 WebView 기반 고급 에디터를 사용하지 않는다.

### 6.10 모델 및 JSON 직렬화

권장:

- `freezed`
- `json_serializable`
- `build_runner`

초기 구현 속도가 더 중요하면 수동 모델도 가능하지만, API DTO와 도메인 모델을 분리한다.

### 6.11 기타

- `package_info_plus`
- `url_launcher`
- `share_plus` 선택
- `intl`
- `uuid`
- `crypto`

---

## 7. 권장 아키텍처

Feature-first 구조와 Repository Pattern을 사용한다.

```text
lib/
├── app/
│   ├── app.dart
│   ├── router.dart
│   └── theme.dart
├── core/
│   ├── constants/
│   ├── errors/
│   ├── network/
│   ├── storage/
│   ├── utils/
│   └── widgets/
├── features/
│   ├── auth/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   ├── repository_selection/
│   ├── file_browser/
│   ├── editor/
│   ├── sync/
│   ├── search/
│   ├── conflict/
│   └── settings/
└── main.dart
```

각 Feature 내부 구조:

```text
feature/
├── data/
│   ├── datasources/
│   ├── dto/
│   └── repositories/
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── usecases/
└── presentation/
    ├── controllers/
    ├── pages/
    └── widgets/
```

과도한 Clean Architecture 보일러플레이트는 피하되, 다음 경계는 유지한다.

- UI는 Dio를 직접 호출하지 않는다.
- UI는 Drift DAO를 직접 호출하지 않는다.
- GitHub DTO를 화면에서 직접 사용하지 않는다.
- 동기화 정책은 Editor 화면과 분리한다.

---

## 8. 인증 방식

### 8.1 MVP 인증

GitHub Fine-grained Personal Access Token을 사용자가 직접 입력한다.

필요 권한:

- Repository contents: Read and write
- Metadata: Read-only

사용자가 선택한 저장소에만 접근 가능한 Fine-grained Token 사용을 안내한다.

### 8.2 Token 저장 규칙

Token은 `flutter_secure_storage`에 저장한다.

저장 금지 위치:

- SharedPreferences
- Drift 일반 테이블
- 앱 로그
- Crash Report의 Custom Field
- 오류 메시지
- Analytics

### 8.3 인증 추상화

향후 OAuth로 교체할 수 있도록 인터페이스를 둔다.

```dart
abstract interface class GitHubAuthRepository {
  Future<String?> getToken();
  Future<void> saveToken(String token);
  Future<void> deleteToken();
  Future<GitHubUser> validateToken(String token);
}
```

### 8.4 Token 검증

Token 입력 후 GitHub 사용자 API를 호출하여 검증한다.

성공 시:

- 로그인 사용자명
- 프로필 이미지 URL
- 사용자 ID

를 로컬 설정에 저장한다.

실패 시 Token 자체는 로그에 포함하지 않는다.

---

## 9. GitHub REST API 연동

GitHub API Base URL:

```text
https://api.github.com
```

공통 Header 예시:

```text
Accept: application/vnd.github+json
Authorization: Bearer {TOKEN}
X-GitHub-Api-Version: 2022-11-28
```

구현이 필요한 기능:

1. 현재 사용자 조회
2. 사용자 저장소 목록 조회
3. 저장소 상세 조회
4. 브랜치 목록 조회
5. 저장소 콘텐츠 목록 조회
6. 파일 콘텐츠 조회
7. 파일 생성 또는 수정
8. 파일 삭제
9. 필요 시 커밋 또는 Blob 조회

파일 생성·수정 시 Content API를 사용한다.

요청 Body 개념:

```json
{
  "message": "Update notes/idea.md from mobile",
  "content": "BASE64_ENCODED_CONTENT",
  "branch": "main",
  "sha": "CURRENT_FILE_SHA"
}
```

새 파일 생성 시 `sha`를 보내지 않는다.

파일 수정 시 서버에서 마지막으로 읽은 `sha`를 반드시 포함한다.

---

## 10. 주요 사용자 흐름

### 10.1 최초 실행

1. Splash 화면
2. 저장된 Token 확인
3. Token이 없으면 Token 설정 화면 이동
4. Token 입력
5. 유효성 검사
6. 사용자 정보 표시
7. 저장소 선택
8. 브랜치 선택
9. Vault 루트 폴더 선택
10. 파일 탐색 화면 이동

### 10.2 일반 사용

1. 앱 실행
2. 마지막 저장소와 브랜치 복원
3. 로컬 캐시 파일 목록 즉시 표시
4. 온라인 상태라면 서버 목록 새로고침
5. 파일 선택
6. 로컬 초안을 우선 확인
7. 초안이 없으면 캐시 또는 GitHub 원문 로드
8. 편집
9. 로컬 자동 저장
10. 입력 정지 후 동기화 예약
11. 서버 SHA 확인
12. 충돌이 없으면 커밋
13. 커밋 성공 후 로컬 상태 갱신

### 10.3 새 메모 작성

1. 새 메모 버튼 선택
2. 파일명 입력
3. 저장 폴더 선택
4. `.md` 확장자 자동 보정
5. 로컬 임시 문서 생성
6. 편집 화면 진입
7. 첫 자동 저장
8. 온라인 상태이면 GitHub 새 파일 생성

### 10.4 오프라인 편집

1. 인터넷이 없어도 캐시된 파일 열기
2. 수정 내용 로컬 저장
3. 상태를 `pendingUpload`로 변경
4. 연결 복구 또는 사용자의 동기화 요청 시 업로드
5. 업로드 전 서버 SHA 검사

---

## 11. 화면 구성

## 11.1 Splash 화면

- 앱 로고
- 저장된 설정 로드
- Secure Storage Token 확인
- DB 초기화 및 마이그레이션
- 마지막 Vault 유효성 확인

오래 걸리는 작업은 Splash에서 모두 기다리지 않는다. 최소 초기화 후 다음 화면으로 이동하고 데이터는 비동기로 갱신한다.

## 11.2 GitHub 연결 화면

구성:

- Token 입력 필드
- 표시/숨김 버튼
- 연결 확인 버튼
- GitHub Token 발급 안내 링크
- 최소 권한 안내
- 보안 안내

오류 메시지 예시:

- Token이 올바르지 않습니다.
- 선택한 저장소에 대한 쓰기 권한이 없습니다.
- 인터넷 연결을 확인해 주세요.
- GitHub API 요청 한도에 도달했습니다.

## 11.3 저장소 선택 화면

- 저장소 검색
- 저장소 목록
- Public/Private 표시
- Owner/Repository 표시
- 최근 사용 저장소 우선 표시
- 새로고침

목록은 pagination을 지원한다.

## 11.4 브랜치 및 Vault 폴더 선택 화면

- 기본 브랜치 자동 선택
- 브랜치 변경
- 저장소 폴더 탐색
- Vault Root 선택
- `/` 선택 가능

선택 완료 시 저장소 ID, owner, repo, branch, vault root를 저장한다.

## 11.5 파일 탐색 화면

AppBar:

- 현재 Vault 이름
- 현재 경로
- 뒤로 가기
- 검색
- 동기화
- 설정

목록 정렬:

1. 폴더
2. Markdown 파일
3. 이름 오름차순

기본 숨김:

- `.obsidian`
- 숨김 폴더
- `.md` 외 파일

Floating Action Button 또는 하단 버튼:

- 새 메모
- 새 폴더

파일 항목 표시:

- 파일명
- 아이콘
- 최근 수정 시각
- 동기화 상태
- 충돌 여부

지원 제스처:

- 탭: 열기
- 길게 누르기: 이름 변경, 삭제, 경로 복사

## 11.6 편집 화면

구성:

- 파일명
- 현재 폴더 경로
- 저장 상태
- 편집/미리보기 전환
- 더보기 메뉴
- 전체 화면 TextField

편집기 요구사항:

- 여러 줄 입력
- 자동 줄바꿈
- 시스템 글자 크기 대응
- Undo/Redo는 Flutter 기본 기능 범위에서 지원
- 키보드 닫기
- Markdown 특수문자 입력 지원
- 긴 문서 스크롤
- 현재 커서 위치 유지
- 화면 회전 시 내용 유지

저장 상태:

```text
저장됨
로컬 저장 중
동기화 대기
동기화 중
오프라인
충돌 발생
동기화 실패
```

## 11.7 검색 화면

MVP 검색 범위:

- 파일명 검색
- 로컬 캐시에 저장된 문서 내용 검색

검색 결과:

- 파일명
- 경로
- 일치 문장 일부

전체 저장소 서버 검색 API에 의존하지 않는다.

## 11.8 충돌 해결 화면

- 서버 버전
- 내 로컬 버전
- 서버 최종 수정 정보
- 내 로컬 수정 시각

버튼:

- 서버 버전 사용
- 내 버전으로 덮어쓰기
- 두 버전을 합친 새 파일 생성
- 나중에 처리

MVP에서는 문장 단위 자동 Merge를 구현하지 않는다.

## 11.9 설정 화면

- GitHub 계정 정보
- Token 변경
- 저장소 변경
- 브랜치 변경
- Vault Root 변경
- 자동 동기화 On/Off
- 자동 동기화 지연시간
- 숨김 파일 표시
- `.md` 외 파일 표시 여부
- 테마: 시스템/라이트/다크
- 캐시 삭제
- 로그아웃
- 앱 버전

---

## 12. 편집 및 자동 저장 정책

### 12.1 로컬 자동 저장

입력 변경 후 300~800ms debounce를 적용하여 로컬 초안을 저장한다.

로컬 저장은 GitHub 동기화와 별개다.

사용자가 입력한 내용은 다음 상황에서도 보존되어야 한다.

- 앱 강제 종료
- 네트워크 끊김
- GitHub API 실패
- 화면 이동
- 앱 백그라운드 전환

### 12.2 GitHub 자동 동기화

입력이 멈춘 뒤 기본 5초 후 업로드를 예약한다.

동기화 실행 조건:

- 로컬 변경사항 존재
- 인터넷 연결 가능
- 다른 업로드 진행 중이 아님
- 충돌 상태가 아님
- Token과 Vault 설정이 유효함

앱이 백그라운드로 전환될 때 로컬 저장은 즉시 수행한다. 네트워크 커밋은 OS 정책상 완료가 보장되지 않으므로 로컬 저장을 우선한다.

### 12.3 수동 동기화

사용자가 Sync 버튼을 누르면:

1. 현재 편집 내용을 로컬 저장
2. Pending 작업 확인
3. 서버 SHA 확인
4. 충돌 없는 파일 순차 업로드
5. 서버 목록 갱신
6. 결과 요약 표시

동시에 너무 많은 GitHub API 요청을 보내지 않는다.

---

## 13. 충돌 감지 정책

파일을 읽을 때 서버 SHA를 저장한다.

예시:

```text
baseSha = abc123
```

업로드 직전에 서버의 현재 SHA를 다시 확인한다.

```text
현재 serverSha = def456
```

`baseSha != serverSha`이고 로컬 변경사항이 있으면 충돌로 판단한다.

### 충돌 시 금지 행동

- 사용자 확인 없이 서버 파일 덮어쓰기
- 로컬 초안 삭제
- 실패를 성공 상태로 표시

### 내 버전으로 덮어쓰기

사용자가 명시적으로 선택한 경우에만 최신 server SHA를 사용해 로컬 내용을 커밋한다.

### 합친 새 파일 생성

예시:

```text
ideas-conflict-2026-07-17-153000.md
```

파일 이름은 동일 폴더 안에서 중복되지 않게 생성한다.

---

## 14. 데이터 모델

### 14.1 VaultConfig

```dart
class VaultConfig {
  final String id;
  final String owner;
  final String repository;
  final int repositoryId;
  final String branch;
  final String rootPath;
  final DateTime createdAt;
  final DateTime updatedAt;
}
```

### 14.2 NoteFile

```dart
class NoteFile {
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
}
```

### 14.3 NoteDraft

```dart
class NoteDraft {
  final String fileId;
  final String content;
  final String? baseSha;
  final DateTime updatedAt;
  final bool isDirty;
}
```

문서가 매우 커질 가능성을 고려해 DB에 본문을 넣는 대신 파일 시스템에 저장하는 구조도 허용한다.

### 14.4 SyncStatus

```dart
enum SyncStatus {
  synced,
  localOnly,
  pendingUpload,
  uploading,
  pendingDelete,
  conflict,
  failed,
}
```

### 14.5 SyncJob

```dart
class SyncJob {
  final String id;
  final String fileId;
  final SyncOperation operation;
  final int retryCount;
  final String? lastErrorCode;
  final DateTime createdAt;
  final DateTime? nextRetryAt;
}
```

---

## 15. 로컬 DB 테이블 예시

- `vault_configs`
- `note_files`
- `note_drafts`
- `sync_jobs`
- `app_settings`
- `recent_files`
- `conflicts`

DB 마이그레이션 버전을 관리한다.

삭제 작업은 서버 반영 전까지 Tombstone 상태로 남겨야 한다.

---

## 16. 동기화 엔진 요구사항

`SyncService` 또는 `SyncCoordinator`를 별도 구현한다.

책임:

- Pending 작업 조회
- 파일별 직렬 처리
- SHA 검사
- 업로드
- 삭제
- Retry
- 충돌 생성
- DB 상태 갱신

인터페이스 예시:

```dart
abstract interface class SyncCoordinator {
  Future<SyncSummary> syncAll();
  Future<SyncResult> syncFile(String fileId);
  Future<void> enqueueUpload(String fileId);
  Future<void> enqueueDelete(String fileId);
}
```

동일 파일에 대해 중복 Sync Job이 생성되지 않도록 한다.

네트워크 오류 Retry:

- 즉시 무한 재시도 금지
- 지수 Backoff 적용
- 사용자가 수동 재시도 가능
- 401/403은 자동 Retry하지 않음
- 409 또는 SHA 불일치는 충돌 처리

---

## 17. 오류 처리

앱 내부 오류를 사용자 메시지와 분리한다.

예시 오류 타입:

```dart
sealed class AppFailure {}
class NetworkFailure extends AppFailure {}
class UnauthorizedFailure extends AppFailure {}
class PermissionDeniedFailure extends AppFailure {}
class RateLimitFailure extends AppFailure {}
class ConflictFailure extends AppFailure {}
class LocalStorageFailure extends AppFailure {}
class ValidationFailure extends AppFailure {}
class UnknownFailure extends AppFailure {}
```

사용자 메시지는 기술적인 Stack Trace를 노출하지 않는다.

Rate Limit 발생 시 reset time을 확인하고 사용자가 이해할 수 있게 표시한다.

---

## 18. 파일명 및 경로 검증

- 빈 파일명 금지
- `/`가 포함된 파일명 금지
- 상대경로 공격 방지를 위해 `..` 검증
- `.md` 확장자 자동 추가
- 같은 폴더에 동일 파일명 존재 여부 확인
- GitHub 경로는 UTF-8 처리
- Windows/macOS에서 문제가 될 수 있는 특수문자 경고

파일명 변경은 GitHub Contents API 특성상 다음 순서로 처리할 수 있다.

1. 새 경로에 동일 내용으로 파일 생성
2. 기존 경로 파일 삭제
3. 둘 중 하나가 실패하면 사용자에게 부분 실패 표시

가능하면 해당 작업을 하나의 고수준 Rename 작업으로 로컬 큐에 보관한다.

---

## 19. Obsidian 호환 규칙

- Markdown 원문을 불필요하게 재포맷하지 않는다.
- YAML Front Matter를 유지한다.
- `[[Wiki Link]]` 텍스트를 그대로 보존한다.
- `![[Embed]]` 문법을 그대로 보존한다.
- 태그를 임의 변경하지 않는다.
- 줄바꿈 형식을 불필요하게 바꾸지 않는다.
- `.obsidian` 폴더는 기본 숨김 처리한다.
- 앱 전용 메타데이터를 Markdown 본문에 삽입하지 않는다.

MVP 미리보기에서 Wiki Link를 실제 링크로 해석하지 않아도 된다.

---

## 20. 보안 요구사항

1. Token은 Secure Storage에만 저장한다.
2. 모든 GitHub 통신은 HTTPS만 사용한다.
3. Token을 URL Query Parameter로 전달하지 않는다.
4. Release Build에서 Debug Logging을 비활성화한다.
5. Token, 문서 본문, Authorization Header를 로그에서 마스킹한다.
6. Clipboard로 Token을 복사한 사실을 장기간 저장하지 않는다.
7. Logout 시 Token과 사용자 설정을 삭제한다.
8. 캐시 삭제 시 문서 캐시와 초안을 구분한다.
9. 미동기화 초안이 있으면 삭제 전 경고한다.

---

## 21. UX 요구사항

- 앱 실행 후 최근 파일 목록 또는 마지막 폴더를 빠르게 표시한다.
- 서버 응답을 기다리는 동안 빈 화면만 표시하지 않는다.
- 로컬 캐시를 먼저 렌더링한다.
- 현재 저장 상태를 편집 화면에서 항상 확인할 수 있어야 한다.
- 동기화 실패 시 사용자가 글을 계속 작성할 수 있어야 한다.
- Snackbar는 짧은 결과에만 사용한다.
- 중요한 충돌과 데이터 삭제는 Dialog 또는 전용 화면으로 표시한다.
- 작은 모바일 화면에서 파일 경로는 말줄임 처리하되 전체 경로 확인 기능을 제공한다.
- 접근성을 위해 터치 영역은 충분히 크게 구성한다.

---

## 22. 테스트 요구사항

### Unit Test

- 파일명 검증
- 경로 정규화
- Base64 인코딩/디코딩
- SHA 충돌 판단
- 자동 저장 debounce
- Sync Job 중복 방지
- Retry 정책

### Repository Test

- GitHub API 응답 DTO 변환
- Token 검증
- 파일 목록 조회
- 파일 생성/수정/삭제
- HTTP 오류 변환

### Widget Test

- Token 입력 화면
- 파일 목록 화면
- 편집 화면 저장 상태
- 충돌 Dialog
- 설정 변경

### Integration Test

- Token 등록 → 저장소 선택 → 파일 열기
- 새 파일 생성 → 편집 → GitHub 업로드
- 기존 파일 수정 → 커밋
- 오프라인 수정 → 온라인 복귀 → 동기화
- 서버 변경 발생 → 충돌 화면 표시

실제 GitHub API 테스트에는 테스트 전용 저장소를 사용한다. Token과 저장소 정보는 소스 코드에 포함하지 않는다.

---

## 23. 개발 단계

### 1단계: 프로젝트 기반

- Flutter 프로젝트 생성
- Material 3 Theme
- go_router
- Riverpod
- Dio Client
- Secure Storage
- Drift 초기화
- 공통 오류 모델

### 2단계: GitHub 연결

- Token 입력
- Token 검증
- 사용자 정보 표시
- 저장소 목록
- 브랜치 목록
- Vault Root 선택

### 3단계: 파일 탐색

- GitHub Contents API
- 폴더 이동
- Markdown 필터
- `.obsidian` 숨김
- 로컬 캐시

### 4단계: 편집기

- TextField 기반 편집기
- 로컬 자동 저장
- Markdown 미리보기
- 저장 상태 표시
- 앱 Lifecycle 대응

### 5단계: 동기화

- 파일 생성 및 수정
- 자동 동기화 debounce
- Sync Queue
- Retry
- 수동 동기화

### 6단계: 충돌 및 삭제

- SHA 비교
- 충돌 화면
- 덮어쓰기
- 충돌 파일 생성
- 파일 삭제
- 파일명 변경

### 7단계: 검색 및 설정

- 파일명 검색
- 캐시 본문 검색
- 테마
- 자동 동기화 설정
- 캐시 관리

### 8단계: 안정화

- Unit/Widget/Integration Test
- Android Release Build
- iOS Build 확인
- 장문 편집 성능 확인
- API Rate Limit 대응
- 앱 강제 종료 복구 테스트

---

## 24. 완료 기준

다음 조건을 모두 만족해야 MVP 완료로 본다.

1. Android 실제 기기에서 실행된다.
2. GitHub Token이 안전하게 저장된다.
3. Private 저장소를 선택할 수 있다.
4. 지정된 브랜치와 Vault Root를 탐색할 수 있다.
5. Markdown 파일을 열고 수정할 수 있다.
6. 수정 내용이 앱 종료 후에도 남아 있다.
7. 수정한 파일이 GitHub에 정상 커밋된다.
8. 오프라인 수정이 유실되지 않는다.
9. 서버 파일이 변경되었을 때 충돌을 감지한다.
10. 충돌 상태에서 사용자 확인 없이 덮어쓰지 않는다.
11. 새 파일 생성, 이름 변경, 삭제가 가능하다.
12. `.obsidian` 폴더가 기본적으로 숨겨진다.
13. Token이나 문서 내용이 로그에 노출되지 않는다.
14. 주요 기능에 자동 테스트가 존재한다.

---

## 25. AI 코딩 작업 규칙

코딩 AI는 다음 규칙을 지킨다.

1. 한 번에 전체 앱을 생성하지 말고 단계별로 구현한다.
2. 각 단계 시작 전 현재 구조와 변경 파일을 설명한다.
3. 패키지를 추가할 때 선택 이유를 설명한다.
4. Deprecated API를 사용하지 않는다.
5. Flutter Analyzer 오류를 남기지 않는다.
6. `dart format`을 적용한다.
7. Null Safety를 준수한다.
8. UI 코드에 API 호출을 직접 작성하지 않는다.
9. Token과 문서 본문을 Debug Print하지 않는다.
10. Mock 데이터와 실제 API 코드를 명확히 구분한다.
11. 각 단계 완료 후 실행 방법과 테스트 방법을 제공한다.
12. 기존 동작을 깨뜨리는 대규모 리팩터링은 이유 없이 수행하지 않는다.
13. 플랫폼별 설정 변경 사항을 README에 기록한다.
14. Android와 iOS 권한을 최소화한다.
15. 구현되지 않은 기능을 구현된 것처럼 표시하지 않는다.

---

## 26. AI에게 전달할 최초 명령

```text
첨부한 작업 지시서를 기준으로 Flutter 앱을 개발해라.

우선 전체 코드를 한 번에 만들지 말고 1단계 프로젝트 기반부터 시작한다.

필수 조건:
- Flutter 최신 Stable 및 Dart Null Safety 사용
- Material 3
- Riverpod
- go_router
- Dio
- flutter_secure_storage
- Drift
- Feature-first 구조
- Android 우선, iOS 호환 고려
- GitHub Token이나 Markdown 본문을 로그에 출력하지 말 것

먼저 다음을 수행해라.
1. 권장 프로젝트 폴더 구조를 제시한다.
2. 필요한 pubspec.yaml 패키지와 선택 이유를 설명한다.
3. 앱 Theme, Router, Riverpod ProviderScope, Dio Client, Secure Storage, Drift DB 기본 구조를 구현한다.
4. Splash 화면과 GitHub Token 입력 화면의 UI를 만든다.
5. 아직 실제 GitHub API를 연결하지 말고 Repository Interface와 Mock 구현을 분리한다.
6. flutter analyze와 테스트가 통과하도록 작성한다.
7. 생성하거나 수정한 파일 목록과 실행 방법을 마지막에 설명한다.

작업 지시서에 없는 기능을 임의로 확대하지 마라.
```

---

## 27. 추천 앱 이름

임시 프로젝트명:

- RepoNote
- PocketVault
- GitMemo
- VaultNote
- CommitNote

코드 내부 임시 명칭은 `repo_note`를 사용한다.

예시:

```text
Flutter project name: repo_note
Android applicationId: com.backdev.reponote
```

applicationId는 실제 배포 전에 최종 확인한다.
