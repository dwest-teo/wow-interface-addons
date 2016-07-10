local addon, C = ...

local gameBuild = select(4, GetBuildInfo())
local playerClass = select(2, UnitClass('player'))

local classEnabled = {
	['PRIEST'] = true,
	['WARLOCK'] = true,
}

if not classEnabled[playerClass] then return end

local format = string.format
local find = string.find
local match = string.match
local pairs = pairs
local floor = math.floor
local tonumber = tonumber

local enabledProfiles = {}



local ALL_FILTER = 'ALL'

local classFilter = { [ALL_FILTER] = true }

for class in pairs(RAID_CLASS_COLORS) do
	classFilter[class] = true
end

local buildFilter = { [ALL_FILTER] = 'All' }
buildFilter[60000] = '6.0.x'
buildFilter[60100] = '6.1.x'
buildFilter[60200] = '6.2.x'

--[[
	
		["CritRating"] = "CritRating",
		["HasteRating"] = "HasteRating",
		["MasteryRating"] = "MasteryRating",
		["Multistrike"] = "Multistrike",
		["Versatility"] = "Versatility",
		["Stamina"] = "Stamina",
			
	
		crit = 0.7597,
		haste = 0.6883,
		multistrike = 0.5809, 
		versatility =  0.4917, 
		mastery = 0.4109, 

]]

local useBlizzardAPI = false
local GemData = {}
local statCompareCache = {	
	{ 0, "CritRating"},
	{ 0, "HasteRating"},
	{ 0, "MasteryRating"},
	{ 0, "Multistrike"},
	{ 0, "Versatility"},
	{ 0, "Stamina"},	
}

local function statCompareSortFunc(x,y)
	if x[1] > y[1] then
		return true
	else
		return false
	end
end

local function GetMaxPresetStat(name)
	
	statCompareCache[1][1] = PSW_SVDB.presets[name].crit
	statCompareCache[2][1] = PSW_SVDB.presets[name].haste
	statCompareCache[3][1] = PSW_SVDB.presets[name].mastery
	statCompareCache[4][1] = PSW_SVDB.presets[name].multistrike
	statCompareCache[5][1] = PSW_SVDB.presets[name].versatility
	
	statCompareCache[1][2] = "CritRating"
	statCompareCache[2][2] = "HasteRating"
	statCompareCache[3][2] = "MasteryRating"
	statCompareCache[4][2] = "Multistrike"
	statCompareCache[5][2] = "Versatility"
	
--	statCompareCache[6][1] = PSW_SVDB.presets[name].crit
	
	table.sort(statCompareCache, statCompareSortFunc)
	PSW_SVDB.presets[name].maxStat = statCompareCache[1][2]
	
--	print('T', statCompareCache[1][1], statCompareCache[1][2])
end

local function RefreshEnabledProfiles()

	gameBuild = select(4, GetBuildInfo())
	playerClass = select(2, UnitClass('player'))
	
	wipe(enabledProfiles)
	for statname, statdata in pairs(PSW_SVDB.presets) do	
		if statdata.__enabled and ( statdata.__class == ALL_FILTER or statdata.__class == playerClass ) and ( statdata.__gameBuild == ALL_FILTER or statdata.__gameBuild == gameBuild ) then
			enabledProfiles[statname] = true		
			GetMaxPresetStat(statname)
		end
	end
end

local EquippedItem = {}
local CompareItem = {}

