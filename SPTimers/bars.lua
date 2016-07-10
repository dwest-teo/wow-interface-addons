local addon, C = ...

local options
local myGUID
local _
local parent = C.Parent
local spelllist = {}
C.AurasSpellList = spelllist

local SortBars
local L = AleaUI_GUI.GetLocale("SPTimers")

-- NEW GLOBALS ----

local NO_FADE 			= C.NO_FADE
local DO_FADE 			= C.DO_FADE
local DO_FADE_RED 		= C.DO_FADE_RED 
local FADED 			= C.FADED
local DO_FADE_UNLIMIT 	= C.DO_FADE_UNLIMIT
local UNITAURA 			= C.UNITAURA
local CLEU				= C.CLEU
local PLAYER_AURA 		= C.PLAYER_AURA
local OTHERS_AURA 		= C.OTHERS_AURA
local CUSTOM_AURA 		= C.CUSTOM_AURA
local CHANNEL_SPELL 	= C.CHANNEL_SPELL
local TOTEM_SPELL 		= C.TOTEM_SPELL
local SPELL_CAST 		= C.SPELL_CAST
local SPELL_SUMMON 		= C.SPELL_SUMMON
local SPELL_ENERGIZE 	= C.SPELL_ENERGIZE
local COOLDOWN_SPELL 	= C.COOLDOWN_SPELL
local NO_GUID 			= C.NO_GUID

local SOUND_INDEX = 40
------------------
local anchors = {}
C.Anchors = anchors

local tinsert = tinsert
local tremove = tremove

local max = max
local format = format
local floor = math.floor
local stmatch = string.match
local tostring = tostring
local tonumber = tonumber
local UnitGUID = UnitGUID
local UnitClass = UnitClass
local GetTime = GetTime
local tsort = table.sort 
local pairs = pairs
local ipairs = ipairs
local unpack = unpack
local gsub = gsub
local find = string.find
local gmatch = gmatch
local match = string.match
	
local function GetSpellTag(destGuid, spellID, sourceGuid, auraType, auraID)
	return format("%s-%s-%s-%d",( destGuid or NO_GUID ), tostring(spellID), tostring(auraType), tostring(auraID))
end

C.GetSpellTag = GetSpellTag

local function OnTimerEnd(tag, str)
	
	if spelllist[tag] then
		if spelllist[tag][21] then 
			C:RemoveDotFromDB(spelllist[tag][3], spelllist[tag][5], "REMOVE FROM OnTimerEND")
		end
		
		if spelllist[tag][SOUND_INDEX] then
			spelllist[tag][SOUND_INDEX] = false
			C:PlaySound(spelllist[tag][5], "sound_onhide", spelllist[tag][14])
		end
	end
end


local function OnTimerStart(tag)
	if spelllist[tag] then
		spelllist[tag][SOUND_INDEX] = true
		
		C:PlaySound(spelllist[tag][5], "sound_onshow", spelllist[tag][14])
		
	--	print("START TIMER",spelllist[tag][8])
	end
end

-- debug print ------------------
local old_print = print
local print = function(...)
	if C.dodebugging then	
		old_print("SPT_BARS, ", ...)
	end
end

local old_assert = assert
local assert = function(...)
	if C.dodebugging then	
	--	old_assert(...)
	end
end

local function deepcopy(t)
	if type(t) ~= 'table' then return t end
		local mt = getmetatable(t)
		local res = {}
		for k,v in pairs(t) do
			if type(v) == 'table' then
				v = deepcopy(v)
			end
		res[k] = v
		end
		setmetatable(res,mt)
	return res
end

function C:CheckForMissingBarsData()
	for i=1, #self.db.profile.bars_anchors do		
		if not self.db.profile.bars_anchors[i] then
			table.remove(self.db.profile.bars_anchors, i)
			self:CheckForMissingBarsData()
			break
		end
	end
end

function C:InitFrames()
	self.myGUID = UnitGUID("player")

	local _,class = UnitClass("player")	
	self.myCLASS = class
	
	options = self.db.profile

	for i=1, #options.bars_anchors do	
		self:InitBarAnchor(i)
	end
end

function C:ProfileSwapBars()

	options = self.db.profile
	
	local inittest = false
	if self.testbar_shown then
		inittest = true
		self:DisableTestBars()
	end
	
	wipe(spelllist)
	
