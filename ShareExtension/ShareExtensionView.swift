import SwiftUI
import Translation

struct ShareExtensionView: View {
    let inputText: String
    let onDismiss: () -> Void

    @State private var viewModel = ShareExtensionViewModel()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    // 모드 선택
                    Picker("모드", selection: $viewModel.mode) {
                        ForEach(ShareExtensionViewModel.Mode.allCases, id: \.self) { mode in
                            Text(mode.rawValue).tag(mode)
                        }
                    }
                    .pickerStyle(.segmented)

                    if viewModel.mode == .translate {
                        translateSection
                    } else {
                        correctSection
                    }
                }
                .padding()
            }
            .navigationTitle("TypeBoi")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("완료", action: onDismiss)
                }
            }
        }
        .onAppear {
            viewModel.inputText = inputText
        }
        .translationTask(viewModel.translationConfiguration) { session in
            await viewModel.handleTranslationSession(session)
        }
    }

    // MARK: - 번역 섹션

    private var translateSection: some View {
        VStack(spacing: 12) {
            // 언어 선택
            HStack {
                Text("번역 언어")
                    .font(.subheadline).foregroundStyle(.secondary)
                Spacer()
                Menu {
                    ForEach(Language.all) { lang in
                        Button(lang.name) { viewModel.targetLanguage = lang }
                    }
                } label: {
                    HStack(spacing: 4) {
                        Text(viewModel.targetLanguage.name)
                        Image(systemName: "chevron.down").font(.caption2)
                    }
                    .padding(.horizontal, 10).padding(.vertical, 6)
                    .background(.regularMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                }
            }

            // 원문
            Text(inputText)
                .font(.body)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(12)
                .background(Color.secondary.opacity(0.08))
                .clipShape(RoundedRectangle(cornerRadius: 10))

            // 번역 버튼
            Button(action: viewModel.startTranslation) {
                HStack(spacing: 8) {
                    if viewModel.isLoading {
                        ProgressView().tint(.white)
                    } else {
                        Image(systemName: "globe")
                    }
                    Text("번역하기").fontWeight(.semibold)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(viewModel.isLoading ? Color.secondary.opacity(0.3) : Color.accentColor)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .disabled(viewModel.isLoading)

            // 결과
            if !viewModel.translatedText.isEmpty {
                ResultCardView(text: viewModel.translatedText, onCopy: viewModel.copyTranslation)
            }

            if let error = viewModel.errorMessage {
                Text(error).foregroundStyle(.red).font(.caption)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }

    // MARK: - 교정 섹션

    private var correctSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("텍스트를 길게 눌러 Writing Tools → Proofread를 선택하세요", systemImage: "pencil.and.sparkles")
                .font(.caption).foregroundStyle(.secondary)

            WritingToolsTextView(
                text: .constant(inputText),
                placeholder: "",
                minHeight: 200
            )
            .frame(minHeight: 200)
            .padding(10)
            .background(.regularMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.secondary.opacity(0.2)))
        }
    }
}
