---
trigger: always_on
---

# 游戏架构与数据流

## 分层原则

采用「**纯逻辑核心 + 渲染/输入适配**」，目标是玩法逻辑可脱离 UI 独立测试。

```
SwiftUI (UI/) ─────┐
                   ├──→ GameCore (纯逻辑，无框架依赖) ──→ 发布状态
SpriteKit (Scenes/)┘                                        │
        ↑                                                   ↓
     Input (Input/) 归一化跨端输入 → 语义事件 → GameCore    UI / Scenes 刷新
```

## 依赖方向（强约束）

- `GameCore` **不得** import `SpriteKit` / `SwiftUI` / `UIKit` / `AppKit`
- `Scenes` 与 `UI` 可依赖 `GameCore`，但**彼此不直接依赖**，只通过 GameCore 的状态/事件通信
- `Input` 只把平台事件翻译成 GameCore 的语义事件（如 `.select(id)` / `.swap(a,b)` / `.move(from,to)` / `.confirm`）

## 状态与数据流（MVVM + 单向数据流）

- `GameCore` 持有权威状态：当前关卡、元素序列、步数、得分、是否完成
- 状态变更走单向流：输入 → GameCore 变更 → 状态发布 → UI/场景刷新
- ViewModel 用 `@MainActor` + `@Observable`（或 `ObservableObject`）订阅 GameCore，View 不直接改状态
- 玩法逻辑写成纯函数/值类型，尽量 `nonisolated`，方便测试

## 关卡与配置

- 关卡用声明式文件（`Resources/Levels/*.json`）描述，代码只负责解析与执行，禁止把关卡硬编码进逻辑
- 排序规则抽象为协议（如 `SortingRule`），不同玩法作为实现，便于扩展新关卡类型

## 禁止事项

- 不在 `SKScene.update(_:)` 或 SwiftUI `body` 里写复杂业务逻辑
- 不让渲染层持有权威游戏状态（状态只在 GameCore）
