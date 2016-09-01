local E, L, V, P, G = unpack(ElvUI);
local BUI = E:NewModule('BenikUI', "AceConsole-3.0");

local LSM = LibStub('LibSharedMedia-3.0')
local EP = LibStub('LibElvUIPlugin-1.0')
local addon, ns = ...

local _G = _G
local pairs, print = pairs, print
local format = string.format
local CreateFrame = CreateFrame
local IsAddOnLoaded = IsAddOnLoaded
local C_TimerAfter = C_Timer.After
local PlaySound = PlaySound
local HideUIPanel = HideUIPanel

-- GLOBALS: LibStub, BenikUISplashScreen, ElvDB

BUI.Config = {}
BUI.TexCoords = {.08, 0.92, -.04, 0.92}
BUI.Title = format('|cff00c0fa%s |r', 'BenikUI')
BUI.Version = GetAddOnMetadata('ElvUI_BenikUI', 'Version')
BUI.NewSign = '|TInterface\\OptionsFrame\\UI-OptionsFrame-NewFeatureIcon:14:14|t'

function BUI:cOption(name)
	local color = '|cff00c0fa%s |r'
	return (color):format(name)
end

function BUI:PrintURL(url) -- Credit: Azilroka
	return format("|cFF00c0fa[|Hurl:%s|h%s|h]|r", url, url)
end

local color = { r = 1, g = 1, b = 1, a = 1 }
function BUI:unpackColor(color)
	return color.r, color.g, color.b, color.a
end

function BUI:RegisterBuiMedia()
	--Fonts
	E['media'].buiFont = LSM:Fetch('font', 'Bui Prototype')
	E['media'].buiVisitor = LSM:Fetch('font', 'Bui Visitor1')
	E['media'].buiVisitor2 = LSM:Fetch('font', 'Bui Visitor2')
	E['media'].buiTuk = LSM:Fetch('font', 'Bui Tukui')
	
	--Textures
	E['media'].BuiEmpty = LSM:Fetch('statusbar', 'BuiEmpty')
	E['media'].BuiFlat = LSM:Fetch('statusbar', 'BuiFlat')
	E['media'].BuiMelli = LSM:Fetch('statusbar', 'BuiMelli')
	E['media'].BuiMelliDark = LSM:Fetch('statusbar', 'BuiMelliDark')
	E['media'].BuiOnePixel = LSM:Fetch('statusbar', 'BuiOnePixel')
end

function BUI:AddOptions()
	for _, func in pairs(BUI.Config) do
		func()
	end	
end

function BUI:DasOptions()
	E:ToggleConfig(); LibStub("AceConfigDialog-3.0-ElvUI"):SelectGroup("ElvUI", "benikui")
end

function BUI:LoadCommands()
	self:RegisterChatCommand("benikui", "DasOptions")
	self:RegisterChatCommand("benikuisetup", "SetupBenikUI")
end

local function CreateSplashScreen()
	local f = CreateFrame('Frame', 'BenikUISplashScreen', E.UIParent)
	f:Size(300, 150)
	f:SetPoint('CENTER', 0, 100)
	f:SetFrameStrata('TOOLTIP')
	f:SetAlpha(0)

	f.bg = f:CreateTexture(nil, 'BACKGROUND')
	f.bg:SetTexture([[Interface\LevelUp\LevelUpTex]])
	f.bg:SetPoint('BOTTOM')
	f.bg:Size(400, 240)
	f.bg:SetTexCoord(0.00195313, 0.63867188, 0.03710938, 0.23828125)
	f.bg:SetVertexColor(1, 1, 1, 0.7)
	
	f.lineTop = f:CreateTexture(nil, 'BACKGROUND')
	f.lineTop:SetDrawLayer('BACKGROUND', 2)
	f.lineTop:SetTexture([[Interface\LevelUp\LevelUpTex]])
	f.lineTop:SetPoint("TOP")
	f.lineTop:Size(418, 7)
	f.lineTop:SetTexCoord(0.00195313, 0.81835938, 0.01953125, 0.03320313)
	
	f.lineBottom = f:CreateTexture(nil, 'BACKGROUND')
	f.lineBottom:SetDrawLayer('BACKGROUND', 2)
	f.lineBottom:SetTexture([[Interface\LevelUp\LevelUpTex]])
	f.lineBottom:SetPoint("BOTTOM")
	f.lineBottom:Size(418, 7)
	f.lineBottom:SetTexCoord(0.00195313, 0.81835938, 0.01953125, 0.03320313)
	
	f.logo = f:CreateTexture(nil, 'OVERLAY')
	f.logo:Size(256, 128)
	f.logo:SetTexture('Interface\\AddOns\\ElvUI_BenikUI\\media\\textures\\logo_benikui.tga')
	f.logo:Point('CENTER', f, 'CENTER')
	
	f.version = f:CreateFontString(nil, 'OVERLAY')
	f.version:FontTemplate(nil, 12, nil)
	f.version:Point('TOP', f.logo, 'BOTTOM', 0, 30)
	f.version:SetFormattedText("v%s", BUI.Version)
