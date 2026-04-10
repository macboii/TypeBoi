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

## 금지 사항
- `print()` 대신 `Logger` (os.log) 사용
- 시크릿/API 키 하드코딩 절대 금지
- `force unwrap (!)` 지양, `guard let` / `if let` 사용
