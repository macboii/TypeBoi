import Foundation

/// 번역/교정 기능의 추상화 프로토콜.
/// 메인 앱에서는 async/await, Keyboard Extension에서는 KeyboardAIHandler가 내부적으로 활용.
protocol AIServiceProtocol {
    func fix(text: String) async throws -> String
    func translate(text: String, to language: String) async throws -> String
}

enum AIServiceError: LocalizedError {
    case emptyInput
    case translationFailed(String)
    case correctionFailed(String)

    var errorDescription: String? {
        switch self {
        case .emptyInput:
            return "입력 텍스트가 없습니다."
        case .translationFailed(let reason):
            return "번역 실패: \(reason)"
        case .correctionFailed(let reason):
            return "교정 실패: \(reason)"
        }
    }
}
