local addon, C = ...
local _,class = UnitClass("player")

if class ~= "WARLOCK" then return end

local colors = C.CustomColors

local ALL = "ALL"
--[[
	ALL = ALL
	1 = Affli
	2 = Demo
	3 = Destro
	
	spec = "1;2;3",
	
]]


local spells = {
	[184073] 	 = { spec = ALL, color = { 0.631372549019608, 0.192156862745098, 0.227450980392157, }, duration = 10, color_on = true, cleu = true, },	
	[108686]	 = { spec = "3", duration = 15, tick = 3, haste = true, pandemia = true, cleu = true }, -- aoe immolate
	[348]		 = { spec = "3", duration = 15, custom_text = "%tN", tick = 3, haste = true, pandemia = true, cleu = true },	   -- solo immolate
	[157736]	 = { spec = "3", duration = 15, custom_text = "%tN", tick = 3, haste = true, pandemia = true, cleu = true },	   -- solo immolate
	
	[47960]		 = { spec = "2",duration = 6, tick = 1, pandemia = true,  haste = true, color = colors.CURSE },
	[146739]	 = { spec = "1;2",duration = 18, custom_text = "%tN", tick = 2, haste = true, pandemia = true, cleu = true },-- corruption
	[980]		 = { spec = "1",duration = 24, custom_text = "%tN", tick = 2, haste = true, pandemia = true, cleu = true },-- agony
	[30108] 	 = { spec = "1",duration = 15, custom_text = "%tN", tick = 2, cast = 1.5, haste = true, pandemia = true, cleu = true },-- ua
	
	[48181] 	 = { spec = "1",duration = 8,  cast = 3, haste = false, cleu = true },-- блуждающий дух
	
	[74434]		 = { spec = "1",duration = 20, color = colors.CURSE },
	[111400]	 = { spec = ALL,group = "player", color = colors.PURPLE2 },
--	[34936]		 = { group = "procs", duration = 8,  color = colors.CURSE },
	
	[80240]		 = { spec = "3",duration = 15, color = colors.LRED, group = "player", whitelist = 2 },
	
	[104773]	 = { spec = ALL,group = "player", duration = 12, color = colors.WOO2 },
	
	[122355]	 = { spec = "2",duration = 30, color = colors.PURPLE },
	
	[27243]		 = { spec = "1",duration = 15, cast = 1.5, tick = 2, haste = true, cleu = true }, -- soc
	[114790]	 = { spec = "1",duration = 15, cast = 1.5, tick = 2, haste = true, cleu = true }, -- soc + ss

	[105174] 	 = { spec = "2",duration = 6,  tick = 2,  haste = true},	-- hand of Gul'Dan
	[603] 	 	 = { spec = "2", duration = 60, custom_text = "%tN", tick = 15, haste = true, pandemia = true, cleu = true },	-- doom,
	
	[689]		 = { spec = "1;2",duration = 12, tick = 2, haste = true, channel = true, group = "target" }, -- drain life
	[103103]	 = { spec = "1",duration = 4,  tick = 1, haste = true, channel = true, group = "target" }, -- malf grasp
	
	[113861]	 = { spec = "2",duration = 20 }, -- demon souls
	[113860]	 = { spec = "1",duration = 20 },
	[113858]	 = { spec = "3",duration = 20 },
	
	[117828]	 = { spec = "3",duration = 15, group = "procs", color = colors.FIRE },
	[140074]	 = { spec = "2",duration = 30, group = "procs", color = colors.FIRE },
	
	[1122]   	 = { spec = ALL,duration = 60, cleu = true, group = "player", color = colors.BLACK, whitelist_cleu = 5, },
	[18540]  	 = { spec = ALL,duration = 60, cleu = true, group = "player", color = colors.BLACK, whitelist_cleu = 5, },
	[112921] 	 = { spec = ALL,duration = 60, cleu = true, group = "player", color = colors.BLACK, whitelist_cleu = 5, },
	[112927] 	 = { spec = ALL,duration = 60, cleu = true, group = "player", color = colors.BLACK, whitelist_cleu = 5, },
	
	[111895] 	 = { spec = ALL,duration = 20, cleu = true, group = "player", color = colors.BLACK, whitelist_cleu = 5, },
	[111859] 	 = { spec = ALL,duration = 20, cleu = true, group = "player", color = colors.BLACK, whitelist_cleu = 5, },
	[111897] 	 = { spec = ALL,duration = 20, cleu = true, group = "player", color = colors.BLACK, whitelist_cleu = 5, },
	[111898] 	 = { spec = ALL,duration = 20, cleu = true, group = "player", color = colors.BLACK, whitelist_cleu = 5, },
	[111896] 	 = { spec = ALL,duration = 20, cleu = true, group = "player", color = colors.BLACK, whitelist_cleu = 5, },

	[1949]		 = { spec = "2",duration = 14, haste = true }, -- hellfire
	
	[104232]	 = { spec = "3",cleu = false, whitelist = 2, blacklist = 3 },
	
	[86211] 	 = { spec = "1",group = "procs", duration = 20, color = colors.BLACK },
	
	[6789]		 = { spec = ALL,duration = 3 },
	[5484]		 = { spec = ALL,duration = 20, pvpduration = 8, cleu = true },
	[110913]	 = { spec = ALL,group = "procs", duration = 10 },
	[108416] 	 = { spec = ALL,group = "procs", duration = 10 },
	[30283]		 = { spec = ALL,duration = 3, cleu = true },
	[5782]		 = { spec = ALL,duration = 20, pvpduration = 8, cleu = true },
	[118699]	 = { spec = ALL,duration = 20, pvpduration = 8, cleu = true },
--	[104045]	 = { duration = 20, pvpduration = 8, cleu = true },
	[710]		 = { spec = ALL,duration = 30 },
	
	[157698]	 = { spec = "1", duration = 30, group = "procs", pandemia = true, },
	[137587]	 = { spec = ALL, duration = 8, group = "procs", },
	[108508]	 = { spec = ALL, duration = 8, group = "procs", },
	
	[171982]	 = { spec = "2", duration = 15, group = "player", source = 5, target_affil = 2 },
	[145085]	 = { spec = "2", duration = 10, group = "player" },
}

local GetSpell = C.GetSpell
local cooldown = {
	[GetSpell(17962)] = { spellid = 17962, color = colors.PINK },
	[GetSpell(105174)] = { spellid = 105174, color = colors.CURSE },
}	




function C:SetupClassSpells()

	self.myCLASS = class
	
	return spells
end

function C:SetupClassCooldowns()

	self.myCLASS = class
	
	return cooldown
end
