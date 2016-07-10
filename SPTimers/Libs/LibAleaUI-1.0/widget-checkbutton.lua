if AleaUI_GUI then return end
local C = _G['AleaGUI_PrototypeLib']

C.toggleFrames = {}

local function Update(self, panel, opts)
	
	self.free = false
	self:SetParent(panel)
	self:Show()	
	
	self:SetDescription(opts.desc)
	self:SetName(opts.name)	
	self:UpdateState(opts.func or opts.set, opts.get)
	
end

local function Remove(self)
	self.free = true
	self:Hide()	
end

local function SetName(self, name)
	self.main._rname = name
	self.main.text:SetText(name)
end

local function SetDescription(self, text)
	self.main.desc = text
end

local function UpdateState(self, func, get)
	
	self.main._OnClick = func
	self.main._OnShow = get

	self.main.button:SetChecked(self.main._OnShow())
end

local function CreateCoreButton(parent)

	local f = CreateFrame("Frame", nil, parent)
	f:SetSize(170, 25)
	
	local button = CreateFrame('CheckButton', nil, f, "UICheckButtonTemplate") --"UICheckButtonTemplate"
	button:SetFrameLevel(f:GetFrameLevel() + 1)
	button:SetPoint("TOPLEFT")
	button.f = f
	button:SetSize(26, 26)
	button:SetCheckedTexture("Interface\\Buttons\\UI-CheckBox-Check")
	button:SetDisabledCheckedTexture("Interface\\Buttons\\UI-CheckBox-Check-Disabled")

	button:SetScript("OnEnter", function(self)	
		C.Tooltip(self, f._rname, f.desc, "show")
	end)
	button:SetScript("OnLeave", function(self)
		C.Tooltip(self, f._rname, f.desc, "hide")
	end)

	button:SetScript("OnClick", function(self)
		self.f._OnClick()
		self:SetChecked(self.f._OnShow())		
		C:GetRealParent(self):RefreshData()
	end)

	local text = f:CreateFontString(nil, 'OVERLAY', "GameFontHighlight")
	text:SetPoint("LEFT", button, "RIGHT", 0 , 0)
	text:SetPoint("RIGHT", parent, "RIGHT", 0 , 0)	
--	text:SetFont(STANDARD_TEXT_FONT, 12, "OUTLINE")
	text:SetText("TEST")
	text:SetTextColor(1, 1, 1)
	text:SetJustifyH("LEFT")
	text:SetWordWrap(false)
	
	button:SetScript("OnMouseUp", function(self)
		self.f.text:SetPoint("LEFT", self, "RIGHT", 0 , 0)
		self.f.text:SetPoint("RIGHT", self.f:GetParent(), "RIGHT", 0 , 0)	
	end)
	
	button:SetScript("OnMouseDown", function(self)
		self.f.text:SetPoint("LEFT", self, "RIGHT", 0 , -1)
		self.f.text:SetPoint("RIGHT", self.f:GetParent(), "RIGHT", 0 , -1)
	end)
	
	f.button = button
	
	f.mouseover = CreateFrame("Frame", nil, f)
	f.mouseover:SetFrameLevel(f:GetFrameLevel()-1)
	f.mouseover.f = f
	f.mouseover:SetSize(1,1)
	f.mouseover:SetPoint("TOPLEFT", text, "TOPLEFT", -3, 3)
	f.mouseover:SetPoint("BOTTOMRIGHT", text, "BOTTOMRIGHT", 3, -3)
	f.mouseover:SetScript("OnEnter", function(self)		
		C.Tooltip(self, f._rname, f.desc, "show")
	end)
	f.mouseover:SetScript("OnLeave", function(self)
		C.Tooltip(self, f._rname, f.desc, "hide")
	end)
	f.mouseover:SetScript("OnMouseUp", function(self)
		self.f.text:SetPoint("LEFT", self.f.button, "RIGHT", 0 , 0)
		self.f.text:SetPoint("RIGHT", self.f:GetParent(), "RIGHT", 0 , 0)	
		
		self.f._OnClick()
		self.f.button:SetChecked(self.f._OnShow())	
		C:GetRealParent(self.f):RefreshData()
	end)	
	f.mouseover:SetScript("OnMouseDown", function(self)
		self.f.text:SetPoint("LEFT", self.f.button, "RIGHT", 0 , -1)
		self.f.text:SetPoint("RIGHT", self.f:GetParent(), "RIGHT", 0 , -1)
	end)
	
	f.text = text
	
	return f
end

function C:CreateToggle()
	
	for i=1, #C.toggleFrames do
		if C.toggleFrames[i].free then
			return C.toggleFrames[i]
		end
	end
	
	local f = CreateFrame("Frame", nil, UIParent)
	f:SetSize(180, 35)
	f.free = true
	
	f.main = CreateCoreButton(f)
	f.main:SetPoint("TOPLEFT", f, "TOPLEFT", 5, -10)
	
	--[[
	local bg = f:CreateTexture()
	bg:SetAllPoints()
	bg:SetTexture(0.5, 1, 0.5, 1)
	]]
	f.Update = Update
	f.Remove = Remove
	f.SetName = SetName
	f.UpdateState = UpdateState
	f.SetDescription = SetDescription
	
	C.toggleFrames[#C.toggleFrames+1] = f
	
	return f
end
	
C.prototypes["toggle"] = "CreateToggle"