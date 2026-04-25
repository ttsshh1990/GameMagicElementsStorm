# Implementation Status

最后更新：2026-04-25

本文件是 Godot 工程实现状态入口。它只记录工程实现进度，不替代 `docs/design/current-design.md`、`docs/engineering/godot-prototype-architecture.md` 或 `docs/agent/task-board.md`。

## 状态规则

- 保持简洁，只记录后续 engineering agent 开工必须知道的信息。
- 每次工程实现后更新。
- 当前实现必须说明基于哪个设计文档版本和架构文档版本。
- 占位美术资源必须记录用途、期望位置、格式 / 尺寸 / 帧数和当前占位方式。
- 如果实现无法合理 fit 进当前架构，先记录到“架构偏离 / 待讨论”，再和用户讨论是否更新架构。

## 当前实现目标

`Prototype 0.1`：跑通 2D top-down 核心循环，包括玩家移动、敌人刷出与追踪、三基础元素自动技能、XP 拾取、升级暂停和 3 选 1 奖励。

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
- 已实现 3 选 1 奖励界面，当前奖励为火 / 冰 / 雷元素强化。
- HUD 已锚定左上角；升级奖励面板已锚定画布中心，适配电脑、平板和手机横屏窗口缩放。
- 已实现三基础自动技能：小火球、寒冰新星、小闪电。
- 已新增运行时美术接入辅助：`VisualAsset` 会从 `godotGame/assets/` 加载可选图片资源；缺失时返回 `null`，由对应脚本绘制占位符。
- 玩家、三类怪物、XP shard 和基础技能特效已预留帧序列动画接入口：优先加载 `_frames/` 目录下按文件名排序的 PNG 帧；缺少帧序列时加载单张 PNG；都缺失时继续使用当前占位绘制。
- 已将玩家和三类怪物的横向 spritesheet 裁切为 4 帧透明 PNG 序列并接入运行时：`player_idle_frames/`、`enemy_chaser_frames/`、`enemy_fast_frames/`、`enemy_tank_frames/`。
- 三类怪物的 `animation_dir`、`animation_fps`、`sprite_path` 已写入 `EnemyDef`，技能 VFX 的 `vfx_frames_dir`、`vfx_fps`、`vfx_loop`、`vfx_path` 已写入 `SkillDef`，避免在多个模块重复维护资源路径。
- 寒冰新星和闪电链的非循环帧序列会按帧数 / FPS 自动延长特效存在时间，避免动画未播完就被销毁。
- 角色和怪物的视觉尺寸已和碰撞半径解耦：玩家显示约 `108` world units；普通怪约 `84`；快怪约 `69`；厚血怪约 `108`。碰撞 / 接触逻辑仍使用当前半径，不随图片显示尺寸自动变大。
- 已通过实际 Godot 窗口测试修复玩家显示在视口左上角的问题；当前玩家由 `Camera2D` 居中跟随。
- 已新增 debug-only 1 血锁定模式：`DebugSettings` 只在 Godot debug build 中读取 `debug/game/lock_player_health_to_one=true`，用于测试时防止玩家死亡。
- 已将已确认的火 / 冰 / 雷元素图标复制到 Godot 运行时 `godotGame/assets/art/icons/elements/`。
- 2026-04-25 美术资源盘点确认：当前可以直接作为运行时资源使用的生成资产只有三基础元素图标。`skills/elemental-art-assets/assets/game-ready/source-frames/` 下的技能图标 / VFX 是 chroma-key RGB 源帧，不是最终透明 PNG 帧序列，不能直接从 Godot 引用。
- 已添加 headless smoke tests：`godotGame/tests/smoke_test.gd`、`godotGame/tests/core_loop_smoke_test.gd`、`godotGame/tests/input_actions_smoke_test.gd`、`godotGame/tests/display_layout_smoke_test.gd`、`godotGame/tests/visual_asset_smoke_test.gd`。

## 未完成实现

