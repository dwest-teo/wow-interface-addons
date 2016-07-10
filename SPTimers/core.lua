local addon, C = ...
_G[addon] = C

C.LSM = LibStub("LibSharedMedia-3.0")

local L = AleaUI_GUI.GetLocale("SPTimers")
local message

-- EVENTFRAME -----

do
	local __eg = CreateFrame("Frame")
	__eg:SetScript("OnEvent", function(self, event, ...)	
		C[event](C, event, ...)	
	end)
	C.__eh = __eg
	
	C.RegisterEvent = function(self, event)
		assert(C[event], 'No methode for "'..event..'"')	
		__eg:RegisterEvent(event)
	end
	
	C.UnregisterEvent = function(self, event)	
		__eg:UnregisterEvent(event)
	end
	
	C.UnregisterAllEvents = function(self)
		__eg:UnregisterAllEvents()
	end
end

-- NEW GLOBALS ----

local UNITAURA 				= "UNITAURA"
local CLEU 					= "CLEU"
local PLAYER_AURA 			= "PLAYER_AURA"
local OTHERS_AURA 			= "OTHERS_AURA"
local CUSTOM_AURA 			= "CUSTOM_AURA"
local CHANNEL_SPELL 		= "CHANNEL_SPELL"
local TOTEM_SPELL 			= "TOTEM_SPELL"
local SPELL_CAST 			= "SPELL_CAST"
local SPELL_SUMMON 			= "SPELL_SUMMON"
local SPELL_ENERGIZE 		= "SPELL_ENERGIZE"
local NO_GUID 				= "NO_GUID"
local NO_FADE 				= "NO_FADE"
local DO_FADE 				= "DO_FADE"
local DO_FADE_RED 			= "DO_FADE_RED"
local FADED 				= "FADED"
local DO_FADE_UNLIMIT 		= "DO_FADE_UNLIMIT"
local COOLDOWN_SPELL 		= "COOLDOWN_SPELL"

C.NO_FADE 			= NO_FADE
C.DO_FADE 			= DO_FADE
C.DO_FADE_RED 		= DO_FADE_RED
C.FADED 			= FADED
C.DO_FADE_UNLIMIT 	= DO_FADE_UNLIMIT
C.UNITAURA 			= UNITAURA
C.CLEU 				= CLEU
C.PLAYER_AURA 		= PLAYER_AURA
C.OTHERS_AURA 		= OTHERS_AURA
C.CUSTOM_AURA 		= CUSTOM_AURA
C.CHANNEL_SPELL 	= CHANNEL_SPELL
C.TOTEM_SPELL 		= TOTEM_SPELL
C.SPELL_CAST 		= SPELL_CAST
C.SPELL_SUMMON 		= SPELL_SUMMON
C.SPELL_ENERGIZE 	= SPELL_ENERGIZE
C.COOLDOWN_SPELL 	= COOLDOWN_SPELL
C.NO_GUID			= NO_GUID


local parent = CreateFrame('Frame', addon..'Parent', UIParent);
parent:SetFrameLevel(UIParent:GetFrameLevel());
parent:SetPoint('TOPLEFT', UIParent, 'TOPLEFT');
parent:SetPoint('BOTTOMRIGHT', UIParent, 'BOTTOMRIGHT');
parent:SetSize(UIParent:GetSize());

C.Parent = parent

-- locals -----------------------

local myGUID, myCLASS
local options
local UnitGUID = UnitGUID
local math_floor = math.floor
local pairs = pairs
local ipairs = ipairs
local tinsert = table.insert
local debugprefix = addon.."_CORE, "

-- debug print ------------------
local old_print = print
local print = function(...)
	if C.dodebugging then	
		old_print(GetTime(),debugprefix, ...)
	end
end

local old_assert = assert
local assert = function(...)
	if C.dodebugging then	
		old_assert(...)
	end
end

do
	local SendChatMessage = SendChatMessage
	local IsInRaid, IsInGroup = IsInRaid, IsInGroup
	local LE_PARTY_CATEGORY_INSTANCE = LE_PARTY_CATEGORY_INSTANCE
	local LE_PARTY_CATEGORY_HOME = LE_PARTY_CATEGORY_HOME
	
	function C.ChatMessage(msg, chat)
		
		if chat == "RAID_WARNING" then
			SendChatMessage(msg, "RAID_WARNING")
		elseif chat == "PARTY" then
			SendChatMessage(msg, "PARTY")
		elseif chat == "GUILD" then
			SendChatMessage(msg, "GUILD")
		else
			local chatType = "PRINT"
			if IsInGroup(LE_PARTY_CATEGORY_INSTANCE) or IsInRaid(LE_PARTY_CATEGORY_INSTANCE) then
				chatType = "INSTANCE_CHAT"
			elseif IsInRaid(LE_PARTY_CATEGORY_HOME) then
				chatType = "RAID"
			elseif IsInGroup(LE_PARTY_CATEGORY_HOME) then
				chatType = "PARTY"
			end
			
			if chatType == "PRINT" then
				C.message(msg)
			else
				SendChatMessage(msg, chatType)
			end
		end
	--	AddOn:print("Message", msg, chatType)
	end
end


do
	local select = select
	local tostring = tostring
	local sub = string.sub	
	local icon = "\124TInterface\\Icons\\spell_shadow_shadowwordpain:10\124t"
	
	function C.message(...)
	--	old_print("SPTimers_Options:", ...)
		local msg = ""
		for i=1, select("#", ...) do
			
			msg = msg..tostring(select(i, ...))..","
		end	
		msg = sub(msg, 0, -2)
		
		DEFAULT_CHAT_FRAME:AddMessage(icon..addon..":"..msg)	
	end

end

message = C.message

---------------------------------

local function Round(num) return math_floor(num+.5) end
local function SecondsRound(num)
	if num > 2 then return math_floor(num+.5)
	else return math_floor(num*10+.5)/10 end
end

do
	C.targetEngaged = {}
	C.onUpdateHandler  = CreateFrame("Frame")
	
	local onUpdateHandler = C.onUpdateHandler	
	onUpdateHandler.elapsed = 0
	onUpdateHandler.active = false

	local function onUpdateCombat(self, elapsed)
	
		self.elapsed = self.elapsed + elapsed
		if self.elapsed < options.throttleOutCombat then return end		
		self.elapsed = 0

		if not IsEncounterInProgress() and not InCombatLockdown() then
			self.active = false
			wipe(C.targetEngaged)
			wipe(C.pandemia_cache)
			C:OnCombatEndReset()
			self:SetScript("OnUpdate", nil)
		else
			local current = GetTime()
			for guid, last in pairs(C.targetEngaged) do				
				if last <= current then

					C.targetEngaged[guid] = nil

					C.Timer_Remove_DEAD(guid, true)
					
					print("Clear DestGUID by noActive", guid)
				end	
			end
		end	
	end
	
	--onUpdateHandler:SetScript("OnUpdate", onUpdateCombat)
	
	function C:MouseOverOnUpdate()
		if onUpdateHandler.active == false and not C.testbar_shown then		
			onUpdateHandler:SetScript("OnUpdate", onUpdateCombat)
			onUpdateHandler.elapsed = -5
			onUpdateHandler.active = true
		end
	end
	
	function C:PLAYER_REGEN_ENABLED() 
		onUpdateHandler.elapsed = 0

	end
	
	
	function C:PLAYER_REGEN_DISABLED()	
		if options.bar_module_enabled then
			onUpdateHandler:SetScript("OnUpdate", onUpdateCombat)
			if C.testbar_shown then self:TestBars(true) end
		end
		onUpdateHandler.active = true

	end
end

