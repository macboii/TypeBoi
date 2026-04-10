import UIKit
import SwiftUI
import UniformTypeIdentifiers

@objc(ShareViewController)
class ShareViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        extractText { [weak self] text in
            DispatchQueue.main.async {
                self?.presentShareUI(with: text)
            }
        }
    }

    private func extractText(completion: @escaping (String) -> Void) {
        guard
            let item = extensionContext?.inputItems.first as? NSExtensionItem,
            let provider = item.attachments?.first(where: {
                $0.hasItemConformingToTypeIdentifier(UTType.plainText.identifier) ||
                $0.hasItemConformingToTypeIdentifier(UTType.text.identifier)
            })
        else {
            completion("")
            return
        }

        let typeID = provider.hasItemConformingToTypeIdentifier(UTType.plainText.identifier)
            ? UTType.plainText.identifier
            : UTType.text.identifier

        provider.loadItem(forTypeIdentifier: typeID, options: nil) { data, _ in
            let text = (data as? String) ?? ""
            completion(text)
        }
    }

    private func presentShareUI(with text: String) {
        let shareView = ShareExtensionView(inputText: text) { [weak self] in
            self?.extensionContext?.completeRequest(returningItems: nil)
        }

        let hostingController = UIHostingController(rootView: shareView)
        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        hostingController.didMove(toParent: self)
    }
}
