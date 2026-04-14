import Foundation

final class CoinManager {

    static let shared = CoinManager()
    private init() {}

    private let key = "typeboi_coins"
    private let initialCoins = 10

    var coins: Int {
        get {
            let stored = UserDefaults.standard.integer(forKey: key)
            // 최초 실행 시 초기 코인 지급
            if stored == 0 && !UserDefaults.standard.bool(forKey: key + "_initialized") {
                UserDefaults.standard.set(true, forKey: key + "_initialized")
                UserDefaults.standard.set(initialCoins, forKey: key)
                return initialCoins
            }
            return stored
        }
        set {
            UserDefaults.standard.set(max(0, newValue), forKey: key)
        }
    }

    /// 코인 1개 차감. 성공 시 true, 잔액 부족 시 false 반환
    @discardableResult
    func spend(_ amount: Int = 1) -> Bool {
        guard coins >= amount else { return false }
        coins -= amount
        return true
    }

    func add(_ amount: Int) {
        coins += amount
    }
}