do
	local several_auras = {}
	
	local function PlayerAurasFilter(spellID, filter_type, sUnit)
		local skip = false
	
		skip = C:GetWhiteListFilter(spellID, filter_type, skip)
		skip = C:GetBlackListFilter(spellID, filter_type, skip)
		skip = C:GetProcsFilter(spellID, filter_type, skip)
		skip = C:GetOthersFilter(spellID, filter_type, skip)
		
		if skip then skip = C:CheckUnitSource(sUnit, C:GetAffiliation(spellID)) end
		
		return skip
	end
	
	local function OthersAurasFulter(spellID, filter_type, unit, sUnit)
		local skip = false
	
	--	skip = SPTimers:GetOthersFilter(spellID, filter_type, skip)
		skip = C:GetWhiteListFilter(spellID, filter_type, skip)
		skip = C:GetBlackListFilter(spellID, filter_type, skip)
		skip = C:GetProcsFilter(spellID, filter_type, skip)
		skip = C:GetOthersFilter(spellID, filter_type, skip)
		if C:IsChanneling(spellID) then skip = false end						
		if skip then skip = C:CheckUnitSource(sUnit, C:GetAffiliation(spellID)) end
		if skip then skip = C:CheckUnitSource(unit, C:GetTargetAffiliation(spellID)) end

		return skip
	end
	
	local _, spellName, icon, amount, debuffType, duration, endTime, sUnit, spellID, sourceGUID, skip, destGUID, filter, auraType, filter_type, index, sourceName
	
	-- 187616 caster unlimited aura
	
	-- 187620 melee agi use
	
	-- 187619 melee str aura
	
	local agiLTPSpellName = GetSpellInfo(187620)
	local intLTPSpellName = GetSpellInfo(187616)
	local strLTPSpellName = GetSpellInfo(187619)
	local healLTPSpellName = GetSpellInfo(187618)
	
	local function GetLTP(spellID, unit, duration, endTime)
		if spellID == 187616 or spellID == 187620 or spellID == 187619 then
			if duration == 0 and endTime == 0 then		
				local _, _, _, _, _, duration, endTime = UnitBuff(unit, agiLTPSpellName)						
				if duration and duration > 0 and endTime and endTime > 0 then
					return true, duration, endTime
				end				
				local _, _, _, _, _, duration, endTime = UnitBuff(unit, intLTPSpellName)						
				if duration and duration > 0 and endTime and endTime > 0 then
					return true, duration, endTime
				end
				
				local _, _, _, _, _, duration, endTime = UnitBuff(unit, strLTPSpellName)						
				if duration and duration > 0 and endTime and endTime > 0 then
					return true, duration, endTime
				end
			end
		elseif spellID == 187618 then
			if duration == 0 and endTime == 0 then	
				local _, _, _, _, _, duration, endTime = UnitBuff(unit, healLTPSpellName)
				if duration and duration > 0 and endTime and endTime > 0 then
					return true, duration, endTime
				end	
			
			end
			
		end
		
		return false
	end
	
	local function PlayerAuras(unit)

		destGUID = UnitGUID(unit)
		filter, auraType, filter_type, index = "HELPFUL", "BUFF", 2, 1
		
		wipe(several_auras)
		
		while ( true ) do
			spellName, _, icon, amount, debuffType, duration, endTime, sUnit, _, _, spellID = UnitAura(unit, index, filter)		
			if not spellName then break end
			
			local realLTP, durationLTP, endTimeLTP = GetLTP(spellID, sUnit, duration, endTime)
			if realLTP then
				duration, endTime = durationLTP, endTimeLTP
			end
			
			if C:GetInternalCD(spellName, spellID) then
				local icd = C:GetICD(spellName, spellID)
				if icd > 0 and ( endTime ~= 0 and duration ~= 0 ) then
					icd = icd + endTime - duration
					C.NewCooldown(spellName, icon, icd, "INTERNAL_CD")
				end
			end
			
			if endTime ~= 0 and C:GetAuraCD(spellName, spellID, filter) then
				C.NewCooldown(spellName.." buff", icon, endTime, "AURA_CD_BUFF")
			end
			
			index = index + 1
			
			if PlayerAurasFilter(spellID, filter_type, sUnit) then
				sourceGUID = UnitGUID(sUnit or "")
		
				if C:IsSeveralAuras(spellID) then
					several_auras[spellID] = ( several_auras[spellID] or 0 ) + 1
				end
					
				sourceName = UnitName(sUnit or "") or C.myNAME
		
				C.Timer(duration, endTime, destGUID, sourceGUID, spellID, several_auras[spellID] or 1, auraType, PLAYER_AURA, GetRaidTargetIndex(unit), spellName, icon, amount, C.myNAME, sourceName)
			end
		end

		filter, auraType, filter_type, index = "HARMFUL", "DEBUFF", 3, 1

		while ( true ) do
			spellName, _, icon, amount, debuffType, duration, endTime, sUnit, _, _, spellID = UnitAura(unit, index, filter)		
			if not spellName then break end
			
			if endTime ~= 0 and C:GetAuraCD(spellName, spellID, filter) then
				C.NewCooldown(spellName.." debuff", icon, endTime,"AURA_CD_DEBUFF")
			end
			
			index = index + 1
			
			if PlayerAurasFilter(spellID, filter_type, sUnit) then
				sourceGUID = UnitGUID(sUnit or "")
				sourceName = UnitName(sUnit or "") or C.myNAME
				
				C.Timer(duration, endTime, destGUID, sourceGUID, spellID,  1, auraType, PLAYER_AURA, GetRaidTargetIndex(unit), spellName, icon, amount, C.myNAME, sourceName)
			end
		end
		
		C.RemoveGUID_UA(destGUID, "BUFF", PLAYER_AURA, GetTime())
		C.RemoveGUID_UA(destGUID, "DEBUFF", PLAYER_AURA, GetTime())
	end

	local units = { 
		target = 1,
		focus = 1,
		pet = 1,
		boss1 = 1,
		boss2 = 1,
		boss3 = 1,
		boss4 = 1,
		boss5 = 1,
		arena1 = 1,
		arena2 = 1,
		arena3 = 1,
		arena4 = 1,
		arena5 = 1,
		mouseover = 1,
	}
	
	local function OthersAuras(unit)

	--	if not UnitCanAttack("player", unit) then return end

		if unit ~= "target" then 
			if UnitExists("target") and UnitIsUnit(unit, "target") then return end	
			if unit ~= "focus" and UnitExists("focus") and UnitIsUnit(unit, "focus") then return end
		end

		destGUID = UnitGUID(unit)
		filter, auraType, filter_type, index = "HARMFUL", "DEBUFF", 3, 1

		while ( true ) do
			spellName, _, icon, amount, debuffType, duration, endTime, sUnit, _, _, spellID = UnitAura(unit, index, filter)		
			if not spellName then break end
	
			index = index + 1
			
			if OthersAurasFulter(spellID, filter_type, unit, sUnit) then
				sourceGUID = UnitGUID(sUnit or "")
				
				
				C.Timer(duration, endTime, destGUID, sourceGUID, spellID, 1, auraType, OTHERS_AURA, GetRaidTargetIndex(unit), spellName, icon, amount,UnitName(unit), UnitName(sUnit or "") or UnitName(unit))
			end
		end

		filter, auraType, filter_type, index = "HELPFUL", "BUFF", 2, 1

		while ( true ) do
			spellName, _, icon, amount, debuffType, duration, endTime, sUnit, _, _, spellID = UnitAura(unit, index, filter)		
			if not spellName then break end
	
			index = index + 1
			
			if OthersAurasFulter(spellID, filter_type, unit, sUnit) then
				sourceGUID = UnitGUID(sUnit or "")
				
				
				C.Timer(duration, endTime, destGUID, sourceGUID, spellID, 1, auraType, OTHERS_AURA, GetRaidTargetIndex(unit), spellName, icon, amount,UnitName(unit), UnitName(sUnit or "") or UnitName(unit))
			end
		end
		
		C.RemoveGUID_UA(destGUID, "DEBUFF", OTHERS_AURA, GetTime())
		C.RemoveGUID_UA(destGUID, "BUFF", OTHERS_AURA, GetTime())
	end
	
	local __frf = CreateFrame("Frame")
	__frf:Show()
	__frf.elapsed = 0
	__frf:SetScript("OnUpdate", function(self, elapsed)
		
		self.elapsed = self.elapsed + elapsed
		if self.elapsed < 1 then return end
		self.elapsed = 0

		PlayerAuras("player")
	end)
	
	function C:UNIT_AURA(event, unit)
		if unit and not UnitExists(unit) then return end
	
		if unit == "player" then 
			PlayerAuras(unit)
		elseif units[unit] then 
			OthersAuras(unit) 
		end
	end
	
	
	function C:PLAYER_TARGET_CHANGED(event)
		if UnitExists("target") then
			self.CurrentTarget = UnitGUID("target")
			OthersAuras("target") 
		else
			self.CurrentTarget = nil
		end
		
		self.SortBars()
	end

	function C:UPDATE_MOUSEOVER_UNIT(event)
		if UnitExists("mouseover") then
			OthersAuras("mouseover")
		end
	end
	
	function C:PLAYER_FOCUS_CHANGED()
		if UnitExists("focus") then
			self.FocusTarget = UnitGUID("focus")
			OthersAuras("focus") 
		else
			self.FocusTarget = nil
			self.SortBars()
		end
	
	end