end

local function HideSplashScreen()
	BenikUISplashScreen:Hide()
end

local function FadeSplashScreen()
	E:Delay(2, function()
		E:UIFrameFadeOut(BenikUISplashScreen, 2, 1, 0)
		BenikUISplashScreen.fadeInfo.finishedFunc = HideSplashScreen
	end)
end

local function ShowSplashScreen()
	E:UIFrameFadeIn(BenikUISplashScreen, 4, 0, 1)
	BenikUISplashScreen.fadeInfo.finishedFunc = FadeSplashScreen
end

local function GameMenuButton()
	local lib = LibStub("LibElv-GameMenu-1.0")
	local button = {
		["name"] = "BUIConfigButton",
		["text"] = "|cff00c0faBenikUI|r",
		["func"] = function() BUI:DasOptions() PlaySound("igMainMenuOption") HideUIPanel(_G["GameMenuFrame"]) end,
	}
	lib:AddMenuButton(button)
	
	lib:UpdateHolder()
end

-- Clean ElvUI.lua in WTF folder from outdated settings
local function dbCleaning()
	-- Player Castbar icon detach
	if E.db.unitframe.units.player.castbar.detachCastbarIcon then E.db.unitframe.units.player.castbar.detachCastbarIcon = nil end
	if E.db.unitframe.units.player.castbar.detachediconSize then E.db.unitframe.units.player.castbar.detachediconSize = nil end
	if E.db.unitframe.units.player.castbar.xOffset then E.db.unitframe.units.player.castbar.xOffset = nil end
	if E.db.unitframe.units.player.castbar.yOffset then E.db.unitframe.units.player.castbar.yOffset = nil end
	
	-- Target Castbar icon detach
	if E.db.unitframe.units.target.castbar.detachCastbarIcon then E.db.unitframe.units.target.castbar.detachCastbarIcon = nil end
	if E.db.unitframe.units.target.castbar.detachediconSize then E.db.unitframe.units.target.castbar.detachediconSize = nil end
	if E.db.unitframe.units.target.castbar.xOffset then E.db.unitframe.units.target.castbar.xOffset = nil end
	if E.db.unitframe.units.target.castbar.yOffset then E.db.unitframe.units.target.castbar.yOffset = nil end

	-- Clear the old db
	if E.db.bui then E.db.bui = nil end
	if E.db.bab then E.db.bab = nil end
	if E.db.buixprep then E.db.buixprep = nil end
	if E.db.ufb then E.db.ufb = nil end
	if E.db.elvuiaddons then E.db.elvuiaddons = nil end
	if E.db.buiaddonskins then E.db.buiaddonskins = nil end
	if E.db.buiVariousSkins then E.db.buiVariousSkins = nil end
	
	E.db.benikui.dbCleaned = true
end

function BUI:Initialize()
	self:RegisterBuiMedia()
	self:LoadCommands()
	
	if E.db.benikui.dbCleaned ~= true then
		dbCleaning()
	end
	
	if E.db.benikui.general.splashScreen then
		CreateSplashScreen()
	end

	if E.db.benikui.general.gameMenuButton then
		GameMenuButton()
	end
	E:GetModule('DataTexts'):ToggleMailFrame()

	-- run install when ElvUI install finishes
	if E.private.install_complete == E.version and E.db.benikui.installed == nil then self:SetupBenikUI() end
	
	-- Show Splash Screen only if the install is completed
	if (E.db.benikui.installed == true and E.db.benikui.general.splashScreen) then C_TimerAfter(6, ShowSplashScreen) end
	
	-- run the setup again when a profile gets deleted.
	local profileKey = ElvDB.profileKeys[E.myname..' - '..E.myrealm]
	if ElvDB.profileKeys and profileKey == nil then self:SetupBenikUI() end

	if E.db.benikui.general.loginMessage then
		print(BUI.Title..format('v|cff00c0fa%s|r',BUI.Version)..L[' is loaded. For any issues or suggestions, please visit ']..BUI:PrintURL('http://git.tukui.org/Benik/ElvUI_BenikUI/issues'))
	end
	EP:RegisterPlugin(addon, self.AddOptions)
end

E:RegisterModule(BUI:GetName())