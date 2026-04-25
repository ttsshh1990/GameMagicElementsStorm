# Task Board

任务 ID 使用 `G1-0001` 格式。任务状态以本文件为准。

## Now

- `G1-0011` 重做第一批元素美术资源，使其贴合已确认样图风格。
  - 主责：art-agent
  - 状态：待用户确认与后处理
  - 验收：已删除上一版候选；当前三基础元素图标已确认并已接入 Godot。`skills/elemental-art-assets/assets/game-ready/source-frames/` 中有基于 `imagegen` 的技能图标 / VFX chroma-key RGB 源帧，覆盖小火球、寒冰新星、小闪电、火火火陨石、冰冰冰冰锥、冰火雷元素能量场的部分候选表现。它们仍需用户确认风格，并完成去背、缩放、最终透明 PNG 帧序列、manifest 和 Godot 目标路径整理后，才能作为正式运行时资源接入。

- `G1-0006` 重做剩余未定的三元素组合。
  - 主责：design-agent
  - 状态：进行中
  - 验收：冰冰火、火火冰形成明确技能形态与造成伤害方式，并更新设计文档。

## Next

- `G1-0009` 明确基础战斗与合成解锁的工程规格。
  - 主责：design-agent / engineering-agent
  - 状态：进行中
  - 验收：基础元素攻击方式已明确；仍需明确 3 级合成 UI 如何操作、升级奖励界面最小规则，形成可交给 engineering-agent 实现的文档。

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

- `G1-0015` Godot 工程创建后接入已确认的元素美术资源。
  - 主责：engineering-agent
  - 状态：待资源确认与整理
  - 验收：将已确认达标并已整理为最终透明 PNG 帧序列的图标与 VFX 接入 Godot 资源目录，并按对应 manifest 配置帧数、帧率和循环方式。当前只有三基础元素图标已完成接入；技能图标 / VFX 源帧不得直接从 `skills/` 目录被 Godot 引用。

## Blocked

暂无。

## Done

- `G1-0025` 调整玩家和怪物美术显示尺寸。
  - 主责：engineering-agent
  - 状态：已完成
  - 验收：确认美术资源尺寸正常，过小原因是运行时按碰撞半径缩放；已将玩家视觉尺寸改为 `108` world units，普通怪 `84`，快怪 `69`，厚血怪 `108`，同时保持碰撞 / 接触判定半径不变；三类怪物显示尺寸由 `EnemyDef.visual_world_size` 统一维护。

- `G1-0026` 将战斗背景改为浅灰无限重复地面。
  - 主责：engineering-agent
  - 状态：已完成
  - 验收：`GameWorld` 不再绘制固定大小深色矩形，改为围绕玩家 / 相机位置绘制接近白色的浅灰底色和重复网格，避免移动到边界后露出背景外区域。

- `G1-0024` 裁切并接入玩家和三类怪物帧序列资源。
  - 主责：engineering-agent
  - 状态：已完成
  - 验收：已将玩家、普通追踪怪、小型快怪、厚血怪的横向 spritesheet 裁切为各自 `_frames/` 目录下的 4 张透明 PNG 帧；保留单张 spritesheet 作为 fallback；`visual_asset_smoke_test.gd` 已验证帧数量、尺寸、配置路径和玩家运行时动画加载；现有核心 smoke tests 已通过。

- `G1-0023` 支持角色、怪物和技能特效的帧序列动画播放。
  - 主责：engineering-agent
  - 状态：已完成
  - 验收：`VisualAsset` 支持从 `_frames/` 目录按文件名顺序加载透明 PNG 帧并创建 `AnimatedSprite2D`；玩家、三类怪物、XP shard、火球、寒冰新星、闪电链均优先播放帧序列，缺帧序列时 fallback 到单张 PNG，再缺失则使用绘制占位；寒冰新星和闪电链会按非循环动画时长保留特效节点；已新增各 `_frames/` 目录 README。

- `G1-0022` 为当前占位美术补齐工程接入口。
  - 主责：engineering-agent
  - 状态：已完成
  - 验收：新增 `VisualAsset` 可选图片 / 帧序列加载辅助；玩家、三类怪物、XP shard 和三基础技能特效支持 `_frames/` 帧序列优先、单张 PNG fallback、缺图则回退占位；三类怪物动画路径进入 `EnemyDef.animation_dir` / `animation_fps` / `sprite_path`，技能 VFX 路径进入 `SkillDef.vfx_frames_dir` / `vfx_fps` / `vfx_loop` / `vfx_path`；已新增运行时资源目录 README 和 `visual_asset_smoke_test.gd`。

- `G1-0021` 设置 1280x720 横屏基准并检查当前美术资源缩放。
  - 主责：engineering-agent
  - 状态：已完成
  - 验收：Godot 项目已设置 `1280x720`、`canvas_items`、`expand`；HUD 改为左上角锚定，升级奖励面板改为中心锚定；已确认当前三张元素图标均为 `512x512` PNG，并以 `TextureRect` 等比缩放到 HUD 逻辑尺寸；已新增 `display_layout_smoke_test.gd` 自动验证显示设置、UI 锚点和图标尺寸。

- `G1-0020` 补充 Prototype 0.1 按键功能实测和自动化验证。
  - 主责：engineering-agent
  - 状态：已完成
  - 验收：已用 Computer Use 实测奖励暂停阻止移动、恢复战斗后 WASD / 方向键可移动并继续触发 XP / 升级；已新增 `godotGame/tests/input_actions_smoke_test.gd`，自动验证 WASD / 方向键输入映射和暂停态移动阻断。

- `G1-0019` 实现 Godot Prototype 0.1 核心循环。
  - 主责：engineering-agent
  - 状态：已完成
  - 验收：Godot 4.6.2 已通过 arm64 Homebrew 安装；已在 `godotGame/` 创建 Godot 工程、主场景、核心 autoload、集中数据资源、玩家移动、刷怪、三基础技能、XP 拾取、升级暂停和 3 选 1 奖励；已添加 headless smoke tests；缺失美术资源已记录到 `docs/engineering/implementation-status.md`。

- `G1-0018` 增强 engineering agent 工程实现规则。
  - 主责：engineering-agent
  - 状态：已完成
  - 验收：engineering agent 已新增严格遵守架构、代码库简洁文档、代码注释、架构不适配时先讨论、缺失美术资源占位和记录、维护 `docs/engineering/implementation-status.md` 的规则；已创建 implementation status 初始文档。

- `G1-0017` 生成 Godot 原型程序架构文档与示意图。
  - 主责：engineering-agent
  - 状态：已完成
  - 验收：新增 `docs/engineering/godot-prototype-architecture.md`，包含 Godot 目录、场景结构、核心系统、数据资源、资源接入原则、架构待定接口、模块边界、single source of truth 规则和 Mermaid 架构图；未创建 Godot 工程目录或代码。

- `G1-0016` 完善 engineering agent 通用工程规范。
  - 主责：engineering-agent
  - 状态：已完成
  - 验收：engineering agent 不绑定某个固定原型协议，明确 Godot 项目结构、GDScript 风格、数据配置、资源接入、验证、Git 和交接规范；已新增 `docs/engineering/godot-prototype-architecture.md` 作为 Godot 原型程序架构文档。

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
