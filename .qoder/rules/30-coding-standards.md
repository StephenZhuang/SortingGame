---
trigger: glob
globs: "*.swift"
---

# 编码规范（Swift 6 / SwiftUI）

## 通用

- 代码标识符（变量、函数、类、文件名）一律英文；文档与注释一律中文
- 命名清晰具体：`fetchLevelData` 优于 `getData`
- 用 `// MARK: - 分区名` 组织代码；私有辅助函数放 `private extension`
- 禁止提交调试代码（`print` 调试、临时断点）与任何密钥、token
- 不写无意义注释；只在"为什么"不明显时（隐藏约束、微妙不变量、特定 bug 的 workaround）才注释

## Swift 6 并发与线程

- 开启严格并发，告警按错误处理
- UI 更新必须在 MainActor：ViewModel 标注 `@MainActor`，跨线程用 `MainActor.run` / `Task { @MainActor in }`
- 共享可变状态用 `actor`；不碰 MainActor 的纯逻辑标 `nonisolated`
- **绝不阻塞主线程**：重计算放到 `Task.detached`
- 生命周期：优先 `.task(id:)` 而非 `.onAppear`，异步任务可自动取消

## 内存与安全

- 闭包默认 `[weak self]`，异步闭包开头 `guard let self else { return }`
- 只有在能证明生命周期时才用 `[unowned self]`

## SwiftUI

- `body` **不超过 50 行**，超出就拆成子视图 struct 或 private 计算属性
- 状态管理：`@State` 本地值类型；`@StateObject` 仅在创建/持有处；`@ObservedObject` 子视图响应用；`@EnvironmentObject` 少用，优先 init 注入依赖
- 列表用 `LazyVStack`/`LazyHStack`，`id` 用稳定标识，避免 `\.self`
- 动画用 `.animation(_:value:)` 显式绑定状态；高频视觉更新用 `TimelineView` 而非 `Timer`
- 可点击的透明容器加 `.contentShape(Rectangle())` 保证命中
- 谨慎使用 `GeometryReader`（吃满空间、影响布局性能）
- 每个视图尽量提供 `#Preview`，并注入 Mock 数据

## 编辑后验证（必须执行）

每次编辑后运行对应最小验证命令，通过后再继续下一轮编辑（scheme/destination 以工程实际为准，2026-09-21 实证可用）：

- **编译（macOS）**：`xcodebuild -scheme SortingGame -destination 'platform=macOS' build`
- **编译（iOS 模拟器）**：`xcodebuild -scheme SortingGame-iOS -destination 'generic/platform=iOS Simulator' build`
- **单元测试（只跑 GameCore 纯逻辑测试，不触发 UI 测试）**：
  `xcodebuild -scheme SortingGame -destination 'platform=macOS' test -only-testing:SortingGameTests/BottleArrayTests -only-testing:SortingGameTests/BottleTests -only-testing:SortingGameTests/GameEngineTests -only-testing:SortingGameTests/ScoreCalculatorTests`
- **禁止默认执行全量 `test`**：会连带运行 `SortingGameUITests`，拉起模拟器/App 界面自动操作，占用用户屏幕；UI 测试仅在用户明确要求时运行
- 验证失败先定位修复，再继续后续编辑
