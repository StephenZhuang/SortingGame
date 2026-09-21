import SwiftUI

/// sheet(item:) 的载体：呈现时把点击的瓶子数量直接传入，避免 isPresented+State 的时序竞争
private struct GameLaunch: Identifiable {
    let count: Int
    var id: Int { count }
}

struct DifficultySelectView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var launch: GameLaunch?

    var body: some View {
        VStack(spacing: 30) {
            Text("选择难度")
                .font(.title)
                .fontWeight(.bold)

            VStack(spacing: 15) {
                difficultyButton(count: 4, label: "简单 (4个瓶子)")
                difficultyButton(count: 5, label: "中等 (5个瓶子)")
                difficultyButton(count: 6, label: "困难 (6个瓶子)")
                difficultyButton(count: 7, label: "专家 (7个瓶子)")
            }

            Button("取消") {
                dismiss()
            }
            .buttonStyle(.bordered)
        }
        .padding()
        .sheet(item: $launch) { game in
            GameView(bottleCount: game.count, onExitToMenu: {
                launch = nil
                dismiss()
            })
        }
    }

    private func difficultyButton(count: Int, label: String) -> some View {
        Button(label) {
            launch = GameLaunch(count: count)
        }
        .buttonStyle(.borderedProminent)
        .frame(minWidth: 200)
    }
}

#Preview {
    DifficultySelectView()
}