local statsWeight = {	
	["Shadow - Combined BIS (Raid) - 6.1.0"] = {
		__enabled = true,
		__spec = 258,
		__name = "Shadow - Combined BIS (Raid) - 6.1.0",
		__gameBuild = 60100,
		__class = 'PRIEST',
		intellect = 1, 
		crit = 0.7597,
		haste = 0.6883,
		multistrike = 0.5809, 
		versatility =  0.4917, 
		mastery = 0.4109, 
		spellpower = 0.8819, 
	},

	["Shadow - CoP 1 Target BiS (Raid) - 6.1.0"] = {
		__enabled = true,
		__spec = 258,
		__name = "Shadow - CoP 1 Target BiS (Raid) - 6.1.0",
		__gameBuild = 60100,
		__class = 'PRIEST',
		intellect = 1.0000, 
		crit = 0.5467,
		haste = 0.6163,
		multistrike = 0.5953, 
		versatility =  0.4962, 
		mastery = 0.5433, 
		spellpower = 0.8836, 
	},
	['Shadow - Ausp. Spirits BiS (Raid) - 6.1.0'] =  {
		__enabled = true,
		__spec = 258,
		__name = 'Shadow - Ausp. Spirits BiS (Raid) - 6.1.0',
		__gameBuild = 60100,
		__class = 'PRIEST',
		intellect = 1.0000, 
		crit = 0.8980,
		haste = 0.7290,
		multistrike = 0.5716, 
		versatility =  0.4899, 
		mastery = 0.3663, 
		spellpower = 0.8828, 
	},
	
	['Shadow - Combined BiS (Raid) - 6.2.0'] = {
		__enabled = true,
		__spec = 258,
		__name = 'Shadow - Combined BiS (Raid) - 6.2.0',
		__gameBuild = 60200,
		__class = 'PRIEST',
		intellect = 1.0000, 
		crit = 0.9660,
		haste = 0.8355,
		multistrike = 0.7062, 
		versatility =  0.6734, 
		mastery = 0.5520, 
		spellpower = 0.9069, 
	},
	
	['Shadow - Ausp. Spirits BiS (Raid) - 6.2.0'] = {
		__enabled = true,
		__spec = 258,
		__name = 'Shadow - Ausp. Spirits BiS (Raid) - 6.2.0',
		__gameBuild = 60200,
		__class = 'PRIEST',
		intellect = 1.0000, 
		crit = 1.0729,
		haste = 0.8429,
		multistrike = 0.6946, 
		versatility = 0.6529, 
		mastery = 0.4907, 
		spellpower = 0.9069, 
	},
	
	['Shadow - CoP BiS (Raid) - 6.2.0'] = {
		__enabled = true,
		__spec = 258,
		__name = 'Shadow - CoP BiS (Raid) - 6.2.0',
		__gameBuild = 60200,
		__class = 'PRIEST',
		intellect = 1.0000, 
		crit =  0.7592,
		haste =  0.8540,
		multistrike = 0.6584, 
		versatility = 0.6427, 
		mastery =  0.6198, 
		spellpower = 0.9057, 
	},
	
	['Shadow - CoP 1 Target BiS (Raid) - 6.2.0'] = {
		__enabled = true,
		__spec = 258,
		__name = 'Shadow - CoP 1 Target BiS (Raid) - 6.2.0',
		__gameBuild = 60200,
		__class = 'PRIEST',
		intellect = 1.0000, 
		crit =  0.6849,
		haste =  0.7438,
		multistrike = 0.6415, 
		versatility = 0.6281, 
		mastery =  0.6899, 
		spellpower = 0.9064, 
	},
	
	['Shadow - Void Entropy BiS (Raid) - 6.2.0'] = {
		__enabled = true,
		__spec = 258,
		__name = 'Shadow - Void Entropy BiS (Raid) - 6.2.0',
		__gameBuild = 60200,
		__class = 'PRIEST',
		intellect = 1.0000, 
		crit =  0.8581,
		haste =  0.7030,
		multistrike = 0.7051, 
		versatility = 0.6866, 
		mastery =  0.4973, 
		spellpower = 0.9055, 
	},
	
	
	['Warlock - Affliction 6.2.0'] = {
		__enabled = true,
		__spec = 258,
		__name = 'Affliction',
		__gameBuild = 60200,
		__class = 'WARLOCK',
		intellect = 1.0000, 
		crit =  0.6394,
		haste =  0.8622,
		multistrike = 0.666, 
		versatility = 0.3893, 
		mastery =  0.8505, 
		spellpower = 0.8756, 
	},
	['Warlock - Destruction 6.2.0'] = {
		__enabled = true,
		__spec = 258,
		__name = 'Destruction',
		__gameBuild = 60200,
		__class = 'WARLOCK',
		intellect = 1.0000, 
		crit =  0.859,
		haste =  0.6251,
		multistrike = 0.6799, 
		versatility = 0.5496, 
		mastery =  0.9692, 
		spellpower = 0.8715, 
	},
	['Warlock - Demonology 6.2.0'] = {
		__enabled = true,
		__spec = 258,
		__name = 'Demonology',
		__gameBuild = 60200,
		__class = 'WARLOCK',
		intellect = 1.0000, 
		crit =  0.7081,
		haste =  0.7747,
		multistrike = 0.7106, 
		versatility = 0.6196, 
		mastery =  0.8453, 
		spellpower = 0.8775, 
	},
}

--local slot = GetInventorySlotInfo(index)
--GetInventoryItemDurability(slot)

--{'PLAYER_ENTERING_WORLD', "UPDATE_INVENTORY_DURABILITY", "MERCHANT_SHOW"}


--[[
0 = ammo
1 = head
2 = neck
3 = shoulder
4 = shirt
5 = chest
6 = waist
7 = legs
8 = feet
9 = wrist
10 = hands
11 = finger 1
12 = finger 2
13 = trinket 1
14 = trinket 2
15 = back
16 = main hand
17 = off hand
18 = ranged
19 = tabard
20 = first bag (the rightmost one)
21 = second bag
22 = third bag
23 = fourth bag (the leftmost one)
]]
--[[
local hasItem, hasCooldown, repairCost = GameTooltip:SetInventoryItem("player", 10);


for i=1, GameTooltip:NumLines() do        
   --local right = _G[GameTooltip:GetName().."TextRight"..i]:GetText()
   local left = _G[GameTooltip:GetName().."TextLeft"..i]:GetText()
   
   print("T", i, left)
   
end
]]

local ITEM_MOD_INTELLECT_SHORT = ITEM_MOD_INTELLECT_SHORT
local ITEM_MOD_INTELLECT = ITEM_MOD_INTELLECT
local ITEM_MOD_STAMINA_SHORT = ITEM_MOD_STAMINA_SHORT
local ITEM_MOD_STAMINA = ITEM_MOD_STAMINA
local ITEM_MOD_CRIT_RATING_SHORT = ITEM_MOD_CRIT_RATING_SHORT
local ITEM_MOD_CR_MULTISTRIKE_SHORT = ITEM_MOD_CR_MULTISTRIKE_SHORT
local ITEM_MOD_VERSATILITY = ITEM_MOD_VERSATILITY
local ITEM_MOD_HASTE_RATING_SHORT = ITEM_MOD_HASTE_RATING_SHORT
local ITEM_MOD_MASTERY_RATING_SHORT = ITEM_MOD_MASTERY_RATING_SHORT
local ITEM_MOD_SPELL_POWER_SHORT = ITEM_MOD_SPELL_POWER_SHORT
local ITEM_MOD_STRENGTH_SHORT = ITEM_MOD_STRENGTH_SHORT
local ITEM_MOD_AGILITY_SHORT = ITEM_MOD_AGILITY_SHORT
local ITEM_MOD_SPIRIT_SHORT = ITEM_MOD_SPIRIT_SHORT
local ITEM_MOD_EXTRA_ARMOR_SHORT = ITEM_MOD_EXTRA_ARMOR_SHORT



