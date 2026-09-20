---
trigger: model_decision
description: 编写测试、验证玩法逻辑正确性、或改动 GameCore 排序/计分/关卡逻辑时必须加载
---

# 测试策略

## 优先级

测试重心在 `GameCore`（纯逻辑、无框架依赖、跑得快）。渲染与交互靠三端手工验证兜底。

## 单元测试（GameCore）

- 用 XCTest，遵循 **Given-When-Then** 结构
- 覆盖：排序判定（已排序/未排序/边界）、一次操作后的状态变更、计分与步数、关卡加载与解析、胜负条件
- 玩法逻辑写成纯函数/值类型，输入确定则输出确定，禁止依赖随机数而不注入 seed
- 关卡等外部数据用内存中的 Mock/fixture，测试不读真实资源文件

## 依赖隔离

- `Services/`（Game Center、存档、设置）用协议抽象，测试注入 Mock 实现
- 需要随机的玩法通过注入 `RandomNumberGenerator` 保证可复现

## UI / 交互测试

- 关键 SwiftUI 元素设置稳定的 `accessibilityIdentifier`，便于 XCUITest 定位
- UI 测试只覆盖核心流程（进入关卡 → 完成排序 → 结算），不追求全覆盖

## 门槛

- 改动 GameCore 后必须补/更新对应单元测试并跑通（命令见 `30-coding-standards.md`）
- 修 bug 先写一个能复现的失败测试，再修到通过
