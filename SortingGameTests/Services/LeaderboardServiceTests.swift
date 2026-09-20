import XCTest
@testable import SortingGame

@MainActor
final class LeaderboardServiceTests: XCTestCase {
    private func makeStorageURL() -> URL {
        FileManager.default.temporaryDirectory
            .appendingPathComponent("leaderboard-\(UUID().uuidString).json")
    }

    func testEmptyEntries() {
        let service = LeaderboardService(storageURL: makeStorageURL())
        XCTAssertEqual(service.topEntries(bottleCount: 4), [])
    }

    func testAddEntryReturnsRank() {
        let service = LeaderboardService(storageURL: makeStorageURL())
        XCTAssertEqual(service.addEntry(bottleCount: 4, attempts: 5, playerName: "A"), 1)
        XCTAssertEqual(service.addEntry(bottleCount: 4, attempts: 3, playerName: "B"), 1)
        // 排序后为 B(3)、C(4)、A(5)，C 排第 2
        XCTAssertEqual(service.addEntry(bottleCount: 4, attempts: 4, playerName: "C"), 2)
    }

    func testTopEntriesSortedByAttempts() {
        let service = LeaderboardService(storageURL: makeStorageURL())
        service.addEntry(bottleCount: 5, attempts: 9, playerName: "A")
        service.addEntry(bottleCount: 5, attempts: 2, playerName: "B")
        service.addEntry(bottleCount: 5, attempts: 5, playerName: "C")

        let top = service.topEntries(bottleCount: 5)
        XCTAssertEqual(top.map(\.attempts), [2, 5, 9])
        XCTAssertEqual(top.map(\.playerName), ["B", "C", "A"])
    }

    func testSeparateBoardsPerBottleCount() {
        let service = LeaderboardService(storageURL: makeStorageURL())
        service.addEntry(bottleCount: 4, attempts: 1, playerName: "A")
        service.addEntry(bottleCount: 7, attempts: 2, playerName: "B")

        XCTAssertEqual(service.topEntries(bottleCount: 4).map(\.playerName), ["A"])
        XCTAssertEqual(service.topEntries(bottleCount: 7).map(\.playerName), ["B"])
    }

    func testTopEntriesLimitedToTen() {
        let service = LeaderboardService(storageURL: makeStorageURL())
        for attempts in 1...15 {
            service.addEntry(bottleCount: 4, attempts: attempts, playerName: "P\(attempts)")
        }
        XCTAssertEqual(service.topEntries(bottleCount: 4).count, 10)
        XCTAssertEqual(service.topEntries(bottleCount: 4).map(\.attempts), Array(1...10))
    }

    func testRankNilWhenOutsideTopTen() {
        let service = LeaderboardService(storageURL: makeStorageURL())
        for attempts in 1...10 {
            service.addEntry(bottleCount: 4, attempts: attempts, playerName: "P\(attempts)")
        }
        let rank = service.addEntry(bottleCount: 4, attempts: 99, playerName: "Slow")
        XCTAssertNil(rank)
    }

    func testLoadIgnoresCorruptedData() throws {
        let url = makeStorageURL()
        defer { try? FileManager.default.removeItem(at: url) }
        try Data("not json".utf8).write(to: url)

        let service = LeaderboardService(storageURL: url)
        XCTAssertEqual(service.topEntries(bottleCount: 4), [])

        // 损坏数据不影响后续写入，且能正常持久化
        XCTAssertEqual(service.addEntry(bottleCount: 4, attempts: 3, playerName: "A"), 1)

        let reloaded = LeaderboardService(storageURL: url)
        XCTAssertEqual(reloaded.topEntries(bottleCount: 4).map(\.playerName), ["A"])
    }

    func testRankTieBreakByCompletedAt() {
        let service = LeaderboardService(storageURL: makeStorageURL())
        let earlier = Date(timeIntervalSince1970: 1_000)
        let later = earlier.addingTimeInterval(60)

        // 后添加但完成时间更早的记录应排在前面
        let lateRankWhenAdded = service.addEntry(
            bottleCount: 4, attempts: 5, playerName: "Late", completedAt: later)
        let earlyRankWhenAdded = service.addEntry(
            bottleCount: 4, attempts: 5, playerName: "Early", completedAt: earlier)

        XCTAssertEqual(lateRankWhenAdded, 1)   // 添加时榜内仅有自己
        XCTAssertEqual(earlyRankWhenAdded, 1)  // 完成更早，插入后即排第 1
        XCTAssertEqual(service.topEntries(bottleCount: 4).map(\.playerName), ["Early", "Late"])
    }

    func testPersistenceAcrossInstances() throws {
        let url = makeStorageURL()
        defer { try? FileManager.default.removeItem(at: url) }

        let service1 = LeaderboardService(storageURL: url)
        service1.addEntry(bottleCount: 6, attempts: 3, playerName: "A")

        let service2 = LeaderboardService(storageURL: url)
        XCTAssertEqual(service2.topEntries(bottleCount: 6).map(\.playerName), ["A"])
    }
}
