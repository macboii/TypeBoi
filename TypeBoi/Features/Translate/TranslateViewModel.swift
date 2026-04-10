import Foundation
import UIKit
import Translation

@Observable
@MainActor
final class TranslateViewModel {
    var inputText: String = ""
    var translatedText: String = ""
    var isLoading: Bool = false
    var errorMessage: String?
    var sourceLanguage: Language = .korean
    var targetLanguage: Language = .english
    var configuration: TranslationSession.Configuration?

    func translate() {
        let trimmed = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        isLoading = true
        errorMessage = nil
        // configuration 변경이 .translationTask modifier를 트리거함
        configuration = TranslationSession.Configuration(
            source: sourceLanguage.locale,
            target: targetLanguage.locale
        )
    }

    func handleSession(_ session: TranslationSession) async {
        do {
            let response = try await session.translate(inputText)
            translatedText = response.targetText
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    func swapLanguages() {
        let temp = sourceLanguage
        sourceLanguage = targetLanguage
        targetLanguage = temp
        if !translatedText.isEmpty {
            inputText = translatedText
            translatedText = ""
            configuration = nil
        }
    }

    func copyResult() {
        UIPasteboard.general.string = translatedText
    }

    func clear() {
        inputText = ""
        translatedText = ""
        errorMessage = nil
        configuration = nil
    }
}
