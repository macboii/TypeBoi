# TypeBoi — iOS App

## 제품 개요

**TypeBoi**는 iPhone용 텍스트 유틸리티 앱이다. 번역·교정을 핵심으로 하고, OCR(화면 캡처 번역)을 프리미엄 차별화 기능으로 단계적으로 추가한다.

### 경쟁 포지셔닝
- DeepL → 번역만 됨
- Grammarly → 교정만 됨
- TypeBoi → 번역 + 교정 + OCR 캡처 번역 = **화면 어디든 처리 가능**

---

## 기술 스택

| 영역 | 선택 | 이유 |
|------|------|------|
| 언어 | Swift 5.9+ | 필수 |
| UI | SwiftUI | 최신 iOS 타겟, 빠른 개발 |
| 아키텍처 | MVVM + Combine | 단순하고 SwiftUI 친화적 |
| 번역 | Apple Translation framework (iOS 18+) | 완전 네이티브, API 키 불필요 |
| 교정 | iOS Writing Tools (UITextView, iOS 18+) | 완전 네이티브, API 키 불필요 |
| OCR | Vision Framework (Apple 내장) | 추가 의존성 없음 |
| 음성 인식 | Speech framework (Apple 내장) | 추가 의존성 없음 |
| 음성 출력 | AVSpeechSynthesizer (Apple 내장) | 추가 의존성 없음 |
| 광고 | AdMob Rewarded Ads | 코인 지급 방식 |
| 백엔드 | Supabase | 기존 인프라 재사용 |
| 스토리지 | UserDefaults | 코인 등 로컬 상태 |

### 최소 iOS 버전
- **iOS 18.0+** (TranslationSession API 필요 — 실제 iOS 17에서는 다른 Translation API)

---

## 앱 확장 포인트

| 확장 | 용도 |
|------|------|
| Share Extension | 다른 앱에서 텍스트 선택 → TypeBoi로 번역/교정 |
| Action Extension | 텍스트 in-place 처리 |
| Keyboard Extension | (Phase 3) 키보드에서 바로 번역 |

---

## 개발 로드맵

### Phase 1 — MVP (완료)
- [x] 프로젝트 세팅 (SwiftUI, MVVM, XcodeGen)
- [x] 텍스트 입력 화면
- [x] 번역 기능 (Apple Translation API)
- [x] 교정 기능 (iOS Writing Tools)
- [x] Share Extension (다른 앱에서 텍스트 가져오기)
- [x] 결과 복사 / 공유
- [x] 기본 설정 (언어 선택)

### Phase 2 — 킬러 기능 + 수익화 (진행 중)

> 핵심 순서: **Keyboard → OCR → 코인/광고 → Voice**

- [ ] **Week 1**: Keyboard Extension (Fix / Translate)
- [ ] **Week 2**: OCR — 카메라/사진 → 텍스트 추출 → 번역
- [ ] **Week 3**: 코인 시스템 + AdMob Rewarded Ads
- [ ] **Week 4**: Voice (음성 입력 → 번역 → 음성 출력) + 출시

### Phase 3 — 확장
- [ ] 히스토리 / 즐겨찾기
- [ ] 위젯
- [ ] 언어 자동 감지
- [ ] 카메라 실시간 번역 (AR)

---

## 디렉토리 구조 (목표)

```
TypeBoi/
├── App/
│   ├── TypeBoiApp.swift
│   └── AppDelegate.swift
├── Features/
│   ├── Translate/
│   │   ├── TranslateView.swift
│   │   ├── TranslateViewModel.swift
│   │   └── TranslationService.swift
│   ├── Correct/
│   │   ├── CorrectView.swift
│   │   └── CorrectViewModel.swift
│   ├── OCR/              ← Week 2
│   │   ├── OCRView.swift
│   │   ├── OCRViewModel.swift
│   │   └── OCRService.swift
│   └── Voice/            ← Week 4
│       ├── VoiceView.swift
│       ├── VoiceViewModel.swift
│       └── VoiceService.swift
├── Shared/
│   ├── Models/
│   ├── Services/
│   │   ├── AIService.swift        ← 번역/교정 추상화 프로토콜
│   │   ├── CoinManager.swift      ← 구현 완료
│   │   └── AdManager.swift        ← Week 3에 추가 예정
│   ├── Components/
│   └── Extensions/
├── KeyboardExtension/    ← Week 1 (draft 완료)
│   ├── KeyboardViewController.swift
│   └── KeyboardAIHandler.swift
├── ShareExtension/
└── Resources/
    └── Localizable.strings
```

---

## 코딩 원칙

- `.claude/rules/swift.md` — 아키텍처, 비동기, AIService 패턴
- `.claude/rules/api.md` — 번역/교정/OCR/Voice/AdMob 연동
- `.claude/rules/extensions.md` — Keyboard Extension, Share Extension
- `.claude/rules/monetization.md` — 코인 시스템, AdMob
- `.claude/rules/product.md` — 기능 우선순위 원칙

---

## 환경 변수 / 시크릿

번역/교정/OCR/Voice 모두 Apple 네이티브 API — 외부 API 키 없음.
AdMob App ID는 `Config.xcconfig` → Info.plist 경유, 절대 코드에 하드코딩 금지.

## XcodeGen (project.yml) 주의사항

- App Groups entitlements는 **Week 1 Keyboard Extension** 구현 시 활성화 필요
- App Group ID: `group.com.typeboi.shared`
- Developer 계정에서 App Group 등록 후 `project.yml` entitlements 섹션 주석 해제
