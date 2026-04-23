# AGENTS

这是 Game1 项目的 AI agent 通用规则和路由协议。任何 Codex App thread、Codex CLI/SDK/app-server、OpenClaw 或其他 agent 在本项目工作前，都必须先阅读本文。

`AGENTS.md` 只记录稳定规则，不记录会随项目变化的目标、阶段、完成情况或下一步任务。项目状态以 `docs/agent/current-state.md` 为准；任务状态以 `docs/agent/task-board.md` 为准。

## 总原则

- 先读上下文，再行动。
- 重要信息必须写入项目文档，不能只留在聊天记录里。
- 任务以本地 Markdown 追踪，不依赖 GitHub Issues 或外部任务系统。
- 不创建新的设计文档体系；游戏设计只维护 `docs/design/current-design.md` 和 `docs/design/memory.md`，除非用户明确要求扩展。
- 不擅自删除或重写其他 agent 已记录的上下文；如果需要修正，追加说明并保留可追溯性。
- 不把可变状态写进本文；状态、任务、设计记忆、交接信息必须写入各自的持久化文档。

## Agent 路由

根据用户任务选择主责 agent。

### Design Agent

启用条件：

- 游戏设计脑暴。
- 玩法、世界观、核心循环、系统取舍。
- 设计方向、玩家体验、范围控制。
- 将聊天中的想法整理成当前设计。

入口文档：`agents/design-agent.md`

核心职责：

- 维护 `docs/design/current-design.md`，使其始终代表最新设计共识。
- 维护 `docs/design/memory.md`，记录有价值讨论、分歧、取舍、采纳或拒绝原因。

### Engineering Agent

启用条件：

- 代码更改。
- Godot 工程搭建。
- 脚本、场景、工具、测试、bug 修复。
- 工程结构、构建、导出和验证流程。

入口文档：`agents/engineering-agent.md`

核心职责：

- 负责工程实现和验证。
- 记录工程状态、任务进展和交接信息。
- 实现中发现设计问题时，记录问题并交给 design agent 处理。

### Art Agent

启用条件：

- 美术资源、风格探索、图片生成。
- 贴图、图标、sprite、UI 视觉资源。
- 资源命名、整理、导入和接入游戏项目。

入口文档：`agents/art-agent.md`

核心职责：

- 生成或整理美术资源。
- 记录资源来源、用途、命名和接入方式。
- 视觉方向影响玩法或设定时，记录到设计记忆或任务板等待确认。

## 跨领域任务

如果任务跨设计、工程、美术多个领域：

1. 先判断任务的主责 agent。
2. 主责 agent 只处理自己的职责范围。
3. 需要其他 agent 接续的内容，写入 `docs/agent/task-board.md` 或 `docs/agent/session-log.md`。
4. 不要把设计、工程、美术职责混在同一次交付里，除非用户明确要求。

## 所有 Agent 的开始流程

1. 阅读 `README.md`。
2. 阅读 `AGENTS.md`。
3. 阅读 `docs/agent/current-state.md`。
4. 根据任务类型阅读对应 agent 文档。
5. 阅读该 agent 文档列出的专属上下文。
6. 检查 `docs/agent/task-board.md` 中是否已有相关任务。
7. 如果这是新的工作入口，按本文的 Session Log 维护规则创建或补齐交接记录。

## 所有 Agent 的结束流程

结束一次工作前，必须按实际变化更新以下文档：

- 状态变化：`docs/agent/current-state.md`
- 新任务、阻塞项、完成项：`docs/agent/task-board.md`
- 跨 thread、跨机器、跨工具交接信息：`docs/agent/session-log.md`
- 设计讨论价值和取舍：`docs/design/memory.md`
- 最新设计共识：`docs/design/current-design.md`

如果没有变化，不要为了形式化而制造记录；但必须在最终回复中说明未更新的原因。

## Session Log 维护规则

`docs/agent/session-log.md` 用于跨入口交接。以下情况必须追加记录：

- 从新的 Codex App thread 开始工作。
- 从另一台机器 clone 或同步项目后开始工作。
- 通过 Codex CLI、SDK 或 app-server 开始工作。
- 通过 OpenClaw 或其他 AI agent 开始工作。
- 本次工作产生了需要未来 agent 接续理解的状态、任务、设计或工程变化。

每条记录必须包含：

- 日期。
- 入口来源。
- 主责 agent。
- 已读取的关键上下文。
- 任务摘要。
- 产生的状态变化。
- 后续交接事项。

如果只是同一 thread 内连续短交互，且没有产生状态、任务、设计或工程变化，可以不追加 `session-log.md`；最终回复中需要说明未追加原因。

## 文档写作规则

- 中文为主。
- 文件名、任务 ID、未来代码符号用英文。
- `current-state.md` 是项目状态唯一来源。
- `task-board.md` 是任务状态唯一来源。
- `current-design.md` 只保留最新设计共识，不堆历史。
- `memory.md` 记录设计变化过程和原因。
- `session-log.md` 记录工作交接，不替代任务板。
