import SwiftUI

struct ResultCardView: View {
    let text: String
    let onCopy: () -> Void

    @State private var copied = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(text)
                .font(.body)
                .frame(maxWidth: .infinity, alignment: .leading)
                .textSelection(.enabled)

            Divider()

            HStack {
                Spacer()
                Button(action: handleCopy) {
                    Label(copied ? "복사됨" : "복사", systemImage: copied ? "checkmark" : "doc.on.doc")
                        .font(.subheadline)
                        .foregroundStyle(copied ? .green : .accentColor)
                }
                .animation(.easeInOut(duration: 0.2), value: copied)
            }
        }
        .padding()
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.secondary.opacity(0.2))
        )
    }

    private func handleCopy() {
        onCopy()
        copied = true
        Task {
            try? await Task.sleep(for: .seconds(2))
            copied = false
        }
    }
}

#Preview {
    ResultCardView(text: "Hello, this is a sample result.", onCopy: {})
        .padding()
}
