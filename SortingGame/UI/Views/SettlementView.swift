import SwiftUI

/// 结算界面：胜利显示尝试次数，放弃显示答案对比
struct SettlementView: View {
    let state: GameState
    let bottleCount: Int
    let playerArray: BottleArray
    let onPlayAgain: () -> Void
    let onChangeDifficulty: () -> Void
    let onBackToMenu: () -> Void

#if os(iOS)
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
#endif
    @State private var savedRank: Int?
    @State private var scoreSaved = false

    /// iPhone 竖屏（compact）下不施加最小宽度，避免撑宽溢出；macOS 恒为 false
    private var isCompact: Bool {
#if os(iOS)
        horizontalSizeClass == .compact
#else
        false
#endif
    }

    var body: some View {
        VStack(spacing: 20) {
            switch state {
            case .won(let attempts):
                wonContent(attempts: attempts)
            case .gaveUp(let answer):
                gaveUpContent(answer: answer)
            case .preparing, .playing:
                EmptyView()
            }

            HStack(spacing: 16) {
                Button("再来一局", action: onPlayAgain)
                    .buttonStyle(.borderedProminent)
                Button("更换难度", action: onChangeDifficulty)
                    .buttonStyle(.bordered)
                Button("返回主菜单", action: onBackToMenu)
                    .buttonStyle(.bordered)
            }
        }
        .padding(24)
        .frame(minWidth: isCompact ? nil : 400)
    }

    private func wonContent(attempts: Int) -> some View {
        VStack(spacing: 8) {
            Text("恭喜通关！")
                .font(.largeTitle)
                .bold()
            Text("尝试次数：\(attempts)")
                .font(.title2)
            if let savedRank {
                Text("已记入 \(bottleCount) 瓶榜：第 \(savedRank) 名")
                    .foregroundStyle(.secondary)
            }
        }
        .onAppear {
            // 防止 sheet 重复触发 onAppear 造成重复写入
            guard !scoreSaved else { return }
            scoreSaved = true
            savedRank = LeaderboardService.shared.addEntry(
                bottleCount: bottleCount,
                attempts: attempts,
                playerName: SettingsService.shared.playerName
            )
        }
    }

    private func gaveUpContent(answer: BottleArray) -> some View {
        VStack(spacing: 12) {
            Text("正确答案")
                .font(.largeTitle)
                .bold()

            VStack(spacing: 8) {
                Text("正确排列")
                    .font(.headline)
                HStack(spacing: 8) {
                    ForEach(answer.bottles) { bottle in
                        BottleChip(bottle: bottle)
                    }
                }
            }

            VStack(spacing: 8) {
                Text("你的排列（绿=位置正确，红=位置错误）")
                    .font(.headline)
                HStack(spacing: 8) {
                    ForEach(Array(playerArray.bottles.enumerated()), id: \.element.id) { index, bottle in
                        BottleChip(
                            bottle: bottle,
                            isCorrect: index < answer.bottles.count
                                && answer.bottles[index].id == bottle.id
                        )
                    }
                }
            }
        }
    }
}
