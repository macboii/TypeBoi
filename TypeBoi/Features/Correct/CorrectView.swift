import SwiftUI

struct CorrectView: View {
    @State private var viewModel = CorrectViewModel()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    howToCard
                    textEditorSection
                    if !viewModel.text.isEmpty {
                        actionRow
                    }
                }
                .padding()
            }
            .navigationTitle("교정")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("지우기", action: viewModel.clear)
                        .disabled(viewModel.text.isEmpty)
                }
            }
        }
    }

    // MARK: - Subviews

    private var howToCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Label("Writing Tools 사용법", systemImage: "pencil.and.sparkles")
                .font(.subheadline).fontWeight(.semibold)

            VStack(alignment: .leading, spacing: 6) {
                tipRow(icon: "1.circle.fill", text: "아래에 교정할 텍스트를 입력하세요")
                tipRow(icon: "2.circle.fill", text: "텍스트를 길게 누르거나 전체 선택하세요")
                tipRow(icon: "3.circle.fill", text: "팝업 메뉴에서 \"Writing Tools\" → \"Proofread\" 선택")
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.accentColor.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private func tipRow(icon: String, text: String) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: icon)
                .foregroundStyle(Color.accentColor)
                .font(.caption)
                .padding(.top, 2)
            Text(text)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }

    private var textEditorSection: some View {
        WritingToolsTextView(
            text: $viewModel.text,
            placeholder: "교정할 텍스트를 입력하세요",
            minHeight: 200
        )
        .frame(minHeight: 200)
        .padding(10)
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.secondary.opacity(0.2))
        )
    }

    private var actionRow: some View {
        Button(action: viewModel.copyText) {
            Label("복사", systemImage: "doc.on.doc")
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(Color.green)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}

#Preview {
    CorrectView()
}
