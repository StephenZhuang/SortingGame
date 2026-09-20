import SpriteKit
import Foundation

/// 游戏主场景
class GameScene: SKScene {
    private var engine: GameEngine!
    private var boxNode: BoxNode!
    private var bottleNodes: [BottleNode] = []
    private var selectedBottleIndex: Int?

    var onStateChanged: ((GameState) -> Void)?

    override func didMove(to view: SKView) {
        backgroundColor = .black
        setupGame()
    }

    func configure(engine: GameEngine) {
        self.engine = engine
    }

    private func setupGame() {
        guard let engine = engine,
              let currentArray = engine.currentArray else { return }

        // 创建盒子
        let slotSize = CGSize(width: 80, height: 120)
        boxNode = BoxNode(slotCount: currentArray.count, slotSize: slotSize)
        boxNode.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(boxNode)

        // 创建瓶子节点
        for (index, bottle) in currentArray.bottles.enumerated() {
            let bottleNode = BottleNode(bottle: bottle, size: slotSize)
            bottleNode.position = boxNode.getSlotPosition(at: index)
            bottleNode.name = "bottle_\(index)"
            addChild(bottleNode)
            bottleNodes.append(bottleNode)
        }
    }

    #if os(macOS)
    override func mouseDown(with event: NSEvent) {
        handleTap(at: event.location(in: self))
    }
    #else
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        handleTap(at: touch.location(in: self))
    }
    #endif

    private func handleTap(at location: CGPoint) {
        let tappedNode = atPoint(location)

        // 查找点击的瓶子
        for (index, bottleNode) in bottleNodes.enumerated() {
            if tappedNode == bottleNode || tappedNode.parent == bottleNode {
                handleBottleTap(at: index)
                return
            }
        }
    }

    private func handleBottleTap(at index: Int) {
        if let selectedIndex = selectedBottleIndex {
            if selectedIndex == index {
                // 点击同一个瓶子，取消选中
                bottleNodes[selectedIndex].setSelected(false)
                selectedBottleIndex = nil
            } else {
                // 交换瓶子
                engine.swapBottles(from: selectedIndex, to: index)
                updateBottlePositions()
                bottleNodes[selectedIndex].setSelected(false)
                selectedBottleIndex = nil
            }
        } else {
            // 选中瓶子
            bottleNodes[index].setSelected(true)
            selectedBottleIndex = index
        }
    }

    private func updateBottlePositions() {
        guard let currentArray = engine.currentArray else { return }

        for (index, bottle) in currentArray.bottles.enumerated() {
            if let bottleNode = bottleNodes.first(where: { $0.bottleId == bottle.id }) {
                bottleNode.run(.move(to: boxNode.getSlotPosition(at: index), duration: 0.2))
            }
        }
    }

    func updateScene() {
        guard let engine = engine else { return }
        onStateChanged?(engine.state)
    }
}
