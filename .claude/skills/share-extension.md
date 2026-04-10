# Skill: Share Extension 구현

다른 앱에서 텍스트를 선택해 TypeBoi로 보내는 Share Extension.

## Xcode 설정
1. File → New → Target → Share Extension
2. Target 이름: `TypeBoiShareExtension`
3. App Groups 설정 (앱 ↔ 익스텐션 데이터 공유)
   - `group.com.yourcompany.typeboi`

## 핵심 구조

```swift
// ShareViewController.swift
import UIKit
import SwiftUI
import UniformTypeIdentifiers

class ShareViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        extractText { [weak self] text in
            DispatchQueue.main.async {
                self?.showProcessingUI(for: text)
            }
        }
    }

    private func extractText(completion: @escaping (String) -> Void) {
        guard let item = extensionContext?.inputItems.first as? NSExtensionItem,
              let provider = item.attachments?.first(where: { $0.hasItemConformingToTypeIdentifier(UTType.plainText.identifier) })
        else { return }

        provider.loadItem(forTypeIdentifier: UTType.plainText.identifier) { data, _ in
            let text = data as? String ?? ""
            completion(text)
        }
    }

    private func showProcessingUI(for text: String) {
        // SwiftUI View embed
        let hostingController = UIHostingController(
            rootView: ShareExtensionView(inputText: text) {
                self.extensionContext?.completeRequest(returningItems: nil)
            }
        )
        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.view.frame = view.bounds
        hostingController.didMove(toParent: self)
    }
}
```

## App Groups로 데이터 전달
```swift
let sharedDefaults = UserDefaults(suiteName: "group.com.yourcompany.typeboi")
sharedDefaults?.set(text, forKey: "pendingText")
```
