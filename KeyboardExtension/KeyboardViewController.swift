import UIKit

final class KeyboardViewController: UIInputViewController {

    // MARK: - UI

    private let containerView = UIView()
    private let fixButton = UIButton(type: .system)
    private let translateButton = UIButton(type: .system)
    private let coinLabel = UILabel()
    private let statusLabel = UILabel()
    private let activityIndicator = UIActivityIndicatorView(style: .medium)

    private var isProcessing = false {
        didSet { updateButtonState() }
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateCoinLabel()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateCoinLabel()
        statusLabel.text = ""
    }

    // MARK: - Setup

    private func setupUI() {
        view.backgroundColor = UIColor(white: 0.15, alpha: 1)

        setupContainerView()
        setupButtons()
        setupCoinLabel()
        setupStatusLabel()
        setupActivityIndicator()
        setupConstraints()
    }

    private func setupContainerView() {
        containerView.backgroundColor = .clear
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
    }

    private func setupButtons() {
        configureButton(fixButton, title: "✏️ Fix", action: #selector(handleFix))
        configureButton(translateButton, title: "🌍 Translate", action: #selector(handleTranslate))
    }

    private func configureButton(_ button: UIButton, title: String, action: Selector) {
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.gray, for: .disabled)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        button.backgroundColor = UIColor(white: 0.28, alpha: 1)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: action, for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(button)
    }

    private func setupCoinLabel() {
        coinLabel.textColor = UIColor(white: 0.7, alpha: 1)
        coinLabel.font = .systemFont(ofSize: 12)
        coinLabel.textAlignment = .right
        coinLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(coinLabel)
    }

    private func setupStatusLabel() {
        statusLabel.textColor = UIColor(white: 0.6, alpha: 1)
        statusLabel.font = .systemFont(ofSize: 13)
        statusLabel.textAlignment = .center
        statusLabel.numberOfLines = 2
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(statusLabel)
    }

    private func setupActivityIndicator() {
        activityIndicator.color = .white
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(activityIndicator)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.topAnchor.constraint(equalTo: view.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            coinLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            coinLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),

            fixButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            fixButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            fixButton.heightAnchor.constraint(equalToConstant: 44),

            translateButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            translateButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            translateButton.heightAnchor.constraint(equalToConstant: 44),
            translateButton.widthAnchor.constraint(equalTo: fixButton.widthAnchor),
            translateButton.leadingAnchor.constraint(equalTo: fixButton.trailingAnchor, constant: 8),

            activityIndicator.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),

            statusLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            statusLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            statusLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -6),
        ])
    }

    // MARK: - Actions

    @objc private func handleFix() {
        guard let text = textDocumentProxy.documentContextBeforeInput,
              !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            showStatus("교정할 텍스트가 없습니다.")
            return
        }

        guard CoinManager.shared.spend() else {
            showNoCoinAlert()
            return
        }

        startProcessing()

        KeyboardAIHandler.shared.fix(text: text) { [weak self] result in
            DispatchQueue.main.async {
                self?.stopProcessing()
                switch result {
                case .success(let fixed):
                    self?.replaceText(original: text, with: fixed)
                case .failure(let error):
                    CoinManager.shared.add(1) // 실패 시 코인 환불
                    self?.showStatus("교정 실패: \(error.localizedDescription)")
                }
            }
        }
    }

    @objc private func handleTranslate() {
        guard let text = textDocumentProxy.documentContextBeforeInput,
              !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            showStatus("번역할 텍스트가 없습니다.")
            return
        }

        guard CoinManager.shared.spend() else {
            showNoCoinAlert()
            return
        }

        startProcessing()

        KeyboardAIHandler.shared.translate(text: text) { [weak self] result in
            DispatchQueue.main.async {
                self?.stopProcessing()
                switch result {
                case .success(let translated):
                    self?.replaceText(original: text, with: translated)
                case .failure(let error):
                    CoinManager.shared.add(1) // 실패 시 코인 환불
                    self?.showStatus("번역 실패: \(error.localizedDescription)")
                }
            }
        }
    }

    // MARK: - Helpers

    private func replaceText(original: String, with newText: String) {
        for _ in original {
            textDocumentProxy.deleteBackward()
        }
        textDocumentProxy.insertText(newText)
        updateCoinLabel()
    }

    private func startProcessing() {
        isProcessing = true
        activityIndicator.startAnimating()
        statusLabel.text = "처리 중..."
    }

    private func stopProcessing() {
        isProcessing = false
        activityIndicator.stopAnimating()
        statusLabel.text = ""
        updateCoinLabel()
    }

    private func updateButtonState() {
        fixButton.isEnabled = !isProcessing
        translateButton.isEnabled = !isProcessing
        fixButton.alpha = isProcessing ? 0.4 : 1.0
        translateButton.alpha = isProcessing ? 0.4 : 1.0
    }

    private func updateCoinLabel() {
        coinLabel.text = "💰 \(CoinManager.shared.coins)"
    }

    private func showStatus(_ message: String) {
        statusLabel.text = message
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            self?.statusLabel.text = ""
        }
    }

    private func showNoCoinAlert() {
        showStatus("코인이 부족합니다. 앱에서 광고를 시청해 충전하세요.")
    }
}