local PATTERN_INTELLECT 		= "(%d-) "..ITEM_MOD_INTELLECT_SHORT
local PATTERN_STAMINA 			= "(%d-) "..ITEM_MOD_STAMINA_SHORT
local PATTERN_CRIT				= "(%d-) "..ITEM_MOD_CRIT_RATING_SHORT
local PATTERN_MULTISTRIKE 		= "(%d-) "..ITEM_MOD_CR_MULTISTRIKE_SHORT
local PATTERN_VERSATILITY 		= "(%d-) "..ITEM_MOD_VERSATILITY
local PATTERN_HASTE 			= "(%d-) "..ITEM_MOD_HASTE_RATING_SHORT
local PATTERN_MASTERY 			= "(%d-) "..ITEM_MOD_MASTERY_RATING_SHORT
local PATTERN_SPELLPOWER 		= "(%d-) "..ITEM_MOD_SPELL_POWER_SHORT
local PATTERN_STRENGTH 			= "(%d-) "..ITEM_MOD_STRENGTH_SHORT
local PATTERN_AGILITY 			= "(%d-) "..ITEM_MOD_AGILITY_SHORT
local PATTERN_SPIRIT			= "(%d-) "..ITEM_MOD_SPIRIT_SHORT
local PATTERN_EXTRAARMOR		= "(%d-) "..ITEM_MOD_EXTRA_ARMOR_SHORT

--[[
-- Feet
local INVTYPE_FEED
local FEETSLOT

-- RINGS
local FINGER0SLOT
local FINGER1SLOT
local INVTYPE_FINGER

-- TRINKET
local TRINKET0SLOT
local TRINKET1SLOT
local INVTYPE_TRINKET
]]

local Gem100 ={
	{ 115803, "CritRating", 35 }, -- Critical Strike Taladite
	{ 115804, "HasteRating", 35 }, -- Haste Taladite
	{ 115805, "MasteryRating", 35 }, -- Mastery Taladite
	{ 115806, "Multistrike", 35 }, -- Multistrike Taladite
	{ 115807, "Versatility", 35 }, -- Versatility Taladite
	{ 115808, "Stamina", 35 }, -- Stamina Taladite
	
	{ 115809, "CritRating", 50 }, -- Greater Critical Strike Taladite
	{ 115811, "HasteRating", 50 }, -- Greater Haste Taladite
	{ 115812, "MasteryRating", 50 }, -- Greater Mastery Taladite
	{ 115813, "Multistrike", 50 }, -- Greater Multistrike Taladite
	{ 115814, "Versatility", 50 }, -- Greater Versatility Taladite
	{ 115815, "Stamina", 50 }, -- Greater Stamina Taladite
	
	{ 127760, "CritRating", 75 }, -- Immaculate Critical Strike Taladite
	{ 127761, "HasteRating", 75 }, -- Immaculate Haste Taladite
	{ 127762, "MasteryRating", 75 }, -- Immaculate Mastery Taladite
	{ 127763, "Multistrike", 75 }, -- Immaculate Multistrike Taladite
	{ 127764, "Versatility", 75 }, -- Immaculate Versatility Taladite
	{ 127765, "Stamina", 75 }, -- Immaculate Stamina Taladite
}

local function CreateString(data, statweight)
	local totalweght = 0
	
	if not data or not statweight then return 0 end
	
	local tempcrit, tempmultistrike, tempmastery, tempversatility, temphaste = 0, 0, 0, 0, 0
	
	if statweight.intellect and statweight.intellect > 0 and data.intellect then		
		totalweght = totalweght + (data.intellect * statweight.intellect)
	end
	
	if statweight.crit and statweight.crit > 0 and data.crit then		
		totalweght = totalweght + ( (data.crit+ tempcrit ) *  statweight.crit )
	end
	
	if statweight.multistrike and statweight.multistrike > 0 and data.multistrike then		
		totalweght = totalweght + ( (data.multistrike + tempmultistrike ) *  statweight.multistrike )
	end
	
	if statweight.mastery and statweight.mastery > 0 and data.mastery then		
		totalweght = totalweght + ( (data.mastery  + tempmastery ) *  statweight.mastery )
	end
	
	if statweight.versatility and statweight.versatility > 0 and data.versatility then		
		totalweght = totalweght + ( (data.versatility + tempversatility ) * statweight.versatility )
	end
	
	if statweight.haste and statweight.haste > 0 and data.haste then		
		totalweght = totalweght + ( (data.haste + temphaste ) *  statweight.haste )
	end
	
	if statweight.spellpower and statweight.spellpower > 0 and data.spellpower then		
		totalweght = totalweght +  (data.spellpower * statweight.spellpower)
	end
	
	return totalweght
end