end


do
	local string_match = string.match
	function C.Erase(name)
		if not name then return name end
		local rname = string_match(name, "(.+)-") or name
		return rname
	end
end

do
	
	local flagtort = {
		[COMBATLOG_OBJECT_NONE] = 0,
		[COMBATLOG_OBJECT_RAIDTARGET8] = 8,
		[COMBATLOG_OBJECT_RAIDTARGET7] = 7,
		[COMBATLOG_OBJECT_RAIDTARGET6] = 6,
		[COMBATLOG_OBJECT_RAIDTARGET5] = 5,
		[COMBATLOG_OBJECT_RAIDTARGET4] = 4,
		[COMBATLOG_OBJECT_RAIDTARGET3] = 3,
		[COMBATLOG_OBJECT_RAIDTARGET2] = 2,
		[COMBATLOG_OBJECT_RAIDTARGET1] = 1,
	}
		
	local dots = {}
	local new_dot = {}
	
	C.dots = dots

	local truedEvents = {
		SPELL_CAST_SUCCESS = 1,
		SPELL_AURA_REFRESH = 1,
		SPELL_AURA_APPLIED_DOSE = 1,
		SPELL_AURA_APPLIED = 1,
		SPELL_AURA_REMOVED = 1,
		SPELL_AURA_REMOVED_DOSE = 1,
		SPELL_SUMMON = 1,
		SPELL_ENERGIZE = 1,
	}

	function C:GetTickInfo(spellID, destGUID)

		local tick, hasted, pandemia = self:GetCLEUSpellInfo(spellID)

		if not tick then return false end
		
		local haste = UnitSpellHaste("player")
		
		local tick_every = 0
		
		if hasted then
			tick_every	= tick/(1+(haste/100))
		else
			tick_every	= tick
		end

		dots[spellID..destGUID] = tick_every
	end

	function C:GetDotInfo(spellID, destGUID)
		destGUID = destGUID or SPTimers.myGUID
		
		local tick, hasted, pandemia = self:GetCLEUSpellInfo(spellID)
		local default, extended = self:GetDefaultDuraton(spellID)
		
		if not tick then return false end
		
		local haste = UnitSpellHaste("player")
		
		local tick_every = 0
		
		if hasted then
			tick_every	= tick/(1+(haste/100))
		else
			tick_every	= tick
		end
		
		if not new_dot[spellID..destGUID] then
			new_dot[spellID..destGUID] = { tick_every, math_floor(default/tick_every), math_floor(extended/tick_every) }
		else
			new_dot[spellID..destGUID][1] = tick_every
			new_dot[spellID..destGUID][2] = math_floor(default/tick_every)
			new_dot[spellID..destGUID][3] = math_floor(extended/tick_every)
		end
		
		return new_dot[spellID..destGUID][1], new_dot[spellID..destGUID][2], new_dot[spellID..destGUID][3]
	end
	
	function C:GetDotInfoDone(spellID, destGUID)
		
		if new_dot[spellID..destGUID] then return new_dot[spellID..destGUID][1], new_dot[spellID..destGUID][2], new_dot[spellID..destGUID][3] end

		return C:GetDotInfo(spellID, destGUID)
	end
	
	local TYPE_PLAYER = COMBATLOG_OBJECT_TYPE_PLAYER
	local TYPE_NPC	  = COMBATLOG_OBJECT_TYPE_NPC
	
	local function IsPlayer(flag)
		if flag and ( bit.band(flag, TYPE_PLAYER) > 0 ) then return true end
		return false
	end
	
	local function IsNPC(flag)
		if flag and ( bit.band(flag, TYPE_NPC) > 0 ) then return true end
		return false
	end
	
	local anchor, endTime, showticks, sourceFunc
	local name, stacks, duration, unitCaster, debuffType

	function C:COMBAT_LOG_EVENT_UNFILTERED(event, timestamp, eventType, hideCaster,
					srcGUID, srcName, srcFlags, srcFlags2,
					dstGUID, dstName, dstFlags, dstFlags2,
					spellID, spellName, spellSchool, auraType, amount, extraSchool, extraType, ...)
			
			anchor, endTime, showticks, sourceFunc  = 1, nil, false, "CLEU"

			if eventType == "UNIT_DIED" or eventType == "UNIT_DESTROYED" or eventType == "SPELL_INSTAKILL" or eventType == "PARTY_KILL" then
				self.targetEngaged[dstGUID] = nil
				C.Timer_Remove_DEAD(dstGUID)			
				return
			end


			if not truedEvents[eventType] then return end		
			if srcGUID ~= self.myGUID and srcGUID ~= self.petGUID then return end
			
			if C.myCLASS == "HUNTER" and self:GetTrapType(spellID) then
			
				local trapType = self:GetTrapType(spellID)
				local active, nonactive = self:GetTrapEnable(spellID)
				
				local isplayer = IsPlayer(dstFlags)
				local icon = GetSpellTexture(spellID)
				
				if eventType == "SPELL_CAST_SUCCESS" then
				
					if nonactive and ( spellID == 60192 or spellID == 1499 ) then -- контроль на минуту каст 					
						C.Timer_Remove(dstGUID, srcGUID, trapType, 1, "TRAP", true)						
						C.Timer(self:GetDuration(spellID, dstGUID, 2, isplayer), nil, NO_GUID, srcGUID, trapType, 1, "TRAP", CLEU, 0, spellName, icon, 0, spellName, srcName, spellID)						
					elseif nonactive and ( spellID == 82939 or spellID == 13813 ) then -- контроль на минуту каст 					
						C.Timer_Remove(dstGUID, srcGUID, trapType, 1, "TRAP", true)						
						C.Timer(self:GetDuration(spellID, dstGUID, 2, isplayer), nil, NO_GUID, srcGUID, trapType, 1, "TRAP", CLEU, 0, spellName, icon, 0, spellName, srcName, spellID)						
					elseif active and spellID == 13812 then -- контроль на минуту каст 					
						C.Timer_Remove(NO_GUID, srcGUID, trapType, 1, "TRAP", true)						
						C.Timer(self:GetDuration(spellID, dstGUID, 2, isplayer), nil, NO_GUID, srcGUID, spellID, 1, "TRAP", CLEU, 0, spellName, icon, 0, spellName, srcName)				
					elseif nonactive and ( spellID == 82941 or spellID == 13809 ) then
						C.Timer_Remove(NO_GUID, srcGUID, trapType, 1, "TRAP", true)						
						C.Timer(self:GetDuration(spellID, dstGUID, 2, isplayer), nil, NO_GUID, srcGUID, trapType, 1, "TRAP", CLEU, 0, spellName, icon, 0, spellName, srcName, spellID)						
					elseif active and spellID == 13810 then
						C.Timer_Remove(NO_GUID, srcGUID, trapType, 1, "TRAP", true)						
						C.Timer(self:GetDuration(spellID, dstGUID, 2, isplayer), nil, NO_GUID, srcGUID, spellID, 1, "TRAP", CLEU, 0, spellName, icon, 0, spellName, srcName)					
					elseif nonactive and ( spellID == 82948 or spellID == 34600 ) then
						C.Timer_Remove(NO_GUID, srcGUID, trapType, 1, "TRAP", true)						
						C.Timer(self:GetDuration(spellID, dstGUID, 2, isplayer), nil, NO_GUID, srcGUID, trapType, 1, "TRAP", CLEU, 0, spellName, icon, 0, spellName, srcName, spellID)						
					elseif active and spellID == 45145 then	
						C.Timer_Remove(NO_GUID, srcGUID, trapType, 1, "TRAP", true)						
						C.Timer(self:GetDuration(spellID, dstGUID, 2, isplayer), nil, NO_GUID, srcGUID, spellID, 1, "TRAP", CLEU, 0, spellName, icon, 0, spellName, srcName)
					end
					
				--	print("T", eventType, active, nonactive, trapType, srcName, dstName, spellID, spellName)
				elseif eventType == "SPELL_AURA_APPLIED" then				
				--	print("T", eventType, trapType, srcName, dstName, spellID, spellName)
					
					if active and spellID == 3355 then -- контроль на минуту каст 					
						C.Timer_Remove(NO_GUID, srcGUID, trapType, 1, "TRAP", true)						
						C.Timer(self:GetDuration(spellID, dstGUID, 2, isplayer), nil, dstGUID, srcGUID, spellID, 1, "TRAP", CLEU, flagtort[dstFlags2], spellName, icon, 0, dstName, srcName)
					end
					
				elseif eventType == "SPELL_AURA_REMOVED" then
				--	print("T", eventType, trapType, srcName, dstName, spellID, spellName)
					if active and spellID == 3355 then
						C.Timer_Remove(dstGUID, srcGUID, spellID, 1, "TRAP")							
					end					
				end
				
				return
			end
			
			if self.IsFireMage then
				if eventType == 'SPELL_CAST_SUCCESS' and spellID == 108853 then				
					C.SpreadSpellDestGUID = dstGUID
				end				
			end
			
			dstName = dstName or spellName or srcName or ""
			
			if eventType == "SPELL_CAST_SUCCESS" then 
				auraType = SPELL_CAST
			elseif eventType == "SPELL_SUMMON" then
				auraType = SPELL_SUMMON
			elseif eventType == "SPELL_ENERGIZE" then
				auraType = SPELL_ENERGIZE
			end

			if not self:GetCLEUFilter(spellID, auraType) then return end
			if self:IsChanneling(spellID) then return end	
			if not self:CLEU_AffilationCheck(srcFlags, spellID) then return end
			if not self:CLEU_AffilationCheckTarget(dstFlags, spellID) then return end
			
			if not self:UnitFilter_GUID(dstGUID) then return end

			local tick, haste, pandemia = self:GetCLEUSpellInfo(spellID)
			if tick then showticks = true end

			local isplayer = IsPlayer(dstFlags)
			local icon = GetSpellTexture(spellID)
			
			local destName = isplayer and C.Erase(dstName) or dstName
			
			if eventType == "SPELL_AURA_REFRESH" then
				local name, amount, spell_id, duration, endTime_1, unitCaster, debuffType = C:GuidAuraInfo(dstGUID, spellID, auraType)
				return C.Timer(self:GetDuration(spellID, dstGUID, 2, isplayer), endTime, dstGUID, srcGUID, spellID, 1, auraType, CLEU, flagtort[dstFlags2], spellName, icon, amount or 0, destName, srcName)
			elseif eventType == "SPELL_AURA_APPLIED_DOSE" then
				return C.Timer_DOSE(dstGUID, srcGUID, spellID, 1, auraType, CLEU, flagtort[dstFlags2], amount)
			elseif eventType == "SPELL_AURA_APPLIED" then
				
				local name, amount, spell_id, duration, endTime_1, unitCaster, debuffType = C:GuidAuraInfo(dstGUID, spellID, auraType)
				
				if showticks then 
					self:GetTickInfo(spellID, dstGUID) 
					if pandemia then self:RegisterDotApply(dstGUID, spellID) end
				end
				return C.Timer(self:GetDuration(spellID, dstGUID, 1, isplayer), endTime, dstGUID, srcGUID, spellID, 1, auraType, CLEU, flagtort[dstFlags2], spellName, icon, amount or 0, destName, srcName)
			elseif eventType == "SPELL_AURA_REMOVED" then
				self:RemovePandemia(spellID, dstGUID)
				
				if showticks then 
					self:RemoveDotFromDB(dstGUID, spellID)
				end
				
				return C.Timer_Remove(dstGUID, srcGUID, spellID, 1, auraType)				
			elseif event == "SPELL_AURA_BROKEN" or event == "SPELL_AURA_BROKEN_SPELL" then
			
		--		print(eventType, srcName, spellID, spellName, dstName, dstGUID, srcGUID,auraType)
			elseif eventType == "SPELL_AURA_REMOVED_DOSE" then
				return C.Timer_DOSE(dstGUID, srcGUID, spellID, 1, auraType, CLEU, flagtort[dstFlags2], amount)
			elseif eventType == "SPELL_SUMMON" then
				return C.Timer(self:GetDuration(spellID, dstGUID, 1, isplayer), endTime, dstGUID, srcGUID, spellID, 1, auraType, CUSTOM_AURA, flagtort[dstFlags2], spellName, icon, amount or 0, destName, srcName)
			elseif eventType == "SPELL_CAST_SUCCESS" then
			
				if showticks and not pandemia then 									
					if not dstGUID then dstGUID = srcGUID end
					self:GetTickInfo(spellID, dstGUID) 
				end
				return C.Timer(self:GetDuration(spellID, dstGUID, 1, isplayer), endTime, dstGUID, srcGUID, spellID, 1, auraType, CUSTOM_AURA, flagtort[dstFlags2], spellName, icon, amount or 0, destName, srcName)
			elseif eventType == "SPELL_ENERGIZE" then

				return C.Timer(self:GetDuration(spellID, nil, nil, isplayer), endTime, dstGUID, srcGUID, spellID, 1, auraType, CUSTOM_AURA, flagtort[dstFlags2], spellName, icon, amount or 0, destName, srcName)
			end
	end
