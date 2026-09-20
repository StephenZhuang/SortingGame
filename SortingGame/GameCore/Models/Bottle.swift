import Foundation

/// 瓶子模型
/// - Parameters:
///   - id: 唯一标识符（位置索引）
///   - colorIndex: 颜色索引（用于渲染）
///   - shapeIndex: 形状索引（用于色盲友好）
struct Bottle: Identifiable, Equatable, Hashable, Sendable {
    let id: Int
    let colorIndex: Int
    let shapeIndex: Int
}
