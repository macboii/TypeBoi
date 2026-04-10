import Foundation

struct Language: Identifiable, Hashable {
    let id: String
    let name: String
    let locale: Locale.Language

    static let all: [Language] = [
        Language(id: "ko", name: "한국어",   locale: Locale.Language(identifier: "ko")),
        Language(id: "en", name: "English", locale: Locale.Language(identifier: "en")),
        Language(id: "ja", name: "日本語",   locale: Locale.Language(identifier: "ja")),
        Language(id: "zh", name: "中文",     locale: Locale.Language(identifier: "zh")),
        Language(id: "es", name: "Español", locale: Locale.Language(identifier: "es")),
        Language(id: "fr", name: "Français",locale: Locale.Language(identifier: "fr")),
        Language(id: "de", name: "Deutsch", locale: Locale.Language(identifier: "de")),
    ]

    static let korean  = all[0]
    static let english = all[1]
}
