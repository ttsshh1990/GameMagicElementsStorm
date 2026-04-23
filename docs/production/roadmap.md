# Roadmap

本路线图描述 Game1 从 AI agent 工作台到可玩版本的阶段。当前只确定高层阶段，不提前展开复杂工程规划。

## Phase 0 - AI Agent 工作台

状态：进行中

目标：

- 建立项目入口和 agent 路由。
- 建立设计、工程、美术三个 agent 的职责边界。
- 建立当前状态、任务板、会话交接、当前设计和设计记忆。
- 明确当前不创建 Godot 工程。

完成条件：

- `README.md` 和 `AGENTS.md` 能让新 agent 判断如何开始。
- 三个 agent 文档能明确各自主责。
- `docs/design/current-design.md` 和 `docs/design/memory.md` 可用于设计接力。
- `docs/agent/task-board.md` 可追踪下一步任务。

## Phase 1 - 游戏设计收敛

状态：待开始

目标：

- 通过 design agent 完成第一轮游戏设计脑暴。
- 明确一句话概念、目标体验和核心玩法假设。
- 记录关键取舍。
- 判断是否足以进入 Godot 原型阶段。

完成条件：

- `docs/design/current-design.md` 有明确的初版设计共识。
- `docs/design/memory.md` 记录主要讨论和取舍。
- 任务板中有可执行的原型任务。

## Phase 2 - Godot 原型

状态：未开始

目标：

- 创建最小 Godot 4 工程。
- 实现一个可运行的核心玩法原型。
- 建立基础工程结构和验证方式。

进入条件：

- 用户明确决定进入工程阶段。
- 当前设计足以指导一个最小原型。
- engineering agent 更新当前状态和任务板。

## Phase 3 - 垂直切片

状态：未开始

目标：

- 基于原型制作一个短小但完整的可玩体验。
- 引入必要美术、音效、UI 和反馈。
- 验证核心循环是否成立。

## Phase 4 - 可发布版本

状态：未开始

目标：

- 扩展内容、打磨体验、处理导出和发布需求。
- 建立发布检查清单。
- 准备目标平台版本。
