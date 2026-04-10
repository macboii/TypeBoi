import Foundation
import UIKit

@Observable
@MainActor
final class CorrectViewModel {
    var text: String = ""

    func copyText() {
        UIPasteboard.general.string = text
    }

    func clear() {
        text = ""
    }
}
