# Current State

最后更新：2026-04-25

本文件是 Game1 项目当前状态的唯一来源。任何会随项目推进变化的信息，包括项目阶段、当前目标、当前限制和下一步重点，都应记录在这里，而不是记录在 `README.md` 或 `AGENTS.md`。

## 项目阶段

AI agent 工作台已初始化，入口文档、通用规则和交接协议的职责边界已完成拆分。

当前已进入 Godot 原型阶段。`Prototype 0.1` 已开始落地，重点是验证 2D top-down 核心循环：玩家移动、敌人刷出与追踪、三基础元素自动技能、XP 拾取、升级暂停和 3 选 1 奖励。

## 当前目标

- 在现有第一版设计基线上继续实现和验证 `Prototype 0.1`。
- 继续保持工程实现严格遵守 Godot 原型架构和 single source of truth 规则。
- 继续使用 art agent 可复用的稳定美术资源生成流程，支持后续风格统一的资源生成与 Godot 接入。
- 第一批元素技能资源已按修正后的 `imagegen` workflow 重做过一轮；2026-04-25 盘点确认当前可直接接入 Godot 的只有三基础元素图标。技能图标 / VFX 目前只保留在 `skills/elemental-art-assets/assets/game-ready/source-frames/` 的 chroma-key RGB 源帧中，仍需用户确认风格并完成去背、缩放、最终路径整理和 manifest 后才能作为运行时资源接入。
- 将后续设计判断持续沉淀到 `docs/design/memory.md`。
- 当设计共识发生变化时，持续更新 `docs/design/current-design.md`。
- 使用 `docs/engineering/implementation-status.md` 持续维护工程实现状态、缺失资源占位和架构待讨论事项。

## 当前已知方向

- 项目类型：独立游戏。
- 当前游戏方向：元素弹幕 Roguelike。
- 核心主题：冰 / 火 / 雷三元素 build 构筑。
- 当前基础战斗结构：2D 俯视角、单个大平面房间、移动走位、技能自动 CD、怪物无限刷出、拾取经验晶体升级并暂停选择奖励。
- 当前基础元素攻击：火为小火球单体攻击；冰为寒冰新星小范围群伤和轻度减速；雷为小闪电连锁弹射并短暂麻痹。三者基础期望 DPS 基本一致。
- 当前数值方向：使用全局基准值和倍率公式驱动技能伤害、怪物血量、刷怪压力和经验成长。
- 未来技术方向：Godot 4。
- 文档语言：中文为主。
- 任务追踪：本地 Markdown。
- 当前已创建 Godot 4 工程。
- 当前 Godot 工程根目录为 `godotGame/`，不要在仓库根目录创建第二套 Godot 工程目录。
- 当前已有第一轮核心循环代码。
- 当前已通过 Computer Use 和 headless 输入测试验证 WASD / 方向键移动、升级暂停阻止移动。
- 当前 Godot 显示目标为 1280x720 横屏；项目使用 `canvas_items + expand` 拉伸策略，HUD 左上角锚定，升级奖励面板中心锚定。
- 当前运行时已接入已确认的火 / 冰 / 雷元素图标。
- 当前玩家和三类怪物已接入透明 PNG 帧序列动画资源；XP shard 和三基础技能特效已具备帧序列动画资源接入口。把符合 `docs/engineering/implementation-status.md` 清单的透明 PNG 帧放入 `godotGame/assets/` 的 `_frames/` 指定目录即可播放动画；缺帧序列时可用单张 PNG fallback；都缺失时自动回退到 Godot 绘制占位。
- 当前不创建模板区或复杂设计文档拆分区。
- 当前已有项目内 art skill：`skills/elemental-art-assets/`，用于稳定 prompt pack、样图和美术资源接入流程。
- 当前已有已确认的三基础元素图标，并已复制到 `godotGame/assets/art/icons/elements/` 供运行时使用。`skills/elemental-art-assets/assets/game-ready/source-frames/` 中有部分 `imagegen` 生成的技能图标 / VFX chroma-key 源帧，但它们不是最终透明 PNG 帧序列，不能直接作为 Godot 运行时资源引用。
- 当前 Godot 原型程序架构已补充模块边界和 single source of truth 规则：技能、元素、敌人、奖励、全局数值和运行时资源路径必须有唯一事实源，其他系统只能引用或查询。
- 当前 engineering agent 已增加架构遵守、代码注释、模块文档、占位美术资源记录和 implementation status 维护规则。

## 当前文档结构

- `README.md`：人类和新环境的项目入口与文档导航。
- `AGENTS.md`：AI agent 通用规则、路由和交接协议。
- `agents/design-agent.md`：设计 agent。
- `agents/engineering-agent.md`：工程 agent。
- `agents/art-agent.md`：美术 agent。
- `docs/agent/task-board.md`：任务板。
- `docs/agent/session-log.md`：跨入口工作交接。
- `docs/design/current-design.md`：当前设计。
- `docs/design/memory.md`：设计记忆。
- `docs/engineering/godot-prototype-architecture.md`：Godot 原型程序架构。
- `docs/engineering/implementation-status.md`：Godot 工程实现状态。
- `godotGame/`：Godot 4 原型工程。
- `docs/production/roadmap.md`：路线图。

## 当前限制

- Godot 原型目前只是 `Prototype 0.1`，不是完整游戏。
- 当前优先适配横屏；竖屏 UI 和触屏虚拟摇杆尚未实现。
- 完整合成 UI、符文系统、高级技能、紫色 / 橙色品质、失败结算尚未实现。
- 投射物、VFX、XP shard 和 UI 美术仍有占位资源，需求记录在 `docs/engineering/implementation-status.md`。
- 升级 UI 的正式图片 / theme 接入仍未完成。
- 第一批 `imagegen` 元素技能源帧仍需用户确认风格，并完成透明化、缩放、命名、manifest 和 Godot 路径整理后，才能作为正式资源接入。
- 还没有自动 agent 调度服务。
- “启用 agent”目前通过阅读 `AGENTS.md` 和对应 agent 文档来实现。

## 下一步重点

1. 继续在 1280x720 横屏基准下手感检查 `Prototype 0.1`，重点观察刷怪压力、基础技能节奏和升级奖励可读性。
2. 根据原型反馈调整数值、碰撞、刷怪压力和 UI 可读性。
3. 明确 3 级后合成 UI 的操作规则，以及升级奖励界面的最小工程规格。
4. 重做剩余未定的 2 个三元素组合。
5. 等待用户确认第一批 `imagegen` 元素技能源帧的风格质量；确认后再整理为最终透明 PNG 帧序列并交给 engineering-agent 接入。

## 当前进行中的工作

- 第一版设计基线已建立，当前同时处于设计细化和 Godot 原型验证阶段。
- art agent 的项目内 skill 已建立；三基础元素图标已确认并已接入 Godot。第一批 `imagegen` 元素技能源帧暂存在 `skills/elemental-art-assets/assets/game-ready/source-frames/`，需用户确认和后处理后再视为最终可接入资源。
- engineering agent 已从“阶段守门”调整为“通用工程规范”角色；Godot 原型程序架构文档已建立并补强 single source of truth 约束；implementation status 已建立；`Prototype 0.1` 核心循环已开始实现并已整体移动到 `godotGame/`。

## 注意事项

如果新 agent 进入本项目，必须先阅读 `AGENTS.md`，再读取本文件，并按任务类型选择主责 agent。工程实现还必须读取 `docs/engineering/implementation-status.md`。
