# Implementation Status

最后更新：2026-04-26

本文件是 Godot 工程实现状态入口。它只记录工程实现进度，不替代 `docs/design/current-design.md`、`docs/engineering/godot-prototype-architecture.md` 或 `docs/agent/task-board.md`。

## 状态规则

- 保持简洁，只记录后续 engineering agent 开工必须知道的信息。
- 每次工程实现后更新。
- 当前实现必须说明基于哪个设计文档版本和架构文档版本。
- 占位美术资源必须记录用途、期望位置、格式 / 尺寸 / 帧数和当前占位方式。
- 如果实现无法合理 fit 进当前架构，先记录到“架构偏离 / 待讨论”，再和用户讨论是否更新架构。

## 当前实现目标

`Prototype 0.1`：跑通 2D top-down 核心循环，包括玩家移动、敌人刷出与追踪、三基础元素自动技能、XP 拾取、升级暂停、3 选 1 奖励、获得元素奖励和最小合成链路。

## 基准文档

- 当前设计：`docs/design/current-design.md`，最后更新 `2026-04-25`。
- 当前架构：`docs/engineering/godot-prototype-architecture.md`，最后更新 `2026-04-25`。
- Godot 工程根目录：`godotGame/`。

## 已完成实现

- 已创建 Godot 4 工程：`godotGame/project.godot`。
- 已设置 1280x720 横屏基准画布：`display/window/size/viewport_width=1280`、`display/window/size/viewport_height=720`、`display/window/stretch/mode=canvas_items`、`display/window/stretch/aspect=expand`。
- 已实现浅灰色无限重复地面背景：`GameWorld` 会围绕当前相机 / 玩家位置绘制中浅灰底和重复网格，避免玩家移动后露出固定背景边界，并避免接近白色的背景过于刺眼。
- 已创建主场景：`godotGame/scenes/main/main.tscn`。
- 已实现核心 autoload：`RunState`、`GameEvents`、`ContentRegistry / DefLoader`、`DamageSystem`。
- 已实现 `GameWorld`，包含玩家、敌人层、投射物层、拾取物层、VFX 层和运行时系统组合。
- 已实现玩家 WASD / 方向键移动。
- 已实现连续刷怪、普通追踪怪、小型快怪、厚血怪。
- 已实现敌人追踪、接触伤害、死亡掉落 XP。
- 已实现 XP shard 拾取和升级暂停。
- 已实现 3 选 1 奖励界面，当前奖励包含火 / 冰 / 雷元素强化和火 / 冰 / 雷元素获得。
- 已实现最小元素合成链路：3 级后可在元素 / 合成面板中手动选择 3 个火元素，消耗它们并加入一个陨石元素 / 技能实例 `meteor_fire`。
- 已新增 `SynthesisService` 和 `resources/synthesis/recipe_meteor_fire.tres`；合成配方来自 `SynthesisRecipeDef` 资源，不写死在 UI 或技能脚本里。
- 同一配方允许重复合成；`RunState.synthesized_skill_ids` 按实例保存同名高级元素，激活槽按拥有实例数量限制，而不是按技能 ID 去重。`SkillController` 按激活槽维护冷却，重复激活的同名技能会作为多个技能实例释放。
- 同名范围技能多实例释放时会做可见性处理：重复技能槽的初始冷却错开，范围落点按槽位做小幅散布，避免 3 个陨石完全同帧同点重叠成一个特效。
- 已将合成解锁等级放入 `BalanceConfig.synthesis_unlock_level`，当前值为 `3`。
- 已新增陨石技能定义 `resources/skills/skill_meteor_fire.tres`；技能释放、伤害和 VFX 接入口继续走 `SkillDef`、`DamageSystem` 和 `SkillController`。
- HUD 已改为显示最多 3 个当前激活元素 / 技能槽；火火火合成后，陨石会替换基础火技能小火球。
- HUD 会另外显示冰 / 火 / 雷的当前等级和激活元素拆算数量，例如火火火陨石按火 x3 统计；HUD 不再显示拥有数量。
- 已新增最小元素 / 合成面板：类似背包格子显示每个已拥有元素，前三格高亮表示当前激活元素；3 个合成框支持“选框后点元素”放入材料，并可手动执行合成。
- 合成面板已适配 debug 初始 27 个基础元素：背包格子区域固定高度并可滚动，激活技能选择按技能类型去重显示，面板固定在 1280x720 画布内，避免底部合成按钮溢出窗口。
- HUD 已锚定左上角；升级奖励面板已锚定画布中心，适配电脑、平板和手机横屏窗口缩放。
- 已实现三基础自动技能：小火球、寒冰新星、小闪电。
- 已新增运行时美术接入辅助：`VisualAsset` 会从 `godotGame/assets/` 加载可选图片资源；缺失时返回 `null`，由对应脚本绘制占位符。
- 玩家、三类怪物、XP shard 和基础技能特效已预留帧序列动画接入口：优先加载 `_frames/` 目录下按文件名排序的 PNG 帧；缺少帧序列时加载单张 PNG；都缺失时继续使用当前占位绘制。
- 已将玩家和三类怪物的横向 spritesheet 裁切为 4 帧透明 PNG 序列并接入运行时：`player_idle_frames/`、`enemy_chaser_frames/`、`enemy_fast_frames/`、`enemy_tank_frames/`。
- 已接入三基础技能特效 6 帧透明 PNG 序列：火球 `64x64 x6`、寒冰新星 `192x192 x6`、小闪电连锁段 `256x96 x6`；`vfx_fps` 沿用现有配置，未改播放速度。
- 已接入火火火陨石高级技能图标 `512x512` 透明 PNG，并将 `skill_meteor_fire.tres.icon_path` 指向 `godotGame/assets/art/icons/skills/icon_skill_meteor_fire_512.png`。
- 已接入火火火陨石两段式表现：先播放 `meteor_fire_fall_frames/` 6 帧透明 PNG 下落段，再在落点播放 `meteor_fire_frames/` 8 帧透明 PNG 爆炸段。
- 陨石下落段按素材方向从目标左上方斜向落到目标点，`skill_meteor_fire.tres.cast_intro_start_offset = Vector2(-260, -320)`；伤害在爆炸开始时结算，不在下落开始时结算。
- 三类怪物的 `animation_dir`、`animation_fps`、`sprite_path` 已写入 `EnemyDef`，技能 VFX 的 `vfx_frames_dir`、`vfx_fps`、`vfx_loop`、`vfx_path` 已写入 `SkillDef`，避免在多个模块重复维护资源路径。
- 寒冰新星和闪电链的非循环帧序列会按帧数 / FPS 自动延长特效存在时间，避免动画未播完就被销毁。
- 角色和怪物的视觉尺寸已和碰撞半径解耦：玩家显示约 `108` world units；普通怪约 `84`；快怪约 `69`；厚血怪约 `108`。碰撞 / 接触逻辑仍使用当前半径，不随图片显示尺寸自动变大。
- 已通过实际 Godot 窗口测试修复玩家显示在视口左上角的问题；当前玩家由 `Camera2D` 居中跟随。
- 已新增 debug-only 1 血锁定模式：`DebugSettings` 只在 Godot debug build 中读取 `debug/game/lock_player_health_to_one=true`，用于测试时防止玩家死亡。
- 已新增 debug-only 初始库存和开局解锁合成模式：`DebugSettings` 只在 Godot debug build 中读取 `debug/game/initial_basic_element_count=9` 和 `debug/game/unlock_synthesis_from_start=true`，用于开局给火 / 冰 / 雷各 9 个基础元素并直接打开合成面板测试。
- 已将已确认的火 / 冰 / 雷元素图标复制到 Godot 运行时 `godotGame/assets/art/icons/elements/`。
- 2026-04-25 美术资源盘点确认：当前可以直接作为运行时资源使用的生成资产只有三基础元素图标。`skills/elemental-art-assets/assets/game-ready/source-frames/` 下的技能图标 / VFX 是 chroma-key RGB 源帧，不是最终透明 PNG 帧序列，不能直接从 Godot 引用。
- 已添加 headless smoke tests：`godotGame/tests/smoke_test.gd`、`godotGame/tests/core_loop_smoke_test.gd`、`godotGame/tests/input_actions_smoke_test.gd`、`godotGame/tests/display_layout_smoke_test.gd`、`godotGame/tests/visual_asset_smoke_test.gd`。

