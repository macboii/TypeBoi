# API / 서비스 연동 규칙

## Apple Translation API (번역)
- iOS 18+ 필수 (`TranslationSession`)
- `Translation` framework import
- 오프라인 지원 (언어팩 다운로드 후)
- **Extension 제약**: `TranslationSession`은 `translationTask` 컨텍스트(SwiftUI) 또는 `UIView.translationTask`(UIKit) 에서만 세션 획득 가능. Keyboard Extension 내부에서 직접 호출 불가 → App Groups IPC 방식으로 메인 앱에 번역 위임 (Week 2에서 구현)

## iOS Writing Tools (교정)
- iOS 18+ 내장 기능 — 외부 API 없음
- `UITextView` 기반 (`WritingToolsTextView` 래퍼 사용)
- OpenAI / Supabase 프록시 불필요

## Vision Framework (OCR, Week 2)
- `VNRecognizeTextRequest` 사용
- 언어 힌트 제공으로 정확도 향상
- 처리는 반드시 백그라운드 스레드 (`DispatchQueue.global()`)

## Speech / AVSpeechSynthesizer (Voice, Week 4)
- 음성 인식: `SFSpeechRecognizer` + `AVAudioEngine`
- 음성 출력: `AVSpeechSynthesizer`
- 마이크 권한: `NSMicrophoneUsageDescription` 필수
- 음성 인식 권한: `NSSpeechRecognitionUsageDescription` 필수

## AdMob (광고, Week 3)
- Rewarded Ads만 사용 (코인 지급 목적)
- SPM: `https://github.com/googleads/swift-package-manager-google-mobile-ads`
- AdMob App ID: `Config.xcconfig` → Info.plist 경유
- `AdManager` 싱글턴으로 분리 — 나중에 교체 가능한 구조 유지
- 광고 로드 실패 시 코인 차감 없이 무시 (강제 광고 금지)
- 앱 시작 시 미리 prefetch (`loadAd()` 호출)

## AI 추상화 (AIService)
- 번역/교정 구현체를 직접 호출하지 않는다
- `AIService` 프로토콜 경유 → 향후 외부 LLM 교체 용이
- `rules/swift.md` 패턴 참고

## API 키 관리
- `Config.xcconfig` → Info.plist 경유
- `.gitignore`에 Config.xcconfig 추가 필수
