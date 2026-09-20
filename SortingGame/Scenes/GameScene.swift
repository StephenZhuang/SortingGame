import SpriteKit
#if canImport(UIKit)
import UIKit
#endif

/// 游戏主场景：纯渲染 GameCore 状态，输入翻译为语义事件回传引擎
final class GameScene: SKScene {
    private var engine: GameEngine!
    private var boxNode: BoxNode!
    private var bottleNodes: [BottleNode] = []
    /// 上一帧已渲染的瓶子顺序（bottleId 列表），用于 diff 触发移动动画
    private var renderedOrder: [Int] = []

    func configure(engine: GameEngine) {
        self.engine = engine
    }

    override func didMove(to view: SKView) {
        backgroundColor = .black
        setupGame()
    }

    private func setupGame() {
        removeAllChildren()
        bottleNodes = []
        renderedOrder = []
        guard let engine, let currentArray = engine.currentArray else { return }

        let slotSize = CGSize(width: 80, height: 120)
        boxNode = BoxNode(slotCount: currentArray.count, slotSize: slotSize)
        boxNode.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(boxNode)

        for (index, bottle) in currentArray.bottles.enumerated() {
            let node = BottleNode(bottle: bottle, size: slotSize)
            node.position = boxNode.getSlotPosition(at: index)
            boxNode.addChild(node)
            bottleNodes.append(node)
        }
        renderedOrder = currentArray.bottles.map(\.id)
    }

    override func update(_ currentTime: TimeInterval) {
        syncWithEngine()
    }

    /// 每帧 diff 引擎状态：位置变化播放移动动画，选中/标记直接同步
    private func syncWithEngine() {
        guard let engine, let current = engine.currentArray else { return }

        let order = current.bottles.map(\.id)
        if order != renderedOrder {
            for (index, bottle) in current.bottles.enumerated() {
                if let node = bottleNodes.first(where: { $0.bottleId == bottle.id }) {
                    let move = SKAction.move(to: boxNode.getSlotPosition(at: index), duration: 0.2)
                    move.timingMode = .easeInEaseOut
                    node.run(move, withKey: "moveToSlot")
                }
            }
            renderedOrder = order
        }

        for node in bottleNodes {
            let position = current.bottles.firstIndex(where: { $0.id == node.bottleId }) ?? -1
            node.setSelected(engine.selectedPosition == position)
            node.setMarked(engine.markedPositions.contains(position))
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
        guard let engine, engine.state == .playing else { return }
        let tappedNode = atPoint(location)

        for node in bottleNodes {
            // 命中瓶体/高光/选中环/标记等任意子节点都算点中该瓶子
            if tappedNode == node || tappedNode.parent == node || tappedNode.parent?.parent == node {
                if let position = engine.currentArray?.bottles.firstIndex(where: { $0.id == node.bottleId }) {
                    engine.tap(position: position)
                }
                return
            }
        }
    }

    /// 胜利庆祝动画（Task 12 接入调用）
    func runCelebration() {
        for node in bottleNodes {
            let pulse = SKAction.sequence([
                .scale(to: 1.2, duration: 0.15),
                .scale(to: 1.0, duration: 0.15)
            ])
            node.run(.repeat(pulse, count: 3))
        }
    }
}
