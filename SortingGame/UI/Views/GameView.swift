import SwiftUI
import SpriteKit

struct GameView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel: GameViewModel
    @State private var scene: GameScene
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
    }

    private var buttonBar: some View {
        HStack(spacing: 16) {
            Button("提交") {
                viewModel.submitGuess()
            }
            .buttonStyle(.borderedProminent)
            .disabled(viewModel.engine.state != .playing)

            Button(viewModel.engine.isMarkMode ? "退出标记" : "标记模式") {
                viewModel.engine.isMarkMode.toggle()
                viewModel.engine.clearSelection()
            }
            .buttonStyle(.bordered)
            .tint(viewModel.engine.isMarkMode ? .green : .accentColor)

            Button("公布答案") {
                viewModel.giveUp()
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
}
