import XCTest
@testable import SortingGame

@MainActor
final class SettingsServiceTests: XCTestCase {
    private func makeDefaults() -> UserDefaults {
        UserDefaults(suiteName: "SettingsServiceTests.\(UUID().uuidString)")!
    }

    func testDefaultValues() {
        let service = SettingsService(defaults: makeDefaults())
        XCTAssertTrue(service.soundEnabled)
        XCTAssertTrue(service.musicEnabled)
        XCTAssertTrue(service.colorblindMode)
        XCTAssertEqual(service.playerName, "玩家")
    }

    func testValuesPersistToDefaults() {
        let defaults = makeDefaults()
        let service = SettingsService(defaults: defaults)
        service.soundEnabled = false
        service.playerName = "小明"

        let reloaded = SettingsService(defaults: defaults)
        XCTAssertFalse(reloaded.soundEnabled)
        XCTAssertEqual(reloaded.playerName, "小明")
    }
}
