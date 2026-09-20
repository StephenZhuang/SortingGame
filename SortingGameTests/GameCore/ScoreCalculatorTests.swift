import XCTest
@testable import SortingGame

final class ScoreCalculatorTests: XCTestCase {
    func testInitialAttemptCount() {
        let calculator = ScoreCalculator()
        XCTAssertEqual(calculator.attemptCount, 0)
    }

    func testIncrementAttempt() {
        var calculator = ScoreCalculator()
        calculator.incrementAttempt()
        XCTAssertEqual(calculator.attemptCount, 1)
        calculator.incrementAttempt()
        XCTAssertEqual(calculator.attemptCount, 2)
    }

    func testResetAttempts() {
        var calculator = ScoreCalculator()
        calculator.incrementAttempt()
        calculator.incrementAttempt()
        calculator.reset()
        XCTAssertEqual(calculator.attemptCount, 0)
    }
}
