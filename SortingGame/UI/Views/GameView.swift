import SwiftUI
import SpriteKit

struct GameView: View {
    @State private var viewModel: GameViewModel
    @State private var scene: GameScene
#if os(macOS)
    @FocusState private var gameFocused: Bool
#endif
    private let onExitToMenu: () -> Void

    init(bottleCount: Int, onExitToMenu: @escaping () -> Void = {}) {
        let vm = GameViewModel(bottleCount: bottleCount)
        _viewModel = State(initialValue: vm)

        let scene = GameScene(size: CGSize(width: 800, height: 600))
        scene.scaleMode = .aspectFit
        scene.configure(engine: vm.engine)
        _scene = State(initialValue: scene)

        self.onExitToMenu = onExitToMenu
    }

    var body: some View {
        VStack(spacing: 20) {
            SpriteView(scene: scene)
                .frame(maxWidth: .infinity, maxHeight: .infinity)

            Text(viewModel.feedbackText)
                .font(.title2)
                .fontWeight(.semibold)

            buttonBar
        }
        .padding()
#if os(macOS)
        .focused($gameFocused)
        .focusable()
        .focusEffectDisabled()
        .onKeyPress(phases: .down) { press in
            viewModel.handleKey(press.key) ? .handled : .ignored
        }
        .onAppear { gameFocused = true }
#endif
    }

    private var buttonBar: some View {
        HStack(spacing: 16) {
            Button("提交") {
                viewModel.submitGuess()
                restoreFocus()
            }
            .buttonStyle(.borderedProminent)
            .disabled(viewModel.engine.state != .playing)

            Button(viewModel.engine.isMarkMode ? "退出标记" : "标记模式") {
                viewModel.toggleMarkMode()
                restoreFocus()
            }
            .buttonStyle(.bordered)
            .tint(viewModel.engine.isMarkMode ? .green : .accentColor)

            Button("公布答案") {
                viewModel.giveUp()
                restoreFocus()
            }
            .buttonStyle(.bordered)
            .tint(.red)
            .disabled(viewModel.engine.state != .playing)

            Button("返回") {
                onExitToMenu()
            }
            .buttonStyle(.bordered)
        }
    }

#if os(macOS)
    /// 点击按钮后把焦点还给游戏容器，保证数字键/Enter 继续生效
    private func restoreFocus() {
        gameFocused = true
    }
#else
    private func restoreFocus() {}
#endif
}