local function CoundGem(data, data2, statweight)

	if not data or not data2 or not statweight then return 0, 0 end
	
	local totalweght, tempcrit, tempmultistrike, tempmastery, tempversatility, temphaste = 0, 0, 0, 0, 0, 0
	local totalweght2, tempcrit2, tempmultistrike2, tempmastery2, tempversatility2, temphaste2 = 0, 0, 0, 0, 0, 0
	
	if data.gem then
		local value, typeStat
		
		if type(data.gem) == 'string' then
			value, typeStat = strsplit(':', data.gem)
			value = tonumber(value)	
		else
			value = statweight.gemvalue or 75
			typeStat = statweight.gemstat or statweight.maxStat
		end
		
		if typeStat == 'CritRating' then
			tempcrit = value
		elseif typeStat == 'HasteRating' then
			temphaste = value
		elseif typeStat == 'MasteryRating' then
			tempmastery = value
		elseif typeStat == 'Multistrike' then
			tempmultistrike = value
		elseif typeStat == 'Versatility' then
			tempversatility = value
		end
	end

	if statweight.crit and statweight.crit > 0 and data.crit then		
		totalweght = totalweght + ( statweight.crit * tempcrit ) 
	end	
	if statweight.multistrike and statweight.multistrike > 0 and data.multistrike then		
		totalweght = totalweght + ( statweight.multistrike * tempmultistrike ) 
	end
	if statweight.mastery and statweight.mastery > 0 and data.mastery then		
		totalweght = totalweght + ( statweight.mastery * tempmastery )
	end	
	if statweight.versatility and statweight.versatility > 0 and data.versatility then		
		totalweght = totalweght + ( statweight.versatility * tempversatility )
	end	
	if statweight.haste and statweight.haste > 0 and data.haste then		
		totalweght = totalweght + ( statweight.haste * temphaste )
	end
	
	if type(data2) == 'table' then
	
		if data2.gem then
			local value, typeStat
			
			if type(data2.gem) == 'string' then
				value, typeStat = strsplit(':', data2.gem)
				value = tonumber(value)	
			else
				value = statweight.gemvalue or 75
				typeStat = statweight.gemstat or statweight.maxStat
			end
			
			if typeStat == 'CritRating' then
				tempcrit2 = value
			elseif typeStat == 'HasteRating' then
				temphaste2 = value
			elseif typeStat == 'MasteryRating' then
				tempmastery2 = value
			elseif typeStat == 'Multistrike' then
				tempmultistrike2 = value
			elseif typeStat == 'Versatility' then
				tempversatility2 = value
			end
		end
		
		if statweight.crit and statweight.crit > 0 and data2.crit then		
			totalweght2 = totalweght2 + ( statweight.crit * tempcrit2 )
		end	
		if statweight.multistrike and statweight.multistrike > 0 and data2.multistrike then		
			totalweght2 = totalweght2 + ( statweight.multistrike * tempmultistrike2 )
		end
		if statweight.mastery and statweight.mastery > 0 and data2.mastery then		
			totalweght2 = totalweght2 + ( statweight.mastery * tempmastery2 )
		end	
		if statweight.versatility and statweight.versatility > 0 and data2.versatility then		
			totalweght2 = totalweght2 + ( statweight.versatility * tempversatility2 )
		end	
		if statweight.haste and statweight.haste > 0 and data2.haste then
			totalweght2 = totalweght2 + ( statweight.haste * temphaste2 )
		end
		
		if data2.gem and data2.gem == true and totalweght2 == 0 then
			totalweght2 = totalweght
		end
	
	end
	
	return totalweght, totalweght2
end

local selected_preset = nil

local loadGem = 0

local hidegametooltip = CreateFrame("Frame")
hidegametooltip:Hide()
local gametooltip = CreateFrame("GameTooltip", "SPTimers_StatsWeight_GameToolTip", nil, "GameTooltipTemplate");
gametooltip:SetOwner( hidegametooltip,"ANCHOR_NONE");
	
