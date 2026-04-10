# /new-feature

새 기능 파일 구조를 생성한다.

## 사용법
```
/new-feature [FeatureName]
```

## 생성 파일
`Features/[FeatureName]/` 아래:
- `[FeatureName]View.swift` — SwiftUI View + Preview
- `[FeatureName]ViewModel.swift` — ObservableObject, @Published
- `[FeatureName]Service.swift` — Protocol + 구현체

## 템플릿

### View
```swift
import SwiftUI

struct [FeatureName]View: View {
    @StateObject private var viewModel = [FeatureName]ViewModel()

    var body: some View {
        // TODO
    }
}

#Preview {
    [FeatureName]View()
}
```

### ViewModel
```swift
import Foundation
import Combine

@MainActor
class [FeatureName]ViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let service: [FeatureName]ServiceProtocol

    init(service: [FeatureName]ServiceProtocol = [FeatureName]Service()) {
        self.service = service
    }
}
```

### Service
```swift
import Foundation

protocol [FeatureName]ServiceProtocol {
    // TODO
}

class [FeatureName]Service: [FeatureName]ServiceProtocol {
    // TODO
}
```
