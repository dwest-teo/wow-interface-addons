if AleaUI_GUI then return end
local C = _G['AleaGUI_PrototypeLib']

C.sliderFrames = {}

local function Update(self, panel, opts)
	
	self.free = false
	self:SetParent(panel)
	self:Show()	
	
	self:SetDescription(opts.desc)
	self:SetMinMaxStep(opts.min, opts.max, opts.step)
	self:SetName(opts.name)	
	self:UpdateState(opts.set, opts.get)
	
end

local function Remove(self)
	self.free = true
	self.main:SetScript("OnValueChanged", nil)
	self:Hide()	
	self.main._lastval = nil
end

local function SetName(self, name)
	self.main._rname = name
	self.main.text:SetText(name)
end

local function SetMinMaxStep(self, min1, max1, step)
	local step = step or 1
	self.main:SetMinMaxValues(min1,max1)
	self.main.mintext:SetText(min1)
	self.main.maxtext:SetText(max1)
	
	self.main:SetValueStep(step)
	self.main:SetObeyStepOnDrag(step)
	
	if step ~= floor(step) then
		self.main.step = "%.1f"
	else
		self.main.step = "%d"
	end
end

local function SetDescription(self, text)
	self.main.desc = text
end

local function OnValueChanged(self, value)
	local val = format(self.step, value)
	
	if val ~= self._lastval then
		self._lastval = val
	--	print("T", self:HasScript("OnMouseDown"), self:HasScript("OnMouseUp"), self:HasScript("OnDragStop"), self:HasScript("OnDragStart"))
	--	self:SetScript("OnValueChanged", nil)
		self._OnValueChanged(_, tonumber(val))	
	--	self:SetValue(self._OnShow() or 0)
		self.editbox:SetText(format(self.step, self._OnShow() or 0))
	--	self:SetScript("OnValueChanged", OnValueChanged)
	end
end

local function UpdateState(self, set, get)
	
	self.main._lastval = nil
	self.main._OnValueChanged = set
	self.main._OnShow = get
	self.main:SetValue(self.main._OnShow() or 0)
	self.main.editbox:SetText(format(self.main.step, self.main._OnShow() or 0))
	self.main:SetScript("OnValueChanged", OnValueChanged)

end

