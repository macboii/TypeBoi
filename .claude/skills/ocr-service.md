# Skill: OCR Service (Phase 3용 설계)

Vision Framework로 이미지에서 텍스트를 추출한다. Phase 3까지 구현 보류, 구조만 참고.

## 핵심 코드 패턴

```swift
import Vision
import UIKit

protocol OCRServiceProtocol {
    func extractText(from image: UIImage) async throws -> String
}

class OCRService: OCRServiceProtocol {
    func extractText(from image: UIImage) async throws -> String {
        guard let cgImage = image.cgImage else {
            throw OCRError.invalidImage
        }

        return try await withCheckedThrowingContinuation { continuation in
            let request = VNRecognizeTextRequest { request, error in
                if let error {
                    continuation.resume(throwing: error)
                    return
                }
                let text = request.results?
                    .compactMap { $0 as? VNRecognizedTextObservation }
                    .compactMap { $0.topCandidates(1).first?.string }
                    .joined(separator: "\n") ?? ""
                continuation.resume(returning: text)
            }
            request.recognitionLevel = .accurate
            request.usesLanguageCorrection = true

            let handler = VNImageRequestHandler(cgImage: cgImage)
            do {
                try handler.perform([request])
            } catch {
                continuation.resume(throwing: error)
            }
        }
    }
}

enum OCRError: LocalizedError {
    case invalidImage
    var errorDescription: String? {
        switch self {
        case .invalidImage: return "이미지를 처리할 수 없습니다."
        }
    }
}
```

## 진입점 (Phase 3)
- 사진 라이브러리 (`PHPickerViewController`)
- 카메라 (`AVFoundation`)
- 스크린샷 (Share Extension에서 이미지 수신)
