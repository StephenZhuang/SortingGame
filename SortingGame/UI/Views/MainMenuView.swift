import SwiftUI

struct MainMenuView: View {
    @State private var showingDifficultySelect = false
    @State private var showingLeaderboard = false
    @State private var showingSettings = false

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
            Text("设置（待实现）")
                .padding()
        }
    }
}

#Preview {
    MainMenuView()
}
