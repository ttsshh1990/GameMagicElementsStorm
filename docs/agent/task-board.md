# Task Board

任务 ID 使用 `G1-0001` 格式。任务状态以本文件为准。

## Now

暂无。

## Next

- `G1-0002` 进行第一轮游戏设计脑暴。
  - 主责：design-agent
  - 状态：待开始
  - 验收：`docs/design/memory.md` 记录有价值讨论；如形成共识，更新 `docs/design/current-design.md`。

## Backlog

- `G1-0003` 决定何时从文档工作台进入 Godot 原型阶段。
  - 主责：design-agent / engineering-agent
  - 状态：待讨论
  - 验收：路线图中明确阶段切换条件。

- `G1-0004` 后续定义美术方向和资源接入规范。
  - 主责：art-agent
  - 状态：待讨论
  - 验收：当前设计足以支撑美术探索后，再开始资源相关工作。

## Blocked

暂无。

## Done

- `G1-0001` 搭建 AI agent 工作台文档结构。
  - 主责：engineering-agent
  - 状态：已完成
  - 验收：计划中的入口、agent、状态、设计、路线图文档创建完成；未创建 Godot 工程。

- `G1-0005` 拆分 README / AGENTS / 当前状态 / session log 职责。
  - 主责：engineering-agent
  - 状态：已完成
  - 验收：`AGENTS.md` 不承载可变项目状态；`README.md` 只做项目导航；`current-state.md` 承载当前状态；`session-log.md` 明确跨入口交接规则。