local function CreateCoreButton(parent)
	local f = CreateFrame('Slider', "AleaGUI-10Slider"..#C.sliderFrames.."Frame", parent, 'OptionsSliderTemplate')
	f:SetFrameLevel(parent:GetFrameLevel() + 1)
	f:HookScript("OnMouseUp", function(self)
		C:GetRealParent(self):RefreshData()
	--	print("OnMouseUp") 
	end)
--	f:HookScript("OnDragStop", function(self) print("OnDragStop") end)
	
	
	f.text = f:CreateFontString("$parentHeader", 'OVERLAY', "GameFontHighlight")
	f.text:SetPoint("BOTTOM", f, "TOP", 0 , 0)
--	f.text:SetFont(STANDARD_TEXT_FONT, 10, "OUTLINE")
	f.text:SetText(text)
	f.text:SetTextColor(1, 0.8, 0)
	f.text:SetHeight(18)
	f.text:SetWidth(170)
	f.text:SetWordWrap(false)
	
	f:SetMinMaxValues(1, 200)	
	f:SetValueStep(0.1)	
	f:SetWidth(170)
	f:SetHitRectInsets(0, 0, 0, 0) 
	
	f.mintext = _G[f:GetName().."Low"]
	f.maxtext = _G[f:GetName().."High"]
	
	f.mintext:ClearAllPoints()
	f.maxtext:ClearAllPoints()
	
	f.mintext:SetPoint("TOPLEFT", f, "BOTTOMLEFT", 0, -2)
	f.maxtext:SetPoint("TOPRIGHT", f, "BOTTOMRIGHT", 0, -2)
	
	f.editbox = CreateFrame("EditBox", nil, f)
--	f.editbox:SetFont("Fonts\\ARIALN.TTF", 14, "OUTLINE")
	f.editbox:SetFontObject(ChatFontNormal)
	f.editbox.myslider = f
	f.editbox:SetFrameLevel(parent:GetFrameLevel() + 1)
	f.editbox:SetAutoFocus(false)
	f.editbox:SetWidth(40)
	f.editbox:SetHeight(16)
	f.editbox:SetJustifyH("Center")
	f.editbox:SetJustifyV("Center")

	f.editbox:SetBackdrop({
		bgFile = [[Interface\Buttons\WHITE8x8]] , --[=[Interface\ChatFrame\ChatFrameBackground]=]
		edgeFile = [=[Interface\ChatFrame\ChatFrameBackground]=], --[=[Interface\ChatFrame\ChatFrameBackground]=]
		edgeSize = 1,
		insets = {top = 0, left = 0, bottom = 0, right = 0},
		})
	f.editbox:SetBackdropColor(0 , 0 , 0 , 1) --цвет фона
	f.editbox:SetBackdropBorderColor(0.2 , 0.2 , 0.2 , 1) --цвет краев
			
	 f.editbox:SetScript("OnEnterPressed", function(self)
		local val = tonumber(format("%.1f", self:GetText()))	
		if val then
			self.myslider:SetValue(val)
		else
			self.myslider:SetValue(0)
		end		
		self:ClearFocus()
	end)
	f.editbox:SetPoint("TOP", f, "BOTTOM", 0,-3)
	f.editbox:SetScript("OnEscapePressed", function(self)
		self:ClearFocus()
	end)
	
	f._plus = CreateFrame("Button", nil, f)
	f._plus:SetSize(14, 14)
	f._plus:SetPoint("LEFT", f.editbox, "RIGHT", 3, 0)
	f._plus:SetBackdrop({
		bgFile = [[Interface\Buttons\WHITE8x8]] , --[=[Interface\ChatFrame\ChatFrameBackground]=]
		edgeFile = [=[Interface\ChatFrame\ChatFrameBackground]=], --[=[Interface\ChatFrame\ChatFrameBackground]=]
		edgeSize = 1,
		insets = {top = 0, left = 0, bottom = 0, right = 0},
		})
	f._plus:SetBackdropColor(0 , 0 , 0 , 1) --цвет фона
	f._plus:SetBackdropBorderColor(0.2 , 0.2 , 0.2 , 1) --цвет краев
	f._plus.text = f._plus:CreateFontString(nil, "OVERLAY")
	f._plus.text:SetPoint("CENTER")
	f._plus.text:SetFont(STANDARD_TEXT_FONT, 14, "OUTLINE")
	f._plus.text:SetText("+")
	f._plus:SetScript("OnClick", function(self)
		
		local minVal, maxVal = self:GetParent():GetMinMaxValues()
		
		local newVal = tonumber(( self:GetParent()._OnShow() or 0 ) + self:GetParent():GetValueStep())
		
		if newVal > maxVal then
			newVal = maxVal
		end
		
		self:GetParent()._OnValueChanged(_, newVal)		
		C:GetRealParent(self):RefreshData()
	end)
	f._plus.text:SetWordWrap(false)
	
	f._minus = CreateFrame("Button", nil, f)
	f._minus:SetSize(14, 14)
	f._minus:SetPoint("RIGHT", f.editbox, "LEFT", -3, 0)
	f._minus:SetBackdrop({
		bgFile = [[Interface\Buttons\WHITE8x8]] , --[=[Interface\ChatFrame\ChatFrameBackground]=]
		edgeFile = [=[Interface\ChatFrame\ChatFrameBackground]=], --[=[Interface\ChatFrame\ChatFrameBackground]=]
		edgeSize = 1,
		insets = {top = 0, left = 0, bottom = 0, right = 0},
		})
	f._minus:SetBackdropColor(0 , 0 , 0 , 1) --цвет фона
	f._minus:SetBackdropBorderColor(0.2 , 0.2 , 0.2 , 1) --цвет краев
	f._minus.text = f._minus:CreateFontString(nil, "OVERLAY")
	f._minus.text:SetPoint("CENTER")
	f._minus.text:SetFont(STANDARD_TEXT_FONT, 14, "OUTLINE")
	f._minus.text:SetText("-")
	f._minus:SetScript("OnClick", function(self)
	
		local minVal, maxVal = self:GetParent():GetMinMaxValues()
		
		local newVal = tonumber(( self:GetParent()._OnShow() or 0 ) - self:GetParent():GetValueStep())
		
		if newVal < minVal then
			newVal = minVal
		end

		self:GetParent()._OnValueChanged(_, newVal)		
		C:GetRealParent(self):RefreshData()
	end)
	f._minus.text:SetWordWrap(false)
	
	f.mouseover = CreateFrame("Frame", nil, f)
	f.mouseover:SetFrameLevel(f:GetFrameLevel()-1)
	f.mouseover:SetSize(1,1)
	f.mouseover:SetPoint("TOPLEFT", f.text, "TOPLEFT", -3, 3)
	f.mouseover:SetPoint("BOTTOMRIGHT", f.text, "BOTTOMRIGHT", 3, -3)
	f.mouseover:SetScript("OnEnter", function(self)
	--	self:GetParent():SetBackdropBorderColor(unpack(C.button_border_color_onup)) --цвет краев		
		C.Tooltip(self, self:GetParent()._rname, self:GetParent().desc, "show")
	end)
	f.mouseover:SetScript("OnLeave", function(self)
	--	self:GetParent():SetBackdropBorderColor(unpack(C.button_border_color_ondown)) --цвет краев	
		C.Tooltip(self, self:GetParent()._rname, self:GetParent().desc, "hide")
	end)

	return f
end

function C:CreateSlider()
	
	for i=1, #C.sliderFrames do
		if C.sliderFrames[i].free then
			return C.sliderFrames[i]
		end
	end
	
	local f = CreateFrame("Frame", nil, UIParent)
	f:SetSize(180, 60)
	f.free = true
	
	f.main = CreateCoreButton(f)
	f.main:SetPoint("TOPLEFT", f, "TOPLEFT", 5, -15)
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
	f.SetMinMaxStep = SetMinMaxStep
	
	C.sliderFrames[#C.sliderFrames+1] = f
	
	return f
end
	
C.prototypes["slider"] = "CreateSlider"