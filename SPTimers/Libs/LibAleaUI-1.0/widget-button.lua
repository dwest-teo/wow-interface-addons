if AleaUI_GUI then return end
local C = _G['AleaGUI_PrototypeLib']

C.executeFrames = {}

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
	
end

local function CreateCoreButton(parent)
	local f = CreateFrame('Button', nil, parent, "UIPanelButtonTemplate")
	f:SetSize(160, 22)
	f:SetFrameLevel(parent:GetFrameLevel() + 2)

	f:SetScript("OnEnter", function(self)	
		C.Tooltip(self, self._rname, self.desc, "show")
	end)
	f:SetScript("OnLeave", function(self)
		C.Tooltip(self, self._rname, self.desc, "hide")
	end)
	
	f:SetScript("OnMouseUp", function(self)
		self.text:SetPoint("LEFT", self, "LEFT", 3 , 0)
		self.text:SetPoint("RIGHT", self, "RIGHT", -3 , 0)
	end)
	
	f:SetScript("OnMouseDown", function(self)
		self.text:SetPoint("LEFT", self, "LEFT", 2 , -1)
		self.text:SetPoint("RIGHT", self, "RIGHT", -4 ,-1)
	end)
	
	f:SetScript("OnClick", function(self)
		self._OnClick()
		C:GetRealParent(self):RefreshData()
	end)

	local text = f:CreateFontString(nil, 'OVERLAY', "GameFontHighlight")
	text:SetPoint("LEFT", f, "LEFT", 3 , 0)
	text:SetPoint("RIGHT", f, "RIGHT", -3 , 0)
	text:SetTextColor(1, 0.8, 0)
	text:SetJustifyH("CENTER")
	text:SetWordWrap(false)
	
	f.text = text
	
	return f
end

function C:CreateExecuteButton()
	
	for i=1, #C.executeFrames do
		if C.executeFrames[i].free then
			return C.executeFrames[i]
		end
	end
	
	local f = CreateFrame("Frame", nil, UIParent)
	f:SetSize(180, 35)
	f.free = true
	
	f.main = CreateCoreButton(f)
	f.main:SetPoint("TOPLEFT", f, "TOPLEFT", 5, -10)
	f.main:SetPoint("RIGHT", f, "RIGHT", 0, 0)
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
	
	C.executeFrames[#C.executeFrames+1] = f
	
	return f
end
	
C.prototypes["execute"] = "CreateExecuteButton"