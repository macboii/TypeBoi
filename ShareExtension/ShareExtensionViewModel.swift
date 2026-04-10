import Foundation
import UIKit
import Translation

@Observable
@MainActor
final class ShareExtensionViewModel {
    var inputText: String = ""
    var translatedText: String = ""
    var isLoading: Bool = false
    var errorMessage: String?
    var mode: Mode = .translate
    var targetLanguage: Language = .english
    var translationConfiguration: TranslationSession.Configuration?

    enum Mode: String, CaseIterable {
        case translate = "번역"
        case correct   = "교정"
    }

    func startTranslation() {
        guard !inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        isLoading = true
        errorMessage = nil
        translationConfiguration = TranslationSession.Configuration(
            source: nil,
            target: targetLanguage.locale
        )
    }

    func handleTranslationSession(_ session: TranslationSession) async {
        do {
            let response = try await session.translate(inputText)
            translatedText = response.targetText
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    func copyTranslation() {
        UIPasteboard.general.string = translatedText
    }
}
