import SpriteKit

/// 瓶子节点（立体渲染）
class BottleNode: SKNode {
    let bottleId: Int
    let colorIndex: Int
    let shapeIndex: Int

    private let bottleBody: SKShapeNode
    private let highlightRing: SKShapeNode
    private let markLabel: SKLabelNode?

    private var isMarked = false
    private var isSelected = false

    init(bottle: Bottle, size: CGSize) {
        self.bottleId = bottle.id
        self.colorIndex = bottle.colorIndex
        self.shapeIndex = bottle.shapeIndex

        bottleBody = SKShapeNode(rectOf: CGSize(width: size.width * 0.8, height: size.height * 0.9))
        bottleBody.fillColor = Self.colorForIndex(bottle.colorIndex)
        bottleBody.strokeColor = .black
        bottleBody.lineWidth = 2
        bottleBody.position = .zero

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
        isSelected = selected
        highlightRing.alpha = selected ? 1 : 0
    }

    func toggleMark() {
        isMarked.toggle()
        markLabel?.alpha = isMarked ? 1 : 0
    }

    private static func colorForIndex(_ index: Int) -> SKColor {
        let colors: [SKColor] = [.red, .blue, .green, .orange, .purple, .cyan, .yellow]
        return colors[index % colors.count]
    }
}
