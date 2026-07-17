# Changelog

All notable changes to RepoNote are documented in this file.

## 1.0.1 (2026-07-17)

### Added
- 설정에 앱 언어 변경 옵션 추가 (시스템/한국어/English). 기본은 시스템 언어를 따르며,
  선택한 언어는 저장되어 재시작 후에도 유지된다.
- Language selector in Settings (System / 한국어 / English). Defaults to the device
  language; the choice persists across restarts.

## 1.0.0 (2026-07-17)

첫 출시 / Initial release.

- GitHub Fine-grained Token 인증 및 저장소·브랜치·Vault Root 선택
- 접기/펼치기 트리 파일 탐색 (`.obsidian` 기본 숨김)
- 마크다운 편집 + 미리보기, 로컬 자동 저장(600ms debounce)
- 자동 커밋(입력 정지 5초 후) 및 수동 동기화
- SHA 기반 충돌 감지·해결 (서버 버전/내 버전/사본 보존)
- 오프라인 편집 및 재연결 시 자동 동기화 (지수 Backoff)
- 파일 생성·이름 변경·삭제·검색
- 다크 모드, 한국어/영어 지원 (시스템 언어 기본)
