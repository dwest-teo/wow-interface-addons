if AleaUI_GUI then return end
local C = _G['AleaGUI_PrototypeLib']

C.multiSelect = {}

local stringHeight = 16
local stringTextSize = 11
local minWidth = 80

local dropdowns = {}
local nextDropDownButtons = {}
local selectButtons = {}

local BuildDropDown
local ResetElements

local function ResetDropDownFromStep(step)	
	for i=step, #dropdowns do
		dropdowns[i]:Free()
		
	--	print('T', 'ResetDropDownFromStep', step)
	end
end

local chekcerForHide = CreateFrame("Frame")
chekcerForHide:Hide()
chekcerForHide:SetScript('OnUpdate', function(self, elapsed)
	self.elapsed = ( self.elapsed or 0 ) + elapsed
	
	if self.elapsed < 3 then return end
	
	local isMultiOpen = false
	
	for i=2, #dropdowns do
		if dropdowns[i]:IsVisible() then
			isMultiOpen = true
			if MouseIsOver(dropdowns[i]) then
				self.elapsed = 0 
				
		--		print('T', 'Mouse over', 'dropdown', i, 'delay')
				return
			end
		end
	end
	
	for i=1, #nextDropDownButtons do
		if nextDropDownButtons[i]:IsVisible() then
			if MouseIsOver(nextDropDownButtons[i]) then
				self.elapsed = 0 
				
		--		print('T', 'Mouse over', 'nextDropDownButtons', i, 'delay')
				return
			end
		end
	end
	
	for i=1, #selectButtons do
		if selectButtons[i]:IsVisible() then
			if MouseIsOver(selectButtons[i]) then
				self.elapsed = 0 
				
		--		print('T', 'Mouse over', 'nextDropDownButtons', i, 'delay')
				return
			end
		end
	end
	
	if not isMultiOpen and dropdowns[1] and dropdowns[1]:IsVisible() then
		self.elapsed = 0
	--	print('T', 'Only open main dropdown', 'Delay')
		return
	end
	
	self:Hide()
	ResetElements(true)
--	print('T', 'Hide dropdowns')
end)

local function StartCheckForHide()
	chekcerForHide.elapsed = 0
	chekcerForHide:Show()
end

local function EndCheckForHide()
	chekcerForHide.elapsed = 0
	chekcerForHide:Hide()
end
	
function C:HideMultiDropdown()
	ResetElements(true)
	EndCheckForHide()
	
--	print("T", 'HideMultiDropdown')
end

local function createDropdownPanel(index)

	if dropdowns[index] then
		return dropdowns[index]
	end

	
	local frame = CreateFrame("Frame")
	frame:SetSize(100, 100)
	frame.DropDownIndex = index
	frame:SetClampedToScreen(true)
	frame.strings = {}
	
	frame.border1 = CreateFrame("Frame", nil, frame)
	frame.border1:SetPoint("TOPLEFT", frame, "TOPLEFT", -10, 10)
	frame.border1:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 10, -10)
	frame.border1:SetBackdrop({
		bgFile   = [[Interface\Buttons\WHITE8x8]],
		edgeFile = [[Interface\DialogFrame\UI-DialogBox-Border]],
		edgeSize = 22,
		insets = {
			left = 5,
			right = 5,
			top = 5,
			bottom = 5,
		}
	})
	frame.border1:SetBackdropColor(0, 0, 0, 1)
	frame.border1:SetBackdropBorderColor(1, 1, 1, 1)
	frame.free = true
	
	frame.Free = function(self)
		self.free = true
		self:Hide()
		self:ClearAllPoints()
		
	--	print('T', 'Free dropdown', self.DropDownIndex)
		
		for i=1, #self.strings do
			self.strings[i].free = true
			self.strings[i].dropdown = nil
			
			if self.strings[i].dropdown then
		--		print('T', 'Free Dropdown', 'On strings clear', self.strings[i].dropdown.DropDownIndex)
				self.strings[i].dropdown:Free()
				self.strings[i].dropdown = nil
			end
		
			self.strings[i]:Hide()
			self.strings[i]:ClearAllPoints()
		end
		
		wipe(self.strings)
	end
	
	frame:SetScript('OnEnter', function(self)
		chekcerForHide.elapsed = 0
	
	end)
	frame:SetScript('OnLeave', function(self)
		chekcerForHide.elapsed = 0
	end)
	
	dropdowns[index] = frame
	
	return frame
end

