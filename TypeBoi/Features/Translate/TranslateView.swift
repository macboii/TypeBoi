import SwiftUI
import Translation

struct TranslateView: View {
    @State private var viewModel = TranslateViewModel()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    languageSelector
                    inputSection
                    translateButton
                    if !viewModel.translatedText.isEmpty {
                        ResultCardView(
                            text: viewModel.translatedText,
                            onCopy: viewModel.copyResult
                        )
                    }
                    if let error = viewModel.errorMessage {
                        Text(error)
                            .foregroundStyle(.red)
                            .font(.caption)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .padding()
            }
            .navigationTitle("번역")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("지우기", action: viewModel.clear)
                        .disabled(viewModel.inputText.isEmpty && viewModel.translatedText.isEmpty)
                }
            }
        }
        .translationTask(viewModel.configuration) { session in
            await viewModel.handleSession(session)
        }
    }

    // MARK: - Subviews

    private var languageSelector: some View {
        HStack(spacing: 8) {
            languageMenu($viewModel.sourceLanguage)

            Button(action: viewModel.swapLanguages) {
                Image(systemName: "arrow.left.arrow.right")
                    .font(.callout)
                    .padding(8)
                    .background(.regularMaterial)
                    .clipShape(Circle())
            }

            languageMenu($viewModel.targetLanguage)
        }
    }

    private func languageMenu(_ binding: Binding<Language>) -> some View {
        Menu {
            ForEach(Language.all) { lang in
                Button(lang.name) { binding.wrappedValue = lang }
            }
        } label: {
            HStack(spacing: 4) {
                Text(binding.wrappedValue.name)
                    .font(.subheadline).fontWeight(.medium)
                Image(systemName: "chevron.down")
                    .font(.caption2)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .frame(maxWidth: .infinity)
            .background(.regularMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }

    private var inputSection: some View {
        TextEditor(text: $viewModel.inputText)
            .frame(minHeight: 130)
            .padding(10)
            .background(.regularMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.secondary.opacity(0.2))
            )
            .overlay(alignment: .topLeading) {
                if viewModel.inputText.isEmpty {
                    Text("번역할 텍스트를 입력하세요")
                        .foregroundStyle(.tertiary)
                        .padding(.top, 18)
                        .padding(.leading, 14)
                        .allowsHitTesting(false)
                }
            }
    }

    private var translateButton: some View {
        Button(action: viewModel.translate) {
            HStack(spacing: 8) {
                if viewModel.isLoading {
                    ProgressView().tint(.white)
                } else {
                    Image(systemName: "globe")
                }
                Text("번역하기")
                    .fontWeight(.semibold)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(canTranslate ? Color.accentColor : Color.secondary.opacity(0.3))
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .disabled(!canTranslate)
    }

    private var canTranslate: Bool {
        !viewModel.inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !viewModel.isLoading
    }
}

#Preview {
    TranslateView()
}