--	print("InitFrames", #anchors, #options.bars_anchors)
	if #anchors > 0 then
		for i=1, #anchors do
			anchors[i]:ResetAnchor()
		end
	end
	
	for i=1, #options.bars_anchors do	
		self:InitBarAnchor(i)
	end
	
	if inittest then
		self:TestBars()
	end
end


function C:DeleteAnchor(index)

	if self.db.profile.bars_anchors[index] then
		table.remove(self.db.profile.bars_anchors, index)
		
		for i=1, #anchors do		
			if i == index then
				anchors[i]:ResetAnchor()
			end
		end
	end
end

do
	local mark = 0
	local testbar = false
	
	local maxtestbarval = 0
	
	local testbar_onupdate = CreateFrame("Frame")
	testbar_onupdate:Hide()
	testbar_onupdate.elapsed = 0
	testbar_onupdate:SetScript("OnUpdate", function(self, elapsed)
		self.elapsed = self.elapsed + elapsed
		
		if self.elapsed < maxtestbarval then return end
		self.elapsed = 0
		self:Hide()
		maxtestbarval = 0
		
		C:TestBars()
		
	--	print("AuraEnd Testbars")
	end)
	
	function C:DisableTestBars()	
		self.testbar_shown = nil
		self.onUpdateHandler.elapsed = 0
		self.onUpdateHandler:Show()
		mark = 0		
		testbar = false
		
		testbar_onupdate:Hide()
		testbar_onupdate.elapsed = 0
		maxtestbarval = 0
		
	end
	
	function C:TestBars(force)
		if testbar or force then
			self.testbar_shown = nil
			self.onUpdateHandler.elapsed = 0
			self.onUpdateHandler:Show()
			mark = 0
			for tag, data in pairs(spelllist) do
				if data[14] == "TEST_BAR" then
					spelllist[tag] = nil
				end
			end
			
			testbar_onupdate:Hide()
			testbar_onupdate.elapsed = 0
			maxtestbarval = 0
			
			SortBars(true)
		else
			self.testbar_shown = true
			self.onUpdateHandler.elapsed = 99999
			self.onUpdateHandler:Hide()			

			for k,v in pairs(anchors) do
				local a = 0
				local group = 0
				local group_guid = 1
				
				for f=1, 40 do
					local t = math.random(1, 100)
					local name = "Test Bar №"..a.." of "..( v.opts.name or k )
					a = a +1
					 
					group = group + 1
					
					if mark >= 8 then
						mark = 1
					else
						mark = mark + 1
					end
					
					if group >= 5 then 
						group = 0
						group_guid = group_guid + 1
					end

					if maxtestbarval < t then
						maxtestbarval = t
					end
					
					C.Timer(t, GetTime()+t, "group"..group_guid, "group"..group_guid, name, 1, "TEST_BAR"..k, "TEST_BAR", mark, name, "Interface\\Icons\\spell_shadow_shadowwordpain", a, name, name)
					
					testbar_onupdate:Show()
				end
			end
		end
		testbar = not testbar
	end
end

do
	local default_anchor = {
		name = 1,
		bar_number = 20,
		left_icon = true,
		right_icon = false,
		add_up = true,
		point = { 0, 0},
		w = 250,
		h = 14,
		target_name = true,
		gap = 4,
		icon_gap = 5,
		fortam_s = 1,
		border = "Flat",
		bordersize = 1, -- Added defaults
		borderinset = 0, -- Added defaults
		bordercolor = {80/255,80/255,80/255,1},
		show_header = false,
		group_grow_up = true,
		
		tick_ontop = false,
		spark_ontop = false,

		pandemia_color = { 200/255, 210/255, 210/255, 0.2 },
		pandemia_bp_style = 1,
		show_pandemia_bp = false,

		group_bg_show = false,
		group_bg_target_color = { 0,0,0,0 },
		group_bg_focus_color = { 1,1,0,0 },
		group_bg_offtargets_color = { 0,0,0,0},

		group_font_target_color = { 1, 1, 1},
		group_font_focus_color = { 1, 1, 0},

		group_font_style = {
			font = STANDARD_TEXT_FONT,
			alpha = 1,
			size = 12,
			flags = "OUTLINE",
			justify = "CENTER",
			shadow =  { 0, 0, 0, 1},
			offset = { 1, -1 },
		},
		overlays = {
			auto = true,
			color = { 1, 1, 1, 0.4 },
		},
		bar = {
			color = {118/255, 0, 0, 1},
			texture = "Flat",
			bgcolor = {0, 0, 0, 0.5},
			bgtexture = "Flat",
		},
		stack = {
			textcolor = {1, 1, 1},
			font = STANDARD_TEXT_FONT,
			alpha = 1,
			size = 14,
			flags = "OUTLINE",
			justify = "RIGHT",
			shadow =  { 0, 0, 0, 1},
			offset = { 1, -1 },
		},
		timer ={
			textcolor = {1, 1, 1},
			font = STANDARD_TEXT_FONT,
			alpha = 1,
			size = 14,
			flags = "OUTLINE",
			justify = "RIGHT",
			shadow =  { 0, 0, 0, 1},
			offset = { 1, -1 },
		},

		header_custom_text = {
			["target"] 		= { 2, "%target" },
			["player"] 		= { 2, "%player" },
			["procs"] 		= { 2, "%player" },
			["cooldowns"] 	= { 2, "%player" },
			["offtargets"] 	= { 2, "%id : %target" },
		},

		raidicon_x = 0,
		raidicon_y = 5,
		raidiconsize = 10,
		raidicon_alpha = 1,

		spell ={
			textcolor = {1, 1, 1},
			font = STANDARD_TEXT_FONT,
			alpha = 1,
			size = 14,
			flags = "OUTLINE",
			justify = "LEFT",
			offsetx = 0,
			shadow =  { 0, 0, 0, 1},
			offset = { 1, -1 },
		},
		castspark = {
			color = {1, 1, 1, 1},
			alpha = 1,
		},
		dotticks = {
			color = {1, 1, 1, 1},
			alpha = 1,
		},
		sorting = {
			{name = "target", 		gap = 10, alpha = 1,  sort = 1, disabled = false },
			{name = "player", 		gap = 10, alpha = 1,  sort = 2, disabled = false },
			{name = "procs",		gap = 15, alpha = .7, sort = 3, disabled = false },
			{name = "cooldowns",	gap = 15, alpha =  1, sort = 4, disabled = false },
			{name = "offtargets",	gap = 6,  alpha = .7, sort = 5, disabled = false },
		},
	}

	function C:CreateNewAnhors()
		local anhor_number = #options.bars_anchors+1
		
		options.totalanchor = options.totalanchor+1
		
		options.bars_anchors[anhor_number] = deepcopy(default_anchor)
		options.bars_anchors[anhor_number].name = options.totalanchor
		
		self:InitBarAnchor(anhor_number)
		self:SetAnchorTable(anhor_number)
	end

	
	local function addDefaultOptions(t1, t2)
		for i, v in pairs(t2) do
			if t1[i] == nil then
				t1[i] = v
			elseif type(v) == "table" and type(t1[i]) == "table" then
				 addDefaultOptions(t1[i], v)
			end
		end
	end
	
	function C.CheckBarOpts(opt)
	
		if #opt.sorting ~= #default_anchor.sorting then
			opt.sorting = nil
		end
		
		addDefaultOptions(opt, default_anchor)

		if opt and opt.sorting then
			for k,v in ipairs(opt.sorting) do
				if not v.sort then
					if v.name == "offtargets" then 
						v.sort = 5 
					else
						v.sort = k
					end
				end
			end
		end
	end
end

local function ResetAnchor(self)
	self.disabled = true
	self:Hide()
	self.mover:Hide()
	
	for i=1, #self.bars do		
		self.bars[i].disabled = true
		self.bars[i]:ClearAllPoints()
		self.bars[i].tag = nil
		self.bars[i]:Hide()
	end
end

function C:CopySettings(from, to)
	local a1 = options.bars_anchors[to].point
	local a2 = options.bars_anchors[to].name
	
	options.bars_anchors[to] = deepcopy(options.bars_anchors[from])
	options.bars_anchors[to].point = deepcopy(a1)
	options.bars_anchors[to].name = a2
	
--	print(to, options.bars_anchors[to], #options.bars_anchors)
	self:InitBarAnchor(to)	
	
	self:Visibility()
end

function C:UpdateStatusBars()
	wipe(spelllist)
	SortBars(true)
end

function C:Visibility()
	self:InterateBars("UpdateStyle")
end
function C:Update_StackText()
	self:InterateBars("UpdateStackText")
end
function C:Update_TimeText()
	self:InterateBars("UpdateTimeText")
end
function C:Update_SpellText()
	self:InterateBars("UpdateSpellText")
end
function C:UpdateAllBorder()
	self:InterateBars("UpdateBorder")	
end

function C:UpdateRaidIcons()
	self:InterateBars("UpdateRaidIcon")	
end

function C:UpdateBarsSize()
	self:InterateBars("UpdateBarSize")		
	SortBars(true)
end

function C:UpdateBackgroundBarColor()
	self:InterateBars("UpdateBarColor")	
end

function C:UpdateAllSparks()
	self:InterateBars("UpdateSpark_Color")	
end

function C:UpdateAllTiks()
	self:InterateBars("UpdateTick_Color")
end

function C:UpdateMovers()
	if options.locked then
		for k,v in pairs(anchors) do
			v:Lock()
		end
	else 
		for k,v in pairs(anchors) do
			v:Unlock()
		end
	end
end

function C:InterateBars(...)
	for i=1, #anchors do
		for b=1, #anchors[i].bars do		
			for a=1, select("#", ...) do
				local func = select(a, ...)
				anchors[i].bars[b][func](anchors[i].bars[b], anchors[i], i)
			end
		end
	end
end

function C:InitBarAnchor(i)
	
	self.CheckBarOpts(options.bars_anchors[i])
	
	local opts = options.bars_anchors[i]

	if not anchors[i] then
		local f = CreateFrame("Frame", nil ,parent)
		
		f.bg_1 = f:CreateTexture()
		f.bg_1:SetAllPoints()
		f.bg_1:SetTexture(1,0,0,0)

		f.id = i
		f.index = 0
		f.bars = {}
		f.group = { target = {}, player = {}, procs = {}, cooldowns = {}}
		f.group_guid = {}
		
		f.GetOpts = function(self)
			return options.bars_anchors[self.id]
		end
		
		f.ResetAnchor = ResetAnchor
		
		f.Unlock = function(self)
			self.mover:Show()
			self.mover:EnableMouse(true)
		end		
		f.Lock = function(self)
			self.mover:Hide()
			self.mover:EnableMouse(false)
		end
		
		f.mover = CreateFrame("Frame", nil, f)
		f.mover.text = f.mover:CreateFontString(nil, "OVERLAY", "GameFontNormal");
		f.mover.text:SetPoint("CENTER", f.mover, "CENTER",0,0)
		f.mover.text:SetTextColor(1,1,1,1)
		f.mover.text:SetFont(STANDARD_TEXT_FONT,12, "OUTLINE")
		f.mover.text:SetJustifyH("CENTER")
		f.mover.text:SetText(L["Unlocked. Move group"].." "..i)
		
		
		f.mover.parent = f		
		f.mover:SetMovable(true)
		f.mover:RegisterForDrag("LeftButton")
		f.mover:SetScript("OnDragStart", function(self) 
			self:StartMoving() 
		end)
		f.mover:SetScript("OnDragStop", function(self) 
			self:StopMovingOrSizing()
			local x, y = self:GetCenter()
			local ux, uy = parent:GetCenter()

			self.parent.opts.point = { floor(x - ux + 0.5),floor(y - uy + 0.5) }

			for k,v in pairs(self.mover_add_button.editboxes) do
				v:UpdateText()
			end
			
			self:SetPoint("CENTER", parent, "CENTER", self.parent.opts.point[1] or 0,self.parent.opts.point[2] or 0)	
		end)

		f.mover:SetClampedToScreen(true)		
		
		f.mover.bg_1 = f.mover:CreateTexture()
		f.mover.bg_1:SetAllPoints()
		f.mover.bg_1:SetTexture(0,0,0,1)
		
		f.mover:SetAlpha(.6)
		f.mover:Hide()

		anchors[i] = f
	end

	anchors[i].disabled = false
	anchors[i].id = i
	anchors[i].opts = options.bars_anchors[i]
	anchors[i].sorting = options.bars_anchors[i].sorting

	anchors[i].index = 0
	
	anchors[i].mover:ClearAllPoints()
	anchors[i].mover:SetPoint("CENTER", parent, "CENTER",opts.point[1] or 0,opts.point[2] or 0)				
	anchors[i].mover:SetSize( opts.w or 100 , opts.h or 20)
	
	anchors[i]:Show()
	
	local _left, _right = 0, 0
	
	if opts.left_icon then
		_left = _left + opts.h + opts.icon_gap
	end
	
	if opts.right_icon then
		_right = _right + opts.h + opts.icon_gap
	end
	
	anchors[i]:ClearAllPoints()
	anchors[i]:SetPoint("CENTER", anchors[i].mover,"CENTER", (_left/2) - (_right/2) , 0)
	anchors[i]:SetSize(1,opts.h+5)
	
	C.AddMoverButtons(anchors[i].mover, opts)

	for s=1, opts.bar_number do
		
		local bar = anchors[i].bars[s] or C.GetBar(anchors[i])
		
		
		bar:UpdateStyle()
		
		anchors[i].bars[s] = bar
		anchors[i].bars[s].disabled = false
		anchors[i].bars[s]:ClearAllPoints()
		anchors[i].bars[s]:SetParent(anchors[i])
		anchors[i].bars[s]:Hide()
	end

	for s=opts.bar_number+1, #anchors[i].bars do
		anchors[i].bars[s].disabled = true
		anchors[i].bars[s]:ClearAllPoints()
		anchors[i].bars[s]:Hide()
	end
	
	C:UpdateMovers()
end


do
    local hour, minute = 3600, 60
    local format = string.format
    local ceil = math.ceil
	local floor = math.floor
	local fmod = math.fmod
	
	local formats = {
		function(s)  -- 1h, 2m, 119s, 29.9
			if s >= hour then
				return " %dh ", ceil(s / hour)
			elseif s >= minute*2 then
				return " %dm ", ceil(s / minute)
			elseif s >= 30 then
				return " %ds ", floor(s)
			end
			return " %.1f ", s
		end,
		function(s, dur) -- 1h, 2m, 119s / 300 , 29.99 / 300
			if s >= hour then
				return " %dh ", ceil(s / hour)
			elseif s >= minute*2 then
				return " %dm ", ceil(s / minute), dur
			elseif s >= 30 then
				return " %ds / %.0f ", floor(s), dur
			end
			return " %.2f / %.0f ", s, dur
		end,
		function(s) -- 1:11m, 59s, 10s, 1s
			if s <= 60 then
				return (" %.0fs "):format(s+0.1)
			else
				return (" %d:%0.2dm "):format(s/60, fmod(s, 60))
			end
		end,
		function(s) -- 1:11m, 59.1s, 10.2s, 1.1s
			if s <= 60 then
				return (" %.1fs "):format(s+0.1)
			else
				return (" %d:%0.2dm "):format(s/60, fmod(s, 60))
			end
		end,
		
		function(s)  -- 1, 2, 119, 29.9
			if s >= hour then
				return " %d ", ceil(s / hour)
			elseif s >= minute*2 then
				return " %d ", ceil(s / minute)
			elseif s >= 30 then
				return " %d ", floor(s)
			end
			return " %.1f ", s
		end,
		function(s, dur) -- 1, 2, 119 / 300 , 29.99 / 300
			if s >= hour then
				return " %d ", ceil(s / hour)
			elseif s >= minute*2 then
				return " %d ", ceil(s / minute), dur
			elseif s >= 30 then
				return " %d / %.2f ", floor(s), dur
			end
			return " %.2f / %.2f ", s, dur
		end,
		function(s) -- 1:11, 59, 10, 1
			if s <= 60 then
				return (" %.0f "):format(s+0.1)
			else
				return (" %d:%0.2d "):format(s/60, fmod(s, 60))
			end
		end,
		function(s) -- 1:11, 59.1, 10.2, 1.1
			if s <= 60 then
				return (" %.1f "):format(s+0.1)
			else
				return (" %d:%0.2d "):format(s/60, fmod(s, 60))
			end
		end,
	}
	
    function C.FormatTime(t, s, dur)
		return formats[t]( ( s <= 0 and 0.00 or s), dur)
    end
end

do
	local numbers_pattern = '(%d+%,?%.?%d*)' -- "[%d]+%,?%.?[%d]*"
	local tooltipname = 'SPTimersGameToolTip2'
	local tooltipnamelefttext = tooltipname.."TextLeft2"
	local hidegametooltip = CreateFrame("Frame")
	hidegametooltip:Hide()
	local gametooltip = CreateFrame("GameTooltip", tooltipname, nil, "GameTooltipTemplate");
	gametooltip:SetOwner( hidegametooltip,"ANCHOR_NONE");
	local GetValues, GetAuraVal
	local preCahceCheckCustomText = {}
	local supportedTags = {
		['%stacks'] = function(text, data) 
			return gsub(text,"%%stacks", data[20])
		end,
		['%val1'] = function(text, data, opt, self)		
			return gsub(text,"%%val1", GetValues(self, 1))
		end,
		['%val2'] = function(text, data, opt, self)		
			return gsub(text,"%%val2", GetValues(self, 2))
		end,
		['%val3'] = function(text, data, opt, self)		
			return gsub(text,"%%val3", GetValues(self, 3))
		end,
		['%newval1'] = function(text, data, opt, self)
			return gsub(text, "%%newval1", GetAuraVal(self, 1))
		end,
		['%newval2'] = function(text, data, opt, self)
			return gsub(text, "%%newval2", GetAuraVal(self, 2))
		end,
		['%newval3'] = function(text, data, opt, self)
			return gsub(text, "%%newval3", GetAuraVal(self, 3))
		end,
		['%tickcount'] = function(text, data)
			if data[22] then
				return gsub(text,"%%tickcount", data[22])
			end
			return text
		end,
		['%sN'] = function(text, data, opt)
			if opt.short then		
				return gsub(text,"%%sN", C:getShort(data[29]) or UNKNOWN)
			else
				return gsub(text,"%%sN", data[29] or UNKNOWN)
			end		
		end,
		['%spell'] = function(text, data, opt)
			if opt.short then		
				return gsub(text,"%%spell", C:getShort(data[8]))
			else
				return gsub(text,"%%spell", data[8])
			end		
		end,
		['%tN'] = function(text, data, opt)
			if opt.short then		
				return gsub(text, "%%tN", C:getShort(data[28]) or UNKNOWN)
			else
				return gsub(text,"%%tN", data[28] or UNKNOWN)
			end		
		end,
	}
	
	function C:PreCacheCustomTextCheck()
		for k,v in pairs(self.db.profile.procSpells) do
			if v.custom_text_on and v.custom_text and v.custom_text ~= '' then
				for val in gmatch(v.custom_text, "[^ :\"-]+") do
					if supportedTags[val] then
						preCahceCheckCustomText[k] = preCahceCheckCustomText[k] or {}						
						preCahceCheckCustomText[k][#preCahceCheckCustomText[k]+1] = val
					end
				end
			end
		end
		for k,v in pairs(self.db.profile.othersSpells) do
			if v.custom_text_on and v.custom_text and v.custom_text ~= '' then
				for val in gmatch(v.custom_text, "[^ :\"-]+") do		
					if supportedTags[val] then
						preCahceCheckCustomText[k] = preCahceCheckCustomText[k] or {}						
						preCahceCheckCustomText[k][#preCahceCheckCustomText[k]+1] = val
					end
				end
			end
		end
		for k,v in pairs(self.db.profile.classSpells[self.myCLASS]) do
			if v.custom_text_on and v.custom_text and v.custom_text ~= '' then
				for val in gmatch(v.custom_text, "[^ :\"-]+") do		
					if supportedTags[val] then
						preCahceCheckCustomText[k] = preCahceCheckCustomText[k] or {}						
						preCahceCheckCustomText[k][#preCahceCheckCustomText[k]+1] = val
					end
				end
			end
		end	
	end

	local auratypes = {
		['DEBUFF']	= 'HARMFUL',
		['BUFF']	= 'HELPFUL',
		['HARMFUL'] = 'HARMFUL',
		['HELPFUL'] = 'HELPFUL',
	}
	
	local patterns = {
		"(%d+%,?%.?%d*)",
		"%d+%,?%.?%d*%D+(%d+%,?%.?%d*)",
		"%d+%,?%.?%d*%D+%d+%,?%.?%d*%D+(%d+%,?%.?%d*)",
		"%d+%,?%.?%d*%D+%d+%,?%.?%d*%D+%d+%,?%.?%d*%D+(%d+%,?%.?%d*)",
		"%d+%,?%.?%d*%D+%d+%,?%.?%d*%D+%d+%,?%.?%d*%D+%d+%,?%.?%d*%D+(%d+%,?%.?%d*)",
		"%d+%,?%.?%d*%D+%d+%,?%.?%d*%D+%d+%,?%.?%d*%D+%d+%,?%.?%d*%D+%d+%,?%.?%d*%D+(%d+%,?%.?%d*)",
		"%d+%,?%.?%d*%D+%d+%,?%.?%d*%D+%d+%,?%.?%d*%D+%d+%,?%.?%d*%D+%d+%,?%.?%d*%D+%d+%,?%.?%d*%D+(%d+%,?%.?%d*)",
		"%d+%,?%.?%d*%D+%d+%,?%.?%d*%D+%d+%,?%.?%d*%D+%d+%,?%.?%d*%D+%d+%,?%.?%d*%D+%d+%,?%.?%d*%D+%d+%,?%.?%d*%D+(%d+%,?%.?%d*)",
		"%d+%,?%.?%d*%D+%d+%,?%.?%d*%D+%d+%,?%.?%d*%D+%d+%,?%.?%d*%D+%d+%,?%.?%d*%D+%d+%,?%.?%d*%D+%d+%,?%.?%d*%D+%d+%,?%.?%d*%D+(%d+%,?%.?%d*)",
		"%d+%,?%.?%d*%D+%d+%,?%.?%d*%D+%d+%,?%.?%d*%D+%d+%,?%.?%d*%D+%d+%,?%.?%d*%D+%d+%,?%.?%d*%D+%d+%,?%.?%d*%D+%d+%,?%.?%d*%D+%d+%,?%.?%d*%D+(%d+%,?%.?%d*)",
	}
	
	
	function GetValues(timer, i)
		local data = timer.data --timer.tag and spelllist[timer.tag] or nil
		if not data then return '0' end
		
		data[30] = data[30] or {}
		
		local value = data[30][i]
		
		gametooltip:ClearLines()
		
		local unit = C:FindUnitByGUID(data[3])

		if unit and not value then
			
			
			gametooltip:SetUnitAura(unit, data[8], nil, auratypes[data[11]] or "HARMFUL") 

			local line = _G[tooltipnamelefttext]:GetText()
			
			if line then 				
				value = match(line, patterns[i])			
				data[30][i] = value
			end
		end
		
		return value or "0"
	end
	
	function GetAuraVal(timer, i)
		local data = timer.data --timer.tag and spelllist[timer.tag] or nil
		if not data then 
			return ""
		end

		local unit = C:FindUnitByGUID(data[3])
		local value1, value2, value3, _, spellID, sUnit, name
		local val1, val2, val3
		
		-- [1] duration
		-- [2] endTime
		-- [3] destGGUID
		-- [4] sourceGUID
		-- [5] spellID
		-- [6] sourceUnit
		-- [7] aura counter
		-- [8] localized spellname
		-- [9] icon texture path
		
		if data[3] == C.myGUID then unit = 'player' end
		
		if unit then
			
			name, _, _, _, _, _, _, sUnit, _, _, spellID, _, _, value1, value2, value3 = UnitAura(unit, data[8], nil, ( auratypes[data[11]] or "HARMFUL" ) .. ( data[4] == C.myGUID and "|PLAYER" or "" ) )
			-- 13 + 1  13 + 2 13 + 3
			
			if name and spellID == data[5] and UnitGUID(sUnit or '') == data[4] then
				val1, val2, val3 = value1, value2, value3
			end
		end
	
		if i == 1 then
			return val1 and tostring(val1) or ""
		elseif i == 2 then
			return val2 and tostring(val2) or ""
		elseif i == 3 then
			return val3 and tostring(val3) or ""
		end
		
		return ""
	end
	
	function C.CustomTextCreate(self)
		local data = self.data

		local text = data[23]
		local opt = self.opts
		
		if text and preCahceCheckCustomText[data[5]] then		
			for i=1, #preCahceCheckCustomText[data[5]] do
				local val = preCahceCheckCustomText[data[5]][i]		
				text = supportedTags[val](text, data, opt, self)
			end			
		end
		
		return text
	end
end

do
	local ticks_frame_table = {}
	local ticks_frame_table_1 = {}

	local add_tick_table = {}
		

	function C:RegisterDotApply(guid, spellid)	
		if not add_tick_table[guid..spellid] then
			self:GetTickInfo(spellid, guid)
			
			
			add_tick_table[guid..spellid] = { 
				GetTime(), 
				GetTime(), 
				self.dots[spellid..guid],
				ticks = {},
				}
			
			local defauldur, extdur = C:GetDefaultDuraton(spellid)
			
			self:SaveTick(guid, spellid, defauldur, floor(defauldur/self.dots[spellid..guid])+1, self.dots[spellid..guid], self.dots[spellid..guid], floor(extdur/self.dots[spellid..guid])+1)	
		end
	end
	
	function C:GetNextDotTick(guid, spellid)	
		if add_tick_table[guid..spellid] then
			
			local start 		= add_tick_table[guid..spellid][1]
			local tickstart 	= add_tick_table[guid..spellid][2]
			local ticke 		= add_tick_table[guid..spellid][3]
			local nexttick 		= tickstart + ticke
			
			return nexttick
		end
	end
	
	function C:GetDotTickEvery(guid, spellid)
		if add_tick_table[guid..spellid] then
			
			return add_tick_table[guid..spellid][3]
		end
	end
	
	function C:CountNextDotTick(guid, spellid)	
		if add_tick_table[guid..spellid] then

			self:GetTickInfo(spellid, guid)
			
			add_tick_table[guid..spellid][2] = GetTime()
			add_tick_table[guid..spellid][3] = self.dots[spellid..guid]
			
			
		end
	end
	
	function C:UpdateTicksDot(guid, spellid)	
		if add_tick_table[guid..spellid] and ( C:GetNextDotTick(guid, spellid) < GetTime() ) then 	
			return true
		end	
		
		return false
	end
	

	function C:SaveTick(guid, spellid, timer, id, every, newevery, totalamount)
		--[[
		if doprint == "print" then
		print("T2", spellid, timer, id, every, newevery, totalamount)
		end
		]]
		add_tick_table[guid..spellid].ticks[id] = timer
		
		local _maxtotal = #add_tick_table[guid..spellid].ticks+1
		
		if totalamount > _maxtotal then _maxtotal = totalamount end
		--[[
		if doprint == "print" then
		print("Current tick = ", id, timer)
		end
		]]
		for i=id+1, _maxtotal do

			add_tick_table[guid..spellid].ticks[i] = add_tick_table[guid..spellid].ticks[i-1] + every
			--[[
			if doprint == "print" then
			print("Create 1 tick = ", i, add_tick_table[guid..spellid].ticks[i])
			end
			]]
		end
	
		for i=id-1, 1, -1 do
	
			add_tick_table[guid..spellid].ticks[i] = add_tick_table[guid..spellid].ticks[i+1] - newevery
			--[[
			if doprint == "print" then
			print("Create 2 tick = ", i, add_tick_table[guid..spellid].ticks[i])
			end
			]]
		end
		
		self:GetDotInfo(spellid, guid)
	end
	
	local notable = {}
	
	function C:GetSavedTicks(guid, spellid, id)	
		if add_tick_table[guid..spellid] then
		
			return add_tick_table[guid..spellid].ticks	
		end
		
		return notable
	end
	
	function C:DoInitial(guid, spellid)	
		if add_tick_table[guid..spellid] then
			return true
		end
		return false
	end
	
	function C:RemoveDotFromDB(guid, spellid)
		add_tick_table[guid..spellid] = nil
	end
	
	function C:AddTillNextTick(guid, spellid, frame, totime)
		
		
		ticks_frame_table[spellid..guid] = totime
	end
	
end

function C:OnCombatEndReset()

	for tag, data in pairs(spelllist) do
		
		if data[11] == "DEBUFF" then
			data = nil
		end
	
	end
	
	SortBars()
end

do
	-- UTF-8 Reference:
	-- 0xxxxxxx - 1 byte UTF-8 codepoint (ASCII character)
	-- 110yyyxx - First byte of a 2 byte UTF-8 codepoint
	-- 1110yyyy - First byte of a 3 byte UTF-8 codepoint
	-- 11110zzz - First byte of a 4 byte UTF-8 codepoint
	-- 10xxxxxx - Inner byte of a multi-byte UTF-8 codepoint
	
	local char
	local string_byte = string.byte
	local sub = sub
	
	local function chsize(char)
		if not char then
			return 0
		elseif char > 240 then
			return 4
		elseif char > 225 then
			return 3
		elseif char > 192 then
			return 2
		else
			return 1
		end
	end
	 
	-- This function can return a substring of a UTF-8 string, properly handling
	-- UTF-8 codepoints.  Rather than taking a start index and optionally an end
	-- index, it takes the string, the starting character, and the number of
	-- characters to select from the string.
	 
	local function utf8sub(str, startChar, numChars)
	  local startIndex = 1
	  while startChar > 1 do
		  local char = string_byte(str, startIndex)
		  startIndex = startIndex + chsize(char)
		  startChar = startChar - 1
	  end
	 
	  local currentIndex = startIndex
	 
	  while numChars > 0 and currentIndex <= #str do
		local char = string_byte(str, currentIndex)
		currentIndex = currentIndex + chsize(char)
		numChars = numChars -1
	  end
	  return str:sub(startIndex, currentIndex - 1)
	end


	local shortCache = {}
	local tinsert = table.insert
	local gmatch = string.gmatch
	function C:getShort(text)
		
		if not shortCache[text] then
			local msg = ""
			local tbl = {}
			
			local tbl = {}
			for v in gmatch(text, "[^ :\"-]+") do
			  tinsert(tbl, v)
			end
			
			
			if #tbl > 1 then	
				for k,v in ipairs(tbl) do
					msg = msg..utf8sub(v, 1, 1)
				end
			else
				for k,v in ipairs(tbl) do
					msg = msg..v
				end
			end
			
			shortCache[text] = msg
			
			return shortCache[text]
		else
			return shortCache[text]
		end
	end	
end

local _colored = function(val)
   
   local white = val*0.81
   local black = (1-val)*0.23
   
   return white+black
end

local function UpdateBarColor(self)
	local data = self.tag and spelllist[self.tag] or nil

	local opt = self.opts
	
	local cColor = data and C:GetColor(data[5], data[14]) or opt.bar.color
	
	local r,g,b,a = cColor[1], cColor[2], cColor[3], cColor[4] or 1
	
	self.bar:SetStatusBarColor(r, g, b, a)
	
	if opt.overlays.auto then	
		self.bar.overlay2:SetTexture(_colored(r),_colored(g),_colored(b),a)
	else
		self.bar.overlay2:SetTexture(opt.overlays.color[1],opt.overlays.color[2],opt.overlays.color[3],opt.overlays.color[4])
	end
	
	self.fade_in_out_bg:SetTexture(r,g,b,0.7)
		
	if ( options.back_bar_color ) then
		self.bar.bg2:SetVertexColor(r*0.8,g*0.8,b*0.8,opt.bar.bgcolor[4])
	else
		self.bar.bg2:SetVertexColor(opt.bar.bgcolor[1], opt.bar.bgcolor[2], opt.bar.bgcolor[3], opt.bar.bgcolor[4])
	end
	
	
	self.bar.pandemi:SetTexture(opt.pandemia_color[1], opt.pandemia_color[2],opt.pandemia_color[3],opt.pandemia_color[4])	
end

function C.BarTextUpdate(self)
	local data = self.tag and spelllist[self.tag] or nil
	if not data then return end
	local opt = self.opts

	if data[23] then
		self.spellText:SetText(C.CustomTextCreate(self))
	elseif opt.target_name and data[11] ~= "BUFF" then
		if opt.short then	
			if opt.debug_info then
				self.spellText:SetText(C:getShort(data[28]).." "..tostring(data[5] or "").." "..tostring(data[11] or "").." ".. data[14])
			else
				self.spellText:SetText(C:getShort(data[28]))
			end
		else
			if opt.debug_info then
				self.spellText:SetText(data[28].." "..tostring(data[5] or "").." "..tostring(data[11] or "").." ".. data[14])
			else
				self.spellText:SetText(data[28])
			end
		end
	else
		if opt.short then
			if opt.debug_info then
				self.spellText:SetText(C:getShort(data[8]).." "..tostring(data[5] or "").." "..tostring(data[11] or "").." ".. data[14])
			else
				self.spellText:SetText(C:getShort(data[8]))
			end
		else
			if opt.debug_info then
				self.spellText:SetText(data[8].." "..tostring(data[5] or "").." "..tostring(data[11] or "").." ".. data[14])
			else
				self.spellText:SetText(data[8])
			end
		end
	end
end

function C.Timer(duration, endTime, destGuid, sourceGuid, spellID, auraID, auraType, func, raidIndex, spellName, icon, count, destName, sourceName, specialID)
	if not options.bar_module_enabled or not duration then return end
	if endTime and ( endTime ~= 0 and duration ~= 0 ) and (endTime < GetTime()) then 
	--	print("T2", endTime-GetTime(), duration, spellName)	
		return
	end
	
	local tag = GetSpellTag(destGuid,spellID,sourceGuid,auraType,auraID)	
	local sorting,start,init  = false,false,false
	local tick_every, amount_def, anount_ext

	if ( func ~= PLAYER_AURA and func ~= OTHERS_AURA ) and not endTime then
		endTime = GetTime()+duration
	end
	
	if not spelllist[tag] then
		init = true	
		spelllist[tag] = {
				nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, -- 10
				nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, -- 20
				nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, -- 30
				nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, -- 40
				nil												  -- 41
			}		
		start = true
		sorting = true
	end
	
	local data = spelllist[tag]

	local spellID = specialID or spellID
	
	if C.IsFireMage and C.SpreadSpellCast then
		local spread, guid = C.GetFireMageDotSource(destGuid, spellID)	
		if spread then			
			local datas = C.AurasSpellList[GetSpellTag(guid,spellID,sourceGuid,auraType,auraID)]			
			if datas then			
				duration = datas[1]
				endTime = datas[2]
			end
		end
	end
	
	if tonumber(spellID) then
		spellName, _, icon = GetSpellInfo(spellID)
	end

	
	if data[1] ~= duration and
		data[2] ~= endTime then
		
		if endTime > ( data[2] or 0 ) then
			start = true
		end
		sorting = true
	end
	-- [1] duration
	-- [2] endTime
	-- [3] destGGUID
	-- [4] sourceGUID
	-- [5] spellID
	-- [6] sourceUnit
	-- [7] aura counter
	-- [8] localized spellname
	-- [9] icon texture path
	-- [10] destUnit
	-- [11] auraType BUFF DEBUFF or oher custom tag
	-- [12] spelllist tag
	-- [13] Fading status
	-- [14] source of call timer
	-- [15] time when fading start
	-- [16] time when fading end
	-- [17] raid mark
	-- [18] spell priority for sorting
	-- [19] stack count
	-- [20] stack string
	-- [21] showticks
	-- [22] ticks left
	-- [23] custom text  string or false
	-- [24] tick  
	-- [25] haste  
	-- [26] pandemia
	-- [27] ticks_evert_s	
	-- [28] destName
	-- [29] sourceName
	-- [30] value_cache
	-- [31] isChanneling
	-- [32] amount_def
	-- [33] _lastupdate
	-- [34] bar
	-- [35] UA throttle
	-- [36] fading color
	-- [37] current timer
	-- [38] default duration
	-- [39] extended duration
	-- [40] sound index
	-- [41] shine show
	
	if sorting and start then
		if C:IsSingleDest(spellID) then
			for tagst, datast in pairs(spelllist) do
				if datast[4] == sourceGuid and datast[5] == spellID and datast[3] ~= destGuid then
					spelllist[tagst] = nil
				end
			end
		end
	end
	
	data[1] = duration													
	data[2] = endTime																	
	data[3] = destGuid																	
	data[4] = sourceGuid																
	data[5] = spellID																	
	data[6] = sourceUnit																
	data[7] = auraID																	
	data[8] = spellName																	
	data[9] = C:GetCustomTextureBars(spellID) or icon																		
	data[10] = destUnit																	
	data[11] = auraType																	
	data[12] = tag																			
	data[13] = NO_FADE																	
	data[14] = func																		
	data[15] = endTime + options.delayfading_wait										
	data[16] = data[15] + options.delayfading_outanim									
	data[17] = raidIndex																
	data[18] = C:GetPriority(data[5])											
	data[19] = count or 0																
	
	if sorting then
		data[20] = ""											
	else
		data[20] = data[20]
	end
	
	data[21] = C:GetShowTicks(data[5])											
	
	
	if data[21] then
		C:RegisterDotApply(destGuid, data[5])
	end
	
	if data[21] and sorting then		
		tick_every, amount_def, anount_ext = C:GetDotInfo(data[5], destGuid)
	end

	data[23] = C:GetCustomText(data[5])											
	
	data[24], data[25], data[26] = C:GetCLEUSpellInfo(data[5])

																																
	data[27] = C:GetDotTickEvery(data[3], data[5]) or tick_every	
		
	data[28] = destName																	
	data[29] = sourceName																
	
	if sorting then
		data[30] = nil																	
	else
		data[30] = data[30]
	end
	
	data[31] = C:IsChanneling(data[5])											
	
	if data[21] and sorting then data[32] = amount_def end
																				
	if sorting then
		data[34] = nil
	end
	
	if data[34] then data[34]:SetCount(data[19]) end
	
	data[35] = GetTime()+0.5
	
	if C.onUpdateHandler.active and destGUID then
		C.targetEngaged[destGUID] = GetTime()+options.engageThrottle
	end
	
	data[36] = DO_FADE_NORNAL
	
	if not data[37] then
		data[37] = data[1]
	end
	
	if init then
		data[38], data[39] = C:GetDefaultDuraton(spellID)
	end
	
	if sorting then
		data[41] = options.shine_on_apply
	end
	
	if sorting then SortBars() end
	
	if start and not data[SOUND_INDEX] then OnTimerStart(tag) end
end

function C.Timer_DOSE(destGuid, sourceGuid, spellID, auraID, auraType, func, raidIndex, count)
	
	local tag = GetSpellTag(destGuid,spellID,sourceGuid,auraType,auraID)--( destGuid or NO_GUID )..tostring(spellID)..( sourceGuid or NO_GUID )..auraType.."-"..auraID

	if spelllist[tag] then
		spelllist[tag][14] = func																		-- [14] source of call timer
		spelllist[tag][17] = raidIndex
		spelllist[tag][19] = count or 0
		
		if spelllist[tag][34] then			
			spelllist[tag][34]:SetCount(count)
		end
	end
end

function C.Timer_Remove(destGuid, sourceGuid, spellID, auraID, auraType, instant, nored)
	
	local tag = GetSpellTag(destGuid,spellID,sourceGuid,auraType,auraID) --( destGuid or NO_GUID )..tostring(spellID)..( sourceGuid or NO_GUID )..auraType.."-"..auraID
	local sorting = false
	if spelllist[tag] then	
		if options.delayfading and not instant then
			local curtime = GetTime()
			if spelllist[tag][13] == NO_FADE then
				OnTimerEnd(tag)
				if spelllist[tag][2] > curtime+0.2 and not nored then
					spelllist[tag][36] = DO_FADE_RED
				else
					spelllist[tag][36] = DO_FADE_NORMAL
				end
				
				spelllist[tag][13] = DO_FADE
	
				spelllist[tag][15] = curtime + options.delayfading_wait
				spelllist[tag][16] = spelllist[tag][15]+ options.delayfading_outanim
			end
		else
			OnTimerEnd(tag)
			spelllist[tag][13] = FADED
			sorting = true
		end
	end
	
	if sorting then SortBars() end
end

function C.Timer_Remove_By_Tag(tag, instant)
	
	local sorting = false
	if spelllist[tag] then	
		if options.delayfading and not instant then
			local curtime = GetTime()
			if spelllist[tag][13] == NO_FADE then
				OnTimerEnd(tag)
				if spelllist[tag][2] > curtime+0.2 then
					spelllist[tag][36] = DO_FADE_RED
				else
					spelllist[tag][36] = DO_FADE_NORMAL
				end
				
				spelllist[tag][13] = DO_FADE
				
				spelllist[tag][15] = curtime + options.delayfading_wait
				spelllist[tag][16] = spelllist[tag][15]+ options.delayfading_outanim
			end
		else
			OnTimerEnd(tag)
			spelllist[tag][13] = FADED
			sorting = true
		end
	end
	
	if sorting then SortBars() end
end

function C.Timer_Remove_DEAD(destGUID, dored)
	local sorting = false
	
	for tag, data in pairs(spelllist) do
		if data[3] == destGUID then
			if data then	
				if options.delayfading then			
					if data[13] == NO_FADE then
						OnTimerEnd(tag)
						if data[2] > GetTime()+0.2 and not dored then
							data[36] = DO_FADE_RED
						else
							data[36] = DO_FADE_NORMAL
						end
						
						data[13] = DO_FADE
				
						data[15] = GetTime() + options.delayfading_wait
						data[16] = data[15]+ options.delayfading_outanim
					end
				else
					OnTimerEnd(tag)
					spelllist[tag][13] = FADED
					sorting = true
				end
			end
		end
	end
	
	if sorting then SortBars() end
end

function C.RemoveGUID_UA(guid, auraType, func, curtime)
	local sorting = false
	
	
	for tag, data in pairs(spelllist) do
	
	--	print("Remove UA", data[8], data[13], NO_FADE)
	
		if data[3] == guid and data[11] == auraType and data[14] == func and data[35] < curtime then
			if options.delayfading then
				if data[13] == NO_FADE then
					if data[1] == 0 and data[2] == 0 then
						data[13] = DO_FADE_UNLIMIT
					elseif data[2] > curtime+0.2 then
						data[36] = DO_FADE_RED
						data[13] = DO_FADE
					else
						data[36] = DO_FADE_NORMAL
						data[13] = DO_FADE
					end
	
					
					data[15] = curtime + options.delayfading_wait
					data[16] = data[15]+ options.delayfading_outanim
					
					
					OnTimerEnd(tag) 
				end

			else
			--	OnTimerEnd(tag, "733")
				OnTimerEnd(tag)
				spelllist[tag][13] = FADED
				sorting = true			
			end
		end		
	end
	
	if sorting then SortBars() end
end


function C.SetCount(self, count)
	local data = self.tag and spelllist[self.tag] or nil
	if not data then return end
		
	if count ~= "tick" then
		count = count or C:GetCheckStacks(data[5]) or 0
			
		data[20] = count > 1 and count or ""
		
		data[19] = count
	end
	
	if data[21] and options.tick_count_on_stacks then
		
		if count == "tick" or data[22] then
			self.icon.stacktext:SetText(data[22])
			self.icon2.stacktext:SetText(data[22])
		else 
		
			self.icon.stacktext:SetText(data[20])
			self.icon2.stacktext:SetText(data[20])
		end
	else
		
		self.icon.stacktext:SetText(data[20])
		self.icon2.stacktext:SetText(data[20])
	
	end
end

do
	local raidIndexCoord = {
		[1] = { 0, .25, 0, .25 }, --"STAR"
		[2] = { .25, .5, 0, .25}, --MOON
		[3] = { .5, .75, 0, .25}, -- CIRCLE
		[4] = { .75, 1, 0, .25}, -- SQUARE
		[5] = { 0, .25, .25, .5}, -- DIAMOND
		[6] = { .25, .5, .25, .5}, -- CROSS
		[7] = { .5, .75, .25, .5}, -- TRIANGLE
		[8] = { .75, 1, .25, .5}, --  SKULL
	}
	
	
	--[[
	{ text = RAID_TARGET_1, tCoordLeft = 0, tCoordRight = 0.25, tCoordTop = 0, tCoordBottom = 0.25 };
	{ text = RAID_TARGET_2, tCoordLeft = 0.25, tCoordRight = 0.5, tCoordTop = 0, tCoordBottom = 0.25 };
	{ text = RAID_TARGET_3, tCoordLeft = 0.5, tCoordRight = 0.75, tCoordTop = 0, tCoordBottom = 0.25 };
	{ text = RAID_TARGET_4, tCoordLeft = 0.75, tCoordRight = 1, tCoordTop = 0, tCoordBottom = 0.25 };
	{ text = RAID_TARGET_5, tCoordLeft = 0, tCoordRight = 0.25, tCoordTop = 0.25, tCoordBottom = 0.5 };
	{ text = RAID_TARGET_6, tCoordLeft = 0.25, tCoordRight = 0.5, tCoordTop = 0.25, tCoordBottom = 0.5 };
	{ text = RAID_TARGET_7, tCoordLeft = 0.5, tCoordRight = 0.75, tCoordTop = 0.25, tCoordBottom = 0.5 };
	{ text = RAID_TARGET_8, tCoordLeft = 0.75, tCoordRight = 1, tCoordTop = 0.25, tCoordBottom = 0.5 };
	
	]]

	function C.SetMark(self, mark)
	
		if ( mark and mark > 0 and mark < 9 ) and options.show_mark then
			if self.raidMark:IsShown() then
				self.raidMark:SetTexCoord(raidIndexCoord[mark][1],raidIndexCoord[mark][2],raidIndexCoord[mark][3],raidIndexCoord[mark][4])
			else
				self.raidMark:Show()
				self.raidMark:SetTexCoord(raidIndexCoord[mark][1],raidIndexCoord[mark][2],raidIndexCoord[mark][3],raidIndexCoord[mark][4])
			end
		else
			self.raidMark:Hide()
		end
	end
end	
		
do
	
	function C:updateSortings()
		SortBars(true)
	end
	
	local labels = {}

	
	local function SetLabel(self, number, size, bar)
	
		self.labels[number] = size or 1

		if bar then
			self._bars[number] = bar
		end
	end
	
	function C:UpdateLabelStyle()
		
		for i=1, #labels do
			
			local opt = labels[i]:GetParent().opts
			
			if opt then
				labels[i].text:SetJustifyH(opt.group_font_style.justify)
				labels[i].text:SetFont(C.LSM:Fetch("font",opt.group_font_style.font), opt.group_font_style.size, opt.group_font_style.flags)	
				labels[i].text:SetShadowColor(opt.group_font_style.shadow[1],opt.group_font_style.shadow[2],opt.group_font_style.shadow[3],opt.group_font_style.shadow[4])
				labels[i].text:SetShadowOffset(opt.group_font_style.offset[1],opt.group_font_style.offset[2])
				
				C.UpdateIconTextPostition(labels[i]:GetParent())
				
			end
		end
	end

	local function UpdateLabel(self)
		local totalsize = 0
	
		local header = self.show_header and self.size*1.5+self.gap_newgroup or self.gap_newgroup
		local a, a2 = 1, 1
		
		local fading = true
		
		for i=1, #self.labels do
			if self.labels[i] >= 1 then
				fading = false
				break
			end
		end

		for i=1, #self.labels do
			local startfrom = fading and header*self.labels[1] or header
			local barheight = (self.h+self.gap_normal)*self.labels[i]
			if self.parentopt.add_up then  -- рост вверх
				self._bars[i]:Hide()
				if self.parentopt.group_grow_up then -- плашка сверху
					self._bars[i]:SetPoint("BOTTOM", self, "BOTTOM", 0, totalsize)	
					totalsize = totalsize + barheight
				else -- плашка снизу
					self._bars[i]:SetPoint("BOTTOM", self, "BOTTOM", 0, startfrom+totalsize)
					totalsize = totalsize + barheight
				end
				self._bars[i]:Show()
			else	-- рост вниз
				self._bars[i]:Hide()
				if self.parentopt.group_grow_up then	-- плашка сверху
					self._bars[i]:SetPoint("TOP", self, "TOP", 0, -startfrom-totalsize)
					totalsize = totalsize + barheight
				else	-- плашка снизу
					self._bars[i]:SetPoint("TOP", self, "TOP", 0, -totalsize)
					totalsize = totalsize + barheight
				end			
				self._bars[i]:Show()
			end
		end
			
		if fading then
			a = 1*self.labels[1]			
			a2 = a-0.3
			if a2 < 0 then a2 = 0 end
			totalsize = totalsize + ( header * self.labels[1] ) 
		else
			totalsize = totalsize + header
		end
		
		self.text:SetAlpha(a2)
		self:SetAlpha(a)
		self:SetHeight(totalsize)	
	end
	

		
	function C:NewUpdateLabels()
	
		for i=1, #labels do	
			if not labels[i].free and #labels[i]._bars > 0 then
				labels[i]:UpdateLabel()
			end
		end
	end
	
	local function CreateGUIBarBG(parent)
		
		for i=1, #labels do	
			if labels[i].free then
				return labels[i]
			end
		end
		
		local f = CreateFrame("Frame",nil, parent)
		f:SetFrameStrata("LOW")
		
		local opt = parent.opts
		
		local b = f:CreateTexture(nil, "BACKGROUND", nil, 0)
		
		local b3 = f:CreateTexture(nil, "BACKGROUND", nil, 0)
		b3:SetAllPoints()
		b3:SetTexture(0,0,1,0)
		
		local b2 = f:CreateTexture(nil, "BACKGROUND", nil, 0)
		b2:SetTexture(1,0,0,0)
		
		local ft = f:CreateFontString(nil, "OVERLAY");
	
		ft:SetJustifyV("CENTER")
		
		ft:SetJustifyH(opt.group_font_style.justify)
		ft:SetFont( C.LSM:Fetch("font",opt.group_font_style.font), opt.group_font_style.size, opt.group_font_style.flags)	
		ft:SetShadowColor(opt.group_font_style.shadow[1],opt.group_font_style.shadow[2],opt.group_font_style.shadow[3],opt.group_font_style.shadow[4])
		ft:SetShadowOffset(opt.group_font_style.offset[1],opt.group_font_style.offset[2])
	
		f.text = ft
		f.text.bg = b2
		f.labels = {}
		f._bars = {}
		f.newfading = true
		
		f.SetLabel = SetLabel
		f.UpdateLabel = UpdateLabel
		f.background = b
		
		f.free = true
		
		labels[#labels+1] = f
		
		return f						
	end

	local function GetGUIDBarBG(parent, to, title, gap, unit)
	
		local f = CreateGUIBarBG(parent)
		
		local curparent = not ( f:GetParent() == parent )
	
		f:SetParent(parent)
		f.free = false
		
		local opt = parent.opts
		
		f.parentopt = opt
		f.h = opt.h
		f.w = opt.w
		f.gap_normal = opt.gap
		f.gap_newgroup = gap
		f.show_header = opt.show_header
		f.size = opt.group_font_style.size
		f.newfading = true
		
		if curparent then

			f.text:SetJustifyH(opt.group_font_style.justify)
			f.text:SetFont(C.LSM:Fetch("font",opt.group_font_style.font), opt.group_font_style.size, opt.group_font_style.flags)	
			f.text:SetShadowColor(opt.group_font_style.shadow[1],opt.group_font_style.shadow[2],opt.group_font_style.shadow[3],opt.group_font_style.shadow[4])
			f.text:SetShadowOffset(opt.group_font_style.offset[1],opt.group_font_style.offset[2])
			
			C.UpdateIconTextPostition(parent)
		end
		
		f:SetSize(f.w, 1)

		f.text:SetSize(f.w, f.size*1.2) --,f.h)	
		
		-- рост вверх, отступ между группами, отступ между барами, высота верхушки

		local parentanchor = parent == to
		
		if opt.add_up then
			if opt.group_grow_up then	-- плашка сверху
				f:SetPoint("BOTTOM", to, "TOP", 0, 0)
				f.background:SetPoint("TOP", f, "TOP", 0, -gap-opt.gap)
				f.background:SetPoint("BOTTOM", f, "BOTTOM", 0, 0)				
			--	print("T", parentanchor, opt.add_up, gap, opt.gap, f.size, abs(gap-opt.gap))
			else
				f:SetPoint("BOTTOM", to, "TOP", 0, parentanchor and -gap or 0)
				f.background:SetPoint("TOP", f, "TOP", 0, -opt.gap)
				f.background:SetPoint("BOTTOM", f, "BOTTOM", 0, gap)
			end
		else	
			if opt.group_grow_up then	-- плашка сверху готова
				f:SetPoint("TOP", to, "BOTTOM", 0, parentanchor and gap or 0)
				f.background:SetPoint("TOP", f, "TOP", 0, -gap)
				f.background:SetPoint("BOTTOM", f, "BOTTOM", 0, opt.gap)
			else -- плашка снизу готова
				f:SetPoint("TOP", to, "BOTTOM", 0, 0)	
				f.background:SetPoint("TOP", f, "TOP", 0, 0)
				f.background:SetPoint("BOTTOM", f, "BOTTOM", 0, gap+opt.gap)
			end
		end
	
		f.background:SetPoint("LEFT", parent.mover, "LEFT")
		f.background:SetPoint("RIGHT", parent.mover, "RIGHT")
	
		if unit == "target" then
			f.group_color = opt.group_bg_target_color
		elseif unit == "focus" then
			f.group_color = opt.group_bg_focus_color
		else
			f.group_color = opt.group_bg_offtargets_color
		end
	
		f.background:SetTexture(f.group_color[1],f.group_color[2],f.group_color[3],f.group_color[4])
		
		if opt.group_bg_show then f.background:Show() else f.background:Hide() end

		f.text:ClearAllPoints()

		if ( opt.group_grow_up ) then  
			f.text:SetPoint("TOP", f.background, "TOP", 0, 1)			
			f.text:SetJustifyV("BOTTOM")
		else		
			f.text:SetPoint("BOTTOM", f.background, "BOTTOM", 0, -1)				
			f.text:SetJustifyV("TOP")
		end
	
		if f.show_header then
			f.text:SetText(title or "TEST_TITLE")
			
			if unit == "focus" then
				f.text:SetTextColor(opt.group_font_focus_color[1],opt.group_font_focus_color[2], opt.group_font_focus_color[3],1)
			else
				f.text:SetTextColor(opt.group_font_target_color[1],opt.group_font_target_color[2], opt.group_font_target_color[3],1)
			end
			if opt.group_bg_show then f.text.bg:Show() else f.text.bg:Hide() end
		else
			f.text:SetText("")
			f.text.bg:Hide()
		end

		f:Show()

		return f
	end

	local function ClearAllGUIDBarBGs()
		for i=1, #labels do	
			if not labels[i].free then	
				wipe(labels[i].labels)
				wipe(labels[i]._bars)
				labels[i].free = true
				labels[i].prev = nil
				labels[i]:ClearAllPoints()
				labels[i]:Hide()
			end
		end	
	end

	local sorting_functions = {
		function(x,y)		-- 1 priority from lower to upper
			if x[18] == y[18] then
				if x[1] == y[1] then
					return x[2] > y[2]
				else
					return x[1] > y[1]
				end
			else
				return y[18] < x[18]
			end
		end,
		function(x,y)		-- 2 endtime from upper to lower
			if x[2] == y[2] then
				return x[1] < y[1]
			else
				return x[2] < y[2]
			end		
		end,
		function(x,y)		-- 3 endtime from lower to upper
			if x[2] == y[2] then
				return x[1] > y[1]
			else
				return x[2] > y[2] 
			end		
		end,
	}

	function C:UpdateFormatTexts(anchor)
		for k,v in pairs(anchors) do
			
			if v.id == anchor then
				
				v.opts = self.db.profile.bars_anchors[anchor]
				
				for i, timer in ipairs(v.bars) do	
					timer:BarTextUpdate()
				end
			
			end
		end
	end
	
	local function CheckSpell(tag)
	
	--	if not spelllist[tag] then return false end
		
		if C:GetTargetType(spelllist[tag][5]) == 1 and spelllist[tag][3] ~= C.CurrentTarget then 
			spelllist[tag] = nil; 
			return false 
		end
		
		if not C:UnitFilter_GUID(spelllist[tag][3]) then 
			spelllist[tag] = nil; 
			return false 
		end
		--[[
		if spelllist[tag][1] == 0 and spelllist[tag][2] == 0 and spelllist[tag][13] ~= FADED then 
			return true 
		end
		]]
		
		if spelllist[tag][13] == NO_FADE or spelllist[tag][13] == DO_FADE then
			return true
		end
		--[[
		if spelllist[tag][13] == FADED then 
			spelllist[tag] = nil; 
			return false 			
		end
		]]
		--[[
		if options.delayfading and spelllist[tag][16] > GetTime() then 
			return true 
		end
		]]
		--[[
		if spelllist[tag][2] > GetTime() then 
			return true 
		end
		]]
		OnTimerEnd(tag)
		
		spelllist[tag] = nil
	
		return false
	end

	local loop = CreateFrame("Frame", "C-Bar-OnUpdateV2-Loop")
	loop.last = GetTime()
	loop.elapsed = 0
	loop:Hide()
	loop:SetScript("OnUpdate", function(self, elapsed)
		self.elapsed = self.elapsed + elapsed
		if self.elapsed == 0 then return end
		self:Hide()
		self.elapsed = 0
		SortBars(true)
	end)

	local function GetAnchor(spellid, destGUID, auraType, func)
		local group = C:GetGroup(spellid)
		
		if func == "TEST_BAR" then
			local anchor = tonumber(stmatch(auraType, "TEST_BAR(%d+)")) or 1
			
			if destGUID == "group1" then
				return anchor, "player"
			elseif destGUID == "group2" then
				return anchor, "target"
			else
				return anchor, "offtargets"
			end			
		elseif group then
			return C:GetAnchor(spellid, destGUID), group
		elseif func == COOLDOWN_SPELL then
			return C:GetAnchor(spellid, COOLDOWN_SPELL), "cooldowns"
		elseif destGUID == C.myGUID then
			return C:GetAnchor(spellid, destGUID), "player"
		elseif options.doswap then
			if destGUID == C.CurrentTarget or func == CHANNEL_SPELL or destGUID == UnitGUID("target") then
				return C:GetAnchor(spellid, destGUID), "target", C:GetUnitAlwaysShowAnchor(spellid, destGUID)
			else
				return C:GetOffAnchor(spellid, destGUID), "offtargets", C:GetUnitAlwaysShowAnchor(spellid, destGUID)
			end
		elseif destGUID == nil then
			if auraType == "BUFF" then
				return C:GetOffAnchor(spellid, destGUID), "player"
			else
				return C:GetOffAnchor(spellid, destGUID), "target"
			end
		end
		
		if destGUID == C.CurrentTarget or func == CHANNEL_SPELL or destGUID == UnitGUID("target") then
			return C:GetAnchor(spellid, destGUID), "offtargets", C:GetUnitAlwaysShowAnchor(spellid, destGUID)
		else
			return C:GetOffAnchor(spellid, destGUID), "offtargets", C:GetUnitAlwaysShowAnchor(spellid, destGUID)
		end
			
	--	return C:GetOffAnchor(spellid, destGUID), "offtargets", C:GetUnitAlwaysShowAnchor(spellid, destGUID)
	end
	
	local raidIdToString = {
		"|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_1:11:11:0:-5|t",
		"|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_2:11:11:0:-5|t",
		"|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_3:11:11:0:-5|t",
		"|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_4:11:11:0:-5|t",
		"|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_5:11:11:0:-5|t",
		"|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_6:11:11:0:-5|t",
		"|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_7:11:11:0:-5|t",
		"|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_8:11:11:0:-5|t",
	}

	function C.UpdateIconTextPostition(parent)
		local opts = parent.opts
		local size = opts.group_font_style.size

		for i=1, 8 do	
			raidIdToString[i] = format("|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_%d:%d:%d:%d:%d|t", i, 11, 11, 0, -size*0.3)
		end
	end
	
	local group_def_Names = {
		["target"] 		= L["Target"],
		["player"] 		= L["Player"],
		["procs"] 		= L["Procs"],
		["cooldowns"] 	= L["Cooldowns"],
		["offtargets"] 	= L["Offtarget"],
	}
	
	local UNKNOWN = UNKNOWN
	
	local function GetGroupHeaderName(anchor, datas, group_name, indexs)
		local opts = anchor.opts
		
		local config = opts.header_custom_text[group_name]
		--[[
		header_custom_text = {
			["target"] 		= { 1, "%target" },
			["player"] 		= { 1, "%player" },
			["procs"] 		= { 1, "%player" },
			["cooldowns"] 	= { 1, "%player" },
			["offtargets"] 	= { 1, "%id : %target" },	
		},
		]]
		
		if config[1] == 1 then
			return group_def_Names[group_name]
		elseif config[1] == 2 then
			return datas[28] or datas[29]
		elseif config[1] == 3 then
			local text = config[2]
			
			text = gsub(text,"%%target", datas[28] or datas[29])
			text = gsub(text,"%%id", indexs or 1)
			text = gsub(text,"%%player", C.myNAME)
			text = gsub(text,"%%mark",  datas[17] and raidIdToString[datas[17]] or "")
			
			return text
		else		
			return UNKNOWN
		end
		
	end
	
	local function UpdateBar(anchor, label, f, data, group_alpha, unit)
		local opts = anchor.opts
		local bar = anchor.bars[anchor.index]
		bar.tag = data[12]
		bar.data = data
		spelllist[bar.tag][34] = bar
		bar._groupalpha = group_alpha
		bar:SetAlpha(group_alpha)
		
		local header = opts.show_header and label.size*1.5+label.gap_newgroup or label.gap_newgroup

		local startfrom = fading and header*1 or header
		local barheight = (label.h+label.gap_normal)*anchor.index
		
		bar:ClearAllPoints()
		
		if opts.add_up then  -- рост вверх
			if opts.group_grow_up then -- плашка сверху				
				bar:SetPoint("BOTTOM", label, "BOTTOM", 0, barheight)
			else -- плашка снизу
				bar:SetPoint("BOTTOM", label, "BOTTOM", 0, startfrom+barheight)
			end
		else	-- рост вниз
			if opts.group_grow_up then	-- плашка сверху	
				bar:SetPoint("TOP", label, "TOP", 0, -startfrom-barheight)
			else	-- плашка снизу
				bar:SetPoint("TOP", label, "TOP", 0, -barheight)
			end			
		end
		
		
		label:SetLabel(f, nil, bar)		
		bar._label = label
		bar.index = f
		bar:SetMark(data[17])
		bar:BarTextUpdate()							
		bar:SetCount(data[19])							
		bar.icon.texture:SetTexture(data[9])
		bar.icon2.texture:SetTexture(data[9])
		bar:UpdateBarColor()
		
		if data[1] > anchor._maxmax then 
			anchor._maxmax = data[1]
		end

		bar._elapsed = 1
		bar.__elapsed = 1
	end
	
	local function UpdateAnchor(index)
		
		local anchor = anchors[index]
		
		if anchor.disabled == true then return end

		local prev
		anchor.index = 0
	
		local opts = anchor.opts
		
		local sort_func = sorting_functions[opts.sort_func or 1]
		
		for guid, tags in pairs(anchor.group_guid) do
			tsort(tags, sort_func)
		end
		
		tsort(anchor.group.target, sort_func)
		tsort(anchor.group.player, sort_func)

		local label = nil
		
		anchor._maxmax = 0
		
		for s=1, #anchor.sorting do
			local group_name  = anchor.sorting[s].name
			local group_alpha = anchor.sorting[s].alpha
			local group_gap   = anchor.sorting[s].gap
	
			if anchor.index >= opts.bar_number then break end
			if not anchor.sorting[s].disabled then
			
				if group_name == "offtargets" then
					prev = nil
					local indexes = 0
					
					for guid, datas in pairs(anchor.group_guid) do
						if anchor.index >= opts.bar_number then break end
						
						if not prev or not label then
							indexes = indexes + 1
							label = GetGUIDBarBG(anchor, ( label or anchor ), GetGroupHeaderName(anchor,datas[1], group_name, indexes), group_gap, ( guid == C.CurrentTarget and "target" ) or ( guid == C.FocusTarget and "focus" ))						
						elseif prev ~= guid then
							indexes = indexes + 1
							label = GetGUIDBarBG(anchor, ( label or anchor ), GetGroupHeaderName(anchor,datas[1], group_name, indexes), group_gap, ( guid == C.CurrentTarget and "target" ) or ( guid == C.FocusTarget and "focus" ))
						end
				
						for f=1, #datas do
							if anchor.index >= opts.bar_number then break end
							
							anchor.index = anchor.index + 1
							
							UpdateBar(anchor, label, f, datas[f], ( ( not options.doswap and ( datas[f][3] == C.CurrentTarget or datas[f][3] == UnitGUID("target")) and 1 or group_alpha) ))

							prev = guid
						end
					end
					
					break
				else
					local group2 = anchor.group[group_name]
					prev = nil
					
					for f=1, #group2 do
						if anchor.index == opts.bar_number then break end
						
						if not prev or not label then
							label = GetGUIDBarBG(anchor, ( label or anchor ),GetGroupHeaderName(anchor,group2[1], group_name,1) , group_gap, group_name)						
						elseif prev ~= group_name then
							label = GetGUIDBarBG(anchor, ( label or anchor ),GetGroupHeaderName(anchor,group2[1], group_name,1) , group_gap, group_name)
						end
						
						anchor.index = anchor.index + 1
						
				--		print("T", group2[f], group2[f][3], group2[f][12])
						
						UpdateBar(anchor, label, f, group2[f], group_alpha)
						
						prev = group_name
					end
			
				end
			end
		end

		local curtime = GetTime()
		
		for s=1, anchor.index do
	
			if anchor.bars[s].tag and spelllist[anchor.bars[s].tag][21] then
				anchor.bars[s]:SetTicks(true, "UpdateBar")
			end
			
			anchor.bars[s]:Restore()
			anchor.bars[s]:OnUpdateText(0, curtime)
			anchor.bars[s]:Update(curtime)
			anchor.bars[s]:Fading(curtime)
			anchor.bars[s]:bgFade(curtime)
			anchor.bars[s]:Show()
			
			if spelllist[anchor.bars[s].tag][41] then
				anchor.bars[s].barShine_ag:Play()
				spelllist[anchor.bars[s].tag][41] = false
			end
		end

		for f=anchor.index+1, opts.bar_number do
			anchor.bars[f].tag = nil
			anchor.bars[f]:Hide()
		end
		
		if not C.newOnUpdate:IsShown() then
			C.newOnUpdate:Show()
		end
	end

	function SortBars(update)
		
		
		if not update then
			loop:Show()
			return
		end

		ClearAllGUIDBarBGs()
		
		for i=1, #anchors do
			
			wipe(anchors[i].group_guid)
			wipe(anchors[i].group.target)
			wipe(anchors[i].group.player)
			wipe(anchors[i].group.procs)
			wipe(anchors[i].group.cooldowns)
		end
		
		for tag, data in pairs(spelllist) do
		
			if data and CheckSpell(tag) then

				local achor_, group, copy_to1, copy_to2, copy_to3 = GetAnchor(data[5], data[3], data[11], data[14])

				if copy_to2 and achor_ ~= copy_to2 then
					anchors[copy_to2].group[group][#anchors[copy_to2].group[group]+1] = data
				end
				
				if copy_to3 and achor_ ~= copy_to3 then
					anchors[copy_to3].group[group][#anchors[copy_to3].group[group]+1] = data
				end
				
				if group == "offtargets" then
					if not anchors[achor_].group_guid[data[3]] then anchors[achor_].group_guid[data[3]] = {} end
					anchors[achor_].group_guid[data[3]][#anchors[achor_].group_guid[data[3]]+1] = data
				else
					anchors[achor_].group[group][#anchors[achor_].group[group]+1] = data		
				end
			end
		end
		
		
		for i=1, #anchors do
			UpdateAnchor(i)
		end
	
		C:NewUpdateLabels()
	end

	C.SortBars = SortBars
end

function C.UpdateBarSize(self)	
	local opt = options.bars_anchors[self.parent.id]
	self.opts = opt
	
--	print("T", opt.w, self.parent.id)
	self:SetSize(opt.w or 100 , opt.h or 20)

	self.bar.overlay2:SetHeight(opt.h)
	
	self.bar:SetReverseFill(opt.reverse_fill)
	self.bar:SetStatusBarTexture(C.LSM:Fetch("statusbar", opt.bar.texture))
	self.bar:SetStatusBarColor(unpack(opt.bar.color))

	self.bar:ClearAllPoints()
	
	-- opt.gap
	
	if opt.add_up then
		self.bar:SetPoint("TOP", self, "TOP", 0, 0)
	else
		self.bar:SetPoint("BOTTOM", self, "BOTTOM", 0, 0)
	end
	
	local _left, _right = 0, 0
	
	if opt.left_icon then
		_left = _left + opt.h + opt.icon_gap
	end
	
	if opt.right_icon then
		_right = _right + opt.h + opt.icon_gap
	end
	
	self.icon:SetSize(opt.h, opt.h)

	self.icon2:SetSize(opt.h, opt.h)
	
	
	self.parent:ClearAllPoints()
	self.parent:SetPoint("CENTER", self.parent.mover,"CENTER", (_left/2) - (_right/2) , 0)
	self.parent:SetSize(1,opt.h+5)
	
	
	self.bar:SetSize(opt.w-_left-_right,opt.h)
	self.parent.mover:SetSize(opt.w, opt.h)
end

function C.UpdateIcons(f)
	local opt = options.bars_anchors[f.parent.id]
	f.opts = opt
	
	if opt.left_icon then f.icon:Show()
	else f.icon:Hide() end
	
	if opt.right_icon then f.icon2:Show()
	else f.icon2:Hide() end
	
	f.icon:SetSize(opt.h, opt.h)

	f.icon2:SetSize(opt.h, opt.h)
	
	f.icon:SetPoint("TOPRIGHT",f.bar,"TOPLEFT",-opt.icon_gap, 0)
	f.icon:SetPoint("BOTTOMRIGHT",f.bar,"BOTTOMLEFT",-opt.icon_gap, 0)
	
	f.icon2:SetPoint("TOPLEFT",f.bar,"TOPRIGHT",opt.icon_gap, 0)
	f.icon2:SetPoint("BOTTOMLEFT",f.bar,"BOTTOMRIGHT",opt.icon_gap, 0)
	
	local _left, _right = 0, 0
	
	if opt.left_icon then
		_left = _left + opt.h + opt.icon_gap
	end
	
	if opt.right_icon then
		_right = _right + opt.h + opt.icon_gap
	end
	
	f.parent:ClearAllPoints()
	f.parent:SetPoint("CENTER", f.parent.mover,"CENTER", (_left/2) - (_right/2) , 0)
	f.parent:SetSize(1,opt.h+5)
	
	f.parent.mover:SetSize(opt.w, opt.h)
end
function C.UpdateStackText(f)
	local opt = options.bars_anchors[f.parent.id]
	f.opts = opt
	
	f.icon.stacktext:SetPoint("RIGHT", f.icon, "RIGHT",4,0)
	f.icon.stacktext:SetPoint("LEFT", f.icon, "LEFT",-8,0)
	f.icon.stacktext:SetPoint("BOTTOM", f.icon, "BOTTOM",0,0)	
	f.icon.stacktext:SetTextColor(unpack(opt.stack.textcolor))
	f.icon.stacktext:SetFont(C.LSM:Fetch("font",opt.stack.font),opt.stack.size,opt.stack.flags)
	f.icon.stacktext:SetJustifyH(opt.stack.justify)
	f.icon.stacktext:SetAlpha(opt.stack.alpha or 1)
	f.icon.stacktext:SetShadowColor(unpack(opt.stack.shadow or { 0, 0, 0, 1 }))
	f.icon.stacktext:SetShadowOffset(opt.stack.offset and opt.stack.offset[1] or 0,opt.stack.offset and opt.stack.offset[2] or 0)
	
	
	f.icon2.stacktext:SetPoint("RIGHT", f.icon2, "RIGHT",8,0)
	f.icon2.stacktext:SetPoint("LEFT", f.icon2, "LEFT",-4,0)
	f.icon2.stacktext:SetPoint("BOTTOM", f.icon2, "BOTTOM",0,0)
	f.icon2.stacktext:SetTextColor(unpack(opt.stack.textcolor))
	f.icon2.stacktext:SetFont(C.LSM:Fetch("font",opt.stack.font),opt.stack.size,opt.stack.flags)
	f.icon2.stacktext:SetJustifyH(opt.stack.justify)
	f.icon2.stacktext:SetAlpha(opt.stack.alpha or 1)
	f.icon2.stacktext:SetShadowColor(unpack(opt.stack.shadow or { 0, 0, 0, 1 }))
	f.icon2.stacktext:SetShadowOffset(opt.stack.offset and opt.stack.offset[1] or 0,opt.stack.offset and opt.stack.offset[2] or 0)

end
function C.UpdateTimeText(f)
	local opt = options.bars_anchors[f.parent.id]
	f.opts = opt

	f.timeText:SetTextColor(unpack(opt.timer.textcolor))
    f.timeText:SetFont(C.LSM:Fetch("font",opt.timer.font), opt.timer.size, opt.timer.flags)
    f.timeText:SetJustifyH(opt.timer.justify)
    f.timeText:SetAlpha(opt.timer.alpha or 1)
	
	f.timeText:SetWidth(opt.timer.size*4)

	f.timeText:SetShadowColor(unpack(opt.timer.shadow or { 0, 0, 0, 1 }))
	f.timeText:SetShadowOffset(opt.timer.offset and opt.timer.offset[1] or 0,opt.timer.offset and opt.timer.offset[2] or 0)
	
	if not opt.lefttext then
		f.timeText:ClearAllPoints()
		f.timeText:SetPoint("TOP", f.bar, "TOP")
		f.timeText:SetPoint("BOTTOM", f.bar, "BOTTOM")
		f.timeText:SetPoint("RIGHT", f.bar, "RIGHT",0,0)
	else
		f.timeText:ClearAllPoints()
		f.timeText:SetPoint("TOP", f.bar, "TOP")
		f.timeText:SetPoint("BOTTOM", f.bar, "BOTTOM")
		f.timeText:SetPoint("LEFT", f.bar, "LEFT", 0,0)
	end
	
  --  f.timeText:SetVertexColor(unpack(opt.timer.vertexcolor))
end
function C.UpdateSpellText(f)
	local opt = options.bars_anchors[f.parent.id]
	f.opts = opt

	f.spellText:SetDrawLayer("ARTWORK")

	f.spellText:SetTextColor(unpack(opt.spell.textcolor))
    f.spellText:SetFont(C.LSM:Fetch("font",opt.spell.font),opt.spell.size,opt.spell.flags)
--    f.spellText:SetWidth(f.bar:GetWidth()*0.8)
 --   f.spellText:SetHeight(opt.h/2+1)
	f.spellText:SetWordWrap(false)
    f.spellText:SetJustifyH(opt.spell.justify)
    f.spellText:SetAlpha(opt.spell.alpha or 1)
	
	f.spellText:SetShadowColor(unpack(opt.spell.shadow or { 0, 0, 0, 1 }))
	f.spellText:SetShadowOffset(opt.spell.offset and opt.spell.offset[1] or 0,opt.spell.offset and opt.spell.offset[2] or 0)
	
	if not opt.lefttext then
	
		-- таймер справа
		f.spellText:ClearAllPoints()		
		f.spellText:SetPoint("LEFT", f.bar, "LEFT", opt.spell.offsetx,0)
		f.spellText:SetPoint("RIGHT", f.timeText, "LEFT",opt.spell.offsetx,0)
	else
		f.spellText:ClearAllPoints()
		-- таймер слева
		f.spellText:SetPoint("LEFT", f.timeText, "RIGHT", opt.spell.offsetx,0)
		f.spellText:SetPoint("RIGHT", f.bar, "RIGHT",opt.spell.offsetx,0)
	end

	
end
function C.UpdateTick_Color(f)
	local opt = options.bars_anchors[f.parent.id]
	f.opts = opt
	
	if opt.dotticks and opt.dotticks.color and f.tiks then
		
		for i=1, #f.tiks do
			
			if opt.tick_ontop then
				f.tiks[i]:SetDrawLayer("OVERLAY")
			else
				f.tiks[i]:SetDrawLayer("ARTWORK", 5)
			end
			
			f.tiks[i]:SetVertexColor(opt.dotticks.color[1],opt.dotticks.color[2],opt.dotticks.color[3],opt.dotticks.color[4])	
		end
	end
	
end
function C.UpdateSpark_Color(f)
	local opt = options.bars_anchors[f.parent.id]
	f.opts = opt
	
	f.bar.spark:SetTexture("Interface\\CastingBar\\UI-CastingBar-Spark")
	f.bar.spark:SetAlpha(1)
	f.bar.spark:SetWidth(10)		
	f.bar.spark:SetHeight(f.bar:GetHeight()*3)	
	f.bar.spark:SetBlendMode('ADD')
	f.bar.spark:SetPoint("CENTER",f.bar.sp1,"LEFT",0,0)
	f.bar.spark:SetPoint("TOP", f.bar.sp1, "TOP",0,10)
	f.bar.spark:SetPoint("BOTTOM", f.bar.sp1, "BOTTOM",0,-10)
	f.bar.spark:SetVertexColor(opt.castspark.color[1],opt.castspark.color[2],opt.castspark.color[3],opt.castspark.color[4])
	
	f.bar.shine:SetTexture("Interface\\CastingBar\\UI-CastingBar-Spark")
	f.bar.shine:SetAlpha(0)
	f.bar.shine:SetWidth(10)
	f.bar.shine:SetHeight(50)		
	f.bar.shine:SetBlendMode('ADD')
	f.bar.shine:SetPoint("CENTER",f.bar.sp1,"LEFT",0,0)
	
	if opt.spark_ontop then
		
		f.bar.spark:SetDrawLayer("OVERLAY", 6)
		f.bar.shine:SetDrawLayer("OVERLAY", 6)
	else
		f.bar.spark:SetDrawLayer("ARTWORK", 3)
		f.bar.shine:SetDrawLayer("ARTWORK", 4)
	end
	
-- 	f.bar.shine:SetVertexColor(opt.castspark.color[1],opt.castspark.color[2],opt.castspark.color[3],opt.castspark.color[4])
end
function C.UpdateRaidIcon(f)
	local opt = options.bars_anchors[f.parent.id]
	f.opts = opt

	f.raidMark:SetPoint("TOP", f.bar, "TOP", opt.raidicon_x or 0, opt.raidicon_y or 5)
	f.raidMark:SetSize(opt.raidiconsize or 10, opt.raidiconsize or 10)
	f.raidMark:SetAlpha(opt.raidicon_alpha or 1)

end
function C.UpdateBorder(f)
	local opt = options.bars_anchors[f.parent.id]
	f.opts = opt

	f.icon:SetPoint("TOPRIGHT",f.bar,"TOPLEFT",-opt.icon_gap, 0)
	f.icon:SetPoint("BOTTOMRIGHT",f.bar,"BOTTOMLEFT",-opt.icon_gap, 0)

	f.icon.bg:SetPoint("TOPLEFT", -opt.borderinset, opt.borderinset)
	f.icon.bg:SetPoint("BOTTOMRIGHT", opt.borderinset, -opt.borderinset)
	
	f.icon.bg:SetBackdrop({
		edgeFile = C.LSM:Fetch("border", opt.border),
		edgeSize = opt.bordersize,
	})
	f.icon.bg:SetBackdropBorderColor(opt.bordercolor[1], opt.bordercolor[2], opt.bordercolor[3], opt.bordercolor[4])
	
	f.icon2:SetPoint("TOPLEFT",f.bar,"TOPRIGHT",opt.icon_gap, 0)
	f.icon2:SetPoint("BOTTOMLEFT",f.bar,"BOTTOMRIGHT",opt.icon_gap, 0)	
	f.icon2.bg:SetPoint("TOPLEFT", -opt.borderinset, opt.borderinset)
	f.icon2.bg:SetPoint("BOTTOMRIGHT", opt.borderinset, -opt.borderinset)

	f.icon2.bg:SetBackdrop({
		edgeFile = C.LSM:Fetch("border", opt.border),
		edgeSize = opt.bordersize,
	})
	f.icon2.bg:SetBackdropBorderColor(opt.bordercolor[1], opt.bordercolor[2], opt.bordercolor[3], opt.bordercolor[4])
	
	
	f.bar.bg:SetPoint("TOPLEFT", f.bar, -opt.borderinset, opt.borderinset)
	f.bar.bg:SetPoint("BOTTOMRIGHT", f.bar, opt.borderinset, -opt.borderinset)
	f.bar.bg:SetBackdrop({
			edgeFile = C.LSM:Fetch("border", opt.border),
			edgeSize = opt.bordersize,
		})
	f.bar.bg:SetBackdropBorderColor(opt.bordercolor[1], opt.bordercolor[2], opt.bordercolor[3], opt.bordercolor[4])
	
	f.bar.bg2:SetTexture(C.LSM:Fetch("statusbar", opt.bar.bgtexture))
	f.bar.bg2:SetVertexColor(unpack(opt.bar.bgcolor))
end

do 
	local function Round(num) return floor(num+.5) end --.5
	
	local function getbarpos(timer, tik)
		local minValue, maxValue = timer:GetMinMaxValues()
		
		if tik > maxValue then tik = maxValue end
		
		if tik >= 0 then
			return tik / maxValue * timer:GetWidth()
		else
			return (maxValue+tik) / maxValue * timer:GetWidth()
		end
	end
	
	local function getbarcurrentpos(timer, value)
		local minValue, maxValue = timer:GetMinMaxValues()
		if value > maxValue then value = maxValue end
		
		return value/maxValue * timer:GetWidth()
	end

	local function getoverlay2point(timer, _time, value)
		local minValue, maxValue = timer:GetMinMaxValues()
		
		if value > maxValue then value = maxValue end
		if _time > maxValue then _time = maxValue end		
		
		local current_time = value - _time
		
		
		if current_time <= 0 then current_time = 0 end
		return current_time/maxValue * timer:GetWidth()
	end
	
	local function overlayWidth(timer, _time)
		local minValue, maxValue = timer:GetMinMaxValues()
		
		return _time/maxValue * timer:GetWidth()
	end
	
	local function CreateTickFrame(frame,opt)
		local f = frame.bar:CreateTexture(nil, "OVERLAY")
						
		if opt.tick_ontop then
			f:SetDrawLayer("OVERLAY")
		else
			f:SetDrawLayer("ARTWORK", 5)
		end

		f:SetTexture("Interface\\CastingBar\\UI-CastingBar-Spark")
		f:SetAlpha(0.9)
		f:SetWidth(5)
		f:SetHeight(opt.h*1.8)
		f:SetBlendMode('ADD')
		f:SetVertexColor(opt.dotticks.color[1],opt.dotticks.color[2],opt.dotticks.color[3],opt.dotticks.color[4])	
		f:Hide()
						
		return f
	end
	
	
	local lowertick = 99999999
	
	function C.OnValueChanged(self, value)
		local data 				= self.data --self.tag and spelllist[self.tag] or nil
		local opt 				= self.opts
		
	--	if not data then return end
		
		if value < 0 then return end
		
		local current_position 	= getbarcurrentpos(self.bar, value)	
		local tickOverlap 		= C:TickOverlap(data[5]) 
		local castTime 			= C:GetCastTime(data[5]) or 0
		local overlaytime 		= castTime or 0
		
		local min1, max1 		= self.bar:GetMinMaxValues()
		
		local width 			= self:GetWidth()
		
		if data[1] == 0 and data[2] == 0 then
			self.bar.spark:Hide()
		else
			if opt.reverse_fill then
				self.bar.sp1:SetPoint("TOPLEFT",self.bar,"TOPLEFT", -current_position+width, 0)
				self.bar.sp1:SetPoint("BOTTOMLEFT",self.bar,"BOTTOMLEFT", -current_position+width, 0)
			else
				self.bar.sp1:SetPoint("TOPLEFT",self.bar,"TOPLEFT", current_position, 0)
				self.bar.sp1:SetPoint("BOTTOMLEFT",self.bar,"BOTTOMLEFT", current_position, 0)
			end
	
			self.bar.spark:Show()
		end

		if data[26] and options.show_pandemia_bp then
			
			local pandemiapoint = getbarpos(self.bar, ( max1 < data[38]*0.3 and max1 or data[38]*0.3 ))
		
			self.bar.pandemi:ClearAllPoints()
			
			if options.pandemia_bp_style == 1 then
				self.bar.pandemi:SetWidth(2)
				if opt.reverse_fill then
					self.bar.pandemi:SetPoint("TOPLEFT",self.bar,"TOPLEFT", -pandemiapoint+width, 0)
					self.bar.pandemi:SetPoint("BOTTOMLEFT",self.bar,"BOTTOMLEFT", -pandemiapoint+width, 0)
				else
					self.bar.pandemi:SetPoint("TOPLEFT",self.bar,"TOPLEFT", pandemiapoint, 0)
					self.bar.pandemi:SetPoint("BOTTOMLEFT",self.bar,"BOTTOMLEFT", pandemiapoint, 0)
				end		
			elseif options.pandemia_bp_style == 2 then
			
				if opt.reverse_fill then
				
					self.bar.pandemi:SetPoint("TOPLEFT",self.bar,"TOPLEFT", -pandemiapoint+width, 0)
					self.bar.pandemi:SetPoint("BOTTOMLEFT",self.bar,"BOTTOMLEFT", -pandemiapoint+width, 0)
					
					self.bar.pandemi:SetPoint("TOPRIGHT", self.bar, "TOPRIGHT", 0, 0)
					self.bar.pandemi:SetPoint("BOTTOMRIGHT", self.bar, "BOTTOMRIGHT", 0, 0)
					
				else
					self.bar.pandemi:SetPoint("TOPRIGHT",self.bar,"TOPLEFT", pandemiapoint, 0)
					self.bar.pandemi:SetPoint("BOTTOMRIGHT",self.bar,"BOTTOMLEFT", pandemiapoint, 0)
					
					self.bar.pandemi:SetPoint("TOPLEFT", self.bar, "TOPLEFT", 0, 0)
					self.bar.pandemi:SetPoint("BOTTOMLEFT", self.bar, "BOTTOMLEFT", 0, 0)
					
				end
			
			end
			if not self.bar.pandemi:IsShown() then
				self.bar.pandemi:Show()
			end
		else
			if self.bar.pandemi:IsShown() then
				self.bar.pandemi:Hide()
			end
		end
		
		if tickOverlap and data[27] then
		
			if overlaytime > 0 then
				overlaytime = overlaytime+data[27]
			else
				overlaytime = data[27]
			end
		end

		if overlaytime and overlaytime > 0 then

	--		self.bar.overlay1:Hide()
			local over_widht = 0
			
			if castTime > 0 then
				over_widht = overlayWidth(self.bar, castTime)			
				self.bar.overlay2:Show()
				self.bar.overlay2:SetWidth(over_widht)
			elseif castTime < 0 then
				over_widht = overlayWidth(self.bar, abs(castTime))
				
				self.bar.overlay2:Show()
				self.bar.overlay2:SetWidth(over_widht)
			else
				self.bar.overlay2:Hide()
			end
	
			local ov_2point = getoverlay2point(self.bar, overlaytime, value)
	
			if opt.reverse_fill then
				self.bar.sp2:SetPoint("TOPLEFT",self.bar,"TOPLEFT", -ov_2point-over_widht+width, 0)
				self.bar.sp2:SetPoint("BOTTOMLEFT",self.bar,"BOTTOMLEFT", -ov_2point-over_widht+width, 0)
			else
				self.bar.sp2:SetPoint("TOPLEFT",self.bar,"TOPLEFT", ov_2point, 0)
				self.bar.sp2:SetPoint("BOTTOMLEFT",self.bar,"BOTTOMLEFT", ov_2point, 0)
			end
			
		else
		--	self.bar.overlay1:Hide()
			self.bar.overlay2:Hide()
		end
			--data[13] == NO_FADE and
			
		if ( not options.hide_dot_ticks and data[2] and data[21] and data[32]) then
			lowertick = 99999999
			
			if data[32] > #self.tiks then self:SetTicks(true, "data[32] > #self.frame.tiks") end
			
			for i=1, #self.tiks do
				self.tiks[i]:Hide()
			end
			
			local i = 1
			while ( i < data[32] and self.tiks[i] ) do

				local tick_position = floor(getbarpos(self.bar, self.tiks[i].tick_time))
				
				if opt.reverse_fill then
					self.tiks[i]:SetPoint("TOPLEFT",self.bar,"TOPLEFT", -(tick_position)+opt.w, opt.h*0.4)
					self.tiks[i]:SetPoint("BOTTOMLEFT",self.bar,"BOTTOMLEFT", -(tick_position)+opt.w, -opt.h*0.4)				
				else
					self.tiks[i]:SetPoint("TOPLEFT",self.bar,"TOPLEFT", (tick_position), opt.h*0.4)
					self.tiks[i]:SetPoint("BOTTOMLEFT",self.bar,"BOTTOMLEFT", (tick_position), -opt.h*0.4)
				end
				self.tiks[i].tick_pos = tick_position
				
				if options.showonlynext then
					if current_position <= self.tiks[i].tick_pos then
						
						if lowertick > i then lowertick = i	end

						if self.tiks[i].shine  then
							self.bar.spark.shine:Play()
							self.tiks[i].shine = false
						end
						self.tiks[i]:Hide()
						
						if self.tiks[lowertick-1] then
							self.tiks[lowertick-1]:Show()
						end
					end
				elseif options.ticksfade then
					if current_position <= self.tiks[i].tick_pos then		
						if self.tiks[i].shine  then
							self.bar.spark.shine:Play()
							self.tiks[i].shine = false
						end
						self.tiks[i]:Hide()
					else 
						self.tiks[i]:Show()
					end
				else
					if current_position <= self.tiks[i].tick_pos then		
						if self.tiks[i].shine then
							self.bar.spark.shine:Play()
							self.tiks[i].shine = false
						end
					end					
					if self.tiks[i].tick_pos < self:GetWidth() then
						self.tiks[i]:Show()
					end
				end

				i = i + 1
			end
		else
			for i=1, #self.tiks do
				self.tiks[i]:Hide()
			end	
		end
	end

	local function DoTicksTable(frame, initial)
		
		local data = frame.data --frame.tag and spelllist[frame.tag] or nil
		local opt = frame.opts
		
		local ticks1_table = C:GetSavedTicks(data[3], data[5])
		local tick_every = C:GetDotTickEvery(data[3], data[5]) or C:GetDotInfoDone(data[5],data[3])
	
		if ( initial )
		or ( data[27] ~= tick_every ) then
		
			local index = 1
			local duratuion_1 = 0
			
			while ( data[1] > duratuion_1) do
				duratuion_1 = ticks1_table[index]
	
				if not duratuion_1 then break end
				
				local tick_frame = frame.tiks[index] or CreateTickFrame(frame,opt) 
				tick_frame.isdefaultick = false
				tick_frame.mynumber = index
				tick_frame.tick_time = duratuion_1
				tick_frame.shine = false

			--	tick_frame.tick_pos = getbarpos(frame.bar, ticks1_table[index])
				
				frame.tiks[index] = tick_frame
				
		--		print("T", index, ticks1_table[index])
				
				data[32] = index
				index = index + 1
			end
			
			data[27] = tick_every
			data[33] = data[2]
		end
		
	end
	
	local function DoDefaulTicks(self, initial)
		local data = self.data --self.tag and spelllist[self.tag] or nil
		local opt = self.opts
	
		local tiks_every, tickcount = C:GetDotInfoDone(data[5], ( data[31] and CHANNEL_SPELL or data[3] ))

		if not tiks_every then return end

		if initial
		or ( data[27] ~= tiks_every )
		or ( data[33] ~= data[2] ) then

			local index = 0
			local total_duration = 0
			
			while ( data[1] > total_duration ) do
				index = index + 1
				
				total_duration = tiks_every*index
				
				local tick_frame = self.tiks[index] or CreateTickFrame(self,opt) 
				tick_frame.isdefaultick = true
				tick_frame.mynumber = index
				tick_frame.tick_time = tiks_every*index
				tick_frame.shine = true
			--	tick_frame.tick_pos = getbarpos(self.bar,tiks_every*index)
				
				self.tiks[index] = tick_frame
	
			end
				
			data[27] = tiks_every
			data[32] = index
			data[33] = data[2]
		end
	end
	
	function C.SetTicks(self, initial, source)
		local data = self.tag and spelllist[self.tag] or nil

		if not data or not data[21] then return end
		
	--	print("SetTicks", initial, source, data[8], C:DoInitial(data[3], data[5]))
		if data[26] and not data[31] and C:DoInitial(data[3], data[5]) then
			DoTicksTable(self, initial)
		else		
			DoDefaulTicks(self, initial)
		end
	end
end


function C.UpdateStyle(self)	
	self:UpdateBorder()
	self:UpdateRaidIcon()
	self:UpdateTick_Color()
	self:UpdateSpark_Color()
	self:UpdateSpellText()
	self:UpdateTimeText()
	self:UpdateStackText()
	self:UpdateIcons()
	self:UpdateBarSize()	
end


local function Restore(self)	
	if self.__resize >= 1 then 
--		print("Fail to Resore")
		return 
	end
	self.__resize = 1
	
	local opt = self.opts
	--[==[	
	if self.data[13] == DO_FADE then
		local t = 'no'
		
		if self.data[15] < GetTime() and self.data[16] > GetTime() then
			t = 'yes'
		end
		
		if t == 'yes' then
			
		end
		
		print('Trying restore '..self.data[8]..format(' to end %.1f ', self.data[2] - GetTime())..' is fading '..t)
	end
	]==]	
	self.timeText:SetAlpha(opt.timer.alpha)
	self.spellText:SetAlpha(opt.spell.alpha)
	self.icon.stacktext:SetAlpha(opt.stack.alpha)
	self.icon2.stacktext:SetAlpha(opt.stack.alpha)
	
	if self._label then self._label:SetLabel(self.index, 1) end
	
	self:SetAlpha(self._groupalpha)
	self:SetHeight(opt.h)
	self.bar:SetHeight(opt.h)
end

local function FadeOut(self, gettime)
	local data = self.data --self.tag and spelllist[self.tag] or nil

	local a = (data[16]-gettime)/options.delayfading_outanim
	
	if a > 1 then
		error('Error')
	end
	
	if a <= 0 and ( data[13] == DO_FADE or data[13] == DO_FADE_UNLIMIT )then
		self:Resize(0)
		spelllist[self.tag][13] = FADED			
		SortBars()
	else
		self:Resize(a)
	end
end

local function Resize(self, value)
	local opt = self.opts
	
	self.__resize = value

	if self._label then
		self._label:SetLabel(self.index, value)
	end

	self.spellText:SetAlpha(opt.spell.alpha*value)
	self.timeText:SetAlpha(opt.timer.alpha*value)	
	self.icon.stacktext:SetAlpha(opt.stack.alpha*value)
	self.icon2.stacktext:SetAlpha(opt.stack.alpha*value)
	
	self:SetAlpha(self._groupalpha*value)
	self:SetHeight(opt.h*value)
	self.bar:SetHeight(opt.h*value)
	
--	print("Resize in ", value)
end

local function Update(self, gettime)
	local data = self.data --self.tag and spelllist[self.tag] or nil	
--	if not data then return end

	local val = data[2]-gettime

	if not self._maxvalue then self._maxvalue = data[1] end
	
	if options.adapttoonemax then
		local val_max_time = self.parent._maxmax
	
		if options.bar_smooth then		
			if options.maximumtime then				
				data[37] = data[37] + (val-data[37])/options.bar_smooth_value_v2
				self._maxvalue = options.maximumtime_value
			else
				data[37] = data[37] + (val-data[37])/options.bar_smooth_value_v2*0.5			
				self._maxvalue = self._maxvalue + ( val_max_time - self._maxvalue)/options.bar_smooth_value_v2*0.5	
			end
		else
			data[37] = val
		
			self._maxvalue = options.maximumtime and options.maximumtime_value or data[1]
		end
	else
		if options.bar_smooth then
			data[37] = data[37] + (val-data[37])/options.bar_smooth_value_v2
	
			self._maxvalue = options.maximumtime and options.maximumtime_value or data[1]
		else
			data[37] = val
			self._maxvalue = options.maximumtime and options.maximumtime_value or data[1]
		end
	end
	
	if data[1] == 0 and data[2] == 0 then
		self.bar:SetMinMaxValues(0, 1)	
	else	
		self.bar:SetMinMaxValues(0, self._maxvalue)
	end
	
	if data[1] == 0 and data[2] == 0 then
		self.bar:SetValue(1)
		self.timeText:SetText("")
		self:UpdateBarOverlays(1)
	elseif val > 0 then	
		self.bar:SetValue(data[37])
		self.timeText:SetFormattedText(C.FormatTime((self.opts.fortam_s or 1), data[37], data[1]))
		self:UpdateBarOverlays(data[37])
	else
		self.bar:SetValue(data[37])
		self.timeText:SetFormattedText(C.FormatTime((self.opts.fortam_s or 1), 0.00, data[1]))
		self:UpdateBarOverlays(0.00)
	end

	if data[31] then
		if not UnitChannelInfo("player") then
			spelllist[self.tag] = nil --ClearTag(self.tag)
			SortBars()
			return
		end
	end
	
	if data[1] ~= 0 and data[2] ~= 0 and data[2] < gettime then			
		if options.delayfading then
			if data[13] == NO_FADE then
				spelllist[self.tag][13] = DO_FADE
				OnTimerEnd(self.tag)
			end
		elseif data[13] ~= FADED then
			OnTimerEnd(self.tag) 
			spelllist[self.tag][13] = FADED
			SortBars()
		end
	end
end

local function Fading(self, gettime)
	if not options.delayfading then 
		self:Restore()
		return 
	end
	
	local data = self.data --self.tag and spelllist[self.tag] or nil	
--	if not data then return end

	if data[36] == DO_FADE_RED then
		self.bar:SetStatusBarColor(1, 0, 64/255, 1)
	else
		local cColor = C:GetColor(data[5], data[14]) or self.opts.bar.color
		
		self.bar:SetStatusBarColor(cColor[1],cColor[2],cColor[3],cColor[4] or 1)
	end
	--[[
	
			-- [15] time when fading start
			-- [16] time when fading end
	]]

--	print('Fading in', data[13], data[15])
	
	if data[15] < gettime and ( data[13] == DO_FADE_UNLIMIT or data[13] == DO_FADE )then --and data[15] < gettime 
		self:FadeOut(gettime)
--		print('Fading elseif 3')
	elseif data[13] == NO_FADE then
		self:Restore()
--		print('Fading elseif 2')
	else
--		print('Fading elseif 1')
	end
end

local function bgFade(self, gettime)	
	if not options.background_fading then return end
	local data = self.data --self.tag and spelllist[self.tag] or nil	
--	if not data then return end
	
	local dur = data[2] - gettime
	local cur = data[1]*0.2
	
	if cur > 5 then cur = 5 end
	if dur > cur then 
		self.fade_in_out_bg:Hide()
		self.fade_in_out_anim:Stop()
		return 
	end
	
	if dur <= 0 then return end
	
	if not self.fade_in_out_anim:IsPlaying() then				
		local m = dur/cur
		
		if m < .35 then m = .35 end
		
		self.fade_in_out_anim.a1:SetDuration(0.6*m)
		self.fade_in_out_anim.a2:SetDuration(0.6*m)
		
		self.fade_in_out_bg:Show()
		self.fade_in_out_anim:Play()
	end
end

local function OnUpdateText(self, elapsed, gettime)
	local data = self.data --self.tag and spelllist[self.tag] or nil	
--	if not data then return end
	
	self.__elapsed = ( self.__elapsed or 0 ) + elapsed
	
	if data[1] > 0 then

		local val = data[2] - gettime	
		local val2 = ( val < 0 ) and 0 or val
	
		if data[27] then
			data[22] = floor(val2/data[27])+1
		end

		if data[21] and data[27] and data[27] > 0 then
			
			if data[26] then
				if C:UpdateTicksDot(data[3], data[5]) then

					self.bar.spark.shine:Play()
					
					local oldticks_evert_s = data[27]
					local old_ticks_left = data[22]
					
					
					C:CountNextDotTick(data[3], data[5])
					
					C:SaveTick(data[3], data[5], val2, old_ticks_left, oldticks_evert_s, data[27], data[1], data[32])	
		
					self:SetTicks(true, "OnUpdateText")
				end
			end
		end
	end
	
	if self.__elapsed > 0.1 then
		self.__elapsed = 0
		self:SetCount("tick")
		
		if data[23] then
			self.spellText:SetText(C.CustomTextCreate(self))
		end
	end
end

local function OnApplyShine(self, elapsed)
	local opt = self.opts
	if not opt.shine_on_apply then return end
	
	print("T", 'Shine on apply')
	
end

local newOnUpdate = CreateFrame("Frame", "SPTimersNewOnUpdate")
newOnUpdate:SetScript("OnUpdate", function(self, elapsed)
	local curtime = GetTime()
	local updlbl = false
	
	for i=1, #anchors do
		if anchors[i].disabled ~= true then
			for b=1, anchors[i].index do			
				anchors[i].bars[b]:OnUpdateText(elapsed, curtime)
				anchors[i].bars[b]:Update(curtime)
				anchors[i].bars[b]:Fading(curtime)
				anchors[i].bars[b]:bgFade(curtime)		
			--	anchors[i].bars[b]:OnApplyShine(curtime)
				updlbl = true
			end
		end
	end
	
	if not updlbl then		
		self:Hide()
		return
	end
	
	if updlbl then C:NewUpdateLabels() end
end)

C.newOnUpdate = newOnUpdate

function C.GetBar(anchor)

	local f = CreateFrame("Frame", nil, anchor)
	f.parent = anchor
	f.opts = anchor.opts
	f.disabled = true
	f.__resize = 1
	f.tiks = {}

	local opt = f.opts
	
	f:SetSize(opt.w,opt.h)

	local b1 = f:CreateTexture(nil, "BACKGROUND", nil, 0)
	b1:SetPoint("TOP", f, "TOP")
	b1:SetPoint("BOTTOM", f, "BOTTOM")
	b1:SetPoint("LEFT", f.parent.mover, "LEFT")
	b1:SetPoint("RIGHT", f.parent.mover, "RIGHT")
	
	b1:SetTexture(1,0,0,0)

	local sb = CreateFrame("StatusBar", nil, f)
	sb:SetStatusBarTexture("Interface\\ChatFrame\\ChatFrameBackground")
	sb:SetMinMaxValues(0,1)

	local sbt = sb:GetStatusBarTexture()
	sbt:SetDrawLayer("ARTWORK", 0)
	
	local barShine = sb:CreateTexture(nil, "ARTWORK", nil, 5)
	barShine:SetAllPoints(sb)
	barShine:SetTexture(1, 1, 1)
	barShine:SetAlpha(0)
	
	local barShine_ag = barShine:CreateAnimationGroup()
	local barShine_ag_a1 = barShine_ag:CreateAnimation("Alpha")
	barShine_ag_a1:SetChange(0.5)
	barShine_ag_a1:SetDuration(0.2)
	barShine_ag_a1:SetOrder(1)
	
	local barShine_ag_a2 = barShine_ag:CreateAnimation("Alpha")
	barShine_ag_a2:SetChange(-0.5)
	barShine_ag_a2:SetDuration(0.4)
	barShine_ag_a2:SetOrder(2)
	
	
	local bb1 = sb:CreateTexture(nil, "BACKGROUND", nil, 0)
	bb1:SetAllPoints(sb)
	
	local bg1 = CreateFrame("Frame", nil, f)
	bg1:SetParent(f)
	
	local b = sb:CreateTexture(nil, "BACKGROUND", nil, 0)
	b:SetAllPoints()
	b:SetTexture(0,0,0,0)
	
	local fade_in_out = sb:CreateTexture(nil,"BORDER", 0)
	fade_in_out:SetAllPoints(sb)
	fade_in_out:Hide()
	fade_in_out:SetAlpha(0)
	
	local fade_in_out_ag = fade_in_out:CreateAnimationGroup()
	local fade_in_out_ag_a1 = fade_in_out_ag:CreateAnimation("Alpha")
	fade_in_out_ag_a1:SetChange(0.8)
	fade_in_out_ag_a1:SetDuration(0.6)
	fade_in_out_ag_a1:SetOrder(1)
	
	local fade_in_out_ag_a2 = fade_in_out_ag:CreateAnimation("Alpha")
	fade_in_out_ag_a2:SetChange(-0.8)
	fade_in_out_ag_a2:SetDuration(0.6)
	fade_in_out_ag_a2:SetOrder(2)
		
	local libf = CreateFrame("Frame",nil, sb)

	local bg2 = CreateFrame("Frame", nil, libf)
	
	local stacktext = bg2:CreateFontString(nil, "ARTWORK");
	
	bg2:SetParent(libf)

	local libft = libf:CreateTexture(nil,"ARTWORK")
	libft:SetSize(opt.h,opt.h)
	libft:SetTexCoord(.1, .9, .1, .9)
	libft:SetAllPoints(libf)
	
	local ribf = CreateFrame("Frame",nil, sb)

	local bg3 = CreateFrame("Frame", nil, ribf)
	
	local stacktext2 = bg3:CreateFontString(nil, "OVERLAY")
	
	local ribft = ribf:CreateTexture(nil,"ARTWORK")
	ribft:SetSize(opt.h,opt.h)
	ribft:SetTexCoord(.1, .9, .1, .9)
	ribft:SetAllPoints(ribf)

	local ft_l = sb:CreateFontString(nil, "ARTWORK");
	ft_l:SetJustifyV("CENTER")

	local ft_r = sb:CreateFontString(nil, "ARTWORK");
	ft_r:SetJustifyV("CENTER")

	local rit = sb:CreateTexture(nil,"ARTWORK", nil, 6)
	rit:SetTexture("Interface\\TargetingFrame\\UI-RaidTargetingIcons")
	
	local pandemi = sb:CreateTexture(nil, "ARTWORK", nil, 3)
	pandemi:SetAlpha(0.9)
	pandemi:SetWidth(2)
	pandemi:SetHeight(opt.h*1.8)
	pandemi:Hide()
	
	local sp1 = CreateFrame("Frame",nil,sb)
	sp1:SetParent(sb)
	sp1:SetWidth(1)
	sp1:SetHeight(f:GetHeight()*0.7)
	sp1:SetFrameLevel(4)
	sp1:SetAlpha(1)
	
	sp1:SetPoint("TOPLEFT",sb,"TOPLEFT", 10, 0)
	sp1:SetPoint("BOTTOMLEFT",sb,"BOTTOMLEFT", 10, 0)
		
	local sp2 = CreateFrame("Frame",nil,sb)
	sp2:SetParent(sb)
	sp2:SetWidth(1)
	sp2:SetHeight(f:GetHeight()*0.9)
	sp2:SetFrameLevel(4)
	sp2:SetAlpha(1)

	sp2:SetPoint("TOPLEFT",sb,"TOPLEFT", 10, 0)
	sp2:SetPoint("BOTTOMLEFT",sb,"BOTTOMLEFT", 10, 0)
	
	local spark = sb:CreateTexture(nil, "ARTWORK", nil, 3)
	spark.parent = sp1

	local shine = sb:CreateTexture(nil, "ARTWORK", nil, 4)
	shine.parent = sp1

	local ag = shine:CreateAnimationGroup()
	local a1 = ag:CreateAnimation("Alpha")
	a1:SetChange(1)
	a1:SetDuration(0.1)
	a1:SetOrder(1)
	local a2 = ag:CreateAnimation("Alpha")
	a2:SetChange(-1)
	a2:SetDuration(0.1)
	a2:SetOrder(2)

	local overlay2 = sb:CreateTexture(nil, "ARTWORK", nil, 2)
	overlay2:SetTexture(1,1,1,1)	
	overlay2:SetWidth(20)
	overlay2:Hide()		
	overlay2:SetPoint("TOPLEFT",sp2,"TOPLEFT",0,0)
	overlay2:SetPoint("BOTTOMLEFT",sp2,"BOTTOMLEFT",0,0)
		
	f.raidMark = rit		
	f.fade_in_out_bg = fade_in_out
	f.fade_in_out_anim = fade_in_out_ag
	f.fade_in_out_anim.a1 = fade_in_out_ag_a1
	f.fade_in_out_anim.a2 = fade_in_out_ag_a2	
	f.background1 = b1	
	f.background = b
	f.bar = sb
	f.barShine = barShine
	f.barShine_ag = barShine_ag
	f.bar.bg = bg1
	f.bar.bg2 = bb1
	f.bar.texture = sbt
	f.bar.overlay2 = overlay2	
	f.bar.spark = spark
	f.bar.spark.shine = ag		
	f.bar.shine = shine	
	f.bar.pandemi = pandemi
	
	f.bar.sp1 = sp1
	f.bar.sp2 = sp2
	
	f.icon = libf
	f.icon.bg = bg2
	f.icon.texture = libft
	f.icon.stacktext = stacktext
	
	f.icon2 = ribf
	f.icon2.bg = bg3
	f.icon2.texture = ribft
	f.icon2.stacktext = stacktext2
	
	f.timeText = ft_r
	f.spellText = ft_l
	f.bar.frame = f
	
	f.Restore 				= Restore	
	f.FadeOut 				= FadeOut	
	f.Update 				= Update	
	f.Fading 				= Fading	
	f.bgFade 				= bgFade
	f.OnUpdateText			= OnUpdateText
	f.UpdateBarColor		= UpdateBarColor	
	f.Resize 				= Resize
	f.OnApplyShine			= OnApplyShine
	
	f.UpdateStackText 		= C.UpdateStackText
	f.UpdateTimeText 		= C.UpdateTimeText
	f.UpdateSpellText 		= C.UpdateSpellText
	f.UpdateBorder 			= C.UpdateBorder
	f.UpdateTick_Color 		= C.UpdateTick_Color
	f.UpdateSpark_Color 	= C.UpdateSpark_Color
	f.UpdateBarSize			= C.UpdateBarSize
	f.UpdateRaidIcon		= C.UpdateRaidIcon
	f.UpdateIcons			= C.UpdateIcons	
	f.UpdateBarOverlays		= C.OnValueChanged	
	f.UpdateStyle 			= C.UpdateStyle
	f.SetMark				= C.SetMark
	f.SetCount				= C.SetCount
	f.BarTextUpdate 		= C.BarTextUpdate
	f.SetTicks				= C.SetTicks
	
	return f
end