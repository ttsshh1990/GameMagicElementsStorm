# Session Log

本文件记录跨 thread、跨机器、跨工具的工作交接。它不是任务板，任务状态以 `docs/agent/task-board.md` 为准。

## 维护规则

以下情况必须追加记录：

- 从新的 Codex App thread 开始工作。
- 从另一台机器 clone 或同步项目后开始工作。
- 通过 Codex CLI、SDK 或 app-server 开始工作。
- 通过 OpenClaw 或其他 AI agent 开始工作。
- 本次工作产生了需要未来 agent 接续理解的状态、任务、设计或工程变化。

如果只是同一 thread 内连续短交互，且没有产生状态、任务、设计或工程变化，可以不追加记录；最终回复中需要说明未追加原因。

## 记录格式

```md
## YYYY-MM-DD - 简短标题

- 入口来源：
- 主责 agent：
- 已读取上下文：
- 任务摘要：
- 状态变化：
- 后续交接：
```

## 2026-04-23 - 工作台初始化

- 入口来源：Codex App 当前 thread。
- 主责 agent：engineering-agent。
- 已读取上下文：用户确认的初始工作台计划。
- 任务摘要：初始化多 agent 文档工作台。
- 状态变化：创建项目入口、agent 文档、状态文档、设计文档、路线图和 Git 忽略规则；`G1-0001` 已完成。
- 后续交接：下一步建议启用 design agent，进行第一轮游戏设计脑暴。

## 2026-04-23 - README / AGENTS / 状态文档职责拆分

- 入口来源：Codex App 当前 thread。
- 主责 agent：engineering-agent。
- 已读取上下文：`README.md`、`AGENTS.md`、`docs/agent/current-state.md`、`docs/agent/session-log.md`、`docs/agent/task-board.md`。
- 任务摘要：按用户计划拆分 README、AGENTS、当前状态和 session log 的职责。
- 状态变化：`AGENTS.md` 收敛为稳定通用规则和路由协议；可变项目状态集中到 `docs/agent/current-state.md`；`docs/agent/session-log.md` 增加跨入口维护规则和记录格式。
- 后续交接：后续 agent 从新入口开始工作时，必须按 `AGENTS.md` 和本文规则追加交接记录。
