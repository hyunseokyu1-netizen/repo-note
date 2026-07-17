# RepoNote

[English](README.md) | **한국어**

GitHub 저장소를 Obsidian Vault처럼 사용하는 개인용 모바일 메모 앱 (Flutter).

GitHub REST API(Contents API)로 Markdown 파일을 조회·작성·수정·삭제하고 커밋 단위로 동기화한다.
Git CLI, 전체 Clone, SSH 인증은 사용하지 않는다.

## 만든 이유

모바일에서 Obsidian과 Git을 연결하는 과정이 너무 복잡했다. 플러그인 설정은 번거롭고,
막상 연결해도 충돌(conflict)이 나면 폰에서 해결하기가 정말 어려웠다.

그래서 그냥 **Obsidian 저장소(GitHub)와 자동으로 동기화되는 메모 앱**을 직접 만들었다.
앱을 열고 쓰기만 하면 알아서 커밋되고, 충돌이 나면 두 버전을 비교해서 고를 수 있다.

처음에는 React Native로 만들었지만 에러가 너무 많아서, Flutter로 처음부터 다시 만들었다.

## 주요 기능 (MVP)

- GitHub Fine-grained Personal Access Token 등록 및 검증
- 저장소 / 브랜치 / Vault Root 폴더 선택
- 폴더 및 Markdown 파일 탐색 (`.obsidian` 및 숨김 파일 기본 숨김)
- 일반 텍스트 기반 Markdown 편집 + 미리보기
- 로컬 자동 저장 (600ms debounce) — 네트워크보다 로컬 저장이 항상 우선
- GitHub 자동 커밋 (입력 정지 후 기본 5초) 및 수동 동기화
- 새 메모 / 새 폴더 / 이름 변경 / 삭제 (Tombstone 후 서버 반영)
- 파일명 + 로컬 캐시 본문 검색
- SHA 기반 충돌 감지, 충돌 해결 화면 (서버 버전 / 내 버전 / 사본 보존 / 나중에)
- 오프라인 편집 및 연결 복구 시 자동 동기화 (지수 Backoff Retry)
- 다크 모드 (시스템/라이트/다크)

## 기술 스택

| 영역 | 패키지 |
|---|---|
| 상태 관리 | flutter_riverpod (Notifier / AsyncNotifier) |
| 라우팅 | go_router |
| 네트워크 | dio (GitHub REST API, 공통 Interceptor) |
| 인증정보 | flutter_secure_storage (Token은 여기에만 저장) |
| 로컬 DB | drift + sqlite3_flutter_libs |
| 파일 캐시 | path_provider + crypto (경로 해시) |
| 연결 상태 | connectivity_plus |
| 미리보기 | flutter_markdown_plus |

## 아키텍처

Feature-first + Repository Pattern.

```text
lib/
├── app/            # 앱, 라우터, 테마
├── core/
│   ├── errors/     # AppFailure (사용자 메시지 분리)
│   ├── network/    # GitHubApiClient, DTO
│   ├── storage/    # Drift DB, Secure Storage, 파일 캐시
│   └── utils/      # 파일명 검증, Base64 codec, Debouncer, 충돌 판단
└── features/
    ├── auth/                 # Token 등록/검증, 세션
    ├── repository_selection/ # 저장소·브랜치·Vault Root 선택
    ├── file_browser/         # 탐색 + NotesRepository
    ├── editor/               # 편집기, 자동 저장
    ├── sync/                 # SyncCoordinator (직렬 처리, Retry, 충돌 생성)
    ├── search/               # 로컬 검색
    ├── conflict/             # 충돌 해결
    └── settings/             # 설정
```

경계 규칙: UI는 Dio/Drift DAO를 직접 호출하지 않고, GitHub DTO를 화면에서 사용하지 않는다.

## 실행 방법

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs   # Drift 코드 생성
flutter run
```

## 테스트

```bash
flutter analyze
flutter test
```

단위 테스트: 파일명 검증, 경로 정규화, Base64 인코딩/디코딩, SHA 충돌 판단, Debounce.
위젯 테스트: Token 입력 화면.

## 빌드 & 기기 설치

```bash
flutter build apk --release
adb install -r build/app/outputs/flutter-apk/app-release.apk
```

## GitHub Token 준비

1. GitHub → Settings → Developer settings → **Fine-grained personal access tokens**
2. 메모 저장소만 접근하도록 Repository access 제한
3. 권한: **Contents: Read and write**, **Metadata: Read-only**

## 플랫폼별 설정 사항

### Android

- `android/app/src/main/AndroidManifest.xml`
  - `INTERNET`, `ACCESS_NETWORK_STATE` 권한 추가 (최소 권한)
  - 앱 이름 `RepoNote`
- `android/app/build.gradle.kts`
  - `applicationId = "com.backdev.reponote"` (배포 전 최종 확인 필요)
  - 릴리즈 빌드는 현재 debug signing 사용 → 스토어 배포 시 서명 키 필요

### iOS

- 추가 권한 없음 (HTTPS 통신만 사용)
- `flutter build ios` 는 Xcode 서명 설정 후 가능

## 보안

- Token은 `flutter_secure_storage`에만 저장 (SharedPreferences/DB/로그 금지)
- 모든 통신은 HTTPS, Token은 Authorization Header로만 전달
- Token·문서 본문은 로그에 출력하지 않음
- 로그아웃 시 Token과 모든 로컬 데이터 삭제
