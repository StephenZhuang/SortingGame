---
trigger: model_decision
description: 处理 Mac/iPhone/iPad 三端差异、布局适配、输入方式（触摸/鼠标/键盘/触控板）、尺寸类或平台条件编译时必须加载
---

# 跨端适配（macOS / iPhone / iPad）

## 一套代码，多端复用

- 优先写平台无关逻辑；平台差异集中在 `Input/` 与少量视图，不散落到 GameCore
- 条件编译用 `#if os(iOS)` / `#if os(macOS)`，且**成对出现**、范围最小化；禁止大段平台分支包裹业务逻辑

## 输入抽象

- 定义统一语义事件（如 `select` / `swap` / `move` / `confirm` / `undo`），各平台把手势翻译成同一事件
- iPhone/iPad：触摸、拖拽手势（`UITouch` / SwiftUI `DragGesture`）
- macOS：鼠标点击/拖拽、键盘快捷键、触控板；关键操作提供键盘可达路径
- iPad 需兼顾触摸与（连接时的）鼠标/键盘指针

## 布局适配

- 用 SwiftUI 的自适应布局（`ViewThatFits`、`Grid`、相对尺寸），避免写死像素
- 按 **size class** 与横竖屏调整排布：iPhone 竖屏为主，iPad/macOS 利用更大画布
- 尊重**安全区**（刘海/灵动岛/Home 指示条）与 macOS 窗口可缩放；SpriteKit 场景用 `.aspectFill`/`.resizeFill` 明确缩放策略
- HUD/按钮的点击热区在触摸端不小于 ~44pt

## 平台能力

- Game Center、存档、设置等放 `Services/`，用协议抽象以便各端注入不同实现或 mock
- 生命周期差异（iOS `scenePhase` 后台暂停 vs macOS 窗口/多窗口）统一在 App 入口处理，暂停时同步暂停 SpriteKit 场景

## 验收

- 每个功能至少在三端各验证一次（模拟器 + Mac），确认输入、布局、安全区都正常，再报告完成
