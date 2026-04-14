# Swift 코딩 규칙

## 아키텍처
- **MVVM + Combine** 패턴 엄수
- View는 UI만, 로직은 ViewModel에
- Service 계층은 프로토콜로 추상화 (테스트 용이성)

```swift
// ✅ 올바른 구조
protocol TranslationServiceProtocol {
    func translate(_ text: String, to language: String) async throws -> String
}

class TranslateViewModel: ObservableObject {
    @Published var result: String = ""
    private let service: TranslationServiceProtocol

    init(service: TranslationServiceProtocol = TranslationService()) {
        self.service = service
    }
}
```

## 비동기 처리
- `async/await` 우선, Combine은 UI 바인딩 용도로만
- Task 취소 처리 필수
- **Keyboard Extension 예외**: Extension 내부에서는 `async/await` 대신 completion handler 사용
  - Extension 런루프가 짧아 Task가 중간에 끊길 수 있음
  - `KeyboardAIHandler` 메서드는 `completion: @escaping (String) -> Void` 시그니처 유지

```swift
// ✅
func translate() {
    Task {
        do {
            result = try await service.translate(inputText, to: targetLanguage)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
```

## 에러 처리
- 커스텀 `Error` enum 정의
- 사용자에게 보여줄 메시지는 `localizedDescription` 활용

## SwiftUI
- Preview 항상 작성
- `@StateObject` vs `@ObservedObject` 구분 엄수 (소유권 기준)
- 큰 View는 subview로 분리 (body 50줄 초과 시)

## 네이밍
- 파일명 = 타입명 (1파일 1타입 원칙)
- ViewModel 접미사: `TranslateViewModel`
- Service 접미사: `TranslationService`
- View 접미사: `TranslateView`

## AI 추상화 패턴
번역/교정 구현체를 직접 참조하지 않는다. `AIService` 프로토콜로 추상화해 향후 외부 LLM 교체에 대비한다.

```swift
protocol AIService {
    func fix(text: String) async throws -> String
    func translate(text: String, to language: String) async throws -> String
}

// Keyboard Extension, Voice 등 모든 진입점에서 이 프로토콜만 사용
class KeyboardViewModel: ObservableObject {
    private let ai: AIService
    init(ai: AIService = NativeAIService()) { self.ai = ai }
}
```

## 싱글턴 패턴 (전역 상태 관리)
앱 전체에서 공유하는 상태(코인, 광고)는 싱글턴으로 관리한다.

```swift
// ✅ 허용 — CoinManager, AdManager처럼 진짜 전역 상태만
final class CoinManager {
    static let shared = CoinManager()
    private init() {}
}
```

👉 ViewModel은 싱글턴으로 만들지 않는다.

## 금지 사항
- `print()` 대신 `Logger` (os.log) 사용
- 시크릿/API 키 하드코딩 절대 금지
- `force unwrap (!)` 지양, `guard let` / `if let` 사용
