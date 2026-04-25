# Task Board

任务 ID 使用 `G1-0001` 格式。任务状态以本文件为准。

## Now

- `G1-0011` 重做第一批元素美术资源，使其贴合已确认样图风格。
  - 主责：art-agent
  - 状态：待用户确认与后处理
  - 验收：已删除上一版候选；当前三基础元素图标、三基础技能 VFX、火火火陨石技能图标、陨石斜向下落段和陨石落点爆炸 VFX 已确认并已接入 Godot。`skills/elemental-art-assets/assets/game-ready/source-frames/` 中剩余旧 chroma-key RGB 源帧仍需用户确认风格，并完成去背、缩放、最终透明 PNG 帧序列、manifest 和 Godot 目标路径整理后，才能作为正式运行时资源接入。

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

- `G1-0038` 修正重复陨石完全重叠。
  - 主责：engineering-agent
  - 状态：已完成
  - 验收：3 个陨石激活槽不再同帧同点释放；重复技能槽位有初始冷却错开，重复范围技能落点有小幅确定性散布；`duplicate_skill_visual_smoke_test.gd` 已覆盖。

- `G1-0036` 支持同名技能重复激活和重复合成实例。
  - 主责：engineering-agent
  - 状态：已完成
  - 验收：基础元素和合成元素都按拥有实例数提供可激活技能；3 个冰元素可同时激活 3 个寒冰新星；重复火火火合成可获得多个 `meteor_fire` 实例；激活槽最多只能使用已拥有数量；`synthesis_smoke_test.gd` 已覆盖。

- `G1-0037` 测试模式初始基础元素数量改为每种 9 个。
  - 主责：engineering-agent
  - 状态：已完成
  - 验收：新增 debug-only 数量设置 `debug/game/initial_basic_element_count=9`；debug build 中 `RunState.reset_run()` 初始库存为火 / 冰 / 雷各 9 个，激活槽仍保持小火球、寒冰新星、小闪电；`synthesis_smoke_test.gd` 已覆盖该初始库存。

- `G1-0035` 调整 HUD 和背包式合成面板。
  - 主责：engineering-agent
  - 状态：已完成
  - 验收：HUD 只显示冰 / 火 / 雷等级和激活数量，不再显示拥有数量；合成按钮正式逻辑为 3 级前黑色不可点击，debug build 开局解锁；合成面板改为背包格子，前三格高亮当前激活元素，3 个合成框支持选框后点击元素放入材料；`display_layout_smoke_test.gd` 和 `synthesis_smoke_test.gd` 已覆盖。

- `G1-0034` 测试模式开局给三基础元素各 3 个。
  - 主责：engineering-agent
  - 状态：已完成
  - 验收：历史任务，后续已由 `G1-0037` 改为可配置数量 `debug/game/initial_basic_element_count=9`。

- `G1-0033` 接入火火火陨石斜向下落段。
  - 主责：engineering-agent
  - 状态：已完成
  - 验收：新增 `meteor_strike_effect.gd`，`meteor_fire` 现在先从目标左上方斜向落下，再播放落点爆炸并结算伤害；下落资源来自 `meteor_fire_fall_frames/`，爆炸资源继续来自 `meteor_fire_frames/`；普通范围技能仍走原 `AreaEffect`；已新增并通过 `meteor_strike_smoke_test.gd`。

- `G1-0032` 生成并接入火火火陨石技能图标和 VFX 素材。
  - 主责：art-agent / engineering-agent
  - 状态：已完成
  - 验收：按 art-agent 的 imagegen 子代理隔离流程生成源图；已输出并接入 `icon_skill_meteor_fire_512.png`，`skill_meteor_fire.tres.icon_path` 已改用该图标；已输出并接入陨石落点爆炸 `256x256 x8` 透明 PNG 帧序列到 `meteor_fire_frames/`；已输出陨石下落段 `192x192 x6` 透明 PNG 帧序列到 `meteor_fire_fall_frames/`；后续 `G1-0033` 已完成两段式运行时代码接入。

- `G1-0030` 更新 art-agent 的 imagegen 子代理隔离流程。
  - 主责：art-agent
  - 状态：已完成
  - 验收：`agents/art-agent.md` 已规定后续生产资源或候选 bitmap 资源生成时，主线程只负责 prompt 与资源规格设计，实际 `imagegen` 调用交给独立 sub-agent；`skills/elemental-art-assets/SKILL.md` 已同步该约束，避免 art skill 与 agent 流程冲突。

- `G1-0031` 加入最小元素 / 合成面板并取消自动合成。
  - 主责：engineering-agent
  - 状态：已完成
  - 验收：获得元素只增加库存，不自动合成；HUD 显示火 / 冰 / 雷等级、拥有数量和激活数量；元素 / 合成面板可显示库存和激活标记，打开时暂停战斗，可替换选中的激活槽，可选择 3 个基础元素手动合成；`synthesis_smoke_test.gd` 覆盖 3 火不自动合成和手动火火火 -> 陨石。

- `G1-0029` 修正 HUD 和激活技能槽模型。
  - 主责：engineering-agent
  - 状态：已完成
  - 验收：新增 `RunState.active_skill_ids` 作为最多 3 个当前激活技能的来源；`SkillController` 只释放激活技能；HUD 第一行显示 3 个激活技能图标，第二行显示火 / 冰 / 雷等级和按激活技能组成拆算的数量；火火火合成后陨石替换小火球；`synthesis_smoke_test.gd` 和 `display_layout_smoke_test.gd` 已覆盖。

- `G1-0028` 生成并接入三基础技能特效帧序列。
  - 主责：art-agent / engineering-agent
  - 状态：已完成
  - 验收：已生成火球、寒冰新星、小闪电连锁段三套 6 帧透明 PNG 序列，并分别接入 `fireball_frames/`、`ice_nova_frames/`、`lightning_chain_frames/`；保持现有 `vfx_fps` 配置不变；`visual_asset_smoke_test.gd` 已验证帧数量、尺寸和配置路径，核心 smoke tests 已通过。

- `G1-0027` 加入获得元素奖励和火火火陨石合成。
  - 主责：engineering-agent
  - 状态：已完成
  - 验收：奖励池新增获得火 / 冰 / 雷元素；`BalanceConfig.synthesis_unlock_level=3` 后，3 个火元素可通过 `SynthesisService` 合成为 `meteor_fire` 陨石技能；合成消耗 3 个火元素，保留其他元素；技能列表刷新为陨石、寒冰新星、小闪电；后续 `G1-0031` 已将触发方式改为手动面板合成。

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
