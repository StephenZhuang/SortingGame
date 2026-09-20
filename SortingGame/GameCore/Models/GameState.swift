import Foundation

/// 游戏状态
enum GameState: Equatable, Sendable {
    case preparing
    case playing
    case won(attempts: Int)
    case gaveUp(answer: BottleArray)
}