end

do

	local spellname_list = {}
	
	local exists_cd = {}

	local GetSpellBaseCooldown = GetSpellBaseCooldown
	
	local function GetSpellCooldownCharges(spellID)
	
		if spellID == 53351 and IsSpellKnown(157707) then 
			spellID = 157708
		end
		
		local startTime, duration, enabled = GetSpellCooldown(spellID)
		local charges, maxCharges, chargeStart, chargeDuration = GetSpellCharges(spellID)
		if charges and charges ~= maxCharges then
			startTime = chargeStart
			duration = chargeDuration
		end
		return startTime, duration, enabled, charges, maxCharges
	end

	
	local cd_frame = CreateFrame("Frame")
	cd_frame:SetScript("OnUpdate", function(self, elapsed)
		self.elapsed = ( self.elapsed or 0 ) + elapsed
		
		if self.elapsed < 0.2 then return end
		self.elapsed = 0
		
		local curtime = GetTime()
		
		for k,v in pairs(spellname_list) do
			local startTime, duration, enabled, charges, maxCharges = GetSpellCooldownCharges(v)
			
			if enabled and duration > 1.5 then			
				exists_cd[v] = curtime
				C.Timer(duration, startTime+duration, COOLDOWN_SPELL, COOLDOWN_SPELL, v, 1, COOLDOWN_SPELL, COOLDOWN_SPELL, 0, k, nil, 0, k, k)
			end
		end
		
		for k,v in pairs(exists_cd) do
			
			if v < curtime then			
				C.Timer_Remove(COOLDOWN_SPELL, COOLDOWN_SPELL, k, 1, COOLDOWN_SPELL, nil, true)
				v = nil
			end
		end
	end)
	
	C.UpdateBarsSpellList = function(self)
	
		for spellid, data in pairs(options.bars_cooldowns[self.myCLASS] or {}) do
	
			if not data.hide and not data.deleted and not data.fulldel then
				spellname_list[GetSpellInfo(spellid)] = spellid
			end
		end
		
		
	end
	
	
	C.UpdateBars_CooldownPart = function(self)
		
		if options.bar_module_enabled then
			cd_frame:Show()
		else
			cd_frame:Hide()		
		end
		
		self:UpdateBarsSpellList()
	end
end

