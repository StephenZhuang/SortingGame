import SwiftUI
import SpriteKit

/// 结算快照：用 sheet(item:) 在呈现瞬间原子携带数据，规避 iOS 上 isPresented+独立 @State 的时序竞争
private struct SettlementSnapshot: Identifiable {
    let id = UUID()
    let state: GameState
    let playerArray: BottleArray
}

struct GameView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel: GameViewModel
    @State private var scene: GameScene
    @State private var settlement: SettlementSnapshot?
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
                // macOS sheet 按内容自适应尺寸，SpriteView 无 intrinsic size，
                // 必须给最小/理想高度，否则被压成 0 高看不见瓶子
                .frame(maxWidth: .infinity, minHeight: 300, idealHeight: 480, maxHeight: .infinity)

            Text(viewModel.feedbackText)
                .font(.title2)
                .fontWeight(.semibold)
                // 以提交次数为触发器：即使"对了 x 个"数值不变，每次提交也会重放放大缩小动画
                .phaseAnimator([1.0, 1.3, 1.0], trigger: viewModel.engine.scoreCalculator.attemptCount) { text, scale in
                    text.scaleEffect(scale)
                } animation: { scale in
                    scale > 1.0 ? .easeOut(duration: 0.12) : .spring(duration: 0.3)
                }

            buttonBar
        }
        .padding()
        .task(id: viewModel.engine.state) {
            // 使用 .task(id:) 替代 onChange，确保 @Observable 跨对象属性链变更能被可靠捕获
            switch viewModel.engine.state {
            case .won:
                scene.runCelebration()
                try? await Task.sleep(for: .seconds(1.2))
                guard !Task.isCancelled else { return }
                settlement = SettlementSnapshot(
                    state: viewModel.engine.state,
                    playerArray: viewModel.engine.currentArray ?? BottleArray(bottles: [])
                )
            case .gaveUp:
                settlement = SettlementSnapshot(
                    state: viewModel.engine.state,
                    playerArray: viewModel.engine.currentArray ?? BottleArray(bottles: [])
                )
            case .preparing, .playing:
                break
            }
        }
        .sheet(item: $settlement) { snapshot in
            SettlementView(
                state: snapshot.state,
                bottleCount: viewModel.engine.bottleCount,
                playerArray: snapshot.playerArray,
                onPlayAgain: {
                    settlement = nil
                    viewModel.startNewGame()
                },
                onChangeDifficulty: {
                    settlement = nil
                    dismiss()
                },
                onBackToMenu: {
                    settlement = nil
                    onExitToMenu()
                }
            )
        }
#if os(macOS)
        .focused($gameFocused)
        .focusable()
        .focusEffectDisabled()
        .onKeyPress(phases: .down) { press in
            viewModel.handleKey(press.key) ? .handled : .ignored
        }
        .onAppear { gameFocused = true }
        .onChange(of: settlement?.id) { _, newId in
            if newId == nil {
                restoreFocus()
            }
        }
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
