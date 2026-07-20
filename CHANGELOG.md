# Changelog

All notable changes to RepoNote are documented in this file.

## 1.0.3 (2026-07-20)

### Added
- 미리보기에서 `[[위키링크]]`를 탭 가능한 칩으로 표시하고, 탭하면 해당 노트로 이동한다
  (`[[대상|별칭]]` 문법 지원, 원문은 변경하지 않음).
- In preview, `[[wiki links]]` render as tappable chips that navigate to the linked note
  (supports `[[target|alias]]`; the source text is never modified).

### Changed
- 노트를 열면 보기(미리보기) 모드가 기본이 되었다. 빈 노트는 편집 모드로 열린다.
- Notes now open in preview mode by default; empty notes still open in edit mode.

## 1.0.2 (2026-07-18)

### Added
- 파일을 길게 눌러 드래그하면 다른 폴더로 옮길 수 있다. 트리 하단의 드롭 영역에 놓으면
  최상위 폴더로 이동한다.
- Drag a file (long-press) to move it into another folder. Drop it on the zone at the
  bottom of the tree to move it to the root folder.
- 폴더 길게 누르기 메뉴에 "폴더로 이동…" 추가. 대상 폴더를 골라 폴더 전체를 옮긴다.
- Added "Move to folder…" to the folder long-press menu to relocate an entire folder.

### Fixed
- 파일 길게 누르기가 메뉴 대신 드래그를 시작하도록 수정. 파일 메뉴는 우측 더보기(⋮) 버튼으로 이동.
- Long-pressing a file now starts a drag instead of opening the menu; the file menu moved
  to the trailing more (⋮) button.

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
