import Foundation

/// 瓶子排列数据结构
struct BottleArray: Equatable, Sendable {
    private(set) var bottles: [Bottle]

    var count: Int { bottles.count }

    init(bottles: [Bottle]) {
        self.bottles = bottles
    }

    /// 交换两个位置的瓶子
    mutating func swap(from: Int, to: Int) {
        guard from != to,
              from >= 0, from < bottles.count,
              to >= 0, to < bottles.count else { return }
        bottles.swapAt(from, to)
    }

    /// 计算与目标排列相比，位置正确的瓶子数量
    func countCorrectPositions(compareTo target: BottleArray) -> Int {
        guard bottles.count == target.bottles.count else { return 0 }

        var count = 0
        for (index, bottle) in bottles.enumerated() {
            if bottle.id == target.bottles[index].id {
                count += 1
            }
        }
        return count
    }

    /// 判断是否与目标排列完全一致
    func isFullyCorrect(compareTo target: BottleArray) -> Bool {
        return countCorrectPositions(compareTo: target) == bottles.count
    }
}
