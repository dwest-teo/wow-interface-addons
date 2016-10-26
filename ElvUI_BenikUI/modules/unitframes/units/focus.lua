local E, L, V, P, G = unpack(ElvUI);
local UFB = E:GetModule('BuiUnits');
local UF = E:GetModule('UnitFrames');

local _G = _G

-- GLOBALS: hooksecurefunc

function UFB:ArrangeFocus()
	local frame = _G["ElvUF_Focus"]
	local db = E.db['unitframe']['units'].focus
	
	-- Portrait
	UFB:Configure_Portrait(frame)
	
	frame:UpdateAllElements("BenikUI_UpdateAllElements")
end

function UFB:InitFocus()
	if not E.db.unitframe.units.focus.enable then return end
	hooksecurefunc(UF, 'Update_FocusFrame', UFB.ArrangeFocus)
end