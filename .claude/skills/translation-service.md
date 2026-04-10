# Skill: TranslationService 구현

Apple Translation API + DeepL fallback 패턴으로 번역 서비스를 구현한다.

## 전략
1. iOS 17+: `Translation` framework 우선
2. fallback: DeepL API (Supabase Edge Function 경유)

## 핵심 코드 패턴

```swift
import Translation

class TranslationService: TranslationServiceProtocol {
    func translate(_ text: String, from source: Locale.Language?, to target: Locale.Language) async throws -> String {
        if #available(iOS 17.0, *) {
            return try await translateWithApple(text, from: source, to: target)
        } else {
            return try await translateWithDeepL(text, to: target.languageCode?.identifier ?? "en")
        }
    }

    @available(iOS 17.0, *)
    private func translateWithApple(_ text: String, from source: Locale.Language?, to target: Locale.Language) async throws -> String {
        let session = TranslationSession.Configuration(source: source, target: target)
        // TranslationSession은 View에서 .translationTask modifier로 제공받아야 함
        // ViewModel에서는 continuation 패턴 사용
        fatalError("View에서 translationTask modifier 통해 session 주입 필요")
    }
}
```

## 주의사항
Apple Translation API는 `TranslationSession`을 View의 `.translationTask` modifier에서 받아야 한다.
ViewModel에 session을 주입하는 패턴으로 설계할 것.
