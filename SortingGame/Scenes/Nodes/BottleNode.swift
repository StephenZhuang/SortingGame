import SpriteKit

/// 瓶子节点（立体渲染）
class BottleNode: SKNode {
    let bottleId: Int
    let colorIndex: Int
    let shapeIndex: Int

    private let bottleBody: SKShapeNode
    private let highlightRing: SKShapeNode
    private let markLabel: SKLabelNode?

    init(bottle: Bottle, size: CGSize, colorblindMode: Bool) {
        self.bottleId = bottle.id
        self.colorIndex = bottle.colorIndex
        self.shapeIndex = bottle.shapeIndex

        bottleBody = SKShapeNode(rectOf: CGSize(width: size.width * 0.8, height: size.height * 0.9))
        bottleBody.fillColor = Self.colorForIndex(bottle.colorIndex)
        bottleBody.strokeColor = .black
        bottleBody.lineWidth = 2
        bottleBody.position = .zero

        // 形状符号（颜色+形状双重区分，色盲友好）
        let symbol = SKLabelNode(text: Self.shapeSymbols[bottle.shapeIndex % Self.shapeSymbols.count])
        symbol.fontSize = size.width * (colorblindMode ? 0.55 : 0.4)
        symbol.fontColor = Self.symbolColor(forBodyColor: Self.colorForIndex(bottle.colorIndex))
        symbol.horizontalAlignmentMode = .center
        symbol.verticalAlignmentMode = .center
        symbol.position = .zero
        bottleBody.addChild(symbol)

        let highlight = SKShapeNode(rectOf: CGSize(width: size.width * 0.2, height: size.height * 0.7))
        highlight.fillColor = .white.withAlphaComponent(0.3)
        highlight.strokeColor = .clear
        highlight.position = CGPoint(x: -size.width * 0.2, y: 0)
        bottleBody.addChild(highlight)

        highlightRing = SKShapeNode(rectOf: CGSize(width: size.width, height: size.height))
        highlightRing.strokeColor = .yellow
        highlightRing.lineWidth = 4
        highlightRing.fillColor = .clear
        highlightRing.alpha = 0
        highlightRing.position = .zero

        markLabel = SKLabelNode(text: "✓")
        markLabel?.fontSize = 24
        markLabel?.fontColor = .white
        markLabel?.horizontalAlignmentMode = .center
        markLabel?.verticalAlignmentMode = .center
        markLabel?.position = CGPoint(x: 0, y: size.height * 0.3)
        markLabel?.alpha = 0

        super.init()

        addChild(bottleBody)
        addChild(highlightRing)
        if let markLabel = markLabel {
            addChild(markLabel)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setSelected(_ selected: Bool) {
        highlightRing.alpha = selected ? 1 : 0
    }

    func setMarked(_ marked: Bool) {
        markLabel?.alpha = marked ? 1 : 0
    }

    /// 与 UI/BottleStyle 保持一致
    private static let shapeSymbols = ["●", "■", "▲", "◆", "★", "⬟", "✚"]

    /// 与 UI/BottleStyle 保持一致
    private static func colorForIndex(_ index: Int) -> SKColor {
        let colors: [SKColor] = [.red, .blue, .green, .orange, .purple, .cyan, .yellow]
        return colors[index % colors.count]
    }

    /// 深色瓶体用白符号，浅色瓶体（黄/青/橙/绿）用黑符号，保证对比度
    private static func symbolColor(forBodyColor color: SKColor) -> SKColor {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        let luminance = 0.299 * red + 0.587 * green + 0.114 * blue
        return luminance > 0.55 ? .black : .white
    }
}
