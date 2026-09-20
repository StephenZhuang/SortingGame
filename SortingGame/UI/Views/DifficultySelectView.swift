import SwiftUI

struct DifficultySelectView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var showingGame = false
    @State private var selectedBottleCount = 4

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
        .sheet(isPresented: $showingGame) {
            GameView(bottleCount: selectedBottleCount, onExitToMenu: {
                showingGame = false
                dismiss()
            })
        }
    }

    private func difficultyButton(count: Int, label: String) -> some View {
        Button(label) {
            selectedBottleCount = count
            showingGame = true
        }
        .buttonStyle(.borderedProminent)
        .frame(minWidth: 200)
    }
}

#Preview {
    DifficultySelectView()
}
