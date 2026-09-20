import SwiftUI

struct MainMenuView: View {
    @State private var showingDifficultySelect = false
    @State private var showingLeaderboard = false
    @State private var showingSettings = false
    @State private var showingAbout = false

    var body: some View {
        VStack(spacing: 30) {
            Text("SortingGame")
                .font(.largeTitle)
                .fontWeight(.bold)

            VStack(spacing: 15) {
                Button("开始游戏") {
                    showingDifficultySelect = true
                }
                .buttonStyle(.borderedProminent)

                Button("排行榜") {
                    showingLeaderboard = true
                }
                .buttonStyle(.bordered)

                Button("设置") {
                    showingSettings = true
                }
                .buttonStyle(.bordered)

                Button("关于") {
                    showingAbout = true
                }
                .buttonStyle(.bordered)
            }
        }
        .padding()
        .sheet(isPresented: $showingDifficultySelect) {
            DifficultySelectView()
        }
        .sheet(isPresented: $showingLeaderboard) {
            Text("排行榜（待实现）")
                .padding()
        }
        .sheet(isPresented: $showingSettings) {
            SettingsView()
        }
        .sheet(isPresented: $showingAbout) {
            AboutView()
        }
    }
}

struct AboutView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("关于 SortingGame")
                .font(.title)
                .bold()
            Text("系统随机生成一组瓶子的隐藏排列，你通过交换瓶子来推理还原正确顺序。")
            Text("每次提交后系统只告诉你「对了 x 个」——位置正确的瓶子数量，不告诉你具体哪些位置正确。")
            Text("尝试次数越少越厉害，通关成绩会记入本地排行榜（公布答案的成绩不计入）。")
            Text("标记模式（✓）可以帮你记住已推理确定的位置，仅作视觉辅助。")
            Button("关闭") { dismiss() }
                .buttonStyle(.borderedProminent)
        }
        .padding(24)
        .frame(maxWidth: 420)
    }
}

#Preview {
    MainMenuView()
}
