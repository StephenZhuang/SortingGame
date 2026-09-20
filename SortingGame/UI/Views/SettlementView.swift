import SwiftUI

/// 结算界面：胜利显示尝试次数，放弃显示答案对比
struct SettlementView: View {
    let state: GameState
    let playerArray: BottleArray
    let onPlayAgain: () -> Void
    let onChangeDifficulty: () -> Void
    let onBackToMenu: () -> Void

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
        .frame(minWidth: 400)
    }

    private func wonContent(attempts: Int) -> some View {
        VStack(spacing: 8) {
            Text("恭喜通关！")
                .font(.largeTitle)
                .bold()
            Text("尝试次数：\(attempts)")
                .font(.title2)
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
