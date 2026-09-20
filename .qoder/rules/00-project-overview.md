---
trigger: always_on
---

# SortingGame 项目概览

## 系统定位

SortingGame 是一款**排序类益智小游戏**：玩家把打乱的元素（数字/颜色/图案等）按规则排好序即通关。核心诉求：

1. 三端一致体验：macOS / iPhone / iPad 一套代码
2. 玩法逻辑纯净化、可测试
3. 轻量、离线、原生性能

## 平台与技术栈约束

- **语言**：Swift 6，开启严格并发（Strict Concurrency），并发告警按错误处理
- **UI 外壳**：SwiftUI —— 主菜单、关卡选择、设置、HUD、暂停/结算弹窗
- **游戏渲染**：SpriteKit —— 游戏主场景、元素节点、拖拽与动画、粒子与音效
- **不引入第三方跨平台引擎**（Unity/Godot 等）；平台差异用条件编译与输入抽象层处理
- **最低系统版本**：iOS / iPadOS 17，macOS 14（待用户最终确认；改动前先在此更新并评估 `@available`）

## 模块边界

| 模块 | 职责 | 硬约束 |
|------|------|--------|
| `GameCore/` | 排序规则、关卡、计分、状态机 | 纯 Swift，**禁止** import SpriteKit/SwiftUI/UIKit/AppKit |
| `Scenes/` | SKScene、节点、渲染与动画 | 只渲染 GameCore 状态、回传输入，不含玩法逻辑 |
| `UI/` | SwiftUI 视图与 ViewModel | 通过 GameCore 状态驱动，不直接改游戏状态 |
| `Input/` | 跨端输入抽象 | 把平台事件翻译成语义事件交给 GameCore |
| `Services/` | Game Center、存档、设置 | 与玩法逻辑隔离，便于 mock |

## 团队事实

- 单人开发 + AI 助手辅助
- 本规则体系的受众：开发者本人与 AI 编程助手

## 接手任务的第一步

1. 读本规则与 `AGENTS.md`
2. 确认真实 scheme、target、签名、最低系统版本，回填 `30-coding-standards.md` 的验证命令
3. 需求边界不清时，先在 `docs/` 澄清再动代码
