import XCTest
@testable import SortingGame

final class GameEngineTests: XCTestCase {
    func testNewGameInitialization() {
        let engine = GameEngine(bottleCount: 4)
        XCTAssertEqual(engine.bottleCount, 4)
        XCTAssertEqual(engine.state, .preparing)
    }

    func testStartGame() {
        let engine = GameEngine(bottleCount: 4)
        engine.startNewGame()

        XCTAssertEqual(engine.state, .playing)
        XCTAssertNotNil(engine.targetArray)
        XCTAssertEqual(engine.currentArray?.count, 4)
        XCTAssertEqual(engine.scoreCalculator.attemptCount, 0)
    }

    func testSwapBottles() {
        let engine = GameEngine(bottleCount: 4)
        engine.startNewGame()

        let initialArray = engine.currentArray
        engine.swapBottles(from: 0, to: 2)

        XCTAssertNotEqual(engine.currentArray, initialArray)
    }

    func testSubmitCorrectAnswer() {
        let engine = GameEngine(bottleCount: 4)
        engine.startNewGame()

        engine.currentArray = engine.targetArray
        engine.submitGuess()

        if case .won(let attempts) = engine.state {
            XCTAssertEqual(attempts, 1)
        } else {
            XCTFail("Expected .won state")
        }
    }

    func testStartNewGameCurrentArrayIsNaturalOrder() {
        let engine = GameEngine(bottleCount: 4)
        engine.startNewGame()
        XCTAssertEqual(engine.currentArray?.bottles.map(\.id), [0, 1, 2, 3])
    }

    func testStartNewGameTargetDiffersFromCurrent() {
        let engine = GameEngine(bottleCount: 4)
        // 随机生成多次，目标必须始终 != 自然序
        for _ in 0..<50 {
            engine.startNewGame()
            XCTAssertNotEqual(engine.currentArray, engine.targetArray)
        }
    }

    func testSubmitIncorrectAnswer() {
        let engine = GameEngine(bottleCount: 4)
        engine.startNewGame()

        // 自然序必然 != 目标排列，直接提交必然错误
        engine.submitGuess()

        XCTAssertEqual(engine.state, .playing)
        XCTAssertEqual(engine.scoreCalculator.attemptCount, 1)
    }

    func testGiveUp() {
        let engine = GameEngine(bottleCount: 4)
        engine.startNewGame()

        engine.giveUp()

        if case .gaveUp(let answer) = engine.state {
            XCTAssertEqual(answer, engine.targetArray)
        } else {
            XCTFail("Expected .gaveUp state")
        }
    }

    func testCorrectPositionCount() {
        let engine = GameEngine(bottleCount: 4)
        engine.startNewGame()

        let correctCount = engine.correctPositionCount
        XCTAssertGreaterThanOrEqual(correctCount, 0)
        XCTAssertLessThanOrEqual(correctCount, 4)
    }

    func testTapSelectsThenSwaps() {
        let engine = GameEngine(bottleCount: 4)
        engine.startNewGame()

        engine.tap(position: 0)
        XCTAssertEqual(engine.selectedPosition, 0)

        engine.tap(position: 2)
        XCTAssertNil(engine.selectedPosition)
        XCTAssertEqual(engine.currentArray?.bottles[0].id, 2)
        XCTAssertEqual(engine.currentArray?.bottles[2].id, 0)
    }

    func testTapSamePositionDeselects() {
        let engine = GameEngine(bottleCount: 4)
        engine.startNewGame()

        engine.tap(position: 1)
        engine.tap(position: 1)
        XCTAssertNil(engine.selectedPosition)
        XCTAssertEqual(engine.currentArray?.bottles.map(\.id), [0, 1, 2, 3])
    }

    func testTapOutOfRangeIgnored() {
        let engine = GameEngine(bottleCount: 4)
        engine.startNewGame()

        engine.tap(position: -1)
        engine.tap(position: 4)
        XCTAssertNil(engine.selectedPosition)
    }

    func testTapIgnoredWhenNotPlaying() {
        let engine = GameEngine(bottleCount: 4)
        engine.tap(position: 0)
        XCTAssertNil(engine.selectedPosition)
    }

    func testMarkModeTogglesMarks() {
        let engine = GameEngine(bottleCount: 4)
        engine.startNewGame()
        engine.isMarkMode = true

        engine.tap(position: 1)
        XCTAssertEqual(engine.markedPositions, [1])
        XCTAssertNil(engine.selectedPosition)

        engine.tap(position: 1)
        XCTAssertEqual(engine.markedPositions, [])
    }

    func testStartNewGameResetsSelectionAndMarks() {
        let engine = GameEngine(bottleCount: 4)
        engine.startNewGame()
        engine.isMarkMode = true
        engine.tap(position: 0)
        engine.isMarkMode = false
        engine.tap(position: 1)

        engine.startNewGame()
        XCTAssertNil(engine.selectedPosition)
        XCTAssertEqual(engine.markedPositions, [])
        XCTAssertFalse(engine.isMarkMode)
    }

    func testGiveUpClearsSelection() {
        let engine = GameEngine(bottleCount: 4)
        engine.startNewGame()
        engine.tap(position: 0)
        engine.giveUp()
        XCTAssertNil(engine.selectedPosition)
    }
}
