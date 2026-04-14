# 수익화 규칙 (코인 + 광고)

## 코인 시스템

- `CoinManager.shared` 싱글턴으로 전역 관리
- 저장소: `UserDefaults` (v1 — 서버 동기화는 Phase 3 이후 검토)
- 기능 사용 시 코인 1개 차감, 광고 시청 완료 시 30개 지급
- 코인이 0이 되면 즉시 광고 유도 — 강제 차단은 하지 않는다 (첫 번은 안내만)

```swift
// ✅ 코인 차감 흐름
func useFeature() async {
    guard CoinManager.shared.spend(1) else {
        showAdPrompt()
        return
    }
    // 실제 처리
}
```

## AdMob Rewarded Ads

- Rewarded Ads만 사용 — 배너/전면 광고 금지 (UX 훼손)
- 광고 로드는 앱 시작 시 미리 prefetch
- 광고 로드 실패 → 조용히 실패, 코인 차감 없이 재시도 유도
- `AdManager`를 별도 클래스로 분리 — 추후 다른 광고 SDK로 교체 가능한 구조

```swift
protocol AdManagerProtocol {
    func loadRewardedAd() async
    func showRewardedAd(from vc: UIViewController) async throws -> Int // 지급 코인 수
}
```

## UX 원칙

- 코인 부족 시 메시지: **"무료로 계속 사용하기"** (광고 시청 유도)
- Full Access / 권한 요청 전 항상 가치 설명 먼저
- 광고 시청 중 로딩 인디케이터 표시 — 빈 화면 금지

## App Store 정책

- 광고 개인화 여부 ATT(App Tracking Transparency) 팝업 필수
- 데이터 수집 내용 Privacy Policy에 명시
- 코인 시스템은 결제 없음 → In-App Purchase 아님 (심사 이슈 없음)
