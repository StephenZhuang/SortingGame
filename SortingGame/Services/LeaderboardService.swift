import Foundation
import Observation

/// 排行榜单条记录（仅成功通关计入）
struct LeaderboardEntry: Codable, Equatable, Identifiable, Sendable {
    let id: UUID
    let bottleCount: Int
    let attempts: Int
    let completedAt: Date
    let playerName: String
}

/// 本地排行榜：按瓶子数量分榜，尝试次数少者靠前，JSON 文件持久化
@MainActor
@Observable
final class LeaderboardService {
    static let shared = LeaderboardService()

    private(set) var entries: [LeaderboardEntry] = []
    private let storageURL: URL

    init(storageURL: URL? = nil) {
        if let storageURL {
            self.storageURL = storageURL
        } else {
            let directory = FileManager.default
                .urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
                .appendingPathComponent("SortingGame", isDirectory: true)
            self.storageURL = directory.appendingPathComponent("leaderboard.json")
        }
        load()
    }

    /// 添加成绩，返回该难度榜内排名（1 起；未进 Top 10 返回 nil）
    @discardableResult
    func addEntry(bottleCount: Int, attempts: Int, playerName: String, completedAt: Date = Date()) -> Int? {
        let entry = LeaderboardEntry(
            id: UUID(),
            bottleCount: bottleCount,
            attempts: attempts,
            completedAt: completedAt,
            playerName: playerName
        )
        entries.append(entry)
        save()
        return rank(of: entry)
    }

    func rank(of entry: LeaderboardEntry) -> Int? {
        topEntries(bottleCount: entry.bottleCount)
            .firstIndex(where: { $0.id == entry.id })
            .map { $0 + 1 }
    }

    /// 指定难度的 Top N（默认 10），尝试次数少者靠前，同次数按完成时间早者靠前
    func topEntries(bottleCount: Int, limit: Int = 10) -> [LeaderboardEntry] {
        Array(
            entries
                .filter { $0.bottleCount == bottleCount }
                .sorted { lhs, rhs in
                    if lhs.attempts != rhs.attempts {
                        return lhs.attempts < rhs.attempts
                    }
                    return lhs.completedAt < rhs.completedAt
                }
                .prefix(limit)
        )
    }

    private func load() {
        guard let data = try? Data(contentsOf: storageURL),
              let decoded = try? JSONDecoder().decode([LeaderboardEntry].self, from: data) else { return }
        entries = decoded
    }

    private func save() {
        let directory = storageURL.deletingLastPathComponent()
        try? FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        guard let data = try? JSONEncoder().encode(entries) else { return }
        try? data.write(to: storageURL, options: .atomic)
    }
}
