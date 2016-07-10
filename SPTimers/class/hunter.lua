local addon, C = ...
local _,class = UnitClass("player")

if class ~= "HUNTER" then return end
local colors = C.CustomColors
local L = AleaUI_GUI.GetLocale("SPTimers")
local ALL = "ALL"

--[[
	1 = BM
	2 = MM
	3 = Surv
	
	spec = ALL,
]]

local spells = {	
	[131894] = { spec = ALL,duration = 30, color = colors.LBLUE, cleu = true },
	[51755]  = { spec = ALL,duration = 60, color = colors.CURSE },
	[19263]  = { spec = ALL,duration = 5, color = colors.LBLUE },
	
--	[82925]  = { duration = 30, color = colors.LBLUE },
--	[82926]  = { duration = 10, color = colors.WOO2 },
	
	[19615]  = { spec = "1",duration = 10, color = colors.CURSE },
--	[82654]  = { duration = 30, color = { 0.1, 0.75, 0.1} },
--	[56453]  = { spec = ALL,duration = 12, color = colors.LRED },
	[19574]  = { spec = "1",duration = 18, color = colors.LRED },
	[82692]  = { spec = "1",duration = 20, color = colors.GOLD },
	[136]    = { spec = ALL,duration = 10, color = colors.LGREEN },
	[118253] = { spec = ALL,duration = 15, color = colors.PURPLE, pandemia = true },
	
--	[19503]  = { cleu = true, duration = 4, color = colors.CHILL },
	[5116]   = { spec = ALL,duration = 6, color = colors.CHILL, cleu = true },
--	[34490]  = { duration = 3, color = colors.PINK, cleu = true },
	[24394]  = { spec = ALL,duration = 3, color = colors.RED, cleu = true },
	[19386]  = { spec = ALL,duration = 30, pvpduration = 8,color = colors.RED, cleu = true },
--	[3355]   = { spec = ALL,duration = 60, pvpduration = 8, color = colors.FROZEN, cleu = true },
--	[1513]   = { duration = 20, pvpduration = 8, color = colors.CURSE, cleu = true },
	[3045]   = { spec = "2",duration = 15, color = colors.CURSE },
	[128405] = { spec = ALL,duration = 8,  color = colors.BROWN, cleu = true },
	[117526] = { spec = ALL,duration = 5, pvpduration = 3, color = colors.RED, cleu = true },
}

local GetSpell = C.GetSpell

local cooldown = {
	[GetSpell(34026)] = { spellid = 34026, color = colors.LRED },	
	[GetSpell(53209)] = { spellid = 53209, color = colors.RED },	
	[GetSpell(53301)] = { spellid = 53301, color = colors.RED },	
	[GetSpell(3674)]  = { spellid = 3674, color = colors.WOO },	
	[GetSpell(130392)] = { spellid = 130392, color = colors.WOO },	
	[GetSpell(109259)] = { spellid = 109259, color = colors.BLACK },	
	[GetSpell(117050)] = { spellid = 117050, color = colors.BLACK },	
	[GetSpell(120360)] = { spellid = 120360, color = colors.BLACK },	
}



function C:SetupClassSpells() self.myCLASS = class; return spells end
function C:SetupClassCooldowns() self.myCLASS = class; return cooldown end

local function GetSpellNameGUI(spellID)
	local name, _, icon = GetSpellInfo(spellID)
	
	return "\124T"..icon..":14\124t "..name
end

local trapsettins = {
	{ "frostTrap", "frost",1499 },
	{ "slowTrap", "slow", 13809 },
	{ "fireTrap", "fire", 82939 },
}

function C:SetupClassOptions()
	local order = 60
	
	self.options.args.bars.args.Traps = {
		type = "group",
		name = "|c"..RAID_CLASS_COLORS[class].colorStr..L["Traps"],
		order = order+1, embend = false, args = {},
		}
	
	for i=1, 3 do
		local dir = trapsettins[i][1]
		local prof = trapsettins[i][2]
		local spID = trapsettins[i][3]
		
		self.options.args.bars.args.Traps.args[dir] = {
			type = "group",
			name = GetSpellNameGUI(spID),
			order = order+i, embend = true, args = {},
		}
	
		self.options.args.bars.args.Traps.args[dir].args.active = {
			type = "toggle", order = 1,
			name = L["Active"], 
			set = function(info, value)
				self.db.profile.hunterTraps[prof].active = not self.db.profile.hunterTraps[prof].active
			end,
			get = function(info)		
				return self.db.profile.hunterTraps[prof].active
			end
		}
	
		self.options.args.bars.args.Traps.args[dir].args.nonactive = {
			type = "toggle", order = 2,
			name = L["Non-active"], 
			set = function(info, value)
				self.db.profile.hunterTraps[prof].nonactive = not self.db.profile.hunterTraps[prof].nonactive
			end,
			get = function(info)			
				return self.db.profile.hunterTraps[prof].nonactive
			end
		}
		
		self.options.args.bars.args.Traps.args[dir].args.color = {
			type = "color", order = 3,
			name = L["Color"], hasAlpha = false,
			set = function(info, r,g,b,a)		
				self.db.profile.hunterTraps[prof].color = { r, g, b, 1 }
			end,
			get = function(info)
			
				return self.db.profile.hunterTraps[prof].color[1], self.db.profile.hunterTraps[prof].color[2], self.db.profile.hunterTraps[prof].color[3], 1
			end
		}
		
		self.options.args.bars.args.Traps.args[dir].args.priority = {
			name = L["Priority"],
			type = "slider",
			order	= 4,
			min		= -20,
			max		= 20,
			step	= 1,
			set = function(info,val) 
				self.db.profile.hunterTraps[prof].priority = val
			end,
			get = function(info)
				return self.db.profile.hunterTraps[prof].priority
			end,
		}
		
		self.options.args.bars.args.Traps.args[dir].args.anchor = {
			name = L["Select Anchor"],
			order = 5,
			desc = L["Select Anchor Desc"],
			type = "dropdown",
			values = function()
				local t = {}							
				for k,v in ipairs(self.db.profile.bars_anchors) do						
					t[k] = ""..k..""
				end							
				return t
			end,
			set = function(info,val)
				self.db.profile.hunterTraps[prof].anchor = val
			end,
			get = function(info, val) 
				return self.db.profile.hunterTraps[prof].anchor or 1
			end
		}
		
		self.options.args.bars.args.Traps.args[dir].args.group = {
			name = L["Select group"],
			order = 6,
			desc = L["Select group Desc"],
			type = "dropdown",
			values = function()		
				return {
					["player"] = "player",
					["procs"]  = "procs",
					["auto"]   = "auto",
					["target"] = "target",
				}
			end,
			set = function(info,val)
				self.db.profile.hunterTraps[prof].group = val
			end,
			get = function(info, val) 
				return self.db.profile.hunterTraps[prof].group or "auto"
			end,
		}
	end
end