import Foundation
import Observation

/// 游戏引擎（状态机）
@Observable
final class GameEngine {
    let bottleCount: Int
    private(set) var state: GameState = .preparing
    private(set) var targetArray: BottleArray?
    var currentArray: BottleArray?
    private(set) var scoreCalculator = ScoreCalculator()

    var correctPositionCount: Int {
        guard let target = targetArray, let current = currentArray else { return 0 }
        return target.countCorrectPositions(compareTo: current)
    }

    init(bottleCount: Int) {
        precondition(bottleCount >= 4 && bottleCount <= 7, "瓶子数量必须在 4-7 之间")
        self.bottleCount = bottleCount
    }

    func startNewGame() {
        let bottles = (0..<bottleCount).map { index in
            Bottle(id: index, colorIndex: index, shapeIndex: index)
        }
        var target = bottles.shuffled()
        // 保证目标排列 != 自然序，否则开局即通关
        if target.map(\.id) == bottles.map(\.id) {
            target.swapAt(0, 1)
        }
        targetArray = BottleArray(bottles: target)
        currentArray = BottleArray(bottles: bottles)
        scoreCalculator.reset()
        state = .playing
    }

    func swapBottles(from: Int, to: Int) {
        guard state == .playing else { return }
        currentArray?.swap(from: from, to: to)
    }

    func submitGuess() {
        guard state == .playing,
              let target = targetArray,
              let current = currentArray else { return }

        scoreCalculator.incrementAttempt()

        if current.isFullyCorrect(compareTo: target) {
            state = .won(attempts: scoreCalculator.attemptCount)
        }
    }

    func giveUp() {
        guard state == .playing, let target = targetArray else { return }
        state = .gaveUp(answer: target)
    }
}
