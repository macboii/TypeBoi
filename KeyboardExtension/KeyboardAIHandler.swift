import Foundation

/// Keyboard Extension 전용 AI 처리기.
/// Extension 환경 제약으로 async/await 대신 completion handler 사용.
///
/// 번역: Translation framework는 translationTask(SwiftUI) 또는 UIView.translationTask(UIKit)
/// 컨텍스트에서만 세션을 받을 수 있으므로, Extension에서는 별도 세션 관리 필요.
/// Draft v1: mock 응답으로 UI/흐름 검증 → Week 2에서 실제 API 연결.
final class KeyboardAIHandler {

    static let shared = KeyboardAIHandler()
    private init() {}

    // MARK: - Fix (교정)

    /// 텍스트 교정.
    /// TODO: Apple Intelligence Writing Tools API 연동 (iOS 18.1+ on-device LLM)
    func fix(text: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            completion(.failure(KeyboardAIError.emptyInput))
            return
        }
        // Draft: 문장 앞뒤 공백 정리 + 마침표 자동 추가 (실제 교정은 추후 연동)
        DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 0.5) {
            let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
            let fixed = trimmed.hasSuffix(".") || trimmed.hasSuffix("!") || trimmed.hasSuffix("?")
                ? trimmed
                : trimmed + "."
            completion(.success(fixed))
        }
    }

    // MARK: - Translate (번역)

    /// 텍스트 번역.
    /// Translation.framework는 세션 컨텍스트가 필요해 Extension에서 직접 사용 불가.
    /// TODO: Supabase proxy 또는 앱 내 IPC(App Groups)로 번역 결과 전달 방식으로 교체.
    func translate(
        text: String,
        targetLanguageCode: String = "en",
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        guard !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            completion(.failure(KeyboardAIError.emptyInput))
            return
        }
        // Draft: 언어 코드 prefix 붙여서 흐름 검증
        DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 0.5) {
            completion(.success("[\(targetLanguageCode)] \(text)"))
        }
    }
}

enum KeyboardAIError: LocalizedError {
    case emptyInput

    var errorDescription: String? {
        switch self {
        case .emptyInput: return "텍스트를 입력해주세요."
        }
    }
}
