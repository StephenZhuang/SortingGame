import SpriteKit

/// 带分隔的盒子容器
class BoxNode: SKNode {
    private let slotCount: Int
    private let slotSize: CGSize
    private var slots: [SKShapeNode] = []

    init(slotCount: Int, slotSize: CGSize) {
        self.slotCount = slotCount
        self.slotSize = slotSize
        super.init()

        setupBox()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupBox() {
        let totalWidth = slotSize.width * CGFloat(slotCount)
        let startX = -totalWidth / 2 + slotSize.width / 2

        for i in 0..<slotCount {
            let slot = SKShapeNode(rectOf: slotSize)
            slot.fillColor = .darkGray
            slot.strokeColor = .lightGray
            slot.lineWidth = 2
            slot.position = CGPoint(x: startX + CGFloat(i) * slotSize.width, y: 0)
            slot.name = "slot_\(i)"
            addChild(slot)
            slots.append(slot)
        }
    }

    func getSlotPosition(at index: Int) -> CGPoint {
        guard index >= 0, index < slots.count else { return .zero }
        return slots[index].position
    }

    func highlightSlot(at index: Int, color: SKColor = .yellow) {
        guard index >= 0, index < slots.count else { return }
        slots[index].strokeColor = color
        slots[index].lineWidth = 4
    }

    func resetSlotHighlight(at index: Int) {
        guard index >= 0, index < slots.count else { return }
        slots[index].strokeColor = .lightGray
        slots[index].lineWidth = 2
    }
}
