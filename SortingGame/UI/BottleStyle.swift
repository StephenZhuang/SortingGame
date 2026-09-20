import SwiftUI

/// 瓶子的 SwiftUI 视觉样式（与 SpriteKit 的 BottleNode 保持一致）
enum BottleStyle {
    static let shapeSymbols = ["●", "■", "▲", "◆", "★", "⬟", "✚"]

    static func shapeSymbol(forIndex index: Int) -> String {
        shapeSymbols[index % shapeSymbols.count]
    }

    static func color(forIndex index: Int) -> Color {
        let colors: [Color] = [.red, .blue, .green, .orange, .purple, .cyan, .yellow]
        return colors[index % colors.count]
    }
}

/// 结算界面用的瓶子圆形徽章
struct BottleChip: View {
    let bottle: Bottle
    /// nil = 不显示对错圈；true = 绿圈；false = 红圈
    var isCorrect: Bool? = nil

    var body: some View {
        ZStack {
            Circle()
                .fill(BottleStyle.color(forIndex: bottle.colorIndex))
                .frame(width: 36, height: 36)
            Text(BottleStyle.shapeSymbol(forIndex: bottle.shapeIndex))
                .font(.system(size: 16))
                .foregroundStyle(.white)
        }
        .overlay {
            if let isCorrect {
                Circle()
                    .stroke(isCorrect ? Color.green : Color.red, lineWidth: 3)
            }
        }
    }
}
