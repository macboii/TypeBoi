import SwiftUI
import UIKit

/// UITextView를 SwiftUI로 래핑. iOS 18 Writing Tools (교정/재작성 등) 완전 지원.
struct WritingToolsTextView: UIViewRepresentable {
    @Binding var text: String
    var placeholder: String = "텍스트를 입력하세요"
    var minHeight: CGFloat = 160

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.writingToolsBehavior = .complete
        textView.delegate = context.coordinator
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.backgroundColor = .clear
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 6, bottom: 10, right: 6)
        textView.isScrollEnabled = false
        textView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return textView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        if uiView.text != text {
            uiView.text = text
        }
        // 플레이스홀더 색상
        uiView.textColor = text.isEmpty ? .placeholderText : .label
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(text: $text, placeholder: placeholder)
    }

    // MARK: - Coordinator
    class Coordinator: NSObject, UITextViewDelegate {
        @Binding var text: String
        let placeholder: String

        init(text: Binding<String>, placeholder: String) {
            _text = text
            self.placeholder = placeholder
        }

        func textViewDidBeginEditing(_ textView: UITextView) {
            if textView.textColor == .placeholderText {
                textView.text = ""
                textView.textColor = .label
            }
        }

        func textViewDidEndEditing(_ textView: UITextView) {
            if textView.text.isEmpty {
                textView.text = placeholder
                textView.textColor = .placeholderText
            }
        }

        func textViewDidChange(_ textView: UITextView) {
            // Writing Tools가 텍스트를 수정할 때도 여기서 캐치됨
            if textView.textColor != .placeholderText {
                text = textView.text
            }
        }
    }
}
