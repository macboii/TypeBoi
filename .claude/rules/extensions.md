# App Extension 규칙

## Keyboard Extension (Week 1)

### UI 프레임워크
- **UIKit 필수** — `UIInputViewController` 상속, SwiftUI 사용 불가
- 레이아웃은 `UIStackView` + `UIButton` 으로 구성
- SwiftUI View를 `UIHostingController`로 embed하는 방식은 메모리 이슈로 지양

### App Groups
- Bundle ID: `com.typeboi.app`
- App Group ID: `group.com.typeboi.shared`
- 메인 앱과 키보드 간 `UserDefaults(suiteName:)` 공유에 필요
- Xcode → Signing & Capabilities → App Groups에서 활성화

### 텍스트 접근 및 교체
- `textDocumentProxy.documentContextBeforeInput` 으로 커서 앞 텍스트 가져오기
- 결과 반영: `deleteBackward()` × (원본 글자 수) → `insertText(result)`
- 원본 텍스트 길이만큼 정확히 삭제 후 삽입 (부분 덮어쓰기 주의)

### Full Access
- Full Access 없이도 기본 동작은 가능하게 설계
- Full Access 요청 시 안내 문구: **"더 정확한 결과를 위해 전체 접근이 필요합니다"**
- 설정 진입 버튼 제공

### 성능 제한
- Keyboard Extension 메모리 한도: ~60MB — 무거운 모델 탑재 금지
- 응답 목표: **1~2초 이내**
- AI 처리는 `KeyboardAIHandler` 싱글턴으로 분리

### Info.plist 필수 권한
```xml
NSCameraUsageDescription        <!-- OCR, Week 2 -->
NSSpeechRecognitionUsageDescription  <!-- Voice, Week 4 -->
NSMicrophoneUsageDescription    <!-- Voice, Week 4 -->
```

### App Store 정책
- Keyboard Extension 데이터 수집 여부 반드시 명시
- Full Access 요구 시 개인정보 처리방침 링크 제공 필수

## Share Extension (완료)

- 다른 앱에서 텍스트 선택 → TypeBoi로 전달
- App Groups 활성화 후 메인 앱과 `UserDefaults(suiteName: "group.com.typeboi.shared")` 공유
- `ShareExtensionViewModel` → 메인 앱과 동일한 서비스 계층 재사용