## 未完成实现

- 竖屏 UI 和触屏虚拟摇杆尚未实现；当前显示目标是 1280x720 横屏。
- 完整合成 UI 尚未实现；当前只有最小背包式合成面板、火火火 -> 陨石链路、同名技能重复激活和基础激活槽替换。
- 符文系统尚未实现；当前只保留未来 `RuneDef` / 等价数据源位置。
- 高级技能、紫色品质、橙色品质尚未实现。
- 3 选 1 奖励池当前已有元素强化和获得元素，尚未包含符文、合成决策、奖励权重和稀有度控制。
- 玩家死亡、失败结算、重新开始流程尚未实现。
- 当前 debug 模式会将玩家生命锁到 1，让开局拥有火 / 冰 / 雷各 9 个基础元素，并开局解锁合成面板；正式死亡暂停和重开流程仍未实现。
- XP shard、升级 UI 和除火火火陨石外的后续高级技能正式美术尚未接入。

## 资源占位清单

- 资源：XP shard
  - 用途：怪物死亡掉落经验晶体。
  - 期望路径：优先 `godotGame/assets/art/sprites/pickups/xp_shard_frames/frame_000.png` 等帧序列；fallback 为 `godotGame/assets/art/sprites/pickups/xp_shard.png`。
  - 格式与尺寸：PNG，建议 `48x48`，透明背景。
  - 动画 / 帧数：建议 `4-8` 帧，`8 FPS`，循环。
  - 当前占位方式：帧序列存在时自动加载为 `AnimatedSprite2D`；单张图存在时加载为 `Sprite2D`；文件缺失时脚本中绘制青色小圆形。
  - 需要 art agent：是。

