import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var settings = SettingsService.shared

    var body: some View {
        @Bindable var settings = settings

        VStack(alignment: .leading, spacing: 16) {
            Text("设置")
                .font(.title)
                .bold()

            Toggle("音效", isOn: $settings.soundEnabled)
            Toggle("音乐", isOn: $settings.musicEnabled)
            Toggle("色盲模式（强化形状差异）", isOn: $settings.colorblindMode)
            TextField("昵称", text: $settings.playerName)
                .textFieldStyle(.roundedBorder)

            #if os(macOS)
            VStack(alignment: .leading, spacing: 4) {
                Text("键盘快捷键")
                    .font(.headline)
                Text("数字键 1-7：选中瓶子 / 交换 / 放下")
                Text("Enter：提交当前排列")
            }
            .font(.callout)
            .foregroundStyle(.secondary)
            #endif

            Button("完成") { dismiss() }
                .buttonStyle(.borderedProminent)
                .frame(maxWidth: .infinity, alignment: .center)
        }
        .padding(24)
        .frame(minWidth: 340)
    }
}

#Preview {
    SettingsView()
}
