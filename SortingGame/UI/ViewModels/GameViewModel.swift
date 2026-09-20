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
    }

    func giveUp() {
        engine.giveUp()
    }

    func toggleMarkMode() {
        engine.isMarkMode.toggle()
        engine.clearSelection()
    }

    private func updateFeedback() {
        if case .playing = engine.state {
            let correctCount = engine.correctPositionCount
            feedbackText = "对了 \(correctCount) 个"
        }
    }
}
