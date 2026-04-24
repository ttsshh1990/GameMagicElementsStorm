# Task Board

任务 ID 使用 `G1-0001` 格式。任务状态以本文件为准。

## Now

- `G1-0006` 重做剩余未定的三元素组合。
  - 主责：design-agent
  - 状态：进行中
  - 验收：冰冰火、火火冰形成明确技能形态与造成伤害方式，并更新设计文档。

## Next

- `G1-0011` 用 art skill 做第一轮美术风格锁定。
  - 主责：art-agent
  - 状态：待开始
  - 验收：基于 `skills/elemental-art-assets/` 的 prompt pack 和样图，确认或调整第一版统一美术方向。

- `G1-0009` 明确基础战斗与合成解锁的工程规格。
  - 主责：design-agent / engineering-agent
  - 状态：待开始
  - 验收：1-2 级基础元素如何攻击、3 级合成 UI 如何操作、升级奖励界面最小规则形成明确文档，可交给 engineering-agent 实现。

- `G1-0007` 细化已确认组合的技能细节与成长差异。
  - 主责：design-agent
  - 状态：待开始
  - 验收：冰冰雷、火火雷、雷雷雷、雷雷冰、雷雷火、冰火雷补齐技能细节；紫色 / 橙色阶段的成长差异形成明确描述。

- `G1-0008` 定义符文效果池与奖励分配原则。
  - 主责：design-agent
  - 状态：待开始
  - 验收：不同品质符文的效果分层、激活条件取舍、升级奖励中元素 / 强化 / 符文的分配原则形成当前共识。

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

- `G1-0002` 进行第一轮游戏设计脑暴。
  - 主责：design-agent
  - 状态：已完成
  - 验收：用户历史设计初稿已导入为项目第一版设计基线；`docs/design/current-design.md` 和 `docs/design/memory.md` 已更新。

- `G1-0010` 确定连续生存结构与统一数值规则。
  - 主责：design-agent
  - 状态：已完成
  - 验收：`docs/design/current-design.md` 已记录 2D 俯视角、单平面房间、技能自动 CD、无限刷怪、拾取经验升级、升级暂停奖励、3 级解锁合成，以及基于全局基准值的技能 / 怪物 / 经验公式。

- `G1-0012` 创建 art agent 项目内 skill。
  - 主责：art-agent
  - 状态：已完成
  - 验收：`skills/elemental-art-assets/` 包含有效 `SKILL.md`、稳定 prompt pack、asset workflow 和 3 张风格样图；`agents/art-agent.md` 已要求使用该 skill。

- `G1-0013` 根据用户反馈调整 art skill 风格样板。
  - 主责：art-agent
  - 状态：已完成
  - 验收：已认可的火 / 雷图标已拆成 `512x512` RGBA PNG；人物方向样图保留；冰元素候选图标已生成到 `tmp/art-review/` 等待确认；prompt pack 已强化冰元素约束，避免生成普通蓝宝石或泛青色水晶。

- `G1-0014` 调整冰元素图标方向为菱形冰晶。
  - 主责：art-agent
  - 状态：已完成
  - 验收：冰元素 prompt 已从“大雪花图标”调整为“菱形冰晶主体 + 少量霜雪细节”；用户已确认候选图，并已加入为 `skills/elemental-art-assets/assets/game-ready/icons/icon_element_ice_512.png`。

- `G1-0001` 搭建 AI agent 工作台文档结构。
  - 主责：engineering-agent
  - 状态：已完成
  - 验收：计划中的入口、agent、状态、设计、路线图文档创建完成；未创建 Godot 工程。

- `G1-0005` 拆分 README / AGENTS / 当前状态 / session log 职责。
  - 主责：engineering-agent
  - 状态：已完成
  - 验收：`AGENTS.md` 不承载可变项目状态；`README.md` 只做项目导航；`current-state.md` 承载当前状态；`session-log.md` 明确跨入口交接规则。
