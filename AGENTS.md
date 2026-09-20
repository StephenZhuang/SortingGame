# SortingGame（排序益智小游戏）

一款在 macOS / iPhone / iPad 三端运行的排序类益智小游戏，一套代码多端复用。

- 技术栈：Swift 6（严格并发）+ SwiftUI（外壳/菜单/HUD）+ SpriteKit（游戏场景与渲染）
- 架构：纯逻辑核心（GameCore）与渲染/输入解耦，玩法逻辑可脱离 UI 独立测试
- 详细背景见 `.qoder/rules/00-project-overview.md`，设计文档位于 `docs/`

## AI 协作规则索引

规则正文统一维护在 `.qoder/rules/`，按主题拆分。两者冲突时以更具体、更新的规则为准：

| 文件 | 主题 |
|------|------|
| `.qoder/rules/00-project-overview.md` | 项目背景、平台、技术栈约束、模块边界 |
| `.qoder/rules/10-change-management.md` | 文档先行的变更管理流程与提交/分支规范 |
| `.qoder/rules/20-game-architecture.md` | 游戏分层、依赖方向、状态与数据流 |
| `.qoder/rules/30-coding-standards.md` | Swift 6 / SwiftUI 编码规范与编辑后验证 |
| `.qoder/rules/40-spritekit-scenes.md` | SpriteKit 场景、节点、资源与帧循环规范 |
| `.qoder/rules/50-multiplatform.md` | Mac/iPhone/iPad 跨端适配与输入抽象 |
| `.qoder/rules/60-testing.md` | 测试策略（重点覆盖 GameCore） |

## 交流约定
- 始终用**中文**交流，技术术语可保留英文。
- 用户问方案时**只给方案、不直接实施**；明确说"改/做"后再动代码。
- 结论**实证验证**：先跑命令 / 编译 / 查数据，不臆测。
