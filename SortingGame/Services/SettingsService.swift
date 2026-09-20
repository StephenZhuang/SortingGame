import Foundation
import Observation

/// 用户设置持久化（UserDefaults）
@MainActor
@Observable
final class SettingsService {
    static let shared = SettingsService()

    var soundEnabled: Bool {
        didSet { defaults.set(soundEnabled, forKey: Keys.sound) }
    }
    var musicEnabled: Bool {
        didSet { defaults.set(musicEnabled, forKey: Keys.music) }
    }
    /// 色盲模式：强化瓶子形状差异（默认开启）
    var colorblindMode: Bool {
        didSet { defaults.set(colorblindMode, forKey: Keys.colorblind) }
    }
    /// 排行榜用昵称
    var playerName: String {
        didSet { defaults.set(playerName, forKey: Keys.name) }
    }

    private let defaults: UserDefaults

    private enum Keys {
        static let sound = "settings.soundEnabled"
        static let music = "settings.musicEnabled"
        static let colorblind = "settings.colorblindMode"
        static let name = "settings.playerName"
    }

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        self.soundEnabled = defaults.object(forKey: Keys.sound) as? Bool ?? true
        self.musicEnabled = defaults.object(forKey: Keys.music) as? Bool ?? true
        self.colorblindMode = defaults.object(forKey: Keys.colorblind) as? Bool ?? true
        self.playerName = defaults.string(forKey: Keys.name) ?? "玩家"
    }
}