local function GetGemData()
	local failed = false
	wipe(GemData)
	for i=1, #Gem100 do
		local itemID, type, value = Gem100[i][1], Gem100[i][2], Gem100[i][3]
	
		local name, link = GetItemInfo(itemID)

		if not name then
			failed = true
		elseif link then	
			gametooltip:SetHyperlink(link)				
			local left = _G[gametooltip:GetName().."TextLeft4"]:GetText()
			if left then
				GemData[#GemData+1] = { left, value, type }
			else
				failed = true
			end
		end
	end
	
	if failed then
		C_Timer.After(1, GetGemData)
	else
--		print('GetData Loaded in ', format('%.1fs', GetTime()-loadGem))
	end
end

function C:InitStatWeight()

	if IsAddOnLoaded('PriestStatWeights') then
			AleaUI_GUI.ShowPopUp(
			   "SPTimers", 
			   'PriestStatWeights is enabled. Delete addon or disable it.', 
			   { name = "Ok", OnClick = function() DisableAddOn('PriestStatWeights'); ReloadUI(); end}, 
			   { name = "Later", OnClick = function() end}		   
			)		
		return 
	end
	
	if not PSW_SVDB then 
		PSW_SVDB = {} 
	end
	
	if not PSW_SVDB.presets then
		PSW_SVDB.presets = statsWeight
	end
	
	for k,v in pairs(statsWeight) do
		if not PSW_SVDB.presets[k] then
			PSW_SVDB.presets[k] = v
		end
	end
	
	RefreshEnabledProfiles()
	
	C_Timer.After(0.5, function()
		if InCombatLockdown() then
			hidegametooltip:RegisterEvent('PLAYER_REGEN_ENABLED')
			hidegametooltip:SetScript('OnEvent', function()
				hidegametooltip:UnregisterAllEvents()
				loadGem = GetTime()
				C_Timer.After(0.3, GetGemData)
			end)
		else
			loadGem = GetTime()
			C_Timer.After(0.3, GetGemData)
		end
	end)
	
	PSW_SVDB.minimap = PSW_SVDB.minimap or {}
	
	PSW_SVDB.totalpresets = PSW_SVDB.totalpresets or 0
	
	local presets = {		
		name = "Stats Weight Presets",
		order = 1.1,
		expand = false,
		type = "group",
		args = {}
	}

	presets.args.DisableIt = {
		name = "Disable module",
		type = "toggle",
		order = 0.5,
		width = 'full',
		set = function()
			PSW_SVDB.disabled = not PSW_SVDB.disabled
		end,
		get = function()
			return PSW_SVDB.disabled
		end,	
	}
	
	presets.args.New = {		
		name = "",
		order = 1,
		embend = true,
		type = "group",
		args = {}
	}
	
	presets.args.New.args.CreateNew = {
		name = "Create New",
		type = "execute",
		order = 1,
		set = function()
			PSW_SVDB.totalpresets = PSW_SVDB.totalpresets + 1
			
			local named = "Preset #"..PSW_SVDB.totalpresets
			
			PSW_SVDB.presets[named] = {
				__enabled = true,
				__spec = 3,
				__name = named,
				intellect = 1, 
				crit = 0,
				haste = 0,
				multistrike = 0, 
				versatility =  0, 
				mastery = 0, 
				spellpower = 0, 			
			}
			
			selected_preset = named
			GetMaxPresetStat(named)
		end,
		get = function()
			
		end,	
	}
	
	presets.args.New.args.Select = {
		name = "Select",
		type = "dropdown",
		width = 'full',
		order = 2,
		values = function()	
			local t = {}
			
			for k, v in pairs(PSW_SVDB.presets) do
				t[k] = v.__name or k
			end
			
			return t
		end,
		set = function(info, value)
			
			selected_preset = value
			GetMaxPresetStat(value)
		end,
		get = function()
			return selected_preset
		end,	
	}
	
	presets.args.Edit = {		
		name = "Stats",
		order = 2,
		embend = true,
		type = "group",
		args = {}
	}
	
	presets.args.Gens = {		
		name = "Gems",
		order = 3,
		embend = true,
		type = "group",
		args = {}
	}
	
	presets.args.Edit.args.enable = {
		name = "Enable",
		type = "toggle",
		order = 1,
		width = 'full',
		set = function()
			if selected_preset then
				PSW_SVDB.presets[selected_preset].__enabled = not PSW_SVDB.presets[selected_preset].__enabled
			end
		end,
		get = function()
			if selected_preset then
				return PSW_SVDB.presets[selected_preset].__enabled
			end
			
			return false
		end,	
	}
	
	presets.args.Edit.args.Classes = {
		name = "Classes",
		type = "dropdown",
		order = 1.1,
		values = function()
			local t = {}
			for k,v in pairs(classFilter) do
				t[k] = k
			end
			
			return t
		end,
		set = function(info, value)
			if selected_preset then
				PSW_SVDB.presets[selected_preset].__class = value
			end
		end,
		get = function()
			if selected_preset then
				return PSW_SVDB.presets[selected_preset].__class
			end
		end,	
	}
	
	presets.args.Edit.args.Build = {
		name = "Build",
		type = "dropdown",
		order = 1.2,
		values = buildFilter,
		set = function(info, value)
			if selected_preset then
				PSW_SVDB.presets[selected_preset].__gameBuild = value
			end
		end,
		get = function()
			if selected_preset then
				return PSW_SVDB.presets[selected_preset].__gameBuild
			end
		end,	
	}
	
	presets.args.Edit.args.Spec = {
		name = "Spec",
		type = "dropdown",
		order = 1.3,
		values = function()
			local t = {}
			t[ALL_FILTER] = 'All'
			for i=1, GetNumSpecializations() do
				local id, name, description, icon, background, role = GetSpecializationInfo(i)				
				local role = GetSpecializationRoleByID(id)
				
				if role then
					t[id] = name
				end
			end
			
			return t
		end,
		set = function(info, value)
			if selected_preset then
				PSW_SVDB.presets[selected_preset].__spec = value
			end
		end,
		get = function()
			if selected_preset then
				return PSW_SVDB.presets[selected_preset].__spec
			end
		end,	
	}
	
	presets.args.Edit.args.name = {
		name = "Name",
		type = "editbox",
		width = 'full',
		order = 2,
		set = function(info, value)
			if selected_preset then
				local temp = gsub(value, '||', '|')
				
				PSW_SVDB.presets[selected_preset].__name = temp
			end
		end,
		get = function()
			if selected_preset then
			
				local temp = PSW_SVDB.presets[selected_preset].__name
				
				if temp then
					temp = gsub(temp, '|', '||')
				end
				
				return temp or selected_preset
			end
			
			return ''
		end,	
	}
	
	presets.args.Edit.args.intellect = {
		name = "Intellect",
		type = "editbox",
		order = 3,
		set = function(info, value)
			if selected_preset then
				local num = tonumber(value)
				if num then
					PSW_SVDB.presets[selected_preset].intellect = num
				end
			end
		end,
		get = function()
			if selected_preset then
				return PSW_SVDB.presets[selected_preset].intellect
			end
			
			return ''
		end,	
	}
	
	presets.args.Edit.args.crit = {
		name = "Crit",
		type = "editbox",
		order = 4,
		set = function(info, value)
			if selected_preset then
				local num = tonumber(value)
				if num then
					PSW_SVDB.presets[selected_preset].crit = num
					GetMaxPresetStat(selected_preset)
				end
			end
		end,
		get = function()
			if selected_preset then
				return PSW_SVDB.presets[selected_preset].crit
			end
			
			return ''
		end,	
	}
	
	presets.args.Edit.args.haste = {
		name = "Haste",
		type = "editbox",
		order = 5,
		set = function(info, value)
			if selected_preset then
				local num = tonumber(value)
				if num then
					PSW_SVDB.presets[selected_preset].haste = num
					GetMaxPresetStat(selected_preset)
				end
			end
		end,
		get = function()
			if selected_preset then
				return PSW_SVDB.presets[selected_preset].haste
			end
			
			return ''
		end,	
	}
	
	presets.args.Edit.args.multistrike = {
		name = "Multistrike",
		type = "editbox",
		order = 6,
		set = function(info, value)
			if selected_preset then
				local num = tonumber(value)
				if num then
					PSW_SVDB.presets[selected_preset].multistrike = num
					GetMaxPresetStat(selected_preset)
				end
			end
		end,
		get = function()
			if selected_preset then
				return PSW_SVDB.presets[selected_preset].multistrike
			end
			
			return ''
		end,	
	}
	
	presets.args.Edit.args.versatility = {
		name = "Versatility",
		type = "editbox",
		order = 7,
		set = function(info, value)
			if selected_preset then
				local num = tonumber(value)
				if num then
					PSW_SVDB.presets[selected_preset].versatility = num
					GetMaxPresetStat(selected_preset)
				end
			end
		end,
		get = function()
			if selected_preset then
				return PSW_SVDB.presets[selected_preset].versatility
			end
			
			return ''
		end,	
	}
	
	presets.args.Edit.args.mastery = {
		name = "Mastery",
		type = "editbox",
		order = 8,
		set = function(info, value)
			if selected_preset then
				local num = tonumber(value)
				if num then
					PSW_SVDB.presets[selected_preset].mastery = num
					GetMaxPresetStat(selected_preset)
				end
			end
		end,
		get = function()
			if selected_preset then
				return PSW_SVDB.presets[selected_preset].mastery
			end
			
			return ''
		end,	
	}
	
	presets.args.Edit.args.spellpower = {
		name = "SpellPower",
		type = "editbox",
		order = 9,
		set = function(info, value)
			if selected_preset then
				local num = tonumber(value)
				if num then
					PSW_SVDB.presets[selected_preset].spellpower = num
				end
			end
		end,
		get = function()
			if selected_preset then
				return PSW_SVDB.presets[selected_preset].spellpower
			end
			
			return ''
		end,	
	}
	
	presets.args.Gens.args.value = {	
		name = "Value",
		type = "dropdown",
		order = 1,
		values = {
			[35] = '+35',
			[50] = '+50',
			[75] = '+75',
		},
		set = function(info, value)
			if selected_preset then
				PSW_SVDB.presets[selected_preset].gemvalue = tonumber(value)
			end
		end,
		get = function()
			if selected_preset then
				return PSW_SVDB.presets[selected_preset].gemvalue or 75
			end
			return 75
		end,
	}
	
	presets.args.Gens.args.stat = {	
		name = "Stat",
		type = "dropdown",
		order = 2,
		values = {
			["CritRating"] = "CritRating",
			["HasteRating"] = "HasteRating",
			["MasteryRating"] = "MasteryRating",
			["Multistrike"] = "Multistrike",
			["Versatility"] = "Versatility",
			["Stamina"] = "Stamina",
		},
		set = function(info, value)
			if selected_preset then
				PSW_SVDB.presets[selected_preset].gemstat = value
			end
		end,
		get = function()
			if selected_preset then
				return PSW_SVDB.presets[selected_preset].gemstat or PSW_SVDB.presets[selected_preset].maxStat
			end
			return ''
		end,
	}

	
	presets.args.delete = {
		name = "Delete",
		type = "execute",
		order = -1,
		set = function()
			if selected_preset then
				PSW_SVDB.presets[selected_preset] = nil
				selected_preset = nil
			end
		end,
		get = function()
			
		end,	
	}
	
	return presets
end

local function GetExistedLine(self, name)
	for i=1, self:NumLines() do        
		
		local left = _G[self:GetName().."TextLeft"..i]:GetText()
		
		if left and find(left, name ) then
			return i
		end
	end
	
	return false
end
--[[
function C:PLAYER_ENTERING_WORLD()

end

function C:UNIT_INVENTORY_CHANGED()

end

function C:UPDATE_INVENTORY_DURABILITY()

end

function C:PLAYER_EQUPMENT_CHANGED()

end

function C:MODIFIER_STATE_CHANGED()end
]]
local function SkipText(text)
	
	if find(text, ITEM_SPELL_TRIGGER_ONEQUIP) then
		return false
	end
	
	if find(text, ITEM_SPELL_TRIGGER_ONUSE) then
		return false
	end
	
	return true
end

local curItemStats = {}
local itemStatsSort = {}
local curstats = {}
itemStatsSort[1] = ITEM_MOD_INTELLECT_SHORT
itemStatsSort[2] = ITEM_MOD_STAMINA_SHORT
itemStatsSort[3] = ITEM_MOD_CRIT_RATING_SHORT
itemStatsSort[4] = ITEM_MOD_CR_MULTISTRIKE_SHORT
itemStatsSort[5] = ITEM_MOD_VERSATILITY
itemStatsSort[6] = ITEM_MOD_HASTE_RATING_SHORT
itemStatsSort[7] = ITEM_MOD_MASTERY_RATING_SHORT
itemStatsSort[8] = ITEM_MOD_SPELL_POWER_SHORT
itemStatsSort[11] = ITEM_MOD_SPIRIT_SHORT

local function GetItemStats_Custom(self)
	local intellect, stamina, crit, multistrike, versatility, haste, mastery, spellpower, strength, agility, spirit, extraarmor, gem
	
	if useBlizzardAPI then
		wipe(curItemStats)
		wipe(curstats)
		local _name, _link = self:GetItem()
		GetItemStats(_link, curstats)
		
		for stat, value in pairs(curstats) do 
			curItemStats[stat] = tonumber(value)
		end
		
		local gem = false
		if curstats['EMPTY_SOCKET_PRISMATIC'] and curstats['EMPTY_SOCKET_PRISMATIC'] == 1 then
			gem = true
		end
		
		
		intellect	= tonumber(curItemStats[ITEM_MOD_INTELLECT_SHORT] )
		stamina 	= tonumber(curItemStats[ITEM_MOD_STAMINA_SHORT] )
		crit		= tonumber(curItemStats[ITEM_MOD_CRIT_RATING_SHORT] )
		multistrike	= tonumber(curItemStats[ITEM_MOD_CR_MULTISTRIKE_SHORT] )
		versatility	= tonumber(curItemStats[ITEM_MOD_VERSATILITY] )
		haste		= tonumber(curItemStats[ITEM_MOD_HASTE_RATING_SHORT] )
		mastery		= tonumber(curItemStats[ITEM_MOD_MASTERY_RATING_SHORT] )
		spellpower	= tonumber(curItemStats[ITEM_MOD_SPELL_POWER_SHORT] )
		strength	= nil
		agility		= nil
		spirit		=tonumber( curItemStats[ITEM_MOD_SPIRIT_SHORT] )
		extraarmor	= nil
		
		for i=1, self:NumLines() do        
			local left = _G[self:GetName().."TextLeft"..i]:GetText()
			if gem == true then			
				for i=1, #GemData do
					local _text, value, sttype =  GemData[i][1],GemData[i][2],GemData[i][3]				
					if find(left, _text) then
						gem = format('%d:%s', value, sttype)
						break
					end
				end
			else
				break
			end
		end	
		
		return intellect, stamina, crit, multistrike, versatility, haste, mastery, spellpower, strength, agility, spirit, extraarmor, gem
	else
	
		wipe(curstats)
		local _name, _link = self:GetItem()
		GetItemStats(_link, curstats)
		local gem = false
		if curstats['EMPTY_SOCKET_PRISMATIC'] and curstats['EMPTY_SOCKET_PRISMATIC'] == 1 then
			gem = true
		end
		
		for i=1, self:NumLines() do        
			local left = _G[self:GetName().."TextLeft"..i]:GetText()
			if gem == true then			
				for i=1, #GemData do
					local _text, value, sttype =  GemData[i][1],GemData[i][2],GemData[i][3]				
					if find(left, _text) then
						gem = format('%d:%s', value, sttype)
						break
					end
				end
			end
			
			if left ~= '' and SkipText(left) then
				intellect	= tonumber(intellect or match(left,  PATTERN_INTELLECT) )
				stamina 	= tonumber(stamina or match(left,  PATTERN_STAMINA) )
				crit		= tonumber(crit or match(left,   PATTERN_CRIT) )
				multistrike	= tonumber(multistrike or match(left,  PATTERN_MULTISTRIKE) )
				versatility	= tonumber(versatility or match(left,  PATTERN_VERSATILITY) )
				haste		= tonumber(haste or match(left,  PATTERN_HASTE) )
				mastery		= tonumber(mastery or match(left,  PATTERN_MASTERY) )
				spellpower	= tonumber(spellpower or match(left,  PATTERN_SPELLPOWER) )
				strength	= tonumber(strength or match(left,  PATTERN_STRENGTH) )
 				agility		= tonumber(agility or match(left,  PATTERN_AGILITY) )
				spirit		= tonumber(spirit or match(left,  PATTERN_SPIRIT) )
				extraarmor	= tonumber(extraarmor or match(left,  PATTERN_EXTRAARMOR)	)
			end
		end
		
		return intellect, stamina, crit, multistrike, versatility, haste, mastery, spellpower, strength, agility, spirit, extraarmor, gem
	end
end

local function attachItemTooltip(self)
	if PSW_SVDB.disabled then return end
	
	local myItem = self:IsEquippedItem()
	local owner = self:GetName()
	
	local intellect, stamina, crit, multistrike, versatility, haste, mastery, spellpower, strength, agility, spirit, extraarmor, gem = GetItemStats_Custom(self)

	if not CompareItem[owner] then
		CompareItem[owner] = {}
	end
	
	CompareItem[owner].intellect = intellect
	CompareItem[owner].stamina = stamina
	CompareItem[owner].crit = crit
	CompareItem[owner].multistrike = multistrike
	CompareItem[owner].versatility = versatility
	CompareItem[owner].haste = haste
	CompareItem[owner].mastery = mastery
	CompareItem[owner].spellpower = spellpower
	CompareItem[owner].strength = strength
	CompareItem[owner].agility = agility
	CompareItem[owner].spirit = spirit
	CompareItem[owner].extraarmor = extraarmor
	CompareItem[owner].gem = gem
	
	if not intellect then return end

	for name in pairs(enabledProfiles) do
		local statname = name
		local statdata = PSW_SVDB.presets[name]
		local current = CreateString(CompareItem[owner], statdata)
		local gem1 = CoundGem(CompareItem[owner], true, statdata)
		current = current + gem1
	--	self:AddLine(statname..": "..floor(current), 1, 1, 1, 1)
		self:AddDoubleLine(( statdata.__name or statname)..":", floor(current), 1, 1, 1, 1, 1, 1, 1, 1)
	end
end

local function MouseoverItemTooltip(self)
	if PSW_SVDB.disabled then return end
	
	local myItem = self:IsEquippedItem()
	local owner = self:GetName()
	
	local _name, _link = self:GetItem()
	
	if not _name or not _link then return end
	
	local intellect, stamina, crit, multistrike, versatility, haste, mastery, spellpower, strength, agility, spirit, extraarmor, gem = GetItemStats_Custom(self)

	if not CompareItem[owner] then
		CompareItem[owner] = {}
	end
	
	CompareItem[owner].intellect = intellect
	CompareItem[owner].stamina = stamina
	CompareItem[owner].crit = crit
	CompareItem[owner].multistrike = multistrike
	CompareItem[owner].versatility = versatility
	CompareItem[owner].haste = haste
	CompareItem[owner].mastery = mastery
	CompareItem[owner].spellpower = spellpower
	CompareItem[owner].strength = strength
	CompareItem[owner].agility = agility
	CompareItem[owner].spirit = spirit
	CompareItem[owner].extraarmor = extraarmor
	CompareItem[owner].gem = gem
	
	if not intellect then return end
	
	if _G['ItemRefTooltip']:IsShown() and CompareItem['ItemRefTooltip'].intellect then
		
		for name in pairs(enabledProfiles) do		
			local statname = name
			local statdata = PSW_SVDB.presets[name]
			
			local current = CreateString(CompareItem['ItemRefTooltip'], statdata)
			local myReal = CreateString(CompareItem[owner], statdata)
			
			local gem1, gem2 = CoundGem(CompareItem['ItemRefTooltip'], CompareItem[owner], statdata)
			current = current + gem1
			myReal = myReal + gem2
			
			local dims = current - myReal
			local dims2 = abs(( current*100/myReal ) - 100)
			local dimsstr
			
			if current < myReal then
				dimsstr = format("|cFF00FF00+%d%%", dims2)
			elseif myReal < current then
				dimsstr = format("|cFFFF0000-%d%%", dims2)	
			else
				dimsstr = format("|cFFFFFFFF+%d%%", 0)	
			end	
			
			
			local existedLine =  GetExistedLine(self, ( statdata.__name or statname))
			
			if existedLine then
				_G[owner.."TextLeft"..existedLine]:SetText((statdata.__name or statname)..":")
				_G[owner.."TextRight"..existedLine]:SetText(format("%d%s", floor(myReal), dimsstr))
			else
				self:AddDoubleLine(( statdata.__name or statname)..":", format("%d%s", floor(myReal), dimsstr), 1, 1, 1, 1, 1, 1, 1, 1)	
			end
		end
		
	else	

		for name in pairs(enabledProfiles) do		
			local statname = name
			local statdata = PSW_SVDB.presets[name]
			local current = CreateString(CompareItem[owner], statdata)
			local gem1 = CoundGem(CompareItem[owner], true, statdata)
			current = current + gem1
		
			self:AddDoubleLine(( statdata.__name or statname)..":", floor(current), 1, 1, 1, 1, 1, 1, 1, 1)
		end
	end
end

local function CompareItemTooltip(self)

	local myItem = self:IsEquippedItem()
	local owner = self:GetName()
	local _name, _link = self:GetItem()
	
	if not _name or not _link then return end
	
	local intellect, stamina, crit, multistrike, versatility, haste, mastery, spellpower, strength, agility, spirit, extraarmor, gem = GetItemStats_Custom(self)

	if not CompareItem[owner] then
		CompareItem[owner] = {}
	end
	
	CompareItem[owner].intellect = intellect
	CompareItem[owner].stamina = stamina
	CompareItem[owner].crit = crit
	CompareItem[owner].multistrike = multistrike
	CompareItem[owner].versatility = versatility
	CompareItem[owner].haste = haste
	CompareItem[owner].mastery = mastery
	CompareItem[owner].spellpower = spellpower
	CompareItem[owner].strength = strength
	CompareItem[owner].agility = agility
	CompareItem[owner].spirit = spirit
	CompareItem[owner].extraarmor = extraarmor
	CompareItem[owner].gem = gem
	
	if not intellect then return end
	
	for name in pairs(enabledProfiles) do		
		local statname = name
		local statdata = PSW_SVDB.presets[name]
		
		local current = CreateString(CompareItem['GameTooltip'], statdata)
		local myReal = CreateString(CompareItem[owner], statdata)	
		
		local gem1, gem2 = CoundGem(CompareItem['GameTooltip'], CompareItem[owner], statdata)	
		current = current + gem1
		myReal = myReal + gem2
			
		local dims = current - myReal
		local dims2 = abs(( current*100/myReal ) - 100)
		local dimsstr
		
		if current < myReal then
			dimsstr = format("|cFF00FF00+%d%%", dims2)
		elseif myReal < current then
			dimsstr = format("|cFFFF0000-%d%%", dims2)	
		else
			dimsstr = format("|cFFFFFFFF+%d%%", 0)	
		end	
		
		
		local existedLine =  GetExistedLine(self, ( statdata.__name or statname))
		
		if existedLine then
			_G[owner.."TextLeft"..existedLine]:SetText((statdata.__name or statname)..":")
			_G[owner.."TextRight"..existedLine]:SetText(format("%d%s", floor(myReal), dimsstr))
		else
			self:AddDoubleLine(( statdata.__name or statname)..":", format("%d%s", floor(myReal), dimsstr), 1, 1, 1, 1, 1, 1, 1, 1)	
		end
	end
end

GameTooltip:HookScript("OnTooltipSetItem", MouseoverItemTooltip)

ShoppingTooltip1:HookScript("OnTooltipSetItem", function(self)
	if PSW_SVDB.disabled then return end
	
	if _G[self:GetName()]:IsShown() then
		CompareItemTooltip(self)
	end
end)
ShoppingTooltip2:HookScript("OnTooltipSetItem", function(self) 
	if PSW_SVDB.disabled then return end
	
	if _G[self:GetName()]:IsShown() then
		CompareItemTooltip(self)
	end
end)

ItemRefTooltip:HookScript("OnTooltipSetItem", attachItemTooltip)
ItemRefShoppingTooltip1:HookScript("OnTooltipSetItem", attachItemTooltip)
ItemRefShoppingTooltip2:HookScript("OnTooltipSetItem", attachItemTooltip)
