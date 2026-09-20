import SwiftUI
import SpriteKit

struct GameView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel: GameViewModel

    init(bottleCount: Int) {
        _viewModel = State(initialValue: GameViewModel(bottleCount: bottleCount))
    }

    var body: some View {
        VStack(spacing: 20) {
            // SpriteKit 场景
            SpriteView(scene: makeScene())
                .frame(maxWidth: .infinity, maxHeight: .infinity)

            // 反馈文字
            Text(viewModel.feedbackText)
                .font(.title2)
                .fontWeight(.semibold)

            // 按钮区
            HStack(spacing: 20) {
                Button("提交") {
                    viewModel.submitGuess()
                }
                .buttonStyle(.borderedProminent)

                Button("公布答案") {
                    viewModel.giveUp()
                }
                .buttonStyle(.bordered)
                .tint(.red)

                Button("返回") {
                    dismiss()
                }
                .buttonStyle(.bordered)
            }
        }
        .padding()
    }

    private func makeScene() -> SKScene {
        let scene = GameScene(size: CGSize(width: 800, height: 600))
        scene.configure(engine: viewModel.engine)
        scene.scaleMode = .aspectFit
        return scene
    }
}
