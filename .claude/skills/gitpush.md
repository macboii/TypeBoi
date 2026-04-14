---
name: gitpush
description: Build check, commit, and push changes for the TypeBoi iOS project
---

Do NOT ask any questions or request confirmation at any step. Execute all steps automatically without pausing.

## 1. 변경 내용 확인

Run: git status
Run: git diff --stat

## 2. 빌드 검증

커밋 전 빌드가 통과하는지 확인한다:

```
xcodebuild build \
  -project TypeBoi.xcodeproj \
  -scheme TypeBoi \
  -destination 'generic/platform=iOS Simulator' \
  -configuration Debug \
  CODE_SIGNING_ALLOWED=NO \
  2>&1 | grep -E "(error:|BUILD)"
```

빌드 실패 시 에러를 먼저 수정하고 다시 진행한다.

## 3. 안전 검사 — 절대 커밋 금지

아래 파일이 staged에 포함되어 있으면 즉시 unstage하고 경고한다:

- `Config.xcconfig` — AdMob App ID, API 키 포함
- `*.env`, `*.env.local`
- `DerivedData/`, `build/`, `.build/`
- `*.ipa`, `*.dSYM`
- Swift 파일 내 하드코딩된 API 키 (`sk-`, `AIza` 등 패턴)

## 4. 커밋 메시지 생성

실제 변경 내용 기반으로 아래 타입을 사용한다:

| 타입 | 대상 |
|------|------|
| `feat:` | 새 기능 (View/ViewModel/Service 추가) |
| `fix:` | 버그 수정 |
| `ui:` | SwiftUI/UIKit 화면 변경만 |
| `ext:` | Extension 변경 (KeyboardExtension, ShareExtension) |
| `service:` | 서비스 레이어 변경 (AIService, CoinManager, AdManager 등) |
| `config:` | XcodeGen(project.yml), Info.plist, xcconfig 구성 변경 |
| `docs:` | CLAUDE.md, .claude rules/skills/commands 업데이트 |
| `chore:` | 의존성, 빌드 툴링, .gitignore 변경 |
| `refactor:` | 동작 변경 없는 코드 구조 개선 |

예시:
- `ext: add Keyboard Extension with Fix/Translate buttons`
- `feat: add OCR capture view using Vision framework`
- `service: implement CoinManager with UserDefaults`
- `config: add KeyboardExtension target to project.yml`
- `docs: update roadmap and add monetization rules`
- `fix: refund coin on AI processing failure`

## 5. 스테이징 및 커밋

```
git add <변경된 파일들>   # git add . 사용 가능 (안전 검사 통과 후)
git commit -m "<생성된 메시지>

Co-Authored-By: Claude Sonnet 4.6 <noreply@anthropic.com>"
```

## 6. 푸시

Run: git push