local function createNextButton()
	for i=1, #nextDropDownButtons do
		if nextDropDownButtons[i].free then
			return nextDropDownButtons[i]
		end
	end
	
	local frame = CreateFrame("Frame")
	frame:SetSize(100, stringHeight)
	
	
	frame.arrow = frame:CreateTexture(nil, 'OVERLAY')
	frame.arrow:SetSize(16, 16)
	frame.arrow:SetTexture("Interface\\ChatFrame\\ChatFrameExpandArrow")
	frame.arrow:SetPoint('RIGHT', frame, 'RIGHT', 0, 0)
	
	frame.text = frame:CreateFontString(nil, 'OVERLAY')
	frame.text:SetFont(STANDARD_TEXT_FONT, stringTextSize, 'NONE')
	frame.text:SetText('Next Button')
	frame.text:SetPoint('LEFT', frame, 'LEFT', 0, 0)
	frame.text:SetPoint('RIGHT', frame.arrow, 'LEFT', 0, 0)
	frame.text:SetJustifyH('LEFT')
	frame.text:SetWordWrap(false)
	
	frame.free = true
	
	
	frame:SetScript("OnMouseUp", function(self)
		ResetElements(true)
		EndCheckForHide()
	--	print('Click', 'Next', self.step)
	end)
	
	frame:SetScript('OnEnter', function(self)
		
		if self.dropdown then
		--	print('T', 'Free Dropdown', 'OnEnter', self.dropdown.DropDownIndex)
			self.dropdown:Free()
			self.dropdown = nil
		end
	
		ResetDropDownFromStep(self.step+2)	
		
		local dropdown = BuildDropDown(self.values, self.step+1, self.key)
		local realparent = C:GetRealParent(self)
		dropdown:Show()
		dropdown.parent = self
		dropdown:SetParent(realparent)
		dropdown:SetFrameLevel(realparent:GetFrameLevel()+10)
		dropdown:ClearAllPoints()
		dropdown:SetPoint('TOPLEFT', self, 'TOPRIGHT', 15, -5)
		
		self.dropdown = dropdown
		
	--	print('OpenNewDD', self.step+1)
		
		StartCheckForHide()
	end)
	
	frame:SetScript('OnLeave', function(self)
		if self.dropdown then
			chekcerForHide.elapsed = 0
		end
		
	end)
	
	nextDropDownButtons[#nextDropDownButtons+1] = frame
	
	return frame
end

local function createSelectButton()
	for i=1, #selectButtons do
		if selectButtons[i].free then
			return selectButtons[i]
		end
	end
	
	local frame = CreateFrame("Frame")
	frame:SetSize(100, stringHeight)
	
	frame.check = frame:CreateTexture(nil, 'OVERLAY')
	frame.check:SetSize(16, 16)
	frame.check:SetTexture("Interface\\Common\\UI-DropDownRadioChecks")
	frame.check:SetTexCoord(0, 0.5, 0.5, 1)
	frame.check:SetPoint('LEFT', frame, 'LEFT', 0, 0)
	
	-- <TexCoords left="0" right="0.5" top="0.5" bottom="1.0"/>
	
	
	frame.text = frame:CreateFontString(nil, 'OVERLAY')
	frame.text:SetFont(STANDARD_TEXT_FONT, stringTextSize, 'NONE')
	frame.text:SetText('SelectButton')
	frame.text:SetPoint('LEFT', frame.check, 'RIGHT', 0, 0)
	frame.text:SetPoint('RIGHT', frame, 'RIGHT', 0, 0)
	frame.text:SetJustifyH('LEFT')
	frame.text:SetWordWrap(false)
	
	frame.free = true
	
	frame.SetStatus = function(self, checked)
		if checked then			
			self.check:SetTexCoord(0, 0.5, 0.5, 1)
		else
			self.check:SetTexCoord(0.5, 1.0, 0.5, 1)
		end
	end
	selectButtons[#selectButtons+1] = frame
	
	frame:SetScript("OnMouseUp", function(self)
		
		if dropdowns[1] and dropdowns[1].parent then
		--	print('Click', 'Value', self.step, self.value, dropdowns[1].parent)
			
			dropdowns[1].parent._OnClick(_, self.value)
			C:GetRealParent(dropdowns[1].parent):RefreshData()
		end
		ResetElements(true)
		EndCheckForHide()
	end)
	
	frame:SetScript('OnEnter', function(self)	
		ResetDropDownFromStep(self.step+1)	
		StartCheckForHide()
	end)
	
	frame:SetScript('OnLeave', function(self)
		
	end)
	
	
	return frame
end

function ResetElements(reset)
	for i=1, #dropdowns do
		dropdowns[i].free = true
		dropdowns[i]:Hide()
		dropdowns[i]:ClearAllPoints()
		
		if reset then
			dropdowns[i].parent = nil
		end
	end
	
	for i=1, #selectButtons do
		selectButtons[i].free = true
		selectButtons[i]:Hide()
		selectButtons[i]:ClearAllPoints()	
	end
	
	for i=1, #nextDropDownButtons do
		nextDropDownButtons[i].free = true
		nextDropDownButtons[i]:Hide()
		nextDropDownButtons[i]:ClearAllPoints()	
	end
end

function BuildDropDown(list, step, key)
	local lastElement
	local dropdown = createDropdownPanel(step)
	dropdown.free = false
	dropdown:SetWidth(1)
	
	for i=1, #dropdown.strings do
		dropdown.strings[i].free = true
		dropdown.strings[i]:Hide()
	end
	wipe(dropdown.strings)
	
	local realIndex = 0
	local defaultStep = step
	local height = 5
	
	for index, data in pairs(list) do	
		if data.values then	
			lastElement = createNextButton()
			lastElement.free = false
			lastElement.values = data.values
			lastElement.key = key
		elseif data.value then
			lastElement = createSelectButton()
			lastElement.free = false
			lastElement.value = data.value
			lastElement:SetStatus( data.value == key )
		end
		
		realIndex = realIndex + 1
		
	--	print('T', index, realIndex, data.name, data.value)
		
		lastElement:ClearAllPoints()
		lastElement.step = step
		lastElement:Show()
		lastElement:SetParent(dropdown)
		lastElement.text:SetText(data.name)
		
		local width = max( minWidth, lastElement.text:GetStringWidth() + 30 )
		
	--	print('T', lastElement, dropdown, lastElement == dropdown)
		
		lastElement:SetPoint('TOPLEFT', dropdown, 'TOPLEFT', 2, -stringHeight*( realIndex - 1 ))

		dropdown.strings[#dropdown.strings+1] = lastElement
		
		if dropdown:GetWidth() < width then
			dropdown:SetWidth(width)
		end
		
		height = height + stringHeight
		
		dropdown:SetHeight(height)
	end
	
	for i=1, #dropdown.strings do	
		dropdown.strings[i]:SetWidth(dropdown:GetWidth())
	end
	
	return dropdown
end

local function ShowDropdown(self, list, key)
	ResetElements(false)
	
	C:FreeDropDowns('multiDropDown')
	
	local dropdown = BuildDropDown(list, 1, key)
	
	local show = dropdown.parent ~= self

	if show then
	
		local realparent = C:GetRealParent(self)
	
		dropdown:Show()
		dropdown.parent = self
		dropdown:SetParent(realparent)
		dropdown:SetFrameLevel(realparent:GetFrameLevel()+10)
		dropdown:ClearAllPoints()
		dropdown:SetPoint('TOP', self, 'BOTTOM', 0, -5)
		
		StartCheckForHide()
	else
		ResetElements(true)
	end
end

local function Update(self, panel, opts)
	assert(opts.values, "No Values is set on "..opts.name)
	
	self.main._values = nil
	
	if type(opts.values) == "function" then
		self.main._values = opts.values
		self.main.values = self.main._values()		
	elseif type(opts.values) == "table" then
		self.main.values = opts.values
	else
		assert(false, "Values should be only function of table")
	end
	
--	self.main.showSpellTooltip = opts.showSpellTooltip
	self.main.docked = opts.docked
	self.free = false
	self:SetParent(panel)
	self:SetDescription(opts.desc)
	self:Show()	
	self:SetName(opts.name)
	self:SetDisabledState(opts.disabled)
	self:UpdateState(opts.set, opts.get)
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

local function SearchForName(vars, list)	
	if not vars then return end
	if not list then return end
	
	for index, data in pairs(list) do		
		if data.name and data.value then
			vars[data.value] = data.name
		elseif data.value then
			vars[data.value] = data.value
		elseif data.values then
			SearchForName(vars, data.values)
		end
	end
end

local function UpdateState(self, func, get)
	
	self.main._OnClick = func
	self.main._OnShow = get
	
	local nameList = {}
	
	SearchForName(nameList, self.main.values)
	
	self.main.value:SetText(nameList[self.main._OnShow()] or "")
end

local function SetDisabledState(self, state)

	if state == true then		
		self.main.text:SetTextColor(0.5, 0.5, 0.5)
		self.main.value:SetTextColor(0.5, 0.5, 0.5)
		self.main.arrow:Disable()		
	else
		self.main.text:SetTextColor(1, 0.8, 0)
		self.main.value:SetTextColor(1, 1, 1)
		self.main.arrow:Enable()	
	end
end

local function CreateCoreDropDown(parent)
	local f = CreateFrame("Frame", nil, parent)
	f:SetSize(170, 25)
	
	local left = f:CreateTexture(nil, "BORDER")
	left:SetTexture("Interface\\Glues\\CharacterCreate\\CharacterCreate-LabelFrame")
	left:SetTexCoord(0, 0.1953125, 0, 1)
	left:SetPoint("TOPLEFT", -20, 17)
	left:SetSize(25, 64)
	
	local right = f:CreateTexture(nil, "BORDER")
	right:SetTexture("Interface\\Glues\\CharacterCreate\\CharacterCreate-LabelFrame")
	right:SetTexCoord(0.8046875, 1, 0, 1)
	right:SetPoint("TOPRIGHT", 10, 17)
	right:SetSize(25, 64)
	
	local middle = f:CreateTexture(nil, "BORDER")
	middle:SetTexture("Interface\\Glues\\CharacterCreate\\CharacterCreate-LabelFrame")
	middle:SetTexCoord(0.1953125, 0.8046875, 0, 1)
	middle:SetPoint("LEFT", left, "RIGHT", 0, 0)
	middle:SetPoint("RIGHT", right, "LEFT", 0, 0)
	middle:SetSize(165, 64)

	f.arrow = CreateFrame('Button', nil, f) --"UICheckButtonTemplate"
	f.arrow:SetPoint("RIGHT", right, "RIGHT", -15, 1)
	f.arrow:SetFrameLevel(f:GetFrameLevel() + 1)
	f.arrow:SetSize(25, 25)
	
	f.arrow.text = f.arrow:CreateFontString(nil, "OVERLAY")
	f.arrow.text:SetFont("Fonts\\ARIALN.TTF", 1, "OUTLINE")
	f.arrow.text:SetPoint("CENTER")
	f.arrow.text:SetText(C.statearrow[2])
	f.arrow.text:Hide()
	f.arrow.text:SetWordWrap(false)
	
	f.arrow.text:SetJustifyH("CENTER")
	f.arrow.text:SetJustifyV("CENTER")
	
	f.arrow:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Up")
	f.arrow:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Down")
	f.arrow:SetDisabledTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Disabled")
	f.arrow:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight", "ADD")
	
	f.arrow:SetScript("OnEnter", function(self)	
		C.Tooltip(self, f._rname, f.desc, "show")
	end)
	f.arrow:SetScript("OnLeave", function(self)
		C.Tooltip(self, f._rname, f.desc, "hide")
	end)

	f.arrow:SetScript("OnClick", function(self)
		if self:GetParent()._values then
			self:GetParent().values = self:GetParent()._values()
		end

		ShowDropdown(self:GetParent(), self:GetParent().values, self:GetParent()._OnShow())
	end)

	local text = f:CreateFontString(nil, 'OVERLAY', "GameFontHighlightSmall")
	text:SetPoint("BOTTOMLEFT", f, "TOPLEFT", 3 , 0)
	text:SetPoint("BOTTOMRIGHT", f.arrow, "TOPRIGHT", 0 , 0)
	text:SetTextColor(1, 0.8, 0)
	text:SetJustifyH("LEFT")
	text:SetWordWrap(false)
	
	local value = f:CreateFontString(nil, 'OVERLAY', "GameFontHighlightSmall")
	value:SetPoint("LEFT", f, "LEFT", 3 , 0)
	value:SetPoint("RIGHT", f.arrow, "LEFT", 0 , 0)
	value:SetTextColor(1, 1, 1)
	value:SetJustifyH("RIGHT")
	value:SetWordWrap(false)
	
	f.mouseover = CreateFrame("Frame", nil, f)
	f.mouseover:SetFrameLevel(f:GetFrameLevel()-1)
	f.mouseover:SetSize(1,1)
	f.mouseover:SetPoint("TOPLEFT", value, "TOPLEFT", -3, 3)
	f.mouseover:SetPoint("BOTTOMRIGHT", value, "BOTTOMRIGHT", 3, -3)
	f.mouseover:SetScript("OnEnter", function(self)	
		C.Tooltip(self, self:GetParent()._rname,  self:GetParent().desc, "show")
	end)
	f.mouseover:SetScript("OnLeave", function(self)
		C.Tooltip(self, self:GetParent()._rname, self:GetParent().desc, "hide")
	end)
	
	f.text = text
	f.value = value
	
	return f
end

function C:CreateMultiSelect()
	
	for i=1, #C.multiSelect do
		if C.multiSelect[i].free then
			return C.multiSelect[i]
		end
	end
	
	local f = CreateFrame("Frame", nil, UIParent)
	f:SetSize(180, 45)
	f.free = true
	
	f.main = CreateCoreDropDown(f)
	f.main:SetPoint("TOPLEFT", f, "TOPLEFT", 5, -10)
	f.main:SetPoint("RIGHT", f, "RIGHT", 0, 0)
	
	f.Update = Update
	f.Remove = Remove
	f.SetName = SetName
	f.UpdateState = UpdateState
	f.SetDescription = SetDescription
	f.SetDisabledState = SetDisabledState
	
	C.multiSelect[#C.multiSelect+1] = f
	
	return f
end
	
C.prototypes["multiselect"] = "CreateMultiSelect"