- 资源：升级奖励 UI 面板
  - 用途：升级时 3 选 1 奖励背景和按钮视觉。
  - 期望路径：`godotGame/assets/art/ui/level_up_panel.png`
  - 格式与尺寸：PNG 或 Godot theme 资源，建议面板基准 `420x320`。
  - 动画 / 帧数：无。
  - 当前占位方式：Godot 默认 `PanelContainer` 和 `Button`。
  - 需要 art agent：是。

## 架构偏离 / 待讨论

暂无。

## 实测记录

- 2026-04-25：使用 Computer Use 启动 `godotGame` 主场景，确认 HUD、三元素图标、敌人刷出、技能占位效果和接触伤害可见。
- 2026-04-25：开启 debug 1 血锁定后，玩家被怪物攻击到 `1 / 100` 后不再死亡，可继续测试。
- 2026-04-25：拾取 XP 后成功升到 2 级，升级奖励界面出现；点击奖励后战斗恢复，HUD 中对应元素等级更新为 Lv.2。
- 2026-04-25：使用 Computer Use 补测按键功能。奖励暂停界面中移动输入不会移动角色；恢复战斗后，WASD 和方向键均可驱动玩家移动，并能继续触发 XP 拾取和升级流程。
- 2026-04-25：新增并通过 `input_actions_smoke_test.gd`，自动验证 `WASD` / 方向键映射到 `move_left`、`move_right`、`move_up`、`move_down`，并验证升级暂停会阻止移动。
- 2026-04-25：设置 1280x720 横屏基准和 `canvas_items + expand` 拉伸策略；HUD 改为左上角锚定，升级奖励面板改为中心锚定。
- 2026-04-25：检查当前运行时美术资源。火 / 冰 / 雷元素图标均为 `512x512` PNG，作为 HUD `34x34` 逻辑尺寸图标源图足够，并通过 `TextureRect.STRETCH_KEEP_ASPECT_CENTERED` 等比缩放；角色、敌人、投射物、VFX、UI 面板仍是占位资源，尺寸需求见资源占位清单。
- 2026-04-25：新增并通过 `display_layout_smoke_test.gd`，自动验证 1280x720 横屏设置、UI 锚点、元素图标尺寸和 HUD 图标等比缩放模式。
- 2026-04-25：新增 `VisualAsset` 可选图片 / 帧序列加载辅助，玩家、三类怪物、XP shard 和基础技能特效已支持“帧序列目录优先、单张 PNG fallback、缺图则回退占位”；三类怪物路径由 `EnemyDef` 统一维护，基础技能 VFX 路径由 `SkillDef` 统一维护。
- 2026-04-25：新增并通过 `visual_asset_smoke_test.gd`，自动验证已有图片可加载、PNG 帧序列可加载、缺失图片不报错、配置路径有效、玩家缺图时使用 fallback。
- 2026-04-25：以 art-agent 视角盘点生成资产：`godotGame/assets/art/icons/elements/` 中三基础元素图标是已接入资源；`skills/elemental-art-assets/assets/game-ready/source-frames/` 中的火球、寒冰新星、小闪电、陨石、冰锥、三元素能量场候选仍是 chroma-key RGB 源帧，需要 art-agent 后处理和用户确认后再交给 engineering-agent 接入。
- 2026-04-25：补齐帧序列动画播放：`VisualAsset` 可从 `_frames/` 目录创建 `AnimatedSprite2D`；玩家、怪物、XP shard、火球、寒冰新星、闪电链均优先播放帧序列，缺失时继续 fallback；新增各 `_frames/` 目录 README 作为 art agent 交付入口。
- 2026-04-25：生成并接入三基础技能特效 6 帧透明 PNG 序列：火球、寒冰新星、小闪电连锁段；`visual_asset_smoke_test.gd` 已验证 3 套 VFX 帧序列数量、尺寸和配置路径；`vfx_fps` 保持原配置不变。
- 2026-04-25：将已生成的一整张玩家 / 怪物 spritesheet 裁切为运行时帧序列：玩家 `128x128 x4`，普通追踪怪 `96x96 x4`，小型快怪 `80x80 x4`，厚血怪 `128x128 x4`；`visual_asset_smoke_test.gd` 已验证 4 套帧序列尺寸、数量和玩家运行时动画加载。
- 2026-04-25：修正玩家和怪物美术显示过小的问题：确认源图尺寸正常，过小来自运行时按碰撞半径 `RADIUS * 2 = 36` 缩放；已按用户反馈进一步放大为玩家 `108`、普通怪 `84`、快怪 `69`、厚血怪 `108` world units，碰撞 / 接触判定保持原逻辑。
- 2026-04-25：将战斗背景改为接近白色的浅灰无限重复地面；背景围绕玩家位置动态绘制，避免相机移动后出现固定区域边界。
- 2026-04-25：根据实测反馈将背景从接近白色调整为中浅灰；当前角色 / 怪物资源本身为深色主体，游戏内缩放后暗部细节会压缩在一起，后续若仍显得黑，应优先让 art agent 提高轮廓亮边、局部高光和中间调对比，而不是只继续放大运行时尺寸。
- 2026-04-25：加入获得元素奖励和最小合成链路。奖励池新增获得火 / 冰 / 雷元素；`BalanceConfig.synthesis_unlock_level=3` 后，可在元素 / 合成面板中手动把 3 个火元素合成为 `meteor_fire` 陨石技能；新增 `synthesis_smoke_test.gd` 覆盖奖励池、3 级门槛、手动合成、火元素消耗和运行技能列表刷新。
- 2026-04-25：根据设计澄清重做 HUD 和激活技能模型。`RunState.active_skill_ids` 是最多 3 个当前激活技能的唯一来源；`SkillController` 只释放这些激活技能；HUD 第一行显示激活技能图标，第二行显示火 / 冰 / 雷等级和按激活技能组成拆算的数量。
- 2026-04-25：根据用户反馈加入最小元素 / 合成面板，并取消获得 3 火后的自动合成。HUD 和面板都显示拥有数量与激活数量；面板打开时暂停战斗，允许查看库存、替换激活槽、选择 3 个元素并手动合成。
- 2026-04-25：使用 imagegen 子代理生成火火火陨石高级技能图标、陨石下落段和陨石落点爆炸源图；主线程完成去背、裁切、缩放和接入。陨石图标已接入 `SkillDef.icon_path`；落点爆炸 8 帧已接入现有 `vfx_frames_dir`；下落段 6 帧已暂存等待后续运行时代码接入。
- 2026-04-25：接入陨石下落段运行时代码。新增 `meteor_strike_effect.gd`，陨石技能配置 `cast_intro_frames_dir` 后走两段式效果：从目标左上方斜线落下，落地时播放爆炸帧并结算范围伤害；普通范围技能仍走原 `AreaEffect`。新增并通过 `meteor_strike_smoke_test.gd`。
- 2026-04-25：新增 debug 初始库存模式。后续已改为 `debug/game/initial_basic_element_count=9`；debug build 中 `RunState.reset_run()` 会让火 / 冰 / 雷各 9 个，便于一开局打开元素 / 合成面板测试多次技能合成；`synthesis_smoke_test.gd` 已覆盖该初始库存。
- 2026-04-26：按用户反馈调整 HUD 和合成面板。HUD 不再显示拥有数量，只显示基础元素等级和激活数量；合成面板改为背包格子，前三格高亮当前激活元素，3 个合成框通过“选框后点元素”填充材料。正式版合成按钮 3 级前黑色不可点击，debug build 通过 `debug/game/unlock_synthesis_from_start=true` 开局解锁。
- 2026-04-26：修正重复技能实例规则。基础元素和合成元素都按拥有实例数提供可激活技能；3 个冰元素可同时激活 3 个寒冰新星，重复合成火火火可拥有多个 `meteor_fire`，激活槽最多只能使用已拥有数量。合成会在消耗元素后修复已经失去库存支撑的激活槽；技能冷却按槽位记录，避免同名技能共享一个冷却计时。
- 2026-04-26：修正 9×3 debug 库存下的合成面板溢出。背包区改为滚动区域，激活选择去掉同名重复按钮，`display_layout_smoke_test.gd` 已覆盖面板在 1280x720 内可见且背包显示 27 个初始元素。
- 2026-04-26：修正重复陨石视觉重叠。`SkillController` 对重复技能槽加入初始冷却 stagger，并让重复范围技能在目标点附近做确定性散布；新增 `duplicate_skill_visual_smoke_test.gd` 验证 3 个陨石槽会错时生成且落点不完全重叠。
