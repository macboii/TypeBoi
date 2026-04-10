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
| 백엔드 | Supabase | 기존 인프라 재사용 |
| 인증 | Supabase Auth | |
| 스토리지 | UserDefaults + Supabase | |

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

### Phase 1 — MVP (핵심 가치 증명)
- [x] 프로젝트 세팅 (SwiftUI, MVVM, XcodeGen)
- [x] 텍스트 입력 화면
- [x] 번역 기능 (Apple Translation API)
- [x] 교정 기능 (OpenAI API via Supabase proxy)
- [x] Share Extension (다른 앱에서 텍스트 가져오기)
- [x] 결과 복사 / 공유
- [x] 기본 설정 (언어 선택)

### Phase 2 — 완성도
- [ ] 히스토리 (처리 내역)
- [ ] 즐겨찾기
- [ ] 언어 자동 감지
- [ ] 위젯
- [ ] 앱 디자인 polish

### Phase 3 — 킬러 차별화
- [ ] **OCR "Capture & Translate"** — Vision Framework로 이미지/화면 텍스트 추출 후 번역
- [ ] 사진 라이브러리에서 이미지 번역
- [ ] 카메라 실시간 번역 (AR Quick Look)
- [ ] Keyboard Extension

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
│   │   ├── CorrectViewModel.swift
│   │   └── CorrectionService.swift
│   └── Capture/          ← Phase 3
│       ├── CaptureView.swift
│       ├── CaptureViewModel.swift
│       └── OCRService.swift
├── Shared/
│   ├── Models/
│   ├── Services/
│   │   ├── OpenAIService.swift
│   │   └── SupabaseService.swift
│   ├── Components/        ← 재사용 UI
│   └── Extensions/
├── ShareExtension/
└── Resources/
    └── Localizable.strings
```

---

## 코딩 원칙

`.claude/rules/` 참고.

---

## 환경 변수 / 시크릿

현재 외부 API 없음 (번역/교정 모두 네이티브).
향후 Phase 3 등에서 외부 API 추가 시 `Config.xcconfig` 사용, 절대 코드에 하드코딩 금지.
