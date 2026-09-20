import XCTest
import SwiftUI
@testable import SortingGame

@MainActor
final class GameViewModelTests: XCTestCase {
    func testDigitKeySelectsThenSwaps() {
        let vm = GameViewModel(bottleCount: 4)

        XCTAssertTrue(vm.handleKey(KeyEquivalent("1")))
        XCTAssertEqual(vm.engine.selectedPosition, 0)

        XCTAssertTrue(vm.handleKey(KeyEquivalent("3")))
        XCTAssertNil(vm.engine.selectedPosition)
        XCTAssertEqual(vm.engine.currentArray?.bottles[0].id, 2)
        XCTAssertEqual(vm.engine.currentArray?.bottles[2].id, 0)
    }

    func testSameDigitDeselects() {
        let vm = GameViewModel(bottleCount: 4)
        vm.handleKey(KeyEquivalent("2"))
        vm.handleKey(KeyEquivalent("2"))
        XCTAssertNil(vm.engine.selectedPosition)
    }

    func testEnterSubmits() {
        let vm = GameViewModel(bottleCount: 4)
        XCTAssertTrue(vm.handleKey(.return))
        XCTAssertEqual(vm.engine.scoreCalculator.attemptCount, 1)
        XCTAssertFalse(vm.feedbackText.isEmpty)
    }

    func testDigitBeyondBottleCountIgnored() {
        let vm = GameViewModel(bottleCount: 4)
        XCTAssertFalse(vm.handleKey(KeyEquivalent("5")))
        XCTAssertNil(vm.engine.selectedPosition)
    }

    func testNonDigitKeyIgnored() {
        let vm = GameViewModel(bottleCount: 4)
        XCTAssertFalse(vm.handleKey(KeyEquivalent("a")))
    }
}
