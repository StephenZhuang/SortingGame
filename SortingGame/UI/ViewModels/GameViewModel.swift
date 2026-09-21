import SwiftUI
import Observation

@MainActor
@Observable
class GameViewModel {
    let engine: GameEngine
    var feedbackText: String = ""

    init(bottleCount: Int) {
        self.engine = GameEngine(bottleCount: bottleCount)
        startNewGame()
    }

    func startNewGame() {
        engine.startNewGame()
        feedbackText = ""
    }

    func submitGuess() {
        engine.submitGuess()
        updateFeedback()
        if case .won = engine.state {
            SoundEffectPlayer.play(.win)
        } else {
            SoundEffectPlayer.play(.submit)
        }
    }

    func giveUp() {
        engine.giveUp()
    }

    func toggleMarkMode() {
        engine.isMarkMode.toggle()
        engine.clearSelection()
    }

#if os(macOS)
    /// macOS 键盘输入：数字键 1-7 选择/交换/放下，Enter 提交。返回是否消费了该按键。
    func handleKey(_ key: KeyEquivalent) -> Bool {
        guard engine.state == .playing else { return false }

        if key == .return {
            submitGuess()
            return true
        }
        guard let digit = key.character.wholeNumberValue,
              digit >= 1, digit <= engine.bottleCount else { return false }

        engine.tap(position: digit - 1)
        return true
    }
#endif

    private func updateFeedback() {
        // 全对时也先刷新反馈文案（配合动画提示提交结果），再进入结算
        switch engine.state {
        case .playing, .won:
            let attempts = engine.scoreCalculator.attemptCount
            let correctCount = engine.correctPositionCount
            feedbackText = "第 \(attempts) 次提交 · 对了 \(correctCount) 个"
        case .preparing, .gaveUp:
            break
        }
    }
}
