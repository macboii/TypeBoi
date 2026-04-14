# /update-docs

세션 종료 시 변경 내용을 분석하고 .claude 문서를 업데이트한다.

## 실행 절차

1. `git diff HEAD` 와 `git status` 로 이번 세션의 변경 파일 목록을 확인한다
2. 각 변경을 아래 분류 기준에 맞춰 판단한다
3. 업데이트가 필요한 파일만 수정한다 (변경 없으면 스킵)
4. 중복 내용은 추가하지 않는다 — 기존 내용과 합친다
5. 업데이트한 파일 목록과 변경 요약을 출력한다

## 분류 기준

| 변경 유형 | 업데이트 대상 |
|-----------|--------------|
| 새 Feature 추가 (View/ViewModel/Service) | `CLAUDE.md` 디렉토리 구조 + Phase 체크박스 |
| Swift 코딩 패턴 변경/추가 | `rules/swift.md` |
| API/서비스 연동 변경 | `rules/api.md` |
| 제품 결정 또는 기능 우선순위 변경 | `rules/product.md` |
| 새 Skill 패턴 발견 (번역/교정/OCR 등) | `.claude/skills/` 해당 파일 |
| 새 반복 작업 자동화 필요 | `.claude/commands/` 새 파일 |
| Phase 완료 또는 다음 Phase 시작 | `CLAUDE.md` 로드맵 체크박스 |
| 환경 변수 / API 키 관리 방식 변경 | `CLAUDE.md` 환경 변수 섹션 + `rules/api.md` |
| Supabase Edge Function 추가/변경 | `rules/api.md` |
| XcodeGen (project.yml) 구조 변경 | `CLAUDE.md` 기술 스택 섹션 |
| 재사용 가능한 SwiftUI 컴포넌트 추가 | `rules/swift.md` |

## 주의사항

- 전체 파일을 다시 쓰지 않는다. 변경된 부분만 정확히 수정한다
- 코드 패턴/파일 구조는 코드에서 읽을 수 있으므로 문서화하지 않는다
- 새 rules 파일은 5개 이상의 독립 규칙이 생길 때만 생성한다
- CLAUDE.md에 상세 규칙을 직접 쓰지 않는다 — rules 파일에 위임한다
- Phase 체크박스는 기능이 실제로 동작 확인된 경우에만 `[x]`로 변경한다

## 출력 형식

```
## 업데이트 완료

| 파일 | 변경 내용 |
|------|---------|
| CLAUDE.md | 로드맵 체크박스 X 항목 완료 표시 |
| rules/swift.md | async/await 패턴 예시 추가 |

변경 없음: rules/api.md, rules/product.md
```