do

	local channel_spell = {}

	local function UpdateChannelInfo(haste, anchor, showticks, spellID)
		if haste then		
			C:GetTickInfo(spellID, CHANNEL_SPELL)
		end
		
		local spell, _, displayName, icon, startTime, endTime, _, _, _ = UnitChannelInfo("player")
		
		if spell then
			local playerName = C.myNAME -- UnitName("player")
			local targetName = UnitName("target") or playerName

			return C.Timer((endTime-startTime)/1000, endTime/1000, CHANNEL_SPELL, C.myGUID, CHANNEL_SPELL, 1, CHANNEL_SPELL, CHANNEL_SPELL, nil, spell, icon, 0, targetName, playerName, spellID)
		end
	end
	
	function C:ScanForChannelingSpell()
		for k,v in pairs(self.db.profile.classSpells[self.myCLASS]) do
			local spell = GetSpellInfo(k)
			
			if spell then
				if v.channel then				
					channel_spell[spell] = k
				else				
					if channel_spell[spell] and not v.channel then
						channel_spell[spell] = nil			
					end
				end
			end
		end
	end
	
	function C:UNIT_SPELLCAST_CHANNEL_START(event,unit,spell,lineID,spellID)	
		if unit ~= "player" then return end

		local spellID = channel_spell[spell]		
		if not spellID then return end
		
	--	local anchor = self:GetAnchor(spellID)
		local showticks = self:GetCLEUSpellInfo(spellID)
		
	--	self.unitThrottle["target"] = 0
	--	self.unitThrottle["focus"] = 0
		
	--	self.GetUnitDebuffs("target", "UNIT_SPELLCAST_CHANNEL_START")
		
		self:UNIT_AURA(nil, "target")
		
		local skip = false 
		
		skip = C:GetWhiteListFilter(spellID, "BUFF", skip)
		skip = C:GetBlackListFilter(spellID, "BUFF", skip)
			
		if skip then
			UpdateChannelInfo(true, anchor, showticks, spellID)
		end
	end
	
	function C:UNIT_SPELLCAST_CHANNEL_STOP(event,unit, spell, rank, lineID, spellID)
		if unit ~= "player" then return end		
		if not C:IsChanneling(spellID) then return end
		C.Timer_Remove(CHANNEL_SPELL, self.myGUID, CHANNEL_SPELL, 1, CHANNEL_SPELL)	
		
	end

	function C:UNIT_SPELLCAST_CHANNEL_UPDATE(event,unit, spell, rank, lineID, spellID)
		if unit ~= "player" then return end
		if not C:IsChanneling(spellID) then return end
		local showticks = self:GetCLEUSpellInfo(spellID)
		local skip = false 
		
		skip = C:GetWhiteListFilter(spellID, "BUFF", skip)
		skip = C:GetBlackListFilter(spellID, "BUFF", skip)
			
		if skip then
			UpdateChannelInfo(false, anchor, showticks, spellID)
		end
	end
	
	
	
	function C:UNIT_SPELLCAST_SENT(event,unit,spell,rank,target,lineID)
		if unit ~= "player" then return end
		self:UNIT_AURA(nil, "target")
	end
	
	function C:UNIT_SPELLCAST_START(event,unit,spell,rank,lineID,spellID) --"unitID", "spell", "rank", lineID, spellID
		if unit ~= "player" then return end
		self:UNIT_AURA(nil, "target")
	end
	
	function C:UNIT_SPELLCAST_SUCCEEDED(event,unit,spell,rank,lineID,spellID)
		if unit ~= "player" then return end
		
		if spellID == 108853 then
			C.SpreadSpellCast = true
		else
			C.SpreadSpellCast = false
		end
		
		self:UNIT_AURA(nil, "target")
	end
	
	function C:UNIT_SPELLCAST_STOP(event,unit,spell,rank,lineID,spellID)
		if unit ~= "player" then return end
	end
end


function C:PLAYER_LOGIN()
	self.myGUID = UnitGUID("player")
	local _,class = UnitClass("player")	
	self.myCLASS = class
	self.myNAME = UnitName("player")
end

function C:UNIT_PET(event, unit)
	if unit == "player" then
		if UnitExists("pet") then
			self.petGUID = UnitGUID("pet")
		else
			self.petGUID = nil
		end
	end
end

do
	
	local totemsName = {}
	local totemItems = {5176, 5175, 5177, 5178 }
	
	-- 5176 -- Fire , 5175 -- Earth, 5178 -- Air , 5177 -- Water
	
	local function GetTotemFilter(i)
		
		if not totemsName[i] then
			totemsName[i] = GetItemInfo(totemItems[i])
		end
		
		return totemsName[i]
	end
	
	local loop = CreateFrame("Frame")
	loop.elapsed = 0
	loop:Hide()
	loop:SetScript("OnUpdate", function(self, elapsed)
		self.elapsed = self.elapsed + elapsed

		local alldone = true
		
		for i=1, MAX_TOTEMS do
			if GetTotemFilter(i) == nil then		
				alldone = false
			end
		end
		
		if alldone then
		--	print("Complete cache item in "..format("%.1f", self.elapsed).."s.")
			
			for i=1, MAX_TOTEMS do
				C:PLAYER_TOTEM_UPDATE(nil, i)
			end
			
			self.elapsed = 0
			self:Hide()
		end
	end)
	
	
	function C:UpdateTotems()
		if ( self.myCLASS == "SHAMAN" or self.myCLASS == "DRUID" ) then
			if ( self:ShowTotems("totem1") or self:ShowTotems("totem2") or self:ShowTotems("totem3") or self:ShowTotems("totem4") ) then
				self:RegisterEvent("PLAYER_TOTEM_UPDATE")
				loop:Show()
			end
		else	
			self:UnregisterEvent("PLAYER_TOTEM_UPDATE")
			for i=1, MAX_TOTEMS do
				C:PLAYER_TOTEM_UPDATE(nil, i, true)
			end
		end
	end
	
	-- TOTEM_SPELL
	
	function C:PLAYER_TOTEM_UPDATE(event, totem, rem)
--		print("PLAYER_TOTEM_UPDATE", totem)
		local anchor = self:GetAnchor("totem"..totem)
		local haveTotem, totemName, startTime, duration, icon = GetTotemInfo(totem)
		if not rem and self:ShowTotems("totem"..totem) and haveTotem and ( GetTotemFilter(totem) ~= totemName )then
			C.Timer(duration, startTime+duration, self.myGUID, self.myGUID, "totem"..totem, 1, "BUFF", TOTEM_SPELL, nil, totemName, icon, 0,self.myNAME, self.myNAME)
		else
			C.Timer_Remove(self.myGUID, self.myGUID, "totem"..totem, 1, "BUFF")
		end
	end
end

