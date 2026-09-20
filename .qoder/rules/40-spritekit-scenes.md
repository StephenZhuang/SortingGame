---
trigger: model_decision
description: 编写或修改 SpriteKit 场景、游戏节点、拖拽交互、动画、粒子、音效或帧循环逻辑时必须加载
---

# SpriteKit 场景与渲染规范

## 职责边界

- `SKScene` 只做两件事：把 `GameCore` 状态**渲染**出来、把用户输入**回传**给 GameCore
- 玩法判定（是否排好序、得分、步数）一律在 `GameCore`，禁止写进场景或节点

## 场景组织

- 一个玩法对应一个 `SKScene` 子类；场景切换用 `SKView.presentScene(_:transition:)`
- 节点分层用 `SKNode` 容器分组（如 `boardLayer` / `fxLayer` / `hudLayer`），并设置 `zPosition` 常量统一管理，避免魔法数字散落
- 复杂元素封装成自定义 `SKNode` 子类，对外暴露"根据状态更新"的方法，不让场景直接摆弄子节点细节

## 帧循环与性能

- `update(_ currentTime:)` 里只做必要的时间差计算，禁止重业务逻辑与内存分配
- 用 `deltaTime`（当前帧与上一帧时间差）驱动动画，不要假设固定帧率
- 批量同类节点考虑复用，避免频繁 `addChild`/`removeFromParent`
- 纹理集中放进 `Assets.xcassets` 的 SpriteKit Atlas，减少 draw call

## 资源加载

- 纹理/图集通过 `SKTextureAtlas` 预加载，加载完成再进场景，避免运行中卡顿
- 音效用 `SKAction.playSoundFileNamed`（短音效）或 `AVAudioPlayer`（长音频/背景乐），资源名用常量集中管理

## 交互

- 拖拽/点击通过 `touchesBegan/Moved/Ended`（iOS）与 `mouseDown/Dragged/Up`、`keyDown`（macOS）实现，统一经 `Input/` 抽象层归一化后交给 GameCore
- 命中检测用节点的 `name` 或 `userData` 映射回 GameCore 的元素 id，禁止用坐标反推业务身份

## 动画

- 动画用 `SKAction` 组合（`sequence` / `group` / `repeat`），完成回调里再同步 GameCore 状态
- 动画是状态的"表现"而非"来源"：先让 GameCore 变更，再让场景播放对应动画
