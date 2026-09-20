import Foundation
#if os(iOS)
import AudioToolbox
#else
import AppKit
#endif

enum SoundEffect: String {
    case swap
    case submit
    case win
}

/// 音效播放（系统音效，受设置的音效开关控制）
@MainActor
enum SoundEffectPlayer {
    #if os(iOS)
    /// 固定映射表，避免每次播放重建字典。
    /// 注：1104/1105 为键盘 Tock 系音效；1025 不属于经典系统音效 ID 区，
    /// 三者真机听感待 Task 13（iOS 接入）验证。
    private static let soundIDs: [SoundEffect: SystemSoundID] = [
        .swap: 1104,
        .submit: 1105,
        .win: 1025
    ]
    #endif

    static func play(_ effect: SoundEffect) {
        guard SettingsService.shared.soundEnabled else { return }

        #if os(iOS)
        AudioServicesPlaySystemSound(Self.soundIDs[effect] ?? 1104)
        #else
        switch effect {
        case .swap:
            NSSound.beep()
        case .submit:
            NSSound(named: "Funk")?.play()
        case .win:
            NSSound(named: "Glass")?.play()
        }
        #endif
    }
}
