if not(GetLocale() == "zhCN") then
    return;
end

local L = WeakAuras.L

-- Options translation
-- L[""] = ""
L["1 Match"] = "1符合"
L["A 20x20 pixels icon"] = "一个20x20像素图标"
L["A 32x32 pixels icon"] = "一个32x32像素图标"
L["A 40x40 pixels icon"] = "一个40x40像素图标"
L["A 48x48 pixels icon"] = "一个48x48像素图标"
L["A 64x64 pixels icon"] = "一个64x64像素图标"
L["Actions"] = "动作"
L["Activate when the given aura(s) |cFFFF0000can't|r be found"] = "当指定光环 |cFFFF0000无法|r找到时启动"
L["Addons"] = "插件"
L["Add to new Dynamic Group"] = "新增动态群组"
L["Add to new Group"] = "新增群组"
L["Add Trigger"] = "新增触发器"
L["A group that dynamically controls the positioning of its children"] = "一个可以动态控制子元素的位置的群组"
L["Align"] = "对齐"
L["Allow Full Rotation"] = "允许完全旋转"
L["Alpha"] = "透明度"
L["Anchor"] = "锚点"
L["Anchor Point"] = "锚点指向"
L["Angle"] = "角度"
L["Animate"] = "动画"
L["Animated Expand and Collapse"] = "动态展开和折叠"
L["Animation relative duration description"] = [=[动画的相对持续时间，表示为 分数(1/2)，百分比(50％)，或数字(0.5)。
|cFFFF0000注意：|r 如果没有进度(没有时间事件的触发器,没有持续时间的光环,或其他)，动画将不会播放。
|cFF4444FF举例：|r
如果动画的持续时间设定为 |cFF00CC0010%|r，然后触发的增益时间为20秒，入场动画会播放2秒。
如果动画的持续时间设定为 |cFF00CC0010%|r，然后触发的增益没有持续时间，将不会播放开始动画.]=]
L["Animations"] = "动画"
L["Animation Sequence"] = "动画序列"
L["Apply Template"] = "应用模板"
L["Arcane Orb"] = "奥术宝珠" -- Needs review
-- L["At a position a bit left of Left HUD position."] = ""
-- L["At a position a bit left of Right HUD position"] = ""
L["At the same position as Blizzard's spell alert"] = "跟暴雪的法术警报在同一位置"
L["Aura Name"] = "光环名称" -- Needs review
L["Aura(s)"] = "光环"
L["Aura Type"] = "光环类型" -- Needs review
L["Auto"] = "自动"
L["Automatic Icon"] = "自动显示图标"
L["Backdrop Color"] = "背景颜色"
L["Backdrop Style"] = "背景图案类型 "
L["Background"] = "背景"
L["Background Color"] = "背景色"
L["Background Inset"] = "背景内嵌"
L["Background Offset"] = "背景偏移"
L["Background Texture"] = "背景材质"
L["Bar Alpha"] = "条透明度"
L["Bar Color"] = "条颜色"
L["Bar Color Settings"] = "图标条颜色设置"
L["Bar in Front"] = "条材质前置"
L["Bar Texture"] = "条材质"
L["Big Icon"] = "大图标" -- Needs review
L["Blend Mode"] = "混合模式"
L["Blue Rune"] = "蓝色符文" -- Needs review
L["Blue Sparkle Orb"] = "蓝色闪光球" -- Needs review
L["Border"] = "边框"
L["Border Color"] = "边框颜色"
L["Border Inset"] = "插入边框"
L["Border Offset"] = "边框偏移"
L["Border Settings"] = "边框设置"
L["Border Size"] = "边框大小 "
L["Border Style"] = "边框风格"
L["Bottom Text"] = "底部文字"
L["Button Glow"] = "按钮发光"
L["Can be a name or a UID (e.g., party1). Only works on friendly players in your group."] = "可以是名字或是单位ID(例如，party1)。只作用于你当前队伍/团队中的玩家."
L["Cancel"] = "取消"
L["Channel Number"] = "频道索引"
L["Chat Message"] = "聊天讯息" -- Needs review
L["Check On..."] = "检查..."
L["Children:"] = "子集" -- Needs review
L["Choose"] = "选择"
L["Choose Trigger"] = "选择触发器"
L["Choose whether the displayed icon is automatic or defined manually"] = "选择显示的图示是自动显示还是手动定义"
L["Clone option enabled dialog"] = [=[
你已经启用|cFFFF0000自动复制|r。
|cFFFF0000自动复制|r 会让一个图示自动重复来显示多目标的讯息。
直到你把这个图示放在一个|cFF22AA22动态群组|r里，所有被复制的图示都会显示在其它图示的顶端.
你想要让它被放到新的|cFF22AA22动态群组|r的吗？]=]
L["Close"] = "关闭"
L["Collapse all loaded displays"] = "折叠所有载入的图示"
L["Collapse all non-loaded displays"] = "折叠所有未载入的图示"
L["Color"] = "颜色"
L["Compress"] = "压缩"
L["Constant Factor"] = "常数因子"
L["Controls the positioning and configuration of multiple displays at the same time"] = "同时控制多个图示的位置和设定"
L["Cooldown"] = "冷却"
L["Count"] = "计数 "
L["Creating buttons: "] = "创建按钮:"
L["Creating options: "] = "创建配置:"
L["Crop"] = "剪裁" -- Needs review
L["Crop X"] = "裁剪X"
L["Crop Y"] = "裁剪Y"
L["Custom"] = "自定义" -- Needs review
L["Custom Code"] = "自定义代码"
L["Custom Function"] = "自定义功能" -- Needs review
L["Custom Trigger"] = "自定义生效触发器"
L["Custom trigger event tooltip"] = [=[选择用于检查自订触发的事件。
如果有多个事件,可以用逗号或空白分隔。

|cFF4444FF例：|r
UNIT_POWER, UNIT_AURA PLAYER_TARGET_CHANGED]=]
L["Custom trigger status tooltip"] = [=[选择用于检查自订触发的事件。
因为这一个是状态触发器, 指定的事件 可以被 WeakAuras 调用, 而不需指定参数.
如果有多个事件,可以用逗号或空白分隔。

|cFF4444FF例：|r
UNIT_POWER, UNIT_AURA PLAYER_TARGET_CHANGED]=]
L["Custom Untrigger"] = "自定义失效触发器"
L["Debuff Type"] = "减益类型"
L["Default"] = "默认" -- Needs review
L["Delete all"] = "删除所有"
L["Delete Trigger"] = "删除触发器"
L["Desaturate"] = "褪色"
L["Disabled"] = "禁用"
L["Discrete Rotation"] = "离散旋转"
L["Display"] = "图示"
L["Display Icon"] = "图示图标"
L["Displays a text, works best in combination with other displays"] = "显示一条文本，最好与其他显示效果结合运用"
L["Display Text"] = "图示文字"
L["Distribute Horizontally"] = "横向分布"
L["Distribute Vertically"] = "纵向分布"
L["Done"] = "完成" -- Needs review
L["-- Do not remove this comment, it is part of this trigger: "] = "-不要移除这条信息，这是该触发器的一部分。"
L["Duration Info"] = "持续时间讯息"
L["Duration (s)"] = "持续时间"
L["Dynamic Group"] = "动态群组"
L["Dynamic information"] = "动态信息"
L["Dynamic information from first Active Trigger"] = "来自第一个触发器的动态信息"
L["Dynamic information from Trigger %i"] = "来自触发器%i的动态信息"
L["Dynamic text tooltip"] = [=[这里有几个特别的编码允许文字动态显示：

|cFFFF0000%p|r - 进度 - 剩余持续时间或非时间值
|cFFFF0000%t|r - 总共 - 总持续时间或最大的非时间值
|cFFFF0000%n|r - 名称 - 图示名称(通常是光环名称)或是没有动态名称图示的编号
|cFFFF0000%i|r - 图标 - 图示关连的显标
|cFFFF0000%s|r - 堆叠 - 光环堆叠数量(通常)
|cFFFF0000%c|r - 自定义 - 允许你自定义一个Lua函数并返回一个用于显示的字符串]=]
L["Enabled"] = "启用"
L["End Angle"] = "结束角度" -- Needs review
L["Enter an aura name, partial aura name, or spell id"] = "键入一个法术名，或者法术ID"
L["Event"] = "事件"
L["Event(s)"] = "事件（复数）"
L["Event Type"] = "事件类型"
L["Expand all loaded displays"] = "展开所有载入的图示"
L["Expand all non-loaded displays"] = "展开所有未载入的图示"
L["Expand Text Editor"] = "展开本文编辑器"
L["Fade"] = "淡化"
L["Fade In"] = "渐入"
L["Fade Out"] = "渐出"
L["Finish"] = "结束"
L["Fire Orb"] = "火焰宝珠" -- Needs review
L["Font"] = "字体"
L["Font Flags"] = "字体效果"
L["Font Size"] = "字体大小"
L["Font Type"] = "字体类型"
L["Foreground Color"] = "前景色"
L["Foreground Texture"] = "前景材质"
L["Frame"] = "框架"
L["Frame Strata"] = "框架层级"
L["From Template"] = "从模板" -- Needs review
L["Glow Action"] = "发光动作"
L["Green Rune"] = "绿色符文" -- Needs review
L["Group"] = "组" -- Needs review
L["Group aura count description"] = [=[所输入的队伍或团队成员的数量必须给定一个或多个光环作为显示触发的条件。
如果输入的数字是一个整数(如5)，受影响的团队成员数量将与输入的数字相同。
如果输入的数字是一个小数(如0.5)，分数(例如1/ 2)，或百分比(例如50%%)，那么多比例的队伍或团队成员的必须受到影响。
|cFF4444FF举例：|r
|cFF00CC00大于 0|r  会在任意一人受影响时触发
|cFF00CC00等于 100%%|r 会在所有人受影响时触发
|cFF00CC00不等于 2|r 会在2人受影响之外时触发
|cFF00CC00小于等于 0.8|r 会在小于80%%的人受影响时触发
|cFF00CC00大于 1/2|r 会在超过一半以上的人受影响时触发
|cFF00CC00大于等于 0|r 总是触发.]=] -- Needs review
L["Group Member Count"] = "队伍或团队成员数"
L["Grow"] = "生长"
L["Hawk"] = "鹰"
L["Height"] = "高度"
L["Hide"] = "隐藏"
L["Hide on"] = "隐藏于"
L["Hide When Not In Group"] = "不在队伍时隐藏"
L["Horizontal Align"] = "水平对齐"
L["Horizontal Bar"] = "水平条" -- Needs review
L["Horizontal Blizzard Raid Bar"] = "水平暴雪团队条" -- Needs review
L["Huge Icon"] = "巨型图标" -- Needs review
-- L["Hybrid Position"] = ""
-- L["Hybrid Sort Mode"] = ""
L["Icon"] = "图标" -- Needs review
L["Icon Color"] = "图标颜色" -- Needs review
L["Icon Info"] = "图标信息"
L["Icon Inset"] = "项目插入" -- Needs review
L["Ignored"] = "被忽略"
L["%i Matches"] = "%i 符合"
L["Import"] = "导入"
L["Import a display from an encoded string"] = "从字串导入一个图示"
L["Inverse"] = "反转" -- Needs review
L["Justify"] = "对齐"
L["Leaf"] = "叶子" -- Needs review
-- L["Left 2 HUD position"] = ""
-- L["Left HUD position"] = ""
L["Left Text"] = "左边文字"
L["Load"] = "载入"
L["Loaded"] = "已载入"
L["Low Mana"] = "低法力值" -- Needs review
L["Main"] = "主要的"
L["Manage displays defined by Addons"] = "由插件管理已定义的图示"
L["Medium Icon"] = "中等图标"
L["Message"] = "讯息" -- Needs review
L["Message Prefix"] = "讯息前缀"
L["Message Suffix"] = "讯息后缀"
L["Message Type"] = "讯息类型" -- Needs review
L["Mirror"] = "镜像"
L["Model"] = "模型"
L["Multiple Displays"] = "多个图示"
L["Multiple Triggers"] = "多触发器"
L["Multiselect ignored tooltip"] = [=[|cFFFF0000忽略|r - |cFF777777单个|r - |cFF777777多个|r
当图示应该载入时这项设定不应该使用]=]
L["Multiselect multiple tooltip"] = [=[|cFFFF0000忽略|r - |cFF777777单个|r - |cFF777777多个|r
任何相匹配的值的值可以提取]=]
L["Multiselect single tooltip"] = [=[|cFFFF0000忽略|r - |cFF777777单个|r - |cFF777777多个|r
只有一个单一的匹配值可以提取]=]
L["Name Info"] = "名称讯息"
L["Negator"] = "不"
L["Never"] = "从不"
L["New"] = "新增"
L["No"] = "不"
L["None"] = "无" -- Needs review
L["Not all children have the same value for this option"] = "并非所有子元素都拥有相同的此选项的值"
L["Not Loaded"] = "未载入"
L["No tooltip text"] = "没有提示文字"
L["Offer a guided way to create auras for your class"] = "为你的职业提供创建光环的向导" -- Needs review
L["% of Progress"] = "% 进度"
L["Okay"] = "好"
L["On Hide"] = "图示隐藏时触发"
L["On Init"] = "于初始时" -- Needs review
L["Only match auras cast by people other than the player"] = "只匹配其它玩家施放的光环"
L["Only match auras cast by the player"] = "只匹配玩家自己施放的光环"
L["On Show"] = "图示显示时触发"
L["Operator"] = "运算符"
L["or"] = "或"
L["Orange Rune"] = "橙色符文" -- Needs review
L["Orientation"] = "方向"
L["Outline"] = "轮廓"
L["Own Only"] = "只来源于自己"
L["Paste text below"] = "在下方粘贴文本"
L["Play Sound"] = "播放声音"
L["Portrait Zoom"] = "纵向缩放" -- Needs review
L["Preset"] = "预设"
L["Prevents duration information from decreasing when an aura refreshes. May cause problems if used with multiple auras with different durations."] = "阻止刷新光环时持续时间讯息的变动。如果使用了多个光环并且具有不同持续时间那么可能会造成问题。"
L["Processed %i chars"] = "已处理%i个字符" -- Needs review
L["Progress Bar"] = "进度条"
L["Progress Texture"] = "进度条材质"
L["Purple Rune"] = "紫色符文" -- Needs review
L["Radius"] = "范围" -- Needs review
L["Re-center X"] = "到中心 X 偏移"
L["Re-center Y"] = "到中心 Y 偏移"
L["Remaining Time"] = "剩余时间"
L["Remaining Time Precision"] = "剩余时间精度"
L["Required For Activation"] = "需要启动"
-- L["Right 2 HUD position"] = ""
L["Right-click for more options"] = "右键点击获得更多选项"
-- L["Right HUD position"] = ""
L["Right Text"] = "右边文字"
L["Rotate"] = "旋转"
L["Rotate In"] = "旋转进入"
L["Rotate Out"] = "旋转退出"
L["Rotate Text"] = "旋转文字"
L["Rotation"] = "旋转"
L["Rotation Mode"] = "旋转模式" -- Needs review
L["Same"] = "相同"
-- L["Scale"] = ""
L["Search"] = "搜索"
L["Select the auras you always want to be listed first"] = "选择优先列出的光环" -- Needs review
L["Send To"] = "发送给"
L["Show all matches (Auto-clone)"] = "列出所有符合的(自动复制)"
L["Show model of unit "] = "显示该单位的模型"
L["Show players that are |cFFFF0000not affected"] = "显示|cFFFF0000未被影响|r的玩家"
L["Shows a 3D model from the game files"] = "显示游戏文件中的3D模形"
L["Shows a custom texture"] = "显示自定义材质"
L["Shows a progress bar with name, timer, and icon"] = "显示一个进度条组件, 它拥有 名称, 时间 和 图标"
L["Shows a spell icon with an optional cooldown overlay"] = "显示可选的法术图示有冷却时间重叠" -- Needs review
L["Shows a texture that changes based on duration"] = "显示一个随持续时间而变的材质"
L["Shows one or more lines of text, which can include dynamic information such as progress or stacks"] = "显示一行或多行文字, 它们包换动态信息, 如进度和叠加层数"
L["Size"] = "大小"
L["Slide"] = "滑动"
L["Slide In"] = "滑动"
L["Slide Out"] = "滑出"
L["Small Icon"] = "小图标"
L["Sort"] = "排序"
L["Sound"] = "声音"
L["Sound Channel"] = "声道"
L["Sound File Path"] = "声音文件路径"
L["Sound Kit ID"] = "音效包ID" -- Needs review
L["Space"] = "间隙"
L["Space Horizontally"] = "横向间隙"
L["Space Vertically"] = "纵向间隙"
L["Spark"] = "高光"
L["Spark Settings"] = "高光设置"
L["Spark Texture"] = "高光材质"
L["Specific Unit"] = "指定单位"
L["Spell ID"] = "法术ID"
L["Spell ID dialog"] = [=[你已经指定一个|cFFFF0000法术ID|r。

默认地，|cFF8800FFWeakAuras|r 无法区分|cFFFF0000法术编号|r不同但法术名称相同的法术。 
当然，如果你启用完整扫描，|cFF8800FFWeakAuras|r可以搜寻指定的|cFFFF0000法术编号|r的法术。

你想要启用完整扫描来匹配这个|cFFFF0000法术编号|r吗？]=]
L["Stack Count"] = "层数" -- Needs review
L["Stack Info"] = "层数信息" -- Needs review
L["Stacks"] = "层数" -- Needs review
L["Stacks Settings"] = "层数设置" -- Needs review
L["Stagger"] = "交错"
L["Star"] = "星星"
L["Start"] = "开始"
L["Start Angle"] = "起始角度" -- Needs review
L["Status"] = "状态"
L["Stealable"] = "可偷取"
L["Sticky Duration"] = "持续时间置顶"
L["Symbol Settings"] = "标志设置" -- Needs review
L["Temporary Group"] = "模板群组"
L["Text"] = "文字"
L["Text Color"] = "文字颜色"
L["Text Position"] = "文字位置"
L["Texture"] = "材质"
L["Texture Info"] = "材质信息" -- Needs review
L["The children of this group have different display types, so their display options cannot be set as a group."] = "群组中的子元素含有类型不同图示，所以它们的显示选项无法统一成一个群组."
L["The duration of the animation in seconds."] = "动画持续秒数"
L["The type of trigger"] = "触发器类型"
L["This region of type \"%s\" is not supported."] = "该类型区域“%s”不受支持。" -- Needs review
L["Time in"] = "时间"
L["Tiny Icon"] = "微型图标"
L["Toggle the visibility of all loaded displays"] = "切换当前已载入图示的可见状态"
L["Toggle the visibility of all non-loaded displays"] = "切换当前未载入图示的可见状态"
L["to group's"] = "到群组"
L["Tooltip"] = "提示"
L["Tooltip on Mouseover"] = "鼠标提示"
-- L["Top HUD position"] = ""
L["Top Text"] = "顶部文字"
L["to screen's"] = "到屏幕"
L["Total Time Precision"] = "总的时间精度"
L["Trigger"] = "触发"
L["Trigger %d"] = "触发器 %d"
L["Type"] = "类型"
L["Unit"] = "单位"
L["Unlike the start or finish animations, the main animation will loop over and over until the display is hidden."] = "不同于开始或结束动画，主动画将不停循环，直到图示被隐藏。"
L["Update Custom Text On..."] = "更新自定义文字于"
L["Use Full Scan (High CPU)"] = "使用完整扫描(高CPU)"
-- L["Use SetTransform api"] = ""
L["Use tooltip \"size\" instead of stacks"] = "使用\\\"大小\\\"提示,而不是\\\"层数\\\"" -- Needs review
L["Vertical Align"] = "垂直对齐"
L["Vertical Bar"] = "垂直条"
L["WeakAurasOptions"] = "WeakAuras选项"
L["Width"] = "宽度"
L["X Offset"] = "X 偏移"
-- L["X Rotation"] = ""
L["X Scale"] = "宽度比例"
L["Yellow Rune"] = "黄色符文"
L["Yes"] = "是"
L["Y Offset"] = "Y 偏移"
-- L["Y Rotation"] = ""
L["Y Scale"] = "长度比例"
L["Z Offset"] = "深度 偏移"
L["Zoom"] = "缩放"
L["Zoom In"] = "放大"
L["Zoom Out"] = "缩小"
-- L["Z Rotation"] = ""



