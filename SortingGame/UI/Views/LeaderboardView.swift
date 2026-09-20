import SwiftUI

/// 排行榜：按瓶子数量分榜，显示 Top 10
struct LeaderboardView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedCount = 4
    private var service = LeaderboardService.shared

    var body: some View {
        VStack(spacing: 16) {
            Text("排行榜")
                .font(.title)
                .bold()

            Picker("难度", selection: $selectedCount) {
                Text("简单(4)").tag(4)
                Text("中等(5)").tag(5)
                Text("困难(6)").tag(6)
                Text("专家(7)").tag(7)
            }
            .pickerStyle(.segmented)
            .labelsHidden()

            entryList

            Button("关闭") { dismiss() }
                .buttonStyle(.bordered)
        }
        .padding(24)
        .frame(minWidth: 440, minHeight: 420)
    }

    @ViewBuilder
    private var entryList: some View {
        let entries = service.topEntries(bottleCount: selectedCount)
        if entries.isEmpty {
            ContentUnavailableView("暂无记录", systemImage: "trophy", description: Text("通关后成绩会自动记录在这里"))
        } else {
            List {
                ForEach(Array(entries.enumerated()), id: \.element.id) { index, entry in
                    HStack {
                        Text("\(index + 1)")
                            .font(.headline)
                            .frame(width: 28, alignment: .leading)
                        Text(entry.playerName)
                        Spacer()
                        Text("\(entry.attempts) 次")
                            .monospacedDigit()
                        Text(entry.completedAt, format: .dateTime.month().day())
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .listStyle(.inset)
        }
    }
}

#Preview {
    LeaderboardView()
}
