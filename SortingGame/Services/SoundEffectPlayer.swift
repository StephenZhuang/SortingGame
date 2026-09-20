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
    static func play(_ effect: SoundEffect) {
        guard SettingsService.shared.soundEnabled else { return }

        #if os(iOS)
        let soundIDs: [SoundEffect: SystemSoundID] = [
            .swap: 1104,     // Tock
            .submit: 1105,   // Tink
            .win: 1025       // fanfare-ish
        ]
        AudioServicesPlaySystemSound(soundIDs[effect] ?? 1104)
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
