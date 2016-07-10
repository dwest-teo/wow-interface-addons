if AleaUI_GUI then return end
local C = _G['AleaGUI_PrototypeLib']

C.groupFrames = {}

local dim_frame_st = -30

local function UpdateWidth(self)
	return function(panel, width, height)
	
		self:SetWidth(width)
		self.main:SetWidth(width)
		
		self.bg:SetPoint("RIGHT", self:GetParent():GetParent():GetParent():GetParent(), "RIGHT", dim_frame_st-self:GetDim(), 0)
	end
end

local function Update(self, panel, opts, parent1)
	
	self.free = false
	self.panel = parent1
	self:SetParent(panel)
	
	self:SetWidth(panel:GetWidth())
	self.main:SetWidth(panel:GetWidth())
	
	C.OnButtonPanelSizeChanged[#C.OnButtonPanelSizeChanged+1] = self:UpdateWidth()

	self.bg:SetPoint("RIGHT", self:GetParent():GetParent():GetParent():GetParent(), "RIGHT", dim_frame_st-self:GetDim(), 0)
	
	self:Show()	

	self:SetName(opts.name)	
	self:UpdateState(panel, opts.args)
end

local function Remove(self)
	self.free = true
	
	for i=1, #self.elements do
		self.elements[i]:Remove()
	end
	wipe(self.elements)
	self:Hide()	
end

local function SetName(self, name)
	self.main.text:SetText(name)
end

local function GetDim(self)
	local a4 = self:GetParent():GetParent():GetParent():GetParent().rightSide
	if self.main:GetLeft() and a4:GetLeft() then
		if self.main:GetLeft() - a4:GetLeft() > 50 then
			return 50
		end
		return self.main:GetLeft() - a4:GetLeft()
	end
	return 0
end

local function UpdateState(self, panel, args)
	
	for i=1, #self.elements do
		self.elements[i]:Remove()
	end
	wipe(self.elements)
	
	local panel_width = self:GetWidth()-25
	local elements_row = floor(panel_width/180)
	local s = {}
	
	for name, data1 in pairs(args) do
		s[#s+1] = { name = name, order = data1.order }
	end
	
	C:SortTree(s)
	
	local frames = 0
	local index = 0
	local totalheight = 20
	local currentheight = 0
	
	for i=1, #s do
		local opts = args[s[i].name]
		local prototype = opts.type
		local width = opts.width
		local height = opts.height
		
		if prototype ~= "group" then
			index = index + 1
			self.elements[index] = C:GetPrototype(prototype)
			self.elements[index]:Update(panel, opts, self)
			self.elements[index]:ClearAllPoints()
			
			if frames == 0 then
				frames = frames + 1
				self.elements[index]:SetPoint("TOPLEFT", self, "TOPLEFT", 5, -totalheight)
				
				if width == "full" then
					self.elements[index]:SetPoint("RIGHT", self.bg, "RIGHT", -3, 0)
					frames = elements_row
				end
				
				if currentheight < self.elements[index]:GetHeight() then
					currentheight = self.elements[index]:GetHeight()
				end	
				
				if height == "full" then
					
					self.elements[index]:SetPoint("BOTTOM", self, "BOTTOM")
					
				end
			else
				if width == "full" then
				
					totalheight = totalheight + currentheight
					currentheight = 0
					
					self.elements[index]:SetPoint("TOPLEFT", self, "TOPLEFT", 5, -totalheight)
					self.elements[index]:SetPoint("RIGHT", self.bg, "RIGHT", -3, 0)
					if currentheight < self.elements[index]:GetHeight() then
						currentheight = self.elements[index]:GetHeight()
					end
					frames = elements_row
				elseif frames >= elements_row then
				
					totalheight = totalheight + currentheight
					currentheight = 0
					
					frames = 1
					self.elements[index]:SetPoint("TOPLEFT", self, "TOPLEFT", 5, -totalheight)
					if currentheight < self.elements[index]:GetHeight() then
						currentheight = self.elements[index]:GetHeight()
					end
				else
					frames = frames + 1
					self.elements[index]:SetPoint("TOPLEFT", self.elements[index-1], "TOPRIGHT")
					if currentheight < self.elements[index]:GetHeight() then
						currentheight = self.elements[index]:GetHeight()
					end
				end
				
				if height == "full" then
					
					self.elements[index]:SetPoint("BOTTOM", self, "BOTTOM")
					
				end
			end
		elseif prototype == "group" and opts.embend == true then
			index = index + 1		
			self.elements[index] = C:GetPrototype(prototype)
			self.elements[index]:Update(panel, opts, self)
			self.elements[index]:ClearAllPoints()
		
			if frames == 0 then
				frames = elements_row
				self.elements[index]:SetPoint("TOPLEFT", self, "TOPLEFT", 5, -totalheight)			
				if currentheight < self.elements[index]:GetHeight() then
					currentheight = self.elements[index]:GetHeight()
				end
			else
				totalheight = totalheight + currentheight
				currentheight = 0
					
				self.elements[index]:SetPoint("TOPLEFT", self, "TOPLEFT", 5, -totalheight)
				if currentheight < self.elements[index]:GetHeight() then
					currentheight = self.elements[index]:GetHeight()
				end
				frames = elements_row
			end
			
		end
	end
	totalheight = totalheight + currentheight
	
	self:SetHeight(totalheight+10)
end

function C:CreateGroup()
	
	for i=1, #C.groupFrames do
		if C.groupFrames[i].free then
			return C.groupFrames[i]
		end
	end
	
	local f = CreateFrame("Frame", nil, UIParent)
	f:SetSize(200, 200)
	f.free = true
	f.elements = {}
	
	f.main = CreateFrame("Frame", nil, f)
	f.main:SetPoint("TOPLEFT", f, "TOPLEFT", 5, -15)
	f.main:SetSize(200, 185)
	
	local bg = CreateFrame("Frame", nil, f) --f:CreateTexture(nil)
--	bg:EnableMouse(false)
--	bg:SetBackdrop({
--		bgFile = [=[Interface\ChatFrame\ChatFrameBackground]=],
--		edgeFile = [=[Interface\ChatFrame\ChatFrameBackground]=], 
--		edgeSize = 1,
--		insets = {top = 0, left = 0, bottom = 0, right = 0},
--		})
--	bg:SetBackdropColor(0, 0, 0, 0.4) --цвет фона
--	bg:SetBackdropBorderColor(unpack(C.button_border_color_ondown)) --цвет краев
	
	bg:SetPoint("TOPLEFT", f.main, "TOPLEFT", 0, -5)
	bg:SetPoint("BOTTOM", f, "BOTTOM")
	
	local bg_border = CreateFrame("Frame", nil, f)
	bg_border:SetFrameLevel(f:GetFrameLevel()+1)
	bg_border:SetPoint("TOPLEFT", f, "TOPLEFT", -0,-16)
	bg_border:SetPoint("BOTTOMRIGHT", bg, "BOTTOMRIGHT", 0, 3)
	bg_border:SetBackdrop({
		bgFile = [[Interface\Buttons\WHITE8x8]],
		edgeFile = [[Interface\Tooltips\UI-Tooltip-Border]],
		edgeSize = 16,
		insets = {
			left = 5,
			right = 5,
			top = 5,
			bottom = 5,
		}
	})
	bg_border:SetBackdropColor(0, 0, 0, 0.3)
	bg_border:SetBackdropBorderColor(0.5, 0.5, 0.5, 1)
	
	local text = bg:CreateFontString(nil, 'OVERLAY', "GameFontHighlight")
	text:SetPoint("BOTTOMLEFT", f.main, "TOPLEFT", 3 , -1)
--	text:SetFont(STANDARD_TEXT_FONT, 12, "OUTLINE")
	text:SetText("TEST")
	text:SetTextColor(C.fontNormal[1],C.fontNormal[2],C.fontNormal[3],C.fontNormal[4])
	text:SetJustifyH("LEFT")
	text:SetWordWrap(false)
	
	f.main.text = text
	
--	bg:SetTexture(0.5, 1, 0.5, 0.5)	
	f.bg = bg
	
	f.Update = Update
	f.Remove = Remove
	f.SetName = SetName
	f.UpdateState = UpdateState
	f.UpdateWidth = UpdateWidth
	f.GetDim = GetDim
	
	C.groupFrames[#C.groupFrames+1] = f
	
	return f
end
	
C.prototypes["group"] = "CreateGroup"