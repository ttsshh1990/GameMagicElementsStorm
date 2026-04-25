# Game1

Game1 是一个独立游戏项目。项目采用“文档先行、多 agent 协作”的工作方式，让 Codex App、Codex CLI/SDK/app-server、OpenClaw 或其他 AI agent 可以在同一套上下文里稳定接力。

默认技术方向是 Godot 4。文档主体使用中文，文件名、任务 ID、工程命名和未来代码命名使用英文。

## 新环境如何开始

如果你是在新的机器、新的 thread 或新的 agent 入口中打开本项目：

1. 先阅读 `AGENTS.md`，了解 agent 通用规则和任务路由。
2. 再阅读 `docs/agent/current-state.md`，了解项目现在的状态和限制。
3. 根据任务类型进入对应 agent 文档。

## 关键文档

- `AGENTS.md`：AI agent 通用规则、路由和交接协议。
- `docs/agent/current-state.md`：项目当前状态的唯一来源。
- `docs/agent/task-board.md`：本地 Markdown 任务板。
- `docs/agent/session-log.md`：跨 thread、跨机器、跨工具的交接记录。
- `docs/production/roadmap.md`：阶段路线图。
- `godotGame/`：Godot 4 原型工程根目录。

## Agent 文档

- `agents/design-agent.md`：游戏设计脑暴、设计收敛、当前设计维护。
- `agents/engineering-agent.md`：工程实现、代码更改、测试和验证。
- `agents/art-agent.md`：美术资源探索、生成、整理和接入。

## 设计文档

- `docs/design/current-design.md`：唯一的当前游戏设计文档，始终代表最新共识。
- `docs/design/memory.md`：设计迭代记忆，记录讨论、分歧、取舍和原因。

## 工作方式

本项目支持以下入口：

- 当前 Codex App thread。
- 另一台机器 clone 后的 Codex App。
- Codex CLI、SDK 或 app-server。
- OpenClaw 或其他能读取本仓库文档的 AI agent。

所有 agent 的执行细则以 `AGENTS.md` 为准；README 只负责项目导航。