- 竖屏 UI 和触屏虚拟摇杆尚未实现；当前显示目标是 1280x720 横屏。
- 完整合成 UI 尚未实现；当前只保留架构位置。
- 符文系统尚未实现；当前只保留未来 `RuneDef` / 等价数据源位置。
- 高级技能、紫色品质、橙色品质尚未实现。
- 3 选 1 奖励池当前只有元素强化，尚未包含新元素、符文或合成决策。
- 玩家死亡、失败结算、重新开始流程尚未实现。
- 当前 debug 模式会将玩家生命锁到 1；正式死亡暂停和重开流程仍未实现。
- 投射物、技能 VFX、XP shard 和 UI 面板正式美术尚未接入。

## 资源占位清单

- 资源：火球 projectile
  - 用途：火元素基础攻击弹道。
  - 期望路径：优先 `godotGame/assets/art/vfx/projectiles/fireball_frames/frame_000.png` 等帧序列；fallback 为 `godotGame/assets/art/vfx/projectiles/fireball.png`。
  - 格式与尺寸：PNG，建议 `64x64`，透明背景。
  - 动画 / 帧数：建议 `4-8` 帧，`12 FPS`，循环。
  - 当前占位方式：路径由 `SkillDef.vfx_frames_dir` / `SkillDef.vfx_path` 提供；帧序列存在时自动加载为 `AnimatedSprite2D`；单张图存在时加载为 `Sprite2D`；文件缺失时脚本中绘制橙黄色圆形。
  - 需要 art agent：是。

- 资源：寒冰新星 VFX
  - 用途：冰元素基础攻击范围爆发。
  - 期望路径：优先 `godotGame/assets/art/vfx/areas/ice_nova_frames/frame_000.png` 等帧序列；legacy fallback 为 `godotGame/assets/art/vfx/areas/ice_nova_sheet.png`。
  - 格式与尺寸：PNG 帧序列，建议单帧 `192x192`，透明背景。
  - 动画 / 帧数：建议 `6` 帧，`12 FPS`，不循环。
  - 当前占位方式：路径由 `SkillDef.vfx_frames_dir` / `SkillDef.vfx_path` 提供；帧序列存在时自动加载为 `AnimatedSprite2D`；缺失时脚本中绘制浅蓝圆形和圆环。
  - 需要 art agent：是。

- 资源：小闪电 VFX
  - 用途：雷元素基础攻击连锁效果。
  - 期望路径：优先 `godotGame/assets/art/vfx/beams/lightning_chain_frames/frame_000.png` 等帧序列；legacy fallback 为 `godotGame/assets/art/vfx/beams/lightning_chain_sheet.png`。
  - 格式与尺寸：PNG 帧序列，建议单帧 `256x96`，透明背景。
  - 动画 / 帧数：建议 `4` 帧，`16 FPS`，不循环。
  - 当前占位方式：路径由 `SkillDef.vfx_frames_dir` / `SkillDef.vfx_path` 提供；帧序列存在时每段连锁生成一个 `AnimatedSprite2D` 并旋转到连线路径；缺失时脚本中绘制黄紫色线段。
  - 需要 art agent：是。

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
- 2026-04-25：将已生成的一整张玩家 / 怪物 spritesheet 裁切为运行时帧序列：玩家 `128x128 x4`，普通追踪怪 `96x96 x4`，小型快怪 `80x80 x4`，厚血怪 `128x128 x4`；`visual_asset_smoke_test.gd` 已验证 4 套帧序列尺寸、数量和玩家运行时动画加载。
- 2026-04-25：修正玩家和怪物美术显示过小的问题：确认源图尺寸正常，过小来自运行时按碰撞半径 `RADIUS * 2 = 36` 缩放；已按用户反馈进一步放大为玩家 `108`、普通怪 `84`、快怪 `69`、厚血怪 `108` world units，碰撞 / 接触判定保持原逻辑。
- 2026-04-25：将战斗背景改为接近白色的浅灰无限重复地面；背景围绕玩家位置动态绘制，避免相机移动后出现固定区域边界。
- 2026-04-25：根据实测反馈将背景从接近白色调整为中浅灰；当前角色 / 怪物资源本身为深色主体，游戏内缩放后暗部细节会压缩在一起，后续若仍显得黑，应优先让 art agent 提高轮廓亮边、局部高光和中间调对比，而不是只继续放大运行时尺寸。