do
	local delayupdate = CreateFrame("Frame", nil, UIParent)
	delayupdate.elapsed = 0
	delayupdate.updates = {}
	delayupdate:Show()
	delayupdate:SetScript("OnUpdate", function(self, elapsed)
		self.elapsed = self.elapsed + elapsed
		
		if self.elapsed < 1 then return end
		
		for i=1, #delayupdate.updates do
			delayupdate.updates[i]()
		end
		
		wipe(self.updates)
		self:Hide()
	end)

	function C:PlayerLoginDelay(func)
		if type(func) == "function" then
			delayupdate.updates[#delayupdate.updates+1] = func
		end
	end
end

function C:CoreBarsStatusUpdate()
	if options.bar_module_enabled then
		
		self:RegisterEvent("PLAYER_TARGET_CHANGED")
		self:RegisterEvent("PLAYER_FOCUS_CHANGED")
		self:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
		self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		self:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START")
		self:RegisterEvent("UNIT_SPELLCAST_CHANNEL_STOP")
		self:RegisterEvent("UNIT_SPELLCAST_CHANNEL_UPDATE")
		self:RegisterEvent("UNIT_SPELLCAST_SENT")
		self:RegisterEvent("UNIT_SPELLCAST_START")
		self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
		self:RegisterEvent("UNIT_SPELLCAST_STOP")
	else
		self:UnregisterEvent("PLAYER_TARGET_CHANGED")
		self:UnregisterEvent("PLAYER_FOCUS_CHANGED")
		self:UnregisterEvent("UPDATE_MOUSEOVER_UNIT")
		self:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		self:UnregisterEvent("UNIT_SPELLCAST_CHANNEL_START")
		self:UnregisterEvent("UNIT_SPELLCAST_CHANNEL_STOP")
		self:UnregisterEvent("UNIT_SPELLCAST_CHANNEL_UPDATE")
		self:UnregisterEvent("UNIT_SPELLCAST_SENT")
		self:UnregisterEvent("UNIT_SPELLCAST_START")		
		self:UnregisterEvent("PLAYER_TOTEM_UPDATE")
		self:UnregisterEvent("UNIT_SPELLCAST_SUCCEEDED")
		self:UnregisterEvent("UNIT_SPELLCAST_STOP")
	end
	
	self:UpdateBars_CooldownPart()
end

local forced = true
function C:CheckDebugging()
	
	local _, battleTag = BNGetInfo()
	local myBTag = GetAddOnMetadata(addon, "Author")
	
	if battleTag then
		if myBTag == battleTag and forced then 
			self.dodebugging = true
			message("DEBUGGING ON")
		end

		self:UnregisterEvent("BN_CONNECTED")
		self:UnregisterEvent("BN_SELF_ONLINE")
		self:UnregisterEvent("BN_INFO_CHANGED")
	end
end

C.BN_CONNECTED = C.CheckDebugging
C.BN_SELF_ONLINE = C.CheckDebugging
C.BN_INFO_CHANGED = C.CheckDebugging

SLASH_SPTIMERSDEBUG1 = '/sptimersdebugging'
function SPTIMERSDEBUGHandler(msg, editBox)
	C.dodebugging = not C.dodebugging
	
	message( (C.dodebugging and "DEBUGGING ON" or "DEBUGGING OFF" ) )
end

SlashCmdList["SPTIMERSDEBUG"] = SPTIMERSDEBUGHandler

do
	local raid = {}
	
	C.RaidRoster = raid
	
	local IsInRaid, IsInGroup = IsInRaid, IsInGroup
	local inraid = false
	local format = format
	local wipe = wipe
	local UnitExists = UnitExists
	local GetNumGroupMembers, GetNumSubgroupMembers = GetNumGroupMembers, GetNumSubgroupMembers
	local UnitAura, GetSpellInfo = UnitAura, GetSpellInfo
	
	local function LeaveFromRaidOrGroup()
		if not IsInRaid() then
			if inraid then inraid = false; wipe(raid) end
		elseif IsInRaid() then
			if not inraid then inraid = true end
		end
	end
	
	local function CheckUnit(unit)
		if not UnitExists(unit) then return end	
		local guid = UnitGUID(unit)
		if not guid then return end

		raid[guid] = unit
		
	--	print(raid[guid], guid, unit)
	end
	
	function C:GetRaidGUID(guid)		
		return raid[guid]
	end
	
	local auratypes = {
		['DEBUFF']	= 'HARMFUL',
		['BUFF']	= 'HELPFUL',
		['HARMFUL'] = 'HARMFUL',
		['HELPFUL'] = 'HELPFUL',
	}
	
	function C:GuidAuraInfo(guid, spell, auratype)
		if not raid[guid] then return end

		local spellname = type(spell) == "number" and GetSpellInfo(spell) or spell
		
		local name, _, _, count, debuffType, duration, endTime, unitCaster, _, _, spellID = UnitAura(raid[guid], spellname, nil, auratypes[auratype])
		
	--	print("GuidAuraInfo", guid, spell, auratype, name, auratypes[auratype])
		if name and ( spellname == name or spell == spellID ) then		
			return name, count, spellID, duration, endTime, unitCaster, debuffType
		end
		
		return nil
	end
	
	function C:UpdateRaid()
		wipe(raid)

		LeaveFromRaidOrGroup()
		
		if IsInRaid() then
		  for i = 1, GetNumGroupMembers() do
			CheckUnit(format("raid%d", i))
		  end
		end
		
		if IsInGroup() and not IsInRaid() then
		  for i = 1, GetNumSubgroupMembers() do
			CheckUnit(format("party%d", i))
		  end
		end
		
		CheckUnit("player")
	end
	
	C.GROUP_ROSTER_UPDATE = C.UpdateRaid
	C.PLAYER_ENTERING_WORLD = C.UpdateRaid
	C.PLAYER_ENTERING_BATTLEGROUND = C.UpdateRaid
	C.GROUP_JOINED = C.UpdateRaid
	C.RAID_INSTANCE_WELCOME = C.UpdateRaid
	C.ZONE_CHANGED_NEW_AREA = C.UpdateRaid	
end

do
	local isInPetBattle = C_PetBattles.IsInBattle;
	function C:PET_BAR_UPDATE()	
		if ( options.hide_during_petbattle and isInPetBattle() ) then 
			parent:Hide() 
		else 
			parent:Show() 
		end
	end
	
	C.PET_BATTLE_OPENING_START = C.PET_BAR_UPDATE
	C.PET_BATTLE_OPENING_DONE = C.PET_BAR_UPDATE
	C.PET_BATTLE_CLOSE = C.PET_BAR_UPDATE
	C.PET_BATTLE_OVER = C.PET_BAR_UPDATE
end

local LSM_Update = CreateFrame("Frame")
LSM_Update:Hide()
LSM_Update:SetScript("OnUpdate", function(self, elapsed)
	self.elapsed = ( self.elapsed or 0 ) + elapsed
	
	if self.elapsed < 0.1 then return end
	
	C:Visibility()
	C.UpdateSettings()
	C.UpdateCastBarsStyle()

	self:Hide()
	self.elapsed = 0
end)
C.LSM.RegisterCallback(LSM_Update, "LibSharedMedia_Registered", function(mtype, key)
	LSM_Update:Show();	
end)

local function ShowHideUI()
	if AleaUI_GUI:IsOpened(addon) then
		AleaUI_GUI:Close(addon)
	else
		AleaUI_GUI:Open(addon)
	end
end

function C:OnInitialize()
	
	self:ImportProfilesFromV2()
	
	self.myGUID = UnitGUID("player")

	local _,class = UnitClass("player")	
	self.myCLASS = class
	self.petGUID = UnitGUID("pet")
	self.myNAME = UnitName("player")
	
	self.myHaste = 1
	
	self:DefaultOptions()

	self.options = self:OptionsTable()
	
	AleaUI_GUI:RegisterMainFrame(addon, self.options)
	
	if self.SetupClassOptions then
		self:SetupClassOptions()
	end

	self:InitSupports()
	
	options = self.db.profile
	
	self:RemoveSpellExists(options)
	
	self:CheckForMissingBarsData()

	self:InitFrames()
	self:InitCooldownLine()
	self:CastBarInit()
	self:CoPToggle()
	self:PreCacheCustomTextCheck()
	
	self:RegisterEvent("UNIT_AURA")

	self:RegisterEvent("PLAYER_REGEN_ENABLED")
	self:RegisterEvent("PLAYER_REGEN_DISABLED")

	self:RegisterEvent("BN_CONNECTED")
	self:RegisterEvent("BN_SELF_ONLINE")
	self:RegisterEvent("BN_INFO_CHANGED")
	
	self:RegisterEvent("PLAYER_LOGIN")

	self:PlayerLoginDelay(function() C:UpdateTotems() end)

	self:RegisterEvent("GROUP_ROSTER_UPDATE")
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
	self:RegisterEvent("PLAYER_ENTERING_BATTLEGROUND")
	self:RegisterEvent("GROUP_JOINED")
	self:RegisterEvent("RAID_INSTANCE_WELCOME")
	self:RegisterEvent("ZONE_CHANGED_NEW_AREA")
	
	self:RegisterEvent("PET_BAR_UPDATE")
	self:RegisterEvent("PET_BATTLE_OPENING_START")
	self:RegisterEvent("PET_BATTLE_OPENING_DONE")
	self:RegisterEvent("PET_BATTLE_CLOSE")
	self:RegisterEvent("PET_BATTLE_OVER")

	
	
	self:RegisterEvent("UNIT_PET")
	
	self:ScanForChannelingSpell()
	self:RebuildBanCD()
	self:CoreBarsStatusUpdate()
	self:CheckDebugging()
	self:UpdateBars_CooldownPart()
	self:InitVersionCheck()
	
	AleaUI_GUI.SlashCommand(addon, "/sptimers", ShowHideUI)
	AleaUI_GUI.MinimapButton(addon, { OnClick = ShowHideUI, texture = "Interface\\Icons\\spell_shadow_shadowwordpain" }, self.db.profile.minimap)
	
	ALEAUI_OnProfileEvent("SPTimersDB","PROFILE_CHANGED", function()	
		C:OnProfileChange()
	end)
	
	ALEAUI_OnProfileEvent("SPTimersDB","PROFILE_RESET", function()	
		C:OnProfileChange()
	end)
	
	if self.InitStatWeight then
		self.options.args.preset = self:InitStatWeight()
	end
end

local loader = CreateFrame("Frame")
loader:RegisterEvent("ADDON_LOADED")
loader:SetScript("OnEvent", function(self, event, unit)
	if unit ~= addon then return end
	C:OnInitialize()
	self:UnregisterAllEvents()
	self = nil
end)

function C:OnProfileChange()

	self.onUpdateHandler:SetScript("OnUpdate", nil)
	
	self.myGUID = UnitGUID("player")

	local _,class = UnitClass("player")	
	self.myCLASS = class
	self.petGUID = UnitGUID("pet")
	self.myNAME = UnitName("player")

	self:DefaultOptions()
	
	self.options = self:OptionsTable()
	
	AleaUI_GUI:RegisterMainFrame(addon, self.options)
	
	if self.SetupClassOptions then
		self:SetupClassOptions()
	end

	self:InitSupports()
	
	--self:OnAnchorStyleReset()
	
	options = self.db.profile
	
	self:RemoveSpellExists(options)
	
	self:CheckForMissingBarsData()
	
	self:ProfileSwapBars()
	self:InitCooldownLine()
	self:CastBarInit()
	self:CoPToggle()
	self:PreCacheCustomTextCheck()
	
	self:RegisterEvent("UNIT_AURA")
	self:RegisterEvent("PLAYER_REGEN_ENABLED")
	self:RegisterEvent("PLAYER_REGEN_DISABLED")
	self:RegisterEvent("PLAYER_LOGIN")
	self:RegisterEvent("GROUP_ROSTER_UPDATE", "UpdateRaid")
	self:RegisterEvent("PLAYER_ENTERING_WORLD", "UpdateRaid")
	self:RegisterEvent("PLAYER_ENTERING_BATTLEGROUND", "UpdateRaid")
	self:RegisterEvent("GROUP_JOINED", "UpdateRaid")
	self:RegisterEvent("RAID_INSTANCE_WELCOME", "UpdateRaid")
	self:RegisterEvent("ZONE_CHANGED_NEW_AREA", "UpdateRaid")
	self:RegisterEvent("UNIT_PET")

	self:RebuildBanCD()
	self:CheckDebugging() 
	self:ScanForChannelingSpell()	
	self:CoreBarsStatusUpdate()
	self:UpdateTotems()
	self:UpdateBars_CooldownPart()	
	self:OnAnchorStyleReset()
	
	AleaUI_GUI.GetMinimapButton(addon):Update(self.db.profile.minimap)
end

do
	local mover_frames = {}
	local function createbutton(parent, name)
		if not parent.buttons then parent.buttons = {} end
		
		local f = CreateFrame("Button", parent:GetName().."Button"..#parent.buttons+1, parent)
		f:SetFrameLevel(parent:GetFrameLevel() + 1)
		f.parent = parent
		f:SetText(name)
		f:SetWidth(20) --ширина
		f:SetHeight(20) --высота
		f:SetNormalFontObject("GameFontNormalSmall")
		f:SetHighlightFontObject("GameFontHighlightSmall")
		f:SetBackdrop({
				bgFile = [=[Interface\ChatFrame\ChatFrameBackground]=],
				edgeFile = [=[Interface\ChatFrame\ChatFrameBackground]=],
				edgeSize = 1,
				insets = {top = 0, left = 0, bottom = 0, right = 0},
					})
		f:SetBackdropColor(0,0,0,1)
		f:SetBackdropBorderColor(.3,.3,.3,1)
		
		f:SetScript("OnEnter", function(self)
				self:SetBackdropBorderColor(1,1,1,1) --цвет краев
			end)
			f:SetScript("OnLeave", function(self)
				self:SetBackdropBorderColor(.3,.3,.3,1) --цвет краев
			end)
			
		local t = f:GetFontString()
		t:SetFont("Fonts\\ARIALN.TTF", 12, "OUTLINE")
		t:SetJustifyH("CENTER")
		t:SetJustifyV("CENTER")
		f.text = t
		
		return f
	end
	
	local function createeditboxe(parent)
		if not parent.editboxes then parent.editboxes = {} end
		local textbox = CreateFrame("EditBox", parent:GetName().."EditBox"..#parent.editboxes+1, parent)
		textbox:SetFont("Fonts\\ARIALN.TTF", 12, "OUTLINE")
		textbox:SetFrameLevel(parent:GetFrameLevel() + 1)
		textbox:SetAutoFocus(false)
		textbox:SetWidth(50)
		textbox:SetHeight(20)
		textbox:SetJustifyH("LEFT")
		textbox:SetJustifyV("CENTER")
		textbox:SetBackdrop({
				bgFile = [=[Interface\ChatFrame\ChatFrameBackground]=],
				edgeFile = [=[Interface\ChatFrame\ChatFrameBackground]=],
				edgeSize = 1,
				insets = {top = 0, left = 0, bottom = 0, right = 0},
					})
		textbox:SetBackdropColor(0,0,0,1)
		textbox:SetBackdropBorderColor(1,1,1,0.5)
		
		textbox.ok = createbutton(textbox, "OK")
		textbox.ok.editbox = textbox
		textbox.ok.text:SetFont("Fonts\\ARIALN.TTF", 10, "OUTLINE")
		textbox.ok:SetSize(15,15)
		textbox.ok:SetPoint("RIGHT", textbox, "RIGHT", -2, 0)
		textbox.ok:Hide()
		
		textbox:SetScript("OnEscapePressed", function(self)
			self:ClearFocus()
		end)
		textbox:SetScript("OnEnterPressed", function(self)
			self.ChangePosition(self.ok)
		end)
		return textbox
	end
	
	local buttons_name = { "◄", "▲", "▼", "►" }
	local buttons_move = { { -1, 0 } , { 0, 1 }, { 0, -1} , { 1, 0} }
	
	function C:UpdateMoverPosition()
		for k,v in pairs(mover_frames) do
			k:UpdatePoint()
		end
	end
	
	local _unnm = 0
	local function CountUnnamesFrames()
		_unnm = _unnm + 1
		
		return _unnm
	end

	function C.AddMoverButtons(self, opts, tip, tomover, float)
		if not self.mover_add_button then			
			self.mover_add_button = CreateFrame("Frame", (self:GetName() or "SPTimersUnnamedFrame"..CountUnnamesFrames()).."MoverToolTip", self)
			self.mover_add_button.mover = self
			self.mover_add_button.opts = opts
			self.mover_add_button.tip = tip
			self.mover_add_button.tomover = tomover
			self.mover_add_button.float = float
			self.mover_add_button.buttons = {}
			self.mover_add_button.editboxes = {}
			self.mover_add_button:SetSize(120, 70)
			self.mover_add_button:SetClampedToScreen(true)
			self.mover_add_button:SetBackdrop({bgFile = "Interface\\ChatFrame\\ChatFrameBackground",})	
			self.mover_add_button:SetBackdropColor(0, 0, 0, 0.7)
			self.mover_add_button:Show()
			self.mover_add_button.UpdatePoint = function(self)
				
				self:ClearAllPoints()
				
				if self.tomover then
					self:SetPoint("TOP", self.mover, "TOP",0,-3)
					self:SetBackdropColor(0, 0, 0, 0)
				else
					if self.opts and not self.opts.add_up then
						self:SetPoint("BOTTOM", self.mover, "TOP",0, 3)
					else
						self:SetPoint("TOP", self.mover, "BOTTOM",0,-3)
					end
				end
				
				if options.show_more_buttons then 
					self:Show()
				else
					self:Hide()
				end
				
				for k,v in pairs(self.editboxes) do
					v:UpdateText()
				end
			end
			
			mover_frames[self.mover_add_button] = true
			
			for i=1,4 do				
				self.mover_add_button.buttons[i] = createbutton(self.mover_add_button, buttons_name[i])
				self.mover_add_button.buttons[i].i = i
				self.mover_add_button.buttons[i].owner = self.mover_add_button
				
				if i == 1 then
					self.mover_add_button.buttons[i]:SetPoint("TOPRIGHT", self.mover_add_button, "TOP", 0, -3)
				elseif i == 2 then
					self.mover_add_button.buttons[i]:SetPoint("TOPRIGHT", self.mover_add_button, "TOP", -21, -3)
				elseif i == 3 then
					self.mover_add_button.buttons[i]:SetPoint("TOPLEFT", self.mover_add_button, "TOP", 0, -3)
				elseif i == 4 then
					self.mover_add_button.buttons[i]:SetPoint("TOPLEFT", self.mover_add_button, "TOP", 21, -3)
				end
				
				self.mover_add_button.buttons[i]:SetScript("OnClick", function(self)
					
					if self.owner.opts then
						self.owner.opts.point[1] = (tonumber(self.owner.opts.point[1]) or 0) + buttons_move[self.i][1]
						self.owner.opts.point[2] = (tonumber(self.owner.opts.point[2]) or 0) + buttons_move[self.i][2]
						
						self.owner.mover:ClearAllPoints()
						self.owner.mover:SetPoint("CENTER", parent, "CENTER", self.owner.opts.point[1], self.owner.opts.point[2] )
					elseif self.owner.tip and self.owner.tip == "line" then
					
						C.db.profile.cooldownline.x = (tonumber(C.db.profile.cooldownline.x) or 0) + buttons_move[self.i][1]
						C.db.profile.cooldownline.y = (tonumber(C.db.profile.cooldownline.y) or 0) + buttons_move[self.i][2]
						
						self.owner.mover:ClearAllPoints()
						self.owner.mover:SetPoint("CENTER", parent, "CENTER", C.db.profile.cooldownline.x, C.db.profile.cooldownline.y)
					elseif self.owner.tip and self.owner.tip == "splash" then
						C.db.profile.cooldownline.slash_x = (tonumber(C.db.profile.cooldownline.slash_x) or 0) + buttons_move[self.i][1]
						C.db.profile.cooldownline.slash_y = (tonumber(C.db.profile.cooldownline.slash_y) or 0) + buttons_move[self.i][2]
						
						self.owner.mover:ClearAllPoints()
						self.owner.mover:SetPoint("CENTER", parent, "CENTER", C.db.profile.cooldownline.slash_x, C.db.profile.cooldownline.slash_y)
					end
					for k,v in pairs(self.owner.editboxes) do
						v:UpdateText()					
					end
				end)
			end
			
			if float then
				self.mover_add_button.buttons[5] = createbutton(self.mover_add_button, "=====")
				self.mover_add_button.buttons[5]:SetPoint("BOTTOM", self.mover_add_button, "BOTTOM", 0, 3)
				self.mover_add_button.buttons[5]:SetSize(50, 10)
				self.mover_add_button.buttons[5].owner = self.mover_add_button
				self.mover_add_button.buttons[5]:SetScript("OnClick", function(self)
					local a1,a2,a3,a4,a5 = self.owner:GetPoint()
					self.owner:ClearAllPoints()
					self.owner:SetPoint(a3,a2,a1,0, -a5)
				end)
			end
			
			for i=1,2 do				
				self.mover_add_button.editboxes[i] = createeditboxe(self.mover_add_button)
				self.mover_add_button.editboxes[i].i = i
				self.mover_add_button.editboxes[i].owner = self.mover_add_button
				
				if i == 1 then
					self.mover_add_button.editboxes[i]:SetPoint("TOPRIGHT", self.mover_add_button, "TOP", -1, -30)
				else
					self.mover_add_button.editboxes[i]:SetPoint("TOPLEFT", self.mover_add_button, "TOP", 1, -30)
				end
				
				self.mover_add_button.editboxes[i]:SetScript("OnTextChanged", function(self, user)
					if user then
						self.ok:Show()
						
						self.ok:SetScript("OnClick", self.ChangePosition)
					end
				end)
				
				self.mover_add_button.editboxes[i].ChangePosition = function(self)
					local num = tonumber(self.editbox:GetText())				
					if num then
						if self.editbox.owner.opts then
							self.editbox.owner.opts.point[self.editbox.i] = num
								
							self.editbox.owner.mover:ClearAllPoints()
							self.editbox.owner.mover:SetPoint("CENTER", parent, "CENTER", self.editbox.owner.opts.point[1], self.editbox.owner.opts.point[2])
						elseif self.editbox.owner.tip and self.editbox.owner.tip == "line" then
							
							if self.editbox.i == 1 then
								C.db.profile.cooldownline.x = num
							else
								C.db.profile.cooldownline.y = num
							end
							
							self.editbox.owner.mover:ClearAllPoints()
							self.editbox.owner.mover:SetPoint("CENTER", parent, "CENTER", C.db.profile.cooldownline.x, C.db.profile.cooldownline.y)
						elseif self.editbox.owner.tip and self.editbox.owner.tip == "splash" then
							if self.editbox.i == 1 then
								C.db.profile.cooldownline.slash_x = num
							else
								C.db.profile.cooldownline.slash_y = num
							end
							self.editbox.owner.mover:ClearAllPoints()
							self.editbox.owner.mover:SetPoint("CENTER", parent, "CENTER", C.db.profile.cooldownline.slash_x, C.db.profile.cooldownline.slash_y)
						end
					else
						self.editbox:UpdateText()
					end
					self:SetScript("OnClick", nil)
					self:Hide()
					
					self.editbox:ClearFocus()
				end
				self.mover_add_button.editboxes[i]:SetScript("OnShow", function(self) self:UpdateText() end)
				
				self.mover_add_button.editboxes[i].UpdateText = function(self)
					if self.owner.opts then
						self:SetText(tonumber(self.owner.opts.point[self.i]) or 0)
					elseif self.owner.tip and self.owner.tip == "line" then
						if self.i == 1 then
							self:SetText(tonumber(C.db.profile.cooldownline.x) or 0)
						else
							self:SetText(tonumber(C.db.profile.cooldownline.y) or 0)
						end
					elseif self.owner.tip and self.owner.tip == "splash" then
						if self.i == 1 then
							self:SetText(tonumber(C.db.profile.cooldownline.slash_x) or 0)
						else
							self:SetText(tonumber(C.db.profile.cooldownline.slash_y) or 0)
						end
					end
				end
				
				self.mover_add_button.editboxes[i]:UpdateText()
			end
		end
		self.mover_add_button.opts = opts
			
		self.mover_add_button.x = x
		self.mover_add_button.y = y
		self.mover_add_button:UpdatePoint()
	end
end


do
	
	local hooksecurefunc, select, UnitBuff, UnitDebuff, UnitAura, UnitGUID, GetGlyphSocketInfo, tonumber, strfind, strsub, strmatch =
      hooksecurefunc, select, UnitBuff, UnitDebuff, UnitAura, UnitGUID, GetGlyphSocketInfo, tonumber, strfind, strsub, strmatch

	local types = {
		spell      = "|cFFCA3C3CSpell ID:|r",
		item       = "|cFFCA3C3CItem ID:|r",
		talent     = "|cFFCA3C3CTalent ID:|r",
	}

	local function addLine(tooltip, id, type, type2)
		local found = false
		
		if type2 == 'spell' and not options.show_spellid_tooltip then return end
		if type2 == 'talent' and not options.show_spellid_tooltip then return end
		if type2 == 'item' and not options.show_item_spellid then return end

		-- Check if we already added to this tooltip. Happens on the talent frame
		for i = 1,15 do
			local frame = _G[tooltip:GetName() .. "TextLeft" .. i]
			local text
			if frame then text = frame:GetText() end
			if text and text == type then found = true break end
		end

		if not found then
			tooltip:AddDoubleLine(type, "|cffffffff" .. id)
			tooltip:Show()
		end
	end

	-- All types, primarily for linked tooltips
	local function onSetHyperlink(self, link)
		if not options.show_item_spellid and not options.show_spellid_tooltip then return end
		local type, id = string.match(link,"^(%a+):(%d+)")
		if not type or not id then return end
		if type == "spell" then
			addLine(self, id, types.spell, type)
		elseif type == "talent" then
			addLine(self, id, types.talent, type)
		elseif type == "item" then
			addLine(self, id, types.item, type)
		end
	end

	hooksecurefunc(ItemRefTooltip, "SetHyperlink", onSetHyperlink)
	hooksecurefunc(GameTooltip, "SetHyperlink", onSetHyperlink)

	-- Spells
	hooksecurefunc(GameTooltip, "SetUnitBuff", function(self, ...)
		local id = select(11, UnitBuff(...))
		if id then addLine(self, id, types.spell, 'spell') end
	end)

	hooksecurefunc(GameTooltip, "SetUnitDebuff", function(self,...)
		local id = select(11, UnitDebuff(...))
		if id then addLine(self, id, types.spell, 'spell') end
	end)

	hooksecurefunc(GameTooltip, "SetUnitAura", function(self,...)
		local id = select(11, UnitAura(...))
		if id then addLine(self, id, types.spell, 'spell') end
	end)

	hooksecurefunc("SetItemRef", function(link, ...)
		local id = tonumber(link:match("spell:(%d+)"))
		if id then addLine(ItemRefTooltip, id, types.spell, 'spell') end
	end)

	GameTooltip:HookScript("OnTooltipSetSpell", function(self)
		local id = select(3, self:GetSpell())
		if id then addLine(self, id, types.spell, 'spell') end
	end)


	-- Items
	local function attachItemTooltip(self)
		local link = select(2, self:GetItem())
		if link then
			local id = select(3, strfind(link, "^|%x+|Hitem:(%-?%d+):(%d+):(%d+).*"))
			if id then addLine(self, id, types.item, 'item') end
		end
	end

	GameTooltip:HookScript("OnTooltipSetItem", attachItemTooltip)
	ItemRefTooltip:HookScript("OnTooltipSetItem", attachItemTooltip)
	ItemRefShoppingTooltip1:HookScript("OnTooltipSetItem", attachItemTooltip)
	ItemRefShoppingTooltip2:HookScript("OnTooltipSetItem", attachItemTooltip)
	ShoppingTooltip1:HookScript("OnTooltipSetItem", attachItemTooltip)
	ShoppingTooltip2:HookScript("OnTooltipSetItem", attachItemTooltip)
	
end
