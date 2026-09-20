import Foundation

/// 计分器（尝试次数统计）
struct ScoreCalculator: Sendable {
    private(set) var attemptCount: Int = 0

    mutating func incrementAttempt() {
        attemptCount += 1
    }

    mutating func reset() {
        attemptCount = 0
    }
}
