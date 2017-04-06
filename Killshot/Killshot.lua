-- settings ==============================================================================================================
	local version = "v6.00 (23-10-2014)";
	local version_nr = "6000";
	local warn_using_older_version = "true";
	
	local Prefix = "Killshot";
	local currentSaved = 1; -- change = reset settings
	local currentSavedChar = 1; -- change = reset character-saved data
	local delimiter = "@"; -- will never be used in any inputfield or variable
	
	local testGivesRealKill = false;
	local Path_Addons = "Interface\\AddOns\\";
	local Path_Killshot = Path_Addons .. "Killshot\\";
	function Path_Killshot_Sounds() kshot:Check_Sounds_Loaded(); return (Path_Addons .. "Killshot_Sounds\\volume_" .. kshot:round(ks['volume']) .. "\\"); end
	local maxAnnounces = 4;
	local timePerAnnounce = 15;
	local timeBetweenSameReceives = 3;
	local timeBeforeLastDamageDealerResets = 3;
	local audiofiles = 14;
	local multikillTime = 15;
	local showRealms = false;
	local maxRandomKillMessages = 100;
	local testVictim = "TEST_VICTIM";
	local defaultKillMessage = "pwned $v! Streak of $s!";
	local multikillMessage = "scored a MULTIKILL!!! Multikill-Streak of $s!";
	local deathMessage = "$v got pwned by $k!";
	local deathMessageKillerNil = "$v got pwned!";
	function defaultMultikillSound() return (Path_Killshot_Sounds() .. "sp0\\1.ogg") end
	function defaultExecuteSound() return (Path_Killshot_Sounds() .. "sp0\\2.ogg") end
	function defaultDeathSound(use_soundpack) return (Path_Killshot_Sounds() .. "sp" .. kshot:getSoundpackNr(use_soundpack) .. "\\0.ogg") end
	local receiveSharedDataWhileSoloMode = false;
	local defaultEmotes = { "slap"; "rasp"; "spit"; };
	local defaultSayList = {};
	local BROADCAST_EMAIL = "zwarmapapa@hotmail.com";
	
	local GUILD = "GUILD";
	
	local PARTY = "PARTY";
	local RAID = "RAID";
	
	local ARENA = "PARTY";
	local BG = "BATTLEGROUND";
	local PARTY_INSTANCE = "PARTY";
	local RAID_INSTANCE = "RAID";
-- settings ==============================================================================================================

-- init vars =============================================================================================================
	--          Color = { red green blue alpha };
	local Color_White = { 1.0; 1.0; 1.0; 1.0; };
	local Color_Red   = { 1.0; 0.1; 0.1; 1.0; };
	
	local old_defaultMultikillSound = "Killshot\\sounds\\sp0\\1.ogg";
	local old_defaultExecuteSound = "Killshot\\sounds\\sp0\\2.ogg";
	
	local announces = 0;
	local lastAnnounceCheckTime = GetTime();
	
	local lastMessageReceivedData = "";
	local lastMessageReceivedTarget = "";
	local lastMessageReceivedTime = GetTime();
	
	local lastDamageDealer = "";
	local lastDamageDealerTimeAgo = GetTime();
	
	local lastTarget = "";
	
	local killingstreakPvE = 0;
	local lastKill = GetTime();
	local multistreak = 0;
	
	local playername = UnitName("player");
	
	local defaultKillMessages = {};
	for i=1,maxRandomKillMessages do
		defaultKillMessages[i] = defaultKillMessage;
	end
	
	local time_from_last_out_of_date_received = 0;
	local time_from_last_download_killshot_sounds = 0;
	
	local killingstreakNotSaved = 0;
	
	local AddonLoaded_StreakShown = false;
-- init vars =============================================================================================================

-- load vars & start addon ===============================================================================================
	local kshotFrame = CreateFrame("FRAME");
	kshotFrame:RegisterEvent("ADDON_LOADED");
	
	function kshotFrame:OnEvent(event)
		if (event == "ADDON_LOADED") then
			
			local PrefixRegistered = RegisterAddonMessagePrefix(Prefix);
			
			if (select(4, GetBuildInfo()) >= 50100) then
				ARENA = "INSTANCE_CHAT";
				BG = "INSTANCE_CHAT";
				PARTY_INSTANCE = "INSTANCE_CHAT";
				RAID_INSTANCE = "INSTANCE_CHAT";
			end
			
			
			if (ks == nil) then
				ks = {};
			end
			if (ks_char == nil) then
				ks_char = {};
			end
			
			if (saved == currentSaved) then
				if (saved_char == currentSavedChar) then
					ks_char['killingstreak'] 					= kshot:checkLoadedVar(ks_char['killingstreak'], "killingstreak", 0);
					ks_char['maxkillingstreak'] 				= kshot:checkLoadedVar(ks_char['maxkillingstreak'], "maxkillingstreak", 0);
					ks_char['totalkillingblows'] 				= kshot:checkLoadedVar(ks_char['totalkillingblows'], "totalkillingblows", 0);
					ks_char['killingstreaktimes'] 				= kshot:checkLoadedVar(ks_char['killingstreaktimes'], "killingstreaktimes", 0);
					ks_char['maxmultistreak'] 					= kshot:checkLoadedVar(ks_char['maxmultistreak'], "maxmultistreak", 0);
					ks_char['totalmultistreak'] 				= kshot:checkLoadedVar(ks_char['totalmultistreak'], "totalmultistreak", 0);
					ks_char['executeSoundHealthProcent'] 		= kshot:checkLoadedVar(ks_char['executeSoundHealthProcent'], "executeSoundHealthProcent", 20);
					ks_char['enableStreakDataModifications'] 	= kshot:checkLoadedVar(ks_char['enableStreakDataModifications'], "enableStreakDataModifications", true);
					ks_char['summon_random_pet_on_kill'] 		= kshot:checkLoadedVar(ks_char['summon_random_pet_on_kill'], "summon_random_pet_on_kill", false);
					ks_char['summon_random_pet_on_multikill'] 	= kshot:checkLoadedVar(ks_char['summon_random_pet_on_multikill'], "summon_random_pet_on_multikill", false);
				else
					kshot:ResetStreakData();
					kshot:Print("Killshot detected a new character.");
				end
				ks['volume'] 									= kshot:checkLoadedVar(ks['volume'], "volume", 3);
				ks['volume_type'] 								= kshot:checkLoadedVar(ks['volume_type'], "volume_type", "type2sfx");
				ks['soundpack'] 								= kshot:checkLoadedVar(ks['soundpack'], "soundpack", "sp1normal");
				ks['randomKillMessages'] 						= kshot:checkLoadedVar(ks['randomKillMessages'], "randomKillMessages", 1);
				ks['killMessages'] 								= kshot:checkLoadedArray(ks['killMessages'], "killMessages", defaultKillMessages, "defaultKillMessages");
				ks['sound'] 									= kshot:checkLoadedVar(ks['sound'], "sound", true);
				ks['scrollingtext'] 							= kshot:checkLoadedVar(ks['scrollingtext'], "scrollingtext", true);
				ks['chattext'] 									= kshot:checkLoadedVar(ks['chattext'], "chattext", true);
				ks['emote'] 									= kshot:checkLoadedVar(ks['emote'], "emote", true);
				ks['solo'] 										= kshot:checkLoadedVar(ks['solo'], "solo", false);
				ks['CheckVersionGuild'] 						= kshot:checkLoadedVar(ks['CheckVersionGuild'], "CheckVersionGuild", true);
				ks['CheckVersionRaid'] 							= kshot:checkLoadedVar(ks['CheckVersionRaid'], "CheckVersionRaid", true);
				ks['CheckVersionBG'] 							= kshot:checkLoadedVar(ks['CheckVersionBG'], "CheckVersionBG", true);
				ks['SendToGuild'] 								= kshot:checkLoadedVar(ks['SendToGuild'], "SendToGuild", true);
				ks['SendToRaid'] 								= kshot:checkLoadedVar(ks['SendToRaid'], "SendToRaid", true);
				ks['SendToBG'] 									= kshot:checkLoadedVar(ks['SendToBG'], "SendToBG", true);
				ks['ReceiveFromGuild'] 							= kshot:checkLoadedVar(ks['ReceiveFromGuild'], "ReceiveFromGuild", true);
				ks['ReceiveFromRaid'] 							= kshot:checkLoadedVar(ks['ReceiveFromRaid'], "ReceiveFromRaid", true);
				ks['ReceiveFromBG'] 							= kshot:checkLoadedVar(ks['ReceiveFromBG'], "ReceiveFromBG", true);
				ks['SendDeathsToGuild'] 						= kshot:checkLoadedVar(ks['SendDeathsToGuild'], "SendDeathsToGuild", true);
				ks['SendDeathsToRaid'] 							= kshot:checkLoadedVar(ks['SendDeathsToRaid'], "SendDeathsToRaid", true);
				ks['SendDeathsToBG'] 							= kshot:checkLoadedVar(ks['SendDeathsToBG'], "SendDeathsToBG", true);
				ks['ReceiveDeathsFromGuild'] 					= kshot:checkLoadedVar(ks['ReceiveDeathsFromGuild'], "ReceiveDeathsFromGuild", true);
				ks['ReceiveDeathsFromRaid'] 					= kshot:checkLoadedVar(ks['ReceiveDeathsFromRaid'], "ReceiveDeathsFromRaid", true);
				ks['ReceiveDeathsFromBG'] 						= kshot:checkLoadedVar(ks['ReceiveDeathsFromBG'], "ReceiveDeathsFromBG", true);
				ks['sendwhat'] 									= kshot:checkLoadedVar(ks['sendwhat'], "sendwhat", "streak1");
				ks['StreakAnnounceGuild'] 						= kshot:checkLoadedVar(ks['StreakAnnounceGuild'], "StreakAnnounceGuild", true);
				ks['StreakAnnounceRaid'] 						= kshot:checkLoadedVar(ks['StreakAnnounceRaid'], "StreakAnnounceRaid", true);
				ks['StreakAnnounceBG'] 							= kshot:checkLoadedVar(ks['StreakAnnounceBG'], "StreakAnnounceBG", true);
				ks['ResetStreakOnLogin'] 						= kshot:checkLoadedVar(ks['ResetStreakOnLogin'], "ResetStreakOnLogin", false);
				ks['ResetStreakOnZoneChange'] 					= kshot:checkLoadedVar(ks['ResetStreakOnZoneChange'], "ResetStreakOnZoneChange", false);
				ks['PvP'] 										= kshot:checkLoadedVar(ks['PvP'], "PvP", true);
				ks['PvE'] 										= kshot:checkLoadedVar(ks['PvE'], "PvE", true);
				ks['PvE_Random'] 								= kshot:checkLoadedVar(ks['PvE_Random'], "PvE_Random", false);
				ks['ShowStreakOnLogin'] 						= kshot:checkLoadedVar(ks['ShowStreakOnLogin'], "ShowStreakOnLogin", true);
				ks['ShowStreakOnZoneChange'] 					= kshot:checkLoadedVar(ks['ShowStreakOnZoneChange'], "ShowStreakOnZoneChange", true);
				ks['ScreenshotOnKill'] 							= kshot:checkLoadedVar(ks['ScreenshotOnKill'], "ScreenshotOnKill", false);
				ks['ScreenshotOnMultikill'] 					= kshot:checkLoadedVar(ks['ScreenshotOnMultikill'], "ScreenshotOnMultikill", true);
				ks['ScreenshotOnDeath'] 						= kshot:checkLoadedVar(ks['ScreenshotOnDeath'], "ScreenshotOnDeath", false);
				ks['ScreenshotOnNewHighestStreak'] 				= kshot:checkLoadedVar(ks['ScreenshotOnNewHighestStreak'], "ScreenshotOnNewHighestStreak", true);
				ks['ScreenshotOnNewHighestMultiStreak'] 		= kshot:checkLoadedVar(ks['ScreenshotOnNewHighestMultiStreak'], "ScreenshotOnNewHighestMultiStreak", true);
				ks['executeSoundNPC'] 							= kshot:checkLoadedVar(ks['executeSoundNPC'], "executeSoundNPC", true);
				ks['executeSoundPlayer'] 						= kshot:checkLoadedVar(ks['executeSoundPlayer'], "executeSoundPlayer", true);
				ks['Color_Kill_CombatText'] 					= kshot:checkLoadedArray(ks['Color_Kill_CombatText'], "Color_Kill_CombatText", Color_Red, "Color_Red");
				ks['Color_Kill_ChatText'] 						= kshot:checkLoadedArray(ks['Color_Kill_ChatText'], "Color_Kill_ChatText", Color_White, "Color_White");
				ks['Color_Multikill_CombatText'] 				= kshot:checkLoadedArray(ks['Color_Multikill_CombatText'], "Color_Multikill_CombatText", Color_Red, "Color_Red");
				ks['Color_Multikill_ChatText'] 					= kshot:checkLoadedArray(ks['Color_Multikill_ChatText'], "Color_Multikill_ChatText", Color_White, "Color_White");
				ks['Color_Death_CombatText'] 					= kshot:checkLoadedArray(ks['Color_Death_CombatText'], "Color_Death_CombatText", Color_Red, "Color_Red");
				ks['Color_Death_ChatText'] 						= kshot:checkLoadedArray(ks['Color_Death_ChatText'], "Color_Death_ChatText", Color_White, "Color_White");
				ks['multikillSound'] 							= kshot:checkLoadedVar(ks['multikillSound'], "multikillSound", "");
				ks['executeSound'] 								= kshot:checkLoadedVar(ks['executeSound'], "executeSound", "");
				ks['deathSound'] 								= kshot:checkLoadedVar(ks['deathSound'], "deathSound", "");
				ks['YourKillMessages_Emote'] 					= kshot:checkLoadedVar(ks['YourKillMessages_Emote'], "YourKillMessages_Emote", true);
				ks['YourKillMessages_CombatText'] 				= kshot:checkLoadedVar(ks['YourKillMessages_CombatText'], "YourKillMessages_CombatText", true);
				ks['YourKillMessages_ChatText'] 				= kshot:checkLoadedVar(ks['YourKillMessages_ChatText'], "YourKillMessages_ChatText", true);
				ks['YourKillSounds'] 							= kshot:checkLoadedVar(ks['YourKillSounds'], "YourKillSounds", true);
				ks['OtherKillMessages_CombatText'] 				= kshot:checkLoadedVar(ks['OtherKillMessages_CombatText'], "OtherKillMessages_CombatText", true);
				ks['OtherKillMessages_ChatText'] 				= kshot:checkLoadedVar(ks['OtherKillMessages_ChatText'], "OtherKillMessages_ChatText", true);
				ks['OtherKillSounds'] 							= kshot:checkLoadedVar(ks['OtherKillSounds'], "OtherKillSounds", true);
				ks['YourMultikillMessages_Emote'] 				= kshot:checkLoadedVar(ks['YourMultikillMessages_Emote'], "YourMultikillMessages_Emote", true);
				ks['YourMultikillMessages_CombatText'] 			= kshot:checkLoadedVar(ks['YourMultikillMessages_CombatText'], "YourMultikillMessages_CombatText", true);
				ks['YourMultikillMessages_ChatText'] 			= kshot:checkLoadedVar(ks['YourMultikillMessages_ChatText'], "YourMultikillMessages_ChatText", true);
				ks['YourMultikillSounds'] 						= kshot:checkLoadedVar(ks['YourMultikillSounds'], "YourMultikillSounds", true);
				ks['OtherMultikillMessages_CombatText'] 		= kshot:checkLoadedVar(ks['OtherMultikillMessages_CombatText'], "OtherMultikillMessages_CombatText", true);
				ks['OtherMultikillMessages_ChatText'] 			= kshot:checkLoadedVar(ks['OtherMultikillMessages_ChatText'], "OtherMultikillMessages_ChatText", true);
				ks['OtherMultikillSounds'] 						= kshot:checkLoadedVar(ks['OtherMultikillSounds'], "OtherMultikillSounds", true);
				ks['YourDeathMessages_World_PvP_CombatText'] 	= kshot:checkLoadedVar(ks['YourDeathMessages_World_PvP_CombatText'], "YourDeathMessages_World_PvP_CombatText", true);
				ks['YourDeathMessages_World_PvP_ChatText'] 		= kshot:checkLoadedVar(ks['YourDeathMessages_World_PvP_ChatText'], "YourDeathMessages_World_PvP_ChatText", true);
				ks['YourDeathSounds_World_PvP'] 				= kshot:checkLoadedVar(ks['YourDeathSounds_World_PvP'], "YourDeathSounds_World_PvP", true);
				ks['OtherDeathMessages_World_PvP_CombatText'] 	= kshot:checkLoadedVar(ks['OtherDeathMessages_World_PvP_CombatText'], "OtherDeathMessages_World_PvP_CombatText", true);
				ks['OtherDeathMessages_World_PvP_ChatText'] 	= kshot:checkLoadedVar(ks['OtherDeathMessages_World_PvP_ChatText'], "OtherDeathMessages_World_PvP_ChatText", true);
				ks['OtherDeathSounds_World_PvP'] 				= kshot:checkLoadedVar(ks['OtherDeathSounds_World_PvP'], "OtherDeathSounds_World_PvP", true);
				ks['YourDeathMessages_World_PvE_CombatText'] 	= kshot:checkLoadedVar(ks['YourDeathMessages_World_PvE_CombatText'], "YourDeathMessages_World_PvE_CombatText", true);
				ks['YourDeathMessages_World_PvE_ChatText'] 		= kshot:checkLoadedVar(ks['YourDeathMessages_World_PvE_ChatText'], "YourDeathMessages_World_PvE_ChatText", true);
				ks['YourDeathSounds_World_PvE'] 				= kshot:checkLoadedVar(ks['YourDeathSounds_World_PvE'], "YourDeathSounds_World_PvE", true);
				ks['OtherDeathMessages_World_PvE_CombatText'] 	= kshot:checkLoadedVar(ks['OtherDeathMessages_World_PvE_CombatText'], "OtherDeathMessages_World_PvE_CombatText", true);
				ks['OtherDeathMessages_World_PvE_ChatText'] 	= kshot:checkLoadedVar(ks['OtherDeathMessages_World_PvE_ChatText'], "OtherDeathMessages_World_PvE_ChatText", true);
				ks['OtherDeathSounds_World_PvE'] 				= kshot:checkLoadedVar(ks['OtherDeathSounds_World_PvE'], "OtherDeathSounds_World_PvE", true);
				ks['YourDeathMessages_PvP_CombatText'] 			= kshot:checkLoadedVar(ks['YourDeathMessages_PvP_CombatText'], "YourDeathMessages_PvP_CombatText", true);
				ks['YourDeathMessages_PvP_ChatText'] 			= kshot:checkLoadedVar(ks['YourDeathMessages_PvP_ChatText'], "YourDeathMessages_PvP_ChatText", true);
				ks['YourDeathSounds_PvP'] 						= kshot:checkLoadedVar(ks['YourDeathSounds_PvP'], "YourDeathSounds_PvP", true);
				ks['OtherDeathMessages_PvP_CombatText'] 		= kshot:checkLoadedVar(ks['OtherDeathMessages_PvP_CombatText'], "OtherDeathMessages_PvP_CombatText", true);
				ks['OtherDeathMessages_PvP_ChatText'] 			= kshot:checkLoadedVar(ks['OtherDeathMessages_PvP_ChatText'], "OtherDeathMessages_PvP_ChatText", true);
				ks['OtherDeathSounds_PvP'] 						= kshot:checkLoadedVar(ks['OtherDeathSounds_PvP'], "OtherDeathSounds_PvP", true);
				ks['YourDeathMessages_PvE_CombatText'] 			= kshot:checkLoadedVar(ks['YourDeathMessages_PvE_CombatText'], "YourDeathMessages_PvE_CombatText", true);
				ks['YourDeathMessages_PvE_ChatText'] 			= kshot:checkLoadedVar(ks['YourDeathMessages_PvE_ChatText'], "YourDeathMessages_PvE_ChatText", true);
				ks['YourDeathSounds_PvE'] 						= kshot:checkLoadedVar(ks['YourDeathSounds_PvE'], "YourDeathSounds_PvE", true);
				ks['OtherDeathMessages_PvE_CombatText'] 		= kshot:checkLoadedVar(ks['OtherDeathMessages_PvE_CombatText'], "OtherDeathMessages_PvE_CombatText", true);
				ks['OtherDeathMessages_PvE_ChatText'] 			= kshot:checkLoadedVar(ks['OtherDeathMessages_PvE_ChatText'], "OtherDeathMessages_PvE_ChatText", true);
				ks['OtherDeathSounds_PvE'] 						= kshot:checkLoadedVar(ks['OtherDeathSounds_PvE'], "OtherDeathSounds_PvE", true);
				ks['emotes'] 									= kshot:checkLoadedArray(ks['emotes'], "emotes", defaultEmotes, "defaultEmotes");
				ks['Debug_SendData'] 							= kshot:checkLoadedVar(ks['Debug_SendData'], "Debug_SendData", false);
				ks['Debug_ReceivedData_Others'] 				= kshot:checkLoadedVar(ks['Debug_ReceivedData_Others'], "Debug_ReceivedData_Others", false);
				ks['Debug_ReceivedData_You'] 					= kshot:checkLoadedVar(ks['Debug_ReceivedData_You'], "Debug_ReceivedData_You", false);
				ks['Debug_ReceivedAllData'] 					= kshot:checkLoadedVar(ks['Debug_ReceivedAllData'], "Debug_ReceivedAllData", false);
				ks['time_between_out_of_date_receives']			= kshot:checkLoadedVar(ks['time_between_out_of_date_receives'], "time_between_out_of_date_receives", 10);
				ks['out_of_date_chatlines']						= kshot:checkLoadedVar(ks['out_of_date_chatlines'], "out_of_date_chatlines", 3);
				ks['out_of_date_messages_enabled']				= kshot:checkLoadedVar(ks['out_of_date_messages_enabled'], "out_of_date_messages_enabled", true);
				ks['time_between_download_killshot_sounds']		= kshot:checkLoadedVar(ks['time_between_download_killshot_sounds'], "time_between_download_killshot_sounds", 3);
				ks['download_killshot_sounds_chatlines']		= kshot:checkLoadedVar(ks['download_killshot_sounds_chatlines'], "download_killshot_sounds_chatlines", 3);
				ks['download_killshot_sounds_messages_enabled']	= kshot:checkLoadedVar(ks['download_killshot_sounds_messages_enabled'], "download_killshot_sounds_messages_enabled", true);
				ks['var_was_nil_error_enabled']					= kshot:checkLoadedVar(ks['var_was_nil_error_enabled'], "var_was_nil_error_enabled", false);
				ks['say_list'] 									= kshot:checkLoadedArray(ks['say_list'], "say_list", defaultSayList, "defaultSayList");
				ks['say_chance']								= kshot:checkLoadedVar(ks['say_chance'], "say_chance", 100);
				
				if (ks['ResetStreakOnLogin'] == true) then
					kshot:ResetStreak();
				elseif (ks['ShowStreakOnLogin'] == true) then
					if (AddonLoaded_StreakShown == false) then
						AddonLoaded_StreakShown = true;
						kshot:EchoStreakIfHigherThanZero();
					end
				end
				
			else
				kshot:ResetAllSettingsAndData();
				kshot:Print("Killshot detected a new user.");
			end
		end
	end
	
	kshot = LibStub("AceAddon-3.0"):NewAddon("kshot", "AceEvent-3.0", "AceConsole-3.0", "LibSink-2.0");
	kshotFrame:SetScript("OnEvent", kshotFrame.OnEvent);
-- load vars & start addon ===============================================================================================


-- window ================================================================================================================
	local function makeInfo()
		local array = {
			type = "group",
			name = "Killshot",
			args = {
				info_version_and_streak_data = {
					type = "description",
					name = version .. "\n\n\nCurrent killing streak: " .. ks_char['killingstreak'] .. "\nHighest killing streak: " .. ks_char['maxkillingstreak'] .. "\nAverage killing streak: " .. kshot:getStreakAverage() .. "\n\nTotal killingblows: " .. ks_char['totalkillingblows'] .. "\nAmount of killingstreaks: " .. ks_char['killingstreaktimes'] .. "\n\nHighest multikill-streak: " .. ks_char['maxmultistreak'] .. "\nTotal multikills: " .. ks_char['totalmultistreak'] .. "\n\n",
					order = 10
				},
				info_enable_streak_modify = {
					type = 'toggle',
					name = 'Enable Streak Data Modifications (saves per character)',
					get = function() return ks_char['enableStreakDataModifications'] end,
					set = 	function(info, var) ks_char['enableStreakDataModifications'] = var; end,
					width = "full",
					order = 15
				},
				info_streakreset = {
					type = 'execute',
					name = 'reset current streak (same as when you die)',
					func = function() kshot:ResetStreak(); kshot:Print("Your streak has been resetted."); end,
					width = "full",
					order = 20
				},
				info_streakresetall = {
					type = 'execute',
					name = 'reset streak data (streak data is saved per char)',
					func = function() kshot:ResetStreakData(); kshot:Print("Your streak data has been deleted."); end,
					width = "full",
					order = 30
				},
				info_resetcolors = {
					type = 'execute',
					name = 'reset all color settings',
					func = function() kshot:ResetColors(); kshot:Print("Your colors have been resetted."); end,
					width = "full",
					order = 40
				},
				info_resetallsettings = {
					type = 'execute',
					name = "reset all settings (doesn't reset streak data)",
					func = function() kshot:ResetAllSettings(); kshot:Print("All settings have been resetted."); end,
					width = "full",
					order = 50
				},
				info_resetallsettingsanddata = {
					type = 'execute',
					name = 'reset all settings & saved data',
					func = function() kshot:ResetAllSettingsAndData(); kshot:Print("All settings & saved data have been resetted."); end,
					width = "full",
					order = 60
				}
			}
		}
		return array;
	end
	
	local function makeSettings()
		local array = {
			type = "group",
			name = "Settings",
			args = {
				settings_test = {
					type = 'execute',
					name = 'Killshot Test',
					func = function() kshot:Test() end,
					width = "full",
					order = 10
				},
				settings_volume_slider = {
					type = 'range',
					name = 'Sound Volume',
					isPercent = false,
					min = 1, max = 5, bigStep = 1,
					get = function() return ks['volume'] end,
					set = function(info, var) ks['volume'] = kshot:round(var) end,
					width = "full",
					order = 15
				},
				settings_volume_type = {
					type = 'select',
					name = 'Select Volume Type',
					desc = 'Select Volume Type',
					get = function() return ks['volume_type'] end,
					set = function(info, var) ks['volume_type'] = var end,
					values = {
						type1master 	= "1. Master",
						type2sfx 		= "2. SFX",
						type3music 		= "3. Music",
						type4ambience 	= "3. Ambience"
					},
					order = 17
				},
				settings_soundpack = {
					type = 'select',
					name = 'Select Soundpack',
					desc = 'Select Soundpack',
					get = function() return ks['soundpack'] end,
					set = function(info, var) ks['soundpack'] = var end,
					values = {
						sp1normal = "1. Normal",
						sp2female = "2. Female",
						sp3sexy = "3. Sexy",
						sp4custom = "4. Custom"
					},
					order = 20
				},
				settings_emote = {
					type = 'toggle',
					name = 'Enable Emote Messages',
					get = function() return ks['emote'] end,
					set = function(info, var) ks['emote'] = var end,
					width = "full",
					order = 30
				},
				settings_scrollingtext = {
					type = 'toggle',
					name = 'Enable Combat Text Messages',
					get = function() return ks['scrollingtext'] end,
					set = function(info, var) ks['scrollingtext'] = var end,
					width = "full",
					order = 40
				},
				settings_chattext = {
					type = 'toggle',
					name = 'Enable Chat Text Messages',
					get = function() return ks['chattext'] end,
					set = function(info, var) ks['chattext'] = var end,
					width = "full",
					order = 50
				},
				settings_sound = {
					type = 'toggle',
					name = 'Enable Sounds',
					get = function() return ks['sound'] end,
					set = function(info, var) ks['sound'] = var end,
					width = "full",
					order = 60
				},
				settings_empty_line_1 = {
					type = "description",
					name = "\n",
					order = 70
				},
				settings_description_pvp_pve = {
					type = "description",
					name = "PvE kills will only play a sound. PvE kills won't share, and they won't modify your streak-data. ",
					order = 80
				},
				settings_pvp = {
					type = 'toggle',
					name = 'Enable PvP Kills',
					get = function() return ks['PvP'] end,
					set = function(info, var) ks['PvP'] = var end,
					width = "full",
					order = 90
				},
				settings_pve = {
					type = 'toggle',
					name = "Enable PvE Kills",
					get = function() return ks['PvE'] end,
					set = function(info, var) ks['PvE'] = var end,
					width = "full",
					order = 100
				},
				settings_pve_random = {
					type = 'toggle',
					name = "PvE kills play random sounds",
					get = function() return ((ks['PvE_Random'] == true) and (ks['PvE'] == true)) end,
					set = function(info, var) ks['PvE_Random'] = var end,
					width = "full",
					order = 110
				},
				settings_empty_line_2 = {
					type = "description",
					name = "\n",
					order = 120
				},
				settings_showstreakonlogin = {
					type = 'toggle',
					name = 'Show your streak on login',
					get = function() return ks['ShowStreakOnLogin'] end,
					set = 	function(info, var)
								ks['ShowStreakOnLogin'] = var;
								if (var == true) then
									ks['ResetStreakOnLogin'] = false;
								end
							end,
					width = "full",
					order = 130
				},
				settings_resetstreakonlogin = {
					type = 'toggle',
					name = 'Reset your streak on login',
					get = function() return ks['ResetStreakOnLogin'] end,
					set = 	function(info, var)
								ks['ResetStreakOnLogin'] = var;
								if (var == true) then
									ks['ShowStreakOnLogin'] = false;
								end
							end,
					width = "full",
					order = 140
				},
				settings_showstreakonzonechange = {
					type = 'toggle',
					name = 'Show your streak on zone change',
					get = function() return ks['ShowStreakOnZoneChange'] end,
					set = 	function(info, var)
								ks['ShowStreakOnZoneChange'] = var;
								if (var == true) then
									ks['ResetStreakOnZoneChange'] = false;
								end
							end,
					width = "full",
					order = 150
				},
				settings_resetstreakonzonechange = {
					type = 'toggle',
					name = 'Reset your streak on zone change',
					get = function() return ks['ResetStreakOnZoneChange'] end,
					set = 	function(info, var)
								ks['ResetStreakOnZoneChange'] = var;
								if (var == true) then
									ks['ShowStreakOnZoneChange'] = false;
								end
							end,
					width = "full",
					order = 160
				}
			}
		}
		return array;
	end
	
	local function makeWarningMessagesSettings()
		local array = {
			type = "group",
			name = "Warning Messages Settings",
			args = {
				warning_empty_line_1 = {
					type = "description",
					name = "\n",
					order = 10
				},
				warning_var_was_nil_enabled = {
					type = 'toggle',
					name = 'Give a message when there is a new variable beeing used in Killshot',
					get = function() return ks['var_was_nil_error_enabled'] end,
					set = function(info, var) ks['var_was_nil_error_enabled'] = var end,
					width = "full",
					order = 20
				},
				warning_empty_line_2 = {
					type = "description",
					name = "\n",
					order = 30
				},
				warning_out_of_date_enabled = {
					type = 'toggle',
					name = 'Give a message when there is a new Killshot version',
					get = function() return ks['out_of_date_messages_enabled'] end,
					set = function(info, var) ks['out_of_date_messages_enabled'] = var end,
					width = "full",
					order = 40
				},
				warning_out_of_date_slider = {
					type = 'range',
					disabled = function() return (ks['out_of_date_messages_enabled'] == false) end,
					name = 'Newer Killshot version message cooldown (in minutes)',
					isPercent = false,
					min = 1, max = 180, bigStep = 1,
					get = function() return ks['time_between_out_of_date_receives'] end,
					set = function(info, var) ks['time_between_out_of_date_receives'] = var end,
					width = "full",
					order = 50
				},
				warning_out_of_date_chatmessages_slider = {
					type = 'range',
					disabled = function() return (ks['out_of_date_messages_enabled'] == false) end,
					name = 'Howmany chatlines should it spam "Killshot New Version Available"?',
					isPercent = false,
					min = 0, max = 10, bigStep = 1,
					get = function() return ks['out_of_date_chatlines'] end,
					set = function(info, var) ks['out_of_date_chatlines'] = var end,
					width = "full",
					order = 55
				},
				warning_empty_line_3 = {
					type = "description",
					name = "\n",
					order = 60
				},
				warning_download_killshot_sounds_enabled = {
					type = 'toggle',
					name = 'Give a message when you don\'t got the Killshot_Sounds addon',
					get = function() return ks['download_killshot_sounds_messages_enabled'] end,
					set = function(info, var) ks['download_killshot_sounds_messages_enabled'] = var end,
					width = "full",
					order = 70
				},
				warning_download_killshot_sounds_slider = {
					type = 'range',
					disabled = function() return (ks['download_killshot_sounds_messages_enabled'] == false) end,
					name = 'Download Killshot_Sounds message cooldown (in minutes)',
					isPercent = false,
					min = 1, max = 60, bigStep = 1,
					get = function() return ks['time_between_download_killshot_sounds'] end,
					set = function(info, var) ks['time_between_download_killshot_sounds'] = var end,
					width = "full",
					order = 80
				},
				warning_download_killshot_sounds_chatmessages_slider = {
					type = 'range',
					disabled = function() return (ks['download_killshot_sounds_messages_enabled'] == false) end,
					name = 'Howmany chatlines should it spam "Download Killshot_Sounds"?',
					isPercent = false,
					min = 0, max = 10, bigStep = 1,
					get = function() return ks['download_killshot_sounds_chatlines'] end,
					set = function(info, var) ks['download_killshot_sounds_chatlines'] = var end,
					width = "full",
					order = 85
				}
			}
		}
		return array;
	end
	
	local function makeStreakMessages()
		local array = {
			type = "group",
			name = "Random Streak Messages",
			args = {
				sm_messages_slider = {
					type = 'range',
					name = 'Amount of random streak messages',
					isPercent = false,
					min = 1, max = maxRandomKillMessages, bigStep = 1,
					get = function() return ks['randomKillMessages'] end,
					set = function(info, var) ks['randomKillMessages'] = var end,
					width = "full",
					order = 10
				}
			}
		};
		
		for i=1,maxRandomKillMessages do
			local new_array_object = {
				type = 'input',
				hidden = function() return (ks['randomKillMessages'] < i) end,
				name = "Messages",
				desc = "$v = victim, $s = streak",
				get = function() return ks['killMessages'][i] end,
				set = function(info, var) ks['killMessages'][i] = removeDelimiter(var) end,
				width = "full",
				order = 10 + (i*10)
			};
			array['args']['sm_msg_'..i] = new_array_object;
		end
		
		return array;
	end
	
	local function makeEmotes()
		local array = {
			type = "group",
			name = "Emotes",
			args = {
				e_info = {
					type = "description",
					name = "The buttons below shows a list of emotes.\nWhen you kill someone you'll play a random emote from this list.\nClick on an emote's button to delete it, enter a new emote in the inputfield to add a new emote.\nDelete all emotes to disable this function.",
					order = 10
				},
				e_emote_test = {
					type = 'execute',
					name = 'Play a random emote from the current list',
					func = function() kshot:randomEmote("none") end,
					width = "full",
					order = 20
				},
				e_new_emote = {
					type = 'input',
					name = "Typ an emote here to add it to the list",
					desc = "Add an emote",
					get = function() return "" end,
					set = function(info, var) kshot:addEmote(removeDelimiter(var)) end,
					width = "full",
					order = 30
				}
			}
		};
		
		kshot:checkIfEmotesIsNotNil();
		for i, emotes_emote in pairs(ks['emotes']) do 
			local new_array_object = {
				type = 'execute',
				name = emotes_emote,
				func = function() kshot:removeEmote(i); end,
				width = "full",
				order = 100 + (i*10)
			};
			array['args']['e_emote_'..i] = new_array_object;
		end
		
		return array;
	end
	
	local function makeSayList()
		local array = {
			type = "group",
			name = "Say List",
			args = {
				s_info = {
					type = "description",
					name = "The buttons below shows a list of say (/s) messages.\nWhen you kill someone you'll say a random line from this list.\nClick on a button to delete that line, enter a new line in the inputfield to add a new say line.\nDelete all lines, or change the change to 0%, to disable this function.",
					order = 10
				},
				s_emote_test = {
					type = 'execute',
					name = 'Say a random line from the current list',
					func = function() kshot:randomSay(testVictim, true) end,
					width = "full",
					order = 20
				},
				s_chance_slider = {
					type = 'range',
					name = 'Chance that it will say a random message on a kill',
					isPercent = true,
					min = 0, max = 1, bigStep = 0.01,
					get = function() return (ks['say_chance']/100) end,
					set = function(info, var) ks['say_chance'] = (var*100) end,
					width = "full",
					order = 25
				},
				s_new_emote = {
					type = 'input',
					name = "Typ a line here to add it to the list",
					desc = "$p = your name, $v = victim",
					get = function() return "" end,
					set = function(info, var) kshot:addSay(removeDelimiter(var)) end,
					width = "full",
					order = 30
				}
			}
		};
		
		kshot:checkIfSayListIsNotNil();
		for i, say_line in pairs(ks['say_list']) do 
			local new_array_object = {
				type = 'execute',
				name = say_line,
				func = function() kshot:removeSay(i); end,
				width = "full",
				order = 100 + (i*10)
			};
			array['args']['s_sayline_'..i] = new_array_object;
		end
		
		return array;
	end
	
	local function makeScreenshotSettings()
		local array = {
			type = "group",
			name = "Screenshot Settings",
			args = {
				ss_info = {
					type = "description",
					name = "A screenshot can cause a short lagspike.\nPress the button below to see the lagspike.",
					order = 10
				},
				ss_screenshot = {
					type = 'execute',
					name = 'Take A Screenshot',
					func = function() kshot:Screenshot(); end,
					width = "full",
					order = 20
				},
				ss_empty_line_1 = {
					type = "description",
					name = "\n",
					order = 25
				},
				ss_kill = {
					type = 'toggle',
					name = 'Screenshot on Kill',
					get = function() return ks['ScreenshotOnKill'] end,
					set = function(info, var) ks['ScreenshotOnKill'] = var end,
					width = "full",
					order = 30
				},
				ss_multikill = {
					type = 'toggle',
					name = 'Screenshot on Multikill',
					get = function() return ks['ScreenshotOnMultikill'] end,
					set = function(info, var) ks['ScreenshotOnMultikill'] = var end,
					width = "full",
					order = 40
				},
				ss_death = {
					type = 'toggle',
					name = 'Screenshot on Death',
					get = function() return ks['ScreenshotOnDeath'] end,
					set = function(info, var) ks['ScreenshotOnDeath'] = var end,
					width = "full",
					order = 50
				},
				ss_empty_line_2 = {
					type = "description",
					name = "\n",
					order = 60
				},
				ss_new_streak = {
					type = 'toggle',
					name = 'Screenshot on New Streak Record',
					get = function() return ks['ScreenshotOnNewHighestStreak'] end,
					set = function(info, var) ks['ScreenshotOnNewHighestStreak'] = var end,
					width = "full",
					order = 70
				},
				ss_new_multi_streak = {
					type = 'toggle',
					name = 'Screenshot on New Multikill Streak Record',
					get = function() return ks['ScreenshotOnNewHighestMultiStreak'] end,
					set = function(info, var) ks['ScreenshotOnNewHighestMultiStreak'] = var end,
					width = "full",
					order = 80
				}
			}
		}
		return array;
	end
	
	local function makeRandomPetSettings()
		local array = {
			type = "group",
			name = "Random Pet Settings",
			args = {
				rp_info = {
					type = "description",
					name = "Killshot can summon a random pet (non-combat pet/companion) on events.\n",
					order = 10
				},
				rp_info_2 = {
					type = "description",
					name = "Summoning a pet uses the global cooldown. If the global cooldown is on cooldown, the pet won't get summoned. This means only kills made with [DoT's] and [spells with a castime over 1 second] will summon a random pet.\n",
					order = 20
				},
				rp_screenshot = {
					type = 'execute',
					name = 'Summon a random pet',
					func = function() kshot:SummonRandomPet(); end,
					width = "full",
					order = 30
				},
				rp_empty_line_1 = {
					type = "description",
					name = "\n",
					order = 40
				},
				rp_info_3 = {
					type = "description",
					name = "PS: the Random Pet Settings are saved per character.\n",
					order = 50
				},
				rp_kill = {
					type = 'toggle',
					name = 'Summon on Kill',
					get = function() return (ks_char['summon_random_pet_on_kill'] == true) end,
					set = function(info, var) ks_char['summon_random_pet_on_kill'] = var; end,
					width = "full",
					order = 60
				},
				rp_multikill = {
					type = 'toggle',
					name = 'Summon on Multikill',
					get = function() return (ks_char['summon_random_pet_on_multikill'] == true) end,
					set = function(info, var) ks_char['summon_random_pet_on_multikill'] = var; end,
					width = "full",
					order = 70
				}
			}
		}
		return array;
	end
	
	local function makeKillSettings()
		local array = {
			type = "group",
			name = "Kill Settings",
			args = {
				ks_Color_Kill_combattext = {
					type = 'color',
					name = 'Color for Kills (Combat Text)',
					hasAlpha = false,
					get = function() return kshot:getColor(ks['Color_Kill_CombatText']) end,
					set = function(info, r, g, b, a) kshot:setColor(ks['Color_Kill_CombatText'], r, g, b, a) end,
					width = "full",
					order = 10
				},
				ks_Color_Kill_chattext = {
					type = 'color',
					name = 'Color for Kills (Chat Text)',
					hasAlpha = false,
					get = function() return kshot:getColor(ks['Color_Kill_ChatText']) end,
					set = function(info, r, g, b, a) kshot:setColor(ks['Color_Kill_ChatText'], r, g, b, a) end,
					width = "full",
					order = 20
				},
				ks_empty_line_1 = {
					type = "description",
					name = "\n",
					order = 25
				},
				ks_yourkillmessages_emote = {
					type = 'toggle',
					name = 'Enable your Kill Messages (Emote Text)',
					get = function() return ((ks['YourKillMessages_Emote'] == true) and (ks['emote'] == true)) end,
					set = function(info, var) ks['YourKillMessages_Emote'] = var end,
					width = "full",
					order = 30
				},
				ks_yourkillmessages_combattext = {
					type = 'toggle',
					name = 'Enable your Kill Messages (Combat Text)',
					get = function() return ((ks['YourKillMessages_CombatText'] == true) and (ks['scrollingtext'] == true)) end,
					set = function(info, var) ks['YourKillMessages_CombatText'] = var end,
					width = "full",
					order = 32
				},
				ks_yourkillmessages_chattext = {
					type = 'toggle',
					name = 'Enable your Kill Messages (Chat Text)',
					get = function() return ((ks['YourKillMessages_ChatText'] == true) and (ks['chattext'] == true)) end,
					set = function(info, var) ks['YourKillMessages_ChatText'] = var end,
					width = "full",
					order = 34
				},
				ks_yourkillsounds = {
					type = 'toggle',
					name = 'Enable your Kill Sounds',
					get = function() return ((ks['YourKillSounds'] == true) and (ks['sound'] == true)) end,
					set = function(info, var) ks['YourKillSounds'] = var end,
					width = "full",
					order = 40
				},
				ks_empty_line_2 = {
					type = "description",
					name = "\n",
					order = 45
				},
				ks_otherkillmessages_combattext = {
					type = 'toggle',
					name = 'Enable others Kill Messages (Combat Text)',
					get = function() return ((ks['OtherKillMessages_CombatText'] == true) and (ks['scrollingtext'] == true) and (ks['solo'] == false)) end,
					set = function(info, var) ks['OtherKillMessages_CombatText'] = var end,
					width = "full",
					order = 50
				},
				ks_otherkillmessages_chattext = {
					type = 'toggle',
					name = 'Enable others Kill Messages (Chat Text)',
					get = function() return ((ks['OtherKillMessages_ChatText'] == true) and (ks['chattext'] == true) and (ks['solo'] == false)) end,
					set = function(info, var) ks['OtherKillMessages_ChatText'] = var end,
					width = "full",
					order = 52
				},
				ks_otherkillsounds = {
					type = 'toggle',
					name = 'Enable others Kill Sounds',
					get = function() return ((ks['OtherKillSounds'] == true) and (ks['sound'] == true) and (ks['solo'] == false)) end,
					set = function(info, var) ks['OtherKillSounds'] = var end,
					width = "full",
					order = 60
				}
			}
		}
		return array;
	end
	
	local function makeMultikillSettings()
		local array = {
			type = "group",
			name = "Multikill Settings",
			args = {
				ms_Color_Multikill_combattext = {
					type = 'color',
					name = 'Color for Multikills (Combat Text)',
					hasAlpha = false,
					get = function() return kshot:getColor(ks['Color_Multikill_CombatText']) end,
					set = function(info, r, g, b, a) kshot:setColor(ks['Color_Multikill_CombatText'], r, g, b, a) end,
					width = "full",
					order = 80
				},
				ms_Color_Multikill_chattext = {
					type = 'color',
					name = 'Color for Multikills (Chat Text)',
					hasAlpha = false,
					get = function() return kshot:getColor(ks['Color_Multikill_ChatText']) end,
					set = function(info, r, g, b, a) kshot:setColor(ks['Color_Multikill_ChatText'], r, g, b, a) end,
					width = "full",
					order = 90
				},
				ms_empty_line_1 = {
					type = "description",
					name = "\n",
					order = 95
				},
				ms_yourmultikillmessages_emote = {
					type = 'toggle',
					name = 'Enable your Multikill Messages (Emote Text)',
					get = function() return ((ks['YourMultikillMessages_Emote'] == true) and (ks['emote'] == true)) end,
					set = function(info, var) ks['YourMultikillMessages_Emote'] = var end,
					width = "full",
					order = 100
				},
				ms_yourmultikillmessages_combattext = {
					type = 'toggle',
					name = 'Enable your Multikill Messages (Combat Text)',
					get = function() return ((ks['YourMultikillMessages_CombatText'] == true) and (ks['scrollingtext'] == true)) end,
					set = function(info, var) ks['YourMultikillMessages_CombatText'] = var end,
					width = "full",
					order = 102
				},
				ms_yourmultikillmessages_chattext = {
					type = 'toggle',
					name = 'Enable your Multikill Messages (Chat Text)',
					get = function() return ((ks['YourMultikillMessages_ChatText'] == true) and (ks['chattext'] == true)) end,
					set = function(info, var) ks['YourMultikillMessages_ChatText'] = var end,
					width = "full",
					order = 104
				},
				ms_yourmultikillsounds = {
					type = 'toggle',
					name = 'Enable your Multikill Sounds',
					get = function() return ((ks['YourMultikillSounds'] == true) and (ks['sound'] == true)) end,
					set = function(info, var) ks['YourMultikillSounds'] = var end,
					width = "full",
					order = 110
				},
				ms_empty_line_2 = {
					type = "description",
					name = "\n",
					order = 115
				},
				ms_othermultikillmessages_combattext = {
					type = 'toggle',
					name = 'Enable others Multikill Messages (Combat Text)',
					get = function() return ((ks['OtherMultikillMessages_CombatText'] == true) and (ks['scrollingtext'] == true) and (ks['solo'] == false)) end,
					set = function(info, var) ks['OtherMultikillMessages_CombatText'] = var end,
					width = "full",
					order = 120
				},
				ms_othermultikillmessages_chattext = {
					type = 'toggle',
					name = 'Enable others Multikill Messages (Chat Text)',
					get = function() return ((ks['OtherMultikillMessages_ChatText'] == true) and (ks['chattext'] == true) and (ks['solo'] == false)) end,
					set = function(info, var) ks['OtherMultikillMessages_ChatText'] = var end,
					width = "full",
					order = 122
				},
				ms_othermultikillsounds = {
					type = 'toggle',
					name = 'Enable others Multikill Sounds',
					get = function() return ((ks['OtherMultikillSounds'] == true) and (ks['sound'] == true) and (ks['solo'] == false)) end,
					set = function(info, var) ks['OtherMultikillSounds'] = var end,
					width = "full",
					order = 130
				},
				ms_empty_line_3 = {
					type = "description",
					name = "\n",
					order = 132
				},
				ms_multikillsound = {
					type = 'input',
					name = "Custom Multikill Sound",
					desc = "empty = play default sound, example: Killshot\\\\sound\\\\volume_3\\\\sp1\\\\0.ogg",
					get = function() return ks['multikillSound'] end,
					set = function(info, var) ks['multikillSound'] = removeDelimiter(var) end,
					width = "full",
					order = 135
				},
				ms_play_multikill_sound = {
					type = 'execute',
					name = 'Test Multikill Sound',
					func = 	function()
								local getMultikillSound = kshot:getMultikillSound();
								kshot:Print("Multikill sound: "..getMultikillSound);
								kshot:PlaySound(kshot:getMultikillSound());
							end,
					width = "full",
					order = 140
				}
			}
		}
		return array;
	end
	
	local function makeDeathSettings()
		local array = {
			type = "group",
			name = "Death Settings",
			args = {
				-- colors ========================================================
					ds_Color_Death_combattext = {
						type = 'color',
						name = 'Color for Deaths (Combat Text)',
						hasAlpha = false,
						get = function() return kshot:getColor(ks['Color_Death_CombatText']) end,
						set = function(info, r, g, b, a) kshot:setColor(ks['Color_Death_CombatText'], r, g, b, a) end,
						width = "full",
						order = 10
					},
					ds_Color_Death_chattext = {
						type = 'color',
						name = 'Color for Deaths (Chat Text)',
						hasAlpha = false,
						get = function() return kshot:getColor(ks['Color_Death_ChatText']) end,
						set = function(info, r, g, b, a) kshot:setColor(ks['Color_Death_ChatText'], r, g, b, a) end,
						width = "full",
						order = 20
					},
				-- colors ========================================================
				
				ds_empty_line_1a = {
					type = "description",
					name = "\n",
					order = 99
				},
				ds_empty_line_1b = {
					type = "description",
					name = "\n",
					order = 100
				},
				
				-- world pvp =====================================================
					ds_worldpvp = {
						type = "description",
						name = "World PvP",
						order = 105
					},
					
					ds_yourdeathmessages_world_pvp_combattext = {
						type = 'toggle',
						name = 'Enable your Death Messages made in World PvP (Combat Text)',
						get = function() return ((ks['YourDeathMessages_World_PvP_CombatText'] == true) and (ks['scrollingtext'] == true)) end,
						set = function(info, var) ks['YourDeathMessages_World_PvP_CombatText'] = var end,
						width = "full",
						order = 110
					},
					ds_yourdeathmessages_world_pvp_chattext = {
						type = 'toggle',
						name = 'Enable your Death Messages made in World PvP (Chat Text)',
						get = function() return ((ks['YourDeathMessages_World_PvP_ChatText'] == true) and (ks['chattext'] == true)) end,
						set = function(info, var) ks['YourDeathMessages_World_PvP_ChatText'] = var end,
						width = "full",
						order = 120
					},
					ds_yourdeathsounds_world_pvp = {
						type = 'toggle',
						name = 'Enable your Death Sounds made in World PvP',
						get = function() return ((ks['YourDeathSounds_World_PvP'] == true) and (ks['sound'] == true)) end,
						set = function(info, var) ks['YourDeathSounds_World_PvP'] = var end,
						width = "full",
						order = 130
					},
					
					ds_empty_line_2 = {
						type = "description",
						name = "\n",
						order = 135
					},
					
					ds_otherdeathmessages_world_pvp_combattext = {
						type = 'toggle',
						name = 'Enable others Death Messages made in World PvP (Combat Text)',
						get = function() return ((ks['OtherDeathMessages_World_PvP_CombatText'] == true) and (ks['scrollingtext'] == true) and (ks['solo'] == false)) end,
						set = function(info, var) ks['OtherDeathMessages_World_PvP_CombatText'] = var end,
						width = "full",
						order = 140
					},
					ds_otherdeathmessages_world_pvp_chattext = {
						type = 'toggle',
						name = 'Enable others Death Messages made in World PvP (Chat Text)',
						get = function() return ((ks['OtherDeathMessages_World_PvP_ChatText'] == true) and (ks['chattext'] == true) and (ks['solo'] == false)) end,
						set = function(info, var) ks['OtherDeathMessages_World_PvP_ChatText'] = var end,
						width = "full",
						order = 150
					},
					ds_otherdeathsounds_world_pvp = {
						type = 'toggle',
						name = 'Enable others Death Sounds made in World PvP',
						get = function() return ((ks['OtherDeathSounds_World_PvP'] == true) and (ks['sound'] == true) and (ks['solo'] == false)) end,
						set = function(info, var) ks['OtherDeathSounds_World_PvP'] = var end,
						width = "full",
						order = 160
					},
				-- world pvp =====================================================
				
				ds_empty_line_3a = {
					type = "description",
					name = "\n",
					order = 199
				},
				ds_empty_line_3b = {
					type = "description",
					name = "\n",
					order = 200
				},
				
				-- world pve =====================================================
					ds_worldpve = {
						type = "description",
						name = "World PvE",
						order = 205
					},
					
					ds_yourdeathmessages_world_pve_combattext = {
						type = 'toggle',
						name = 'Enable your Death Messages made in World PvE (Combat Text)',
						get = function() return ((ks['YourDeathMessages_World_PvE_CombatText'] == true) and (ks['scrollingtext'] == true)) end,
						set = function(info, var) ks['YourDeathMessages_World_PvE_CombatText'] = var end,
						width = "full",
						order = 210
					},
					ds_yourdeathmessages_world_pve_chattext = {
						type = 'toggle',
						name = 'Enable your Death Messages made in World PvE (Chat Text)',
						get = function() return ((ks['YourDeathMessages_World_PvE_ChatText'] == true) and (ks['chattext'] == true)) end,
						set = function(info, var) ks['YourDeathMessages_World_PvE_ChatText'] = var end,
						width = "full",
						order = 220
					},
					ds_yourdeathsounds_world_pve = {
						type = 'toggle',
						name = 'Enable your Death Sounds made in World PvE',
						get = function() return ((ks['YourDeathSounds_World_PvE'] == true) and (ks['sound'] == true)) end,
						set = function(info, var) ks['YourDeathSounds_World_PvE'] = var end,
						width = "full",
						order = 230
					},
					
					ds_empty_line_4 = {
						type = "description",
						name = "\n",
						order = 235
					},
					
					ds_otherdeathmessages_world_pve_combattext = {
						type = 'toggle',
						name = 'Enable others Death Messages made in World PvE (Combat Text)',
						get = function() return ((ks['OtherDeathMessages_World_PvE_CombatText'] == true) and (ks['scrollingtext'] == true) and (ks['solo'] == false)) end,
						set = function(info, var) ks['OtherDeathMessages_World_PvE_CombatText'] = var end,
						width = "full",
						order = 240
					},
					ds_otherdeathmessages_world_pve_chattext = {
						type = 'toggle',
						name = 'Enable others Death Messages made in World PvE (Chat Text)',
						get = function() return ((ks['OtherDeathMessages_World_PvE_ChatText'] == true) and (ks['chattext'] == true) and (ks['solo'] == false)) end,
						set = function(info, var) ks['OtherDeathMessages_World_PvE_ChatText'] = var end,
						width = "full",
						order = 250
					},
					ds_otherdeathsounds_world_pve = {
						type = 'toggle',
						name = 'Enable others Death Sounds made in World PvE',
						get = function() return ((ks['OtherDeathSounds_World_PvE'] == true) and (ks['sound'] == true) and (ks['solo'] == false)) end,
						set = function(info, var) ks['OtherDeathSounds_World_PvE'] = var end,
						width = "full",
						order = 260
					},
				-- world pve =====================================================
				
				ds_empty_line_5a = {
					type = "description",
					name = "\n",
					order = 299
				},
				ds_empty_line_5b = {
					type = "description",
					name = "\n",
					order = 300
				},
				
				-- bg/arena ======================================================
					ds_pvp = {
						type = "description",
						name = "BG / Arena",
						order = 305
					},
					
					ds_yourdeathmessages_pvp_combattext = {
						type = 'toggle',
						name = 'Enable your Death Messages made in BG/Arena (Combat Text)',
						get = function() return ((ks['YourDeathMessages_PvP_CombatText'] == true) and (ks['scrollingtext'] == true)) end,
						set = function(info, var) ks['YourDeathMessages_PvP_CombatText'] = var end,
						width = "full",
						order = 310
					},
					ds_yourdeathmessages_pvp_chattext = {
						type = 'toggle',
						name = 'Enable your Death Messages made in BG/Arena (Chat Text)',
						get = function() return ((ks['YourDeathMessages_PvP_ChatText'] == true) and (ks['chattext'] == true)) end,
						set = function(info, var) ks['YourDeathMessages_PvP_ChatText'] = var end,
						width = "full",
						order = 320
					},
					ds_yourdeathsounds_pvp = {
						type = 'toggle',
						name = 'Enable your Death Sounds made in BG/Arena',
						get = function() return ((ks['YourDeathSounds_PvP'] == true) and (ks['sound'] == true)) end,
						set = function(info, var) ks['YourDeathSounds_PvP'] = var end,
						width = "full",
						order = 330
					},
					
					ds_empty_line_6 = {
						type = "description",
						name = "\n",
						order = 335
					},
					
					ds_otherdeathmessages_pvp_combattext = {
						type = 'toggle',
						name = 'Enable others Death Messages made in BG/Arena (Combat Text)',
						get = function() return ((ks['OtherDeathMessages_PvP_CombatText'] == true) and (ks['scrollingtext'] == true) and (ks['solo'] == false)) end,
						set = function(info, var) ks['OtherDeathMessages_PvP_CombatText'] = var end,
						width = "full",
						order = 340
					},
					ds_otherdeathmessages_pvp_chattext = {
						type = 'toggle',
						name = 'Enable others Death Messages made in BG/Arena (Chat Text)',
						get = function() return ((ks['OtherDeathMessages_PvP_ChatText'] == true) and (ks['chattext'] == true) and (ks['solo'] == false)) end,
						set = function(info, var) ks['OtherDeathMessages_PvP_ChatText'] = var end,
						width = "full",
						order = 350
					},
					ds_otherdeathsounds_pvp = {
						type = 'toggle',
						name = 'Enable others Death Sounds made in BG/Arena',
						get = function() return ((ks['OtherDeathSounds_PvP'] == true) and (ks['sound'] == true) and (ks['solo'] == false)) end,
						set = function(info, var) ks['OtherDeathSounds_PvP'] = var end,
						width = "full",
						order = 360
					},
				-- bg arena ======================================================
				
				ds_empty_line_7a = {
					type = "description",
					name = "\n",
					order = 399
				},
				ds_empty_line_7b = {
					type = "description",
					name = "\n",
					order = 400
				},
				
				-- dungeon/raids =================================================
					ds_pve = {
						type = "description",
						name = "Dungeon / Raids",
						order = 405
					},
					
					ds_yourdeathmessages_pve_combattext = {
						type = 'toggle',
						name = 'Enable your Death Messages made in Dungeon/Raids (Combat Text)',
						get = function() return ((ks['YourDeathMessages_PvE_CombatText'] == true) and (ks['scrollingtext'] == true)) end,
						set = function(info, var) ks['YourDeathMessages_PvE_CombatText'] = var end,
						width = "full",
						order = 410
					},
					ds_yourdeathmessages_pve_chattext = {
						type = 'toggle',
						name = 'Enable your Death Messages made in Dungeon/Raids (Chat Text)',
						get = function() return ((ks['YourDeathMessages_PvE_ChatText'] == true) and (ks['chattext'] == true)) end,
						set = function(info, var) ks['YourDeathMessages_PvE_ChatText'] = var end,
						width = "full",
						order = 420
					},
					ds_yourdeathsounds_pve = {
						type = 'toggle',
						name = 'Enable your Death Sounds made in Dungeon/Raids',
						get = function() return ((ks['YourDeathSounds_PvE'] == true) and (ks['sound'] == true)) end,
						set = function(info, var) ks['YourDeathSounds_PvE'] = var end,
						width = "full",
						order = 430
					},
					
					ds_empty_line_8 = {
						type = "description",
						name = "\n",
						order = 435
					},
					
					ds_otherdeathmessages_pve_combattext = {
						type = 'toggle',
						name = 'Enable others Death Messages made in Dungeon/Raids (Combat Text)',
						get = function() return ((ks['OtherDeathMessages_PvE_CombatText'] == true) and (ks['scrollingtext'] == true) and (ks['solo'] == false)) end,
						set = function(info, var) ks['OtherDeathMessages_PvE_CombatText'] = var end,
						width = "full",
						order = 440
					},
					ds_otherdeathmessages_pve_chattext = {
						type = 'toggle',
						name = 'Enable others Death Messages made in Dungeon/Raids (Chat Text)',
						get = function() return ((ks['OtherDeathMessages_PvE_ChatText'] == true) and (ks['chattext'] == true) and (ks['solo'] == false)) end,
						set = function(info, var) ks['OtherDeathMessages_PvE_ChatText'] = var end,
						width = "full",
						order = 450
					},
					ds_otherdeathsounds_pve = {
						type = 'toggle',
						name = 'Enable others Death Sounds made in Dungeon/Raids',
						get = function() return ((ks['OtherDeathSounds_PvE'] == true) and (ks['sound'] == true) and (ks['solo'] == false)) end,
						set = function(info, var) ks['OtherDeathSounds_PvE'] = var end,
						width = "full",
						order = 460
					},
				-- dungeon/raids =================================================
				
				ds_empty_line_9a = {
					type = "description",
					name = "\n",
					order = 499
				},
				ds_empty_line_9b = {
					type = "description",
					name = "\n",
					order = 500
				},
				
				-- extra settings ================================================
					ds_deathsound = {
						type = 'input',
						name = "Custom Death Sound",
						desc = "empty = play default sound, example: Killshot\\\\sound\\\\volume_3\\\\sp1\\\\0.ogg",
						get = function() return ks['deathSound'] end,
						set = function(info, var) ks['deathSound'] = removeDelimiter(var) end,
						width = "full",
						order = 510
					},
					ds_play_death_sound = {
						type = 'execute',
						name = 'Test Death Sound',
						func = 	function()
									local getDeathSound = kshot:getDeathSound();
									kshot:Print("Death sound: "..getDeathSound);
									kshot:PlaySound(kshot:getDeathSound());
								end,
						width = "full",
						order = 520
					}
				-- extra settings ================================================
			}
		}
		return array;
	end
	
	local function makeExecuteSoundSettings()
		local array = {
			type = "group",
			name = "Execute Sound Settings",
			args = {
				es_executesound_player = {
					type = 'toggle',
					name = 'Play a sound when targetted Player is below '..ks_char['executeSoundHealthProcent']..'% HP',
					get = function() return ((ks['executeSoundPlayer'] == true) and (ks['sound'] == true)) end,
					set = function(info, var) ks['executeSoundPlayer'] = var end,
					width = "full",
					order = 240
				},
				es_executesound_npc = {
					type = 'toggle',
					name = 'Play a sound when targetted NPC is below '..ks_char['executeSoundHealthProcent']..'% HP',
					get = function() return ((ks['executeSoundNPC'] == true) and (ks['sound'] == true)) end,
					set = function(info, var) ks['executeSoundNPC'] = var end,
					width = "full",
					order = 250
				},
				es_empty_line_1 = {
					type = "description",
					name = "\n",
					order = 255
				},
				es_executesound_slider = {
					type = 'range',
					name = 'target % HP to play Execute sound',
					isPercent = false,
					min = 1, max = 99, bigStep = 1,
					get = function() return ks_char['executeSoundHealthProcent'] end,
					set = function(info, var) ks_char['executeSoundHealthProcent'] = var end,
					width = "full",
					order = 260
				},
				es_empty_line_2 = {
					type = "description",
					name = "\n",
					order = 265
				},
				es_executesound = {
					type = 'input',
					name = "Custom Execute Sound",
					desc = "empty = play default sound, example: Killshot\\\\sound\\\\volume_3\\\\sp1\\\\0.ogg",
					get = function() return ks['executeSound'] end,
					set = function(info, var) ks['executeSound'] = removeDelimiter(var) end,
					width = "full",
					order = 270
				},
				es_play_execute_sound = {
					type = 'execute',
					name = 'Test Execute Sound',
					func = 	function()
								local getExecuteSound = kshot:getExecuteSound();
								kshot:Print("Execute sound: "..getExecuteSound);
								kshot:PlaySound(kshot:getExecuteSound());
							end,
					width = "full",
					order = 280
				}
			}
		}
		return array;
	end
	
	local function makeShareSettings()
		local array = {
			type = "group",
			name = "Share Settings",
			args = {
				ss_solo = {
					type = 'toggle',
					name = 'Solo Mode (blocks all sending/receiving)',
					get = function() return ks['solo'] end,
					set = function(info, var) ks['solo'] = var end,
					width = "full",
					order = 10
				},
				ss_empty_line_1 = {
					type = "description",
					name = "\n",
					order = 20
				},
				ss_sendguild = {
					type = 'toggle',
					name = 'Send Kills/Multikills to Guild',
					get = function() return ((ks['SendToGuild'] == true) and (ks['solo'] == false)) end,
					set = function(info, var) ks['SendToGuild'] = var end,
					width = "full",
					order = 30
				},
				ss_sendraid = {
					type = 'toggle',
					name = 'Send Kills/Multikills to Party/Raid',
					get = function() return ((ks['SendToRaid'] == true) and (ks['solo'] == false)) end,
					set = function(info, var) ks['SendToRaid'] = var end,
					width = "full",
					order = 40
				},
				ss_sendbg = {
					type = 'toggle',
					name = 'Send Kills/Multikills to BG',
					get = function() return ((ks['SendToBG'] == true) and (ks['solo'] == false)) end,
					set = function(info, var) ks['SendToBG'] = var end,
					width = "full",
					order = 50
				},
				ss_empty_line_2 = {
					type = "description",
					name = "\n",
					order = 60
				},
				ss_receiveguild = {
					type = 'toggle',
					name = 'Receive Kills/Multikills from Guild',
					get = function() return ((ks['ReceiveFromGuild'] == true) and (ks['solo'] == false)) end,
					set = function(info, var) ks['ReceiveFromGuild'] = var end,
					width = "full",
					order = 70
				},
				ss_receiveraid = {
					type = 'toggle',
					name = 'Receive Kills/Multikills from Party/Raid',
					get = function() return ((ks['ReceiveFromRaid'] == true) and (ks['solo'] == false)) end,
					set = function(info, var) ks['ReceiveFromRaid'] = var end,
					width = "full",
					order = 80
				},
				ss_receivebg = {
					type = 'toggle',
					name = 'Receive Kills/Multikills from BG',
					get = function() return ((ks['ReceiveFromBG'] == true) and (ks['solo'] == false)) end,
					set = function(info, var) ks['ReceiveFromBG'] = var end,
					width = "full",
					order = 90
				},
				ss_empty_line_3 = {
					type = "description",
					name = "\n",
					order = 100
				},
				ss_senddeathsguild = {
					type = 'toggle',
					name = 'Send Deaths to Guild',
					get = function() return ((ks['SendDeathsToGuild'] == true) and (ks['solo'] == false)) end,
					set = function(info, var) ks['SendDeathsToGuild'] = var end,
					width = "full",
					order = 110
				},
				ss_senddeathsraid = {
					type = 'toggle',
					name = 'Send Deaths to Party/Raid',
					get = function() return ((ks['SendDeathsToRaid'] == true) and (ks['solo'] == false)) end,
					set = function(info, var) ks['SendDeathsToRaid'] = var end,
					width = "full",
					order = 120
				},
				ss_senddeathsbg = {
					type = 'toggle',
					name = 'Send Deaths to BG',
					get = function() return ((ks['SendDeathsToBG'] == true) and (ks['solo'] == false)) end,
					set = function(info, var) ks['SendDeathsToBG'] = var end,
					width = "full",
					order = 130
				},
				ss_empty_line_4 = {
					type = "description",
					name = "\n",
					order = 140
				},
				ss_receivedeathsguild = {
					type = 'toggle',
					name = 'Receive Deaths from Guild',
					get = function() return ((ks['ReceiveDeathsFromGuild'] == true) and (ks['solo'] == false)) end,
					set = function(info, var) ks['ReceiveDeathsFromGuild'] = var end,
					width = "full",
					order = 150
				},
				ss_receivedeathsraid = {
					type = 'toggle',
					name = 'Receive Deaths from Party/Raid',
					get = function() return ((ks['ReceiveDeathsFromRaid'] == true) and (ks['solo'] == false)) end,
					set = function(info, var) ks['ReceiveDeathsFromRaid'] = var end,
					width = "full",
					order = 160
				},
				ss_receivedeathsbg = {
					type = 'toggle',
					name = 'Receive Deaths from BG',
					get = function() return ((ks['ReceiveDeathsFromBG'] == true) and (ks['solo'] == false)) end,
					set = function(info, var) ks['ReceiveDeathsFromBG'] = var end,
					width = "full",
					order = 170
				}
			}
		}
		return array;
	end
	
	local function makeStreakAnnouncements()
		local array = {
			type = "group",
			name = "Announce Streak Data",
			args = {
				sa_sendwhat = {
					type = 'select',
					name = 'Select Data to Send',
					desc = 'Select Data to Send',
					get = function() return ks['sendwhat'] end,
					set = function(info, var) ks['sendwhat'] = var end,
					values = {
						streak1 = "Current Streak",
						streak2max = "Highest Streak",
						streak3avg = "Average Streak",
						streak4multimax = "Highest Multikill Streak",
						streak5multitotal = "Total Multikills"
					},
					order = 10
				},
				sa_guild = {
					type = 'toggle',
					name = 'Guild',
					get = function() return (ks['StreakAnnounceGuild'] and kshot:Guild()) end,
					set = function(info, var) ks['StreakAnnounceGuild'] = var end,
					width = "full",
					order = 20
				},
				sa_raid = {
					type = 'toggle',
					name = 'Party/Raid',
					get = function() return (ks['StreakAnnounceRaid'] and ((kshot:getChannel() == PARTY) or (kshot:getChannel() == RAID) or (kshot:getChannel() == PARTY_INSTANCE) or (kshot:getChannel() == RAID_INSTANCE))) end,
					set = function(info, var) ks['StreakAnnounceRaid'] = var end,
					width = "full",
					order = 30
				},
				sa_bg = {
					type = 'toggle',
					name = 'BG',
					get = function() return (ks['StreakAnnounceBG'] and (kshot:getChannel() == BG)) end,
					set = function(info, var) ks['StreakAnnounceBG'] = var end,
					width = "full",
					order = 40
				},
				sa_send = {
					type = 'execute',
					name = 'Send',
					func = function() kshot:EchoStreakData(ks['sendwhat'], ks['StreakAnnounceGuild'], ks['StreakAnnounceRaid'], ks['StreakAnnounceBG']) end,
					width = "full",
					order = 50
				}
			}
		}
		return array;
	end
	
	local function makeCompareVersions()
		local array = {
			type = "group",
			name = "Compare Versions",
			args = {
				version_guild = {
					type = 'toggle',
					name = 'Guild',
					get = function() return (ks['CheckVersionGuild'] and kshot:Guild()) end,
					set = function(info, var) ks['CheckVersionGuild'] = var end,
					width = "full",
					order = 10
				},
				version_raid = {
					type = 'toggle',
					name = 'Party/Raid',
					get = function() return (ks['CheckVersionRaid'] and ((kshot:getChannel() == PARTY) or (kshot:getChannel() == RAID) or (kshot:getChannel() == PARTY_INSTANCE) or (kshot:getChannel() == RAID_INSTANCE))) end,
					set = function(info, var) ks['CheckVersionRaid'] = var end,
					width = "full",
					order = 20
				},
				version_bg = {
					type = 'toggle',
					name = 'BG',
					get = function() return (ks['CheckVersionBG'] and (kshot:getChannel() == BG)) end,
					set = function(info, var) ks['CheckVersionBG'] = var end,
					width = "full",
					order = 30
				},
				version_check = {
					type = 'execute',
					name = 'Compare your version with others',
					func = function() kshot:checkVersions(ks['CheckVersionGuild'], ks['CheckVersionRaid'], ks['CheckVersionBG']) end,
					width = "full",
					order = 40
				}
			}
		}
		return array;
	end
	
	local function makeDebugOptions()
		local array = {
			type = "group",
			name = "Debug Settings",
			args = {
				debug_senddata = {
					type = 'toggle',
					name = 'Show Send Data',
					get = function() return (ks['Debug_SendData'] == true) end,
					set = function(info, var) ks['Debug_SendData'] = var end,
					width = "full",
					order = 10
				},
				debug_receiveddata_others = {
					type = 'toggle',
					name = 'Show Received Data (from others)',
					get = function() return (ks['Debug_ReceivedData_Others'] == true) end,
					set = function(info, var) ks['Debug_ReceivedData_Others'] = var end,
					width = "full",
					order = 20
				},
				debug_receiveddata_you = {
					type = 'toggle',
					name = 'Show Received Data (from yourself)',
					get = function() return (ks['Debug_ReceivedData_You'] == true) end,
					set = function(info, var) ks['Debug_ReceivedData_You'] = var end,
					width = "full",
					order = 30
				},
				debug_empty_line_1 = {
					type = "description",
					name = "\n",
					order = 40
				},
				debug_receivedalldata = {
					type = 'toggle',
					name = 'Show All Received Data (from all addons, from everyone)',
					get = function() return (ks['Debug_ReceivedAllData'] == true) end,
					set = function(info, var) ks['Debug_ReceivedAllData'] = var end,
					width = "full",
					order = 50
				}
			}
		}
		return array;
	end
	
	local function makeAbout()
		local array = {
			type = "group",
			name = "About",
			args = {
				about_about = {
					type = "description",
					name = "Author: Zwarmapapa \nE-Mail: zwarmapapa@hotmail.com \n\nFor any problems, post your problem (and any bug report too if you can) on Killshot's curse page or send me an email.",
					order = 10
				}--,
				--about_empty_line = {
				--	type = "description",
				--	name = "\n",
				--	order = 20
				--},
				--about_broadcast_info = {
				--	type = "description",
				--	name = "Click the button below to add zwarmapapa@hotmail.com to your friends, zwarmapapa@hotmail.com will broadcast information about Killshot (bugs, updates, etc)",
				--	order = 30
				--},
				--version_check = {
				--	type = 'execute',
				--	name = 'Add zwarmapapa@hotmail.com',
				--	func = function() kshot:addToFriends(BROADCAST_EMAIL); end,
				--	width = "full",
				--	order = 40
				--}
			}
		}
		return array;
	end
	

	function kshot:OnInitialize()
		local window = LibStub("AceConfigRegistry-3.0");
		window:RegisterOptionsTable("Killshot", makeInfo);
		window:RegisterOptionsTable("Killshot Settings", makeSettings);
		window:RegisterOptionsTable("Killshot Warning Messages Settings", makeWarningMessagesSettings);
		window:RegisterOptionsTable("Killshot Streak Messages", makeStreakMessages);
		window:RegisterOptionsTable("Killshot Emotes", makeEmotes);
		window:RegisterOptionsTable("Killshot Say List", makeSayList);
		window:RegisterOptionsTable("Killshot Screenshot Settings", makeScreenshotSettings);
		window:RegisterOptionsTable("Killshot Random Pet Settings", makeRandomPetSettings);
		window:RegisterOptionsTable("Killshot Kill Settings", makeKillSettings);
		window:RegisterOptionsTable("Killshot Multikill Settings", makeMultikillSettings);
		window:RegisterOptionsTable("Killshot Death Settings", makeDeathSettings);
		window:RegisterOptionsTable("Killshot Execute Sound Settings", makeExecuteSoundSettings);
		window:RegisterOptionsTable("Killshot Share Settings", makeShareSettings);
		window:RegisterOptionsTable("Killshot Announce Streak Data", makeStreakAnnouncements);
		window:RegisterOptionsTable("Killshot Compare Versions", makeCompareVersions);
		window:RegisterOptionsTable("Killshot Debug Settings", makeDebugOptions);
		window:RegisterOptionsTable("Killshot About", makeAbout);
		
		local paneel = LibStub("AceConfigDialog-3.0");
		paneel:AddToBlizOptions("Killshot", "Killshot");
		paneel:AddToBlizOptions("Killshot Settings", "Settings", "Killshot");
		paneel:AddToBlizOptions("Killshot Warning Messages Settings", "Warning Messages Settings", "Killshot");
		paneel:AddToBlizOptions("Killshot Streak Messages", "Streak Messages", "Killshot");
		paneel:AddToBlizOptions("Killshot Emotes", "Emotes", "Killshot");
		paneel:AddToBlizOptions("Killshot Say List", "Say List", "Killshot");
		paneel:AddToBlizOptions("Killshot Screenshot Settings", "Screenshot Settings", "Killshot");
		paneel:AddToBlizOptions("Killshot Random Pet Settings", "Random Pet Settings", "Killshot");
		paneel:AddToBlizOptions("Killshot Kill Settings", "Kill Settings", "Killshot");
		paneel:AddToBlizOptions("Killshot Multikill Settings", "Multikill Settings", "Killshot");
		paneel:AddToBlizOptions("Killshot Death Settings", "Death Settings", "Killshot");
		paneel:AddToBlizOptions("Killshot Execute Sound Settings", "Execute Sound Settings", "Killshot");
		paneel:AddToBlizOptions("Killshot Share Settings", "Share Settings", "Killshot");
		paneel:AddToBlizOptions("Killshot Announce Streak Data", "Announce Streak Data", "Killshot");
		paneel:AddToBlizOptions("Killshot Compare Versions", "Compare Versions", "Killshot");
		paneel:AddToBlizOptions("Killshot Debug Settings", "Debug Settings", "Killshot");
		paneel:AddToBlizOptions("Killshot About", "About", "Killshot");
		
		
		self:RegisterChatCommand("killshot", function() InterfaceOptionsFrame_OpenToCategory("Killshot") end);
		self:RegisterChatCommand("kshot", function() InterfaceOptionsFrame_OpenToCategory("Killshot") end);
		self:RegisterChatCommand("ks", function() InterfaceOptionsFrame_OpenToCategory("Killshot") end);
		self:RegisterChatCommand("ksfu", function() kshot:FU_Macro(); return end);
		self:RegisterChatCommand("ksgpromote", function() kshot:AQ_TheBloodsailAdmirals_GuildPromotes(); return end);
	end
-- window ================================================================================================================


-- needed crap ===========================================================================================================
	function kshot:OnEnable()
		self:RegisterEvent("SoundEvent", "SoundEventHandler");
		self:RegisterEvent("CHAT_MSG_ADDON", "AddonMessageHandler");
		self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED", "CombatLogEventHandler");
		self:RegisterEvent("ZONE_CHANGED_NEW_AREA", "ZoneChangedHandler");
	end
	function kshot:checkLoadedVar(var, varname, default)
		if (var == nil) then
			var = default;
			
			if (default == true) then
				default = "true";
			end
			if (default == false) then
				default = "false";
			end
			
			if (ks['var_was_nil_error_enabled'] == true) then
				kshot:Print("New Killshot variable: ["..varname.."], default value: ["..default.."]");
			end
		end
		return var;
	end
	function kshot:checkLoadedArray(array, arrayname, default, defaultname)
		if (array == nil) then
			new_array = kshot:setArray(default);
			if (ks['var_was_nil_error_enabled'] == true) then
				kshot:Print("New Killshot variable (array): ["..arrayname.."], default value: ["..defaultname.."]");
			end
		else
			new_array = array;
		end
		return new_array;
	end
	function kshot:setArray(value)
		array = {};
		for i, array_value in pairs(value) do 
			array[i] = array_value;
		end
		return array;
	end
	function kshot:SoundEventHandler(sound)
		if not ((sound == nil) or (sound == "")) then
			if not (kshot:PlaySoundFileNow(sound)) then
				kshot:Print("This sound-file can't be played (it might not exist): ["..sound.."]");
			end
		end
	end
	function kshot:PlaySoundFileNow(sound)
		if ((ks['volume_type'] == "type1none") or (ks['volume_type'] == "type3master")) then
			ks['volume_type'] = "type1master";
		end
		
		if (ks['volume_type'] == "type1master") then
			return PlaySoundFile(sound, "Master");
		elseif (ks['volume_type'] == "type2sfx") then
			return PlaySoundFile(sound, "SFX");
		elseif (ks['volume_type'] == "type3music") then
			return PlaySoundFile(sound, "Music");
		elseif (ks['volume_type'] == "type4ambience") then
			return PlaySoundFile(sound, "Ambience");
		else
			ks['volume_type'] = "type2sfx";
			return PlaySoundFile(sound, "SFX");
		end
	end
	function kshot:ZoneChangedHandler()
		if (ks['ResetStreakOnZoneChange'] == true) then
			kshot:ResetStreak();
		elseif (ks['ShowStreakOnZoneChange'] == true) then
			kshot:EchoStreakIfHigherThanZero();
		end
	end
	function kshot:EchoStreakIfHigherThanZero()
		if (ks_char['killingstreak'] > 0) then
			local msg = "Your current streak is: " .. ks_char['killingstreak'];
			kshot:ScrollText(msg, true);
			kshot:ChatText(msg);
		end
	end
	function kshot:getColor(color)
		return color[1], color[2], color[3], color[4];
	end
	function kshot:setColor(color, r, g, b, a)
		local decimals_per_color = 4;
		color[1] = kshot:round(r, decimals_per_color);
		color[2] = kshot:round(g, decimals_per_color);
		color[3] = kshot:round(b, decimals_per_color);
		color[4] = kshot:round(a, decimals_per_color);
	end
	function kshot:round( num, idp )
		local mult = 10^(idp or 0);
		if (num >= 0) then 
			return (math.floor((num * mult) + 0.5) / mult);
		else
			return (math.ceil((num * mult) - 0.5) / mult);
		end
	end
	function kshot:ScrollText(msg, force, color)
		if ((ks['scrollingtext'] == true) or (force == true)) then
			if (IsAddOnLoaded("Blizzard_CombatText")) then 
				if (color == nil) then
					color = Color_Red;
				end
				CombatText_AddMessage(msg, CombatText_StandardScroll, color[1], color[2], color[3], "crit", color[4]);
			end
		end
	end
	function kshot:ChatText(msg, color)
		if (ks['chattext'] == true) then
			if (color == nil) then
				color = Color_White;
			end
			kshot:Print( kshot:getColoredString(msg, color) );
		end
	end
	function kshot:EmoteText(msg)
		if (UnitIsDeadOrGhost("player") == true) then return end
		if (ks['emote'] == true) then
			SendChatMessage(msg, "EMOTE");
		end
	end
	function kshot:getColoredString(msg, color)
		if (color == nil) then
			color = Color_White;
		end
		msg = "|c" .. kshot:Color2Hex(color) .. msg .. "|r";
		return msg;
	end
	function kshot:Color2Hex(color)
		return kshot:Dec2Hex(color[4]) .. kshot:Dec2Hex(color[1]) .. kshot:Dec2Hex(color[2]) .. kshot:Dec2Hex(color[3]);
	end
	function kshot:Dec2Hex(dec) --   0.0 - 1.0
		dec = dec <= 1 and dec >= 0 and dec or 0
		return string.format("%02x", dec*255);
	end
	function kshot:UpdateAnnounces()
		local Time = GetTime() - lastAnnounceCheckTime;
		while (Time > timePerAnnounce) do
			lastAnnounceCheckTime = lastAnnounceCheckTime + timePerAnnounce;
			Time = GetTime() - lastAnnounceCheckTime;
			if (announces > 0) then
				announces = announces - 1;
			end
		end
	end
	function kshot:getStreakAverage()
		local avgCalc = 0;
		if (ks_char['totalkillingblows'] == nil) then
			ks_char['totalkillingblows'] = 0;
		end
		if (ks_char['totalkillingblows'] > 0) then
			avgCalc = ks_char['totalkillingblows'] / ks_char['killingstreaktimes'];
		end
		return avgCalc;
	end
	function kshot:getRandomKillMessage()
		local randomInt = math.random(1, ks['randomKillMessages']);
		local message = ks['killMessages'][randomInt];
		
		if (message == "") then
			message = defaultKillMessage;
		end
		
		return message;
	end
	function kshot:getKillMessage(random_kill_message, victim_data, streak) -- victim_data = victim|Arena|BG
		local victim_array = split(victim_data, delimiter);
		local victim = victim_array[1];
		if (victim_array[2] == "true") then
			victim = victim .. "(Arena)";
		end
		if (victim_array[3] == "true") then
			victim = victim .. "(BG)";
		end
		
		local message = random_kill_message;
		message = string.gsub(message, "$v", victim);
		message = string.gsub(message, "$s", streak);
		return message;
	end
	function kshot:getMultikillMessage(multistreak)
		local message = multikillMessage;
		message = string.gsub(message, "$s", multistreak);
		return message;
	end
	function kshot:getDeathMessage(victim, killer_data) -- killer_data = killer|NPC|Arena|BG
		local killer_array = split(killer_data, delimiter);
		
		local killer = killer_array[1];
		if (killer == "") then return end
		if not (killer == "none") then
			if (killer_array[2] == "true") then
				killer = killer .. "(NPC)";
			end
			if (killer_array[3] == "true") then
				killer = killer .. "(Arena)";
			end
			if (killer_array[4] == "true") then
				killer = killer .. "(BG)";
			end
		end
		
		if (victim == playername) then
			victim = "You";
		end
		local message = deathMessage;
		if (killer == "none") then
			message = deathMessageKillerNil;
		end
		
		message = string.gsub(message, "$v", victim);
		message = string.gsub(message, "$k", killer);
		return message;
	end
	function kshot:getName(name)
		if (showRealms == false) then
			local till = string.find(name, "-");
			if not (till == nil) then
				name = string.sub(name, 1, till-1);
			end
		end
		return name;
	end
	function kshot:Screenshot()
		Screenshot();
	end
	function kshot:checkPlayerName()
		if ((playername == nil) or (playername == "") or (playername == "Unknown")) then
			playername = UnitName("player");
		end
	end
	function kshot:bitBand(flags, objectType)
		if ((flags == nil) or (objectType == nil)) then
			return false;
		else
			return (bit.band(flags, objectType) == objectType);
		end
	end
	function kshot:getSoundpackNr(use_soundpack)
		if (use_soundpack == nil) then
			use_soundpack = ks['soundpack'];
		end
		local soundpackNr = use_soundpack;
		if (use_soundpack == "sp1normal") then
			soundpackNr = "1";
		elseif (use_soundpack == "sp2female") then
			soundpackNr = "2";
		elseif (use_soundpack == "sp3sexy") then
			soundpackNr = "3";
		elseif (use_soundpack == "sp4custom") then
			soundpackNr = "4";
		end
		return soundpackNr;
	end
	function split(split_string, split_delimiter) -- http://lua-users.org/wiki/SplitJoin
		if (split_delimiter == "") then
			local t = {split_string};
			return t;
		end
		local t = {}
		local fpat = "(.-)" .. split_delimiter
		local last_end = 1
		local s, e, cap = split_string:find(fpat, 1)
		while s do
			if s ~= 1 or cap ~= "" then
				table.insert(t,cap)
			end
			last_end = e+1
			s, e, cap = split_string:find(fpat, last_end)
		end
		if last_end <= #split_string then
			cap = split_string:sub(last_end)
			table.insert(t, cap)
		end
		return t
	end
	function join(join_array, join_delimiter) -- http://lua-users.org/wiki/MakingLuaLikePhp
		return table.concat(join_array, join_delimiter);
	end
	function remove(remove_string, remove_substring)
		local new_string_array = split(remove_string, remove_substring);
		local new_string = join(new_string_array, "-");
		return new_string;
	end
	function removeDelimiter(remove_string)
		return remove(remove_string, delimiter);
	end
	function kshot:checkIfEmotesIsNotNil()
		if (ks['emotes'] == nil) then
			ks['emotes'] = kshot:setArray(defaultEmotes);
		end
	end
	function kshot:removeEmote(emoteIndex)
		kshot:checkIfEmotesIsNotNil();
		local new_emotes = {};
		for i, emotes_emote in pairs(ks['emotes']) do 
			if not (i == emoteIndex) then
				table.insert(new_emotes, emotes_emote);
			end
		end
		ks['emotes'] = kshot:setArray(new_emotes);
	end
	function kshot:addEmote(newEmote)
		kshot:checkIfEmotesIsNotNil();
		if not ((newEmote == "") or (newEmote == nil)) then
			table.insert(ks['emotes'], newEmote);
		end
	end
	function kshot:randomEmote(target)
		kshot:checkIfEmotesIsNotNil();
		local num_emotes = #(ks['emotes']);
		if (num_emotes > 0) then
			local num = math.random(1, num_emotes);
			local play_emote = ks['emotes'][num];
			kshot:emote(play_emote, target);
		end
	end
	function kshot:emote(emote, target)
		if (UnitIsDeadOrGhost("player") == true) then return end
		if not (target == nil) then
			DoEmote(emote, target);
		end
	end
	function kshot:SummonRandomPet()
		SummonRandomCritter();
	end
	function kshot:addToFriends(email)
		local presenceID, toonID, currentBroadcast, bnetAFK, bnetDND = BNGetInfo();
		if (BNIsFriend(presenceID) == false) then
			BNSendFriendInvite(email, "Killshot has send this invite");
		end
	end
	function kshot:Chat_Say(msg)
		SendChatMessage(msg, "SAY", nil, nil);
	end
	function kshot:Chat_Whisper(msg, target)
		SendChatMessage(msg, "WHISPER", nil, target);
	end
	function kshot:Chat_LocalDefence(msg)
		local channelID = GetChannelName("LocalDefense");
		if not (channelID == nil) then
			SendChatMessage(msg, "CHANNEL", nil, channelID);
		end
	end
	function kshot:FU_Macro()
		SendChatMessage("............./''''/)................(\\''''\\");
		SendChatMessage("............/....//................\\\\...\\");
		SendChatMessage(".........../....//..................\\\\...\\");
		SendChatMessage("....../''''/..../'''''\\............/'''''''\\....\\''''\\.");
		SendChatMessage(".././..../..../..../)_......_(.\\.....\\....\\...\\.\\");
		SendChatMessage("(.(.....(....(..../)..).....(..(.\\....)....)....).)");
		SendChatMessage(".\\................\\/../......\\..\\/................/");
		SendChatMessage("..\\................. /........\\................../");
		
		--RunMacroText("............./��/)...............(\\�'\\");
		--RunMacroText("............/....//................\\\\...\\");
		--RunMacroText(".........../....//..................\\\\...\\");
		--RunMacroText("....../��/..../��\\............./�`\\....\\�`\\.");
		--RunMacroText(".././..../..../..../|_......_|.\\.....\\....\\...\\.\\");
		--RunMacroText("(.(.....(....(..../)..).....(..(.\\....)....)....).)");
		--RunMacroText(".\\................\\/../......\\..\\/................/");
		--RunMacroText("..\\................. /........\\................../");
	end
	function kshot:AQ_TheBloodsailAdmirals_GuildPromotes()
		guildName, guildRankName, guildRankIndex = GetGuildInfo("player");
		if( guildName == "The Bloodsail Admirals" ) then
			numTotalMembers, numOnlineMembers = GetNumGuildMembers();
			
			startMember = 1;
			endMember = 500;
			
			if( numTotalMembers < 500 ) then
				endMember = numTotalMembers;
			end
			
			kshot:AQ_TheBloodsailAdmirals_GuildPromotes_Code(startMember, endMember); -- 1-500
			
			if( numTotalMembers > 500 ) then
				startMember = 501;
				endMember = numTotalMembers;
				kshot:AQ_TheBloodsailAdmirals_GuildPromotes_Code(startMember, endMember); -- 501-1000
			end
		end
	end
	function kshot:AQ_TheBloodsailAdmirals_GuildPromotes_Code(part_startMember, part_endMember)
		for i=part_startMember,part_endMember do local name, rank, rankIndex, level, class, zone, note, officernote, online, status, classFileName, achievementPoints, achievementRank, isMobile = GetGuildRosterInfo(i);
			local rankUp = 0;
			
			if( rank == "Seaman Recruit" ) then
				rankUp = rankUp + 2;
			end
			
			if( (note == "") and (level == 85) ) then
				GuildRosterSetPublicNote(i, "Spec: ?");
				rankUp = rankUp + 1;
			end
			
			if( rankUp > 0 ) then
				SetGuildMemberRank(i, rankIndex - rankUp + 1);
			end
		end
	end
	function kshot:checkIfSayListIsNotNil()
		if (ks['say_list'] == nil) then
			ks['say_list'] = kshot:setArray(defaultSayList);
		end
	end
	function kshot:removeSay(sayIndex)
		kshot:checkIfSayListIsNotNil();
		local new_say_list = {};
		for i, say_line in pairs(ks['say_list']) do 
			if not (i == sayIndex) then
				table.insert(new_say_list, say_line);
			end
		end
		ks['say_list'] = kshot:setArray(new_say_list);
	end
	function kshot:addSay(newSay)
		kshot:checkIfSayListIsNotNil();
		if not ((newSay == "") or (newSay == nil)) then
			table.insert(ks['say_list'], newSay);
		end
	end
	function kshot:randomSay(target, force)
		if ((target == nil) or (target == "") or (target == "unknown") or (target == "Unknown") or (target == "none")) then
			return
		end
		if (force == nil) then
			force = false;
		end
		
		kshot:checkIfSayListIsNotNil();
		
		local chance_nr = math.random(1, 100);
		local chance_got_lucky = (chance_nr <= ks['say_chance']);
		
		if ((chance_got_lucky == true) or (force == true)) then
			local num_say_list = #(ks['say_list']);
			if (num_say_list > 0) then
				local num = math.random(1, num_say_list);
				local say_line = kshot:getRandomChatLine( ks['say_list'][num] );
				kshot:Chat_Say(say_line);
			end
		end
	end
	function kshot:getRandomChatLine(random_chat_line, victim)
		if (victim == nil) then
			victim = "Unknown";
		end
		kshot:checkPlayerName();
		
		local message = random_chat_line;
		message = string.gsub(message, "$p", playername);
		message = string.gsub(message, "$v", victim);
		return message;
	end
-- needed crap ===========================================================================================================


-- check functions =======================================================================================================
	function kshot:getChannel(checkParty, checkRaid, checkArena, checkBg)
		if (IsInGroup(LE_PARTY_CATEGORY_INSTANCE) and IsInInstance()) then
			local group = select(2, IsInInstance());
			if (group == "pvp") then
				if ((checkBg == true) or (checkBg == nil)) then
					return BG;
				else
					return nil;
				end
			elseif (group == "arena") then
				if ((checkArena == true) or (checkArena == nil)) then
					return ARENA;
				else
					return nil;
				end
			elseif (group == "raid") then
				if ((checkRaid == true) or (checkRaid == nil)) then
					return RAID;
				else
					return nil;
				end
			elseif (group == "party") then
				if ((checkParty == true) or (checkParty == nil)) then
					return PARTY;
				else
					return nil;
				end
			elseif (group == nil) then
				if ((checkParty == true) or (checkParty == nil)) then
					return PARTY;
				else
					return nil;
				end
			end
		else
			if (IsInRaid() == true) then
				if ((checkRaid == true) or (checkRaid == nil)) then
					return RAID;
				else
					return nil;
				end
			elseif ((GetNumSubgroupMembers() ~= nil) and (GetNumSubgroupMembers() > 0)) then
				if ((checkParty == true) or (checkParty == nil)) then
					return PARTY;
				else
					return nil;
				end
			end
		end
		return nil;
	end
	function kshot:Guild(checkGuild)
		local GuildOK = false;
		if ((checkGuild == true) or (checkGuild == nil)) then
			local numTotalMembers,numOnlineMembers = GetNumGuildMembers();
			if ((IsInGuild() == 1) or (numTotalMembers > 0)) then
				GuildOK = true;
			end
		end
		return GuildOK;
	end
	function kshot:getLocation()
		local inInstance, instanceType = IsInInstance();
		local location = "world";
		if ((instanceType == "pvp") or (instanceType == "arena")) then
			location = "pvp";
		end
		if ((instanceType == "party") or (instanceType == "raid")) then
			location = "pve";
		end
		return location;
	end
	function kshot:CheckBoolean(what, boolean)
		if ((boolean == true) or (boolean == 1) or (boolean == "true") or (boolean == "1")) then
			kshot:Print(what .. " = true");
		else
			kshot:Print(what .. " = false");
		end
	end
-- check functions =======================================================================================================


-- impotant functions ====================================================================================================
	function kshot:Test()
		local testVictim_data = testVictim .. delimiter .. "false" .. delimiter .. "false";
		
		if (testGivesRealKill == true) then
			kshot:checkPlayerName();
			kshot:randomSay(testVictim); -- is done in CombatLogEventHandler() and not in KillshotPvP(), so it needs to be called here
			kshot:randomEmote(UnitName("target")); -- is done in CombatLogEventHandler() and not in KillshotPvP(), so it needs to be called here
			kshot:KillshotPvP(testVictim_data);
		else
			local killingstreaktest = math.random(1, 25);
			local message = kshot:getKillMessage(kshot:getRandomKillMessage(), testVictim_data, killingstreaktest);
			
			kshot:randomSay(testVictim);
			kshot:randomEmote(UnitName("target"));
			
			if (ks['YourKillMessages_Emote'] == true) then
				kshot:EmoteText(message);
			end
			kshot:yourKill("You " .. message);
			kshot:PlaySound(kshot:getKillSound(killingstreaktest));
			
			if (ks_char['summon_random_pet_on_kill'] == true) then
				kshot:SummonRandomPet();
			end
			
			-- 	if (ScreenshotOnKill == true) then
			--		kshot:Screenshot();
			-- 	end
		end
	end
	
	
	function kshot:VersionOutOfDate()
		if (ks['out_of_date_messages_enabled'] == true) then
			local Time = GetTime() - time_from_last_out_of_date_received;
			if (Time > ks['time_between_out_of_date_receives']*60) then
				
				local text = "New version available! Update Killshot!";
				kshot:ScrollText(text, true);
				for i=1,ks['out_of_date_chatlines'] do
					kshot:Print(text);
				end
				
				time_from_last_out_of_date_received = GetTime();
			end
		end
	end
	
	
	function kshot:Check_Sounds_Loaded()
		if (ks['download_killshot_sounds_messages_enabled'] == true) then
			if not (IsAddOnLoaded("Killshot_Sounds")) then
				local Time = GetTime() - time_from_last_download_killshot_sounds;
				if (Time > ks['time_between_download_killshot_sounds']*60) then
					
					local download_sound_msg = "Download the addon [Killshot_Sounds], else Killshot's sounds won't work!";
					kshot:ScrollText(download_sound_msg, true);
					for i=1,ks['download_killshot_sounds_chatlines'] do
						kshot:ChatText(download_sound_msg);
					end
					
					time_from_last_download_killshot_sounds = GetTime();
				end
			end
		end
	end
	
	
	-- your ========================================================
		function kshot:yourKill(text)
			if (ks['YourKillMessages_CombatText'] == true) then
				kshot:ScrollText(text, false, Color_Kill_CombatText);
			end
			if (ks['YourKillMessages_ChatText'] == true) then
				kshot:ChatText(text, Color_Kill_ChatText);
			end
		end
		
		function kshot:yourKillRecordbreak(text)
			kshot:ScrollText(text, false);
			kshot:ChatText(text);
		end
		
		function kshot:yourMultikill(text)
			if (ks['YourMultikillMessages_CombatText'] == true) then
				kshot:ScrollText(text, false, Color_Multikill_CombatText);
			end
			if (ks['YourMultikillMessages_ChatText'] == true) then
				kshot:ChatText(text, Color_Multikill_ChatText);
			end
		end
		
		function kshot:yourMultikillRecordbreak(text)
			kshot:ScrollText(text, false);
			kshot:ChatText(text);
		end
		
		function kshot:yourDeath(text, killer_is_npc)
			local doCombatText = false;
			local doChatText = false;
			
			local location = kshot:getLocation();
			if (location == "world") then
				if (killer_is_npc == "false") then
					if (ks['YourDeathMessages_World_PvP_CombatText'] == true) then
						doCombatText = true;
					end
					if (ks['YourDeathMessages_World_PvP_ChatText'] == true) then
						doChatText = true;
					end
				else
					if (ks['YourDeathMessages_World_PvE_CombatText'] == true) then
						doCombatText = true;
					end
					if (ks['YourDeathMessages_World_PvE_ChatText'] == true) then
						doChatText = true;
					end
				end
			elseif (location == "pvp") then
				if (ks['YourDeathMessages_PvP_CombatText'] == true) then
					doCombatText = true;
				end
				if (ks['YourDeathMessages_PvP_ChatText'] == true) then
					doChatText = true;
				end
			elseif (location == "pve") then
				if (ks['YourDeathMessages_PvE_CombatText'] == true) then
					doCombatText = true;
				end
				if (ks['YourDeathMessages_PvE_ChatText'] == true) then
					doChatText = true;
				end
			end
			
			if (doCombatText == true) then
				kshot:ScrollText(text, false, Color_Death_CombatText);
			end
			if (doChatText == true) then
				kshot:ChatText(text, Color_Death_ChatText);
			end
		end
	-- your ========================================================
	
	-- other =======================================================
		function kshot:otherKill(text)
			if (ks['OtherKillMessages_CombatText'] == true) then
				kshot:ScrollText(text, false, Color_Kill_CombatText);
			end
			if (ks['OtherKillMessages_ChatText'] == true) then
				kshot:ChatText(text, Color_Kill_ChatText);
			end
		end
		
		function kshot:otherMultikill(text)
			if (ks['OtherMultikillMessages_CombatText'] == true) then
				kshot:ScrollText(text, false, Color_Multikill_CombatText);
			end
			if (ks['OtherMultikillMessages_ChatText'] == true) then
				kshot:ChatText(text, Color_Multikill_ChatText);
			end
		end
		
		function kshot:otherDeath(text, location, killer_is_npc)
			local doCombatText = false;
			local doChatText = false;
			
			if (location == "world") then
				if (killer_is_npc == "false") then
					if (ks['OtherDeathMessages_World_PvP_CombatText'] == true) then
						doCombatText = true;
					end
					if (ks['OtherDeathMessages_World_PvP_ChatText'] == true) then
						doChatText = true;
					end
				else
					if (ks['OtherDeathMessages_World_PvE_CombatText'] == true) then
						doCombatText = true;
					end
					if (ks['OtherDeathMessages_World_PvE_ChatText'] == true) then
						doChatText = true;
					end
				end
			elseif (location == "pvp") then
				if (ks['OtherDeathMessages_PvP_CombatText'] == true) then
					doCombatText = true;
				end
				if (ks['OtherDeathMessages_PvP_ChatText'] == true) then
					doChatText = true;
				end
			elseif (location == "pve") then
				if (ks['OtherDeathMessages_PvE_CombatText'] == true) then
					doCombatText = true;
				end
				if (ks['OtherDeathMessages_PvE_ChatText'] == true) then
					doChatText = true;
				end
			end
			
			if (doCombatText == true) then
				kshot:ScrollText(text, false, Color_Death_CombatText);
			end
			if (doChatText == true) then
				kshot:ChatText(text, Color_Death_ChatText);
			end
		end
	-- other =======================================================
-- important functions ===================================================================================================


-- main script ===========================================================================================================
	-- play soundfiles ===================================================================================================
		function kshot:PlaySound(soundfile)
			if (ks['sound'] == true) then
				kshot:SoundEventHandler(soundfile);
			end
		end
		
		
		function kshot:getKillSound(kills, use_soundpack)
			kills = tonumber(kills);
			local soundfile = "";
			if (kills > -100 ) then
				if (kills > 19) then soundfile = "14.ogg";
				elseif (kills > 15) then soundfile = "13.ogg";
				elseif (kills > 12) then soundfile = "12.ogg";
				elseif (kills > 10) then soundfile = "11.ogg";
				elseif (kills >  9) then soundfile = "10.ogg";
				elseif (kills >  8) then soundfile = "9.ogg";
				elseif (kills >  7) then soundfile = "8.ogg";
				elseif (kills >  6) then soundfile = "7.ogg";
				elseif (kills >  5) then soundfile = "6.ogg";
				elseif (kills >  4) then soundfile = "5.ogg";
				elseif (kills >  3) then soundfile = "4.ogg";
				elseif (kills >  2) then soundfile = "3.ogg";
				elseif (kills >  1) then soundfile = "2.ogg";
				elseif (kills >  0) then soundfile = "1.ogg";
				end
			elseif (kills > -200 ) then
				if (kills == -114) then soundfile = "14.ogg";
				elseif (kills == -113) then soundfile = "13.ogg";
				elseif (kills == -112) then soundfile = "12.ogg";
				elseif (kills == -111) then soundfile = "11.ogg";
				elseif (kills == -110) then soundfile = "10.ogg";
				elseif (kills == -109) then soundfile = "9.ogg";
				elseif (kills == -108) then soundfile = "8.ogg";
				elseif (kills == -107) then soundfile = "7.ogg";
				elseif (kills == -106) then soundfile = "6.ogg";
				elseif (kills == -105) then soundfile = "5.ogg";
				elseif (kills == -104) then soundfile = "4.ogg";
				elseif (kills == -103) then soundfile = "3.ogg";
				elseif (kills == -102) then soundfile = "2.ogg";
				elseif (kills == -101) then soundfile = "1.ogg";
				end
			end
			local soundpack_nr = kshot:getSoundpackNr(use_soundpack);
			local sp_map = "sp" .. soundpack_nr .. "\\";
			return Path_Killshot_Sounds() .. sp_map .. soundfile;
		end
		
		
		function kshot:getMultikillSound()
			if (ks['multikillSound'] == old_defaultMultikillSound) then
				ks['multikillSound'] = "";
			end
			
			local multikillSound_return = ks['multikillSound'];
			if (multikillSound_return == "") then
				multikillSound_return = defaultMultikillSound();
			end
			return multikillSound_return;
		end
		
		
		function kshot:getExecuteSound()
			if (ks['executeSound'] == nil) then
				ks['executeSound'] = "";
			end
			
			if (ks['executeSound'] == old_defaultExecuteSound) then
				ks['executeSound'] = "";
			end
			
			local executeSound_return = ks['executeSound'];
			if (executeSound_return == "") then
				executeSound_return = defaultExecuteSound();
			end
			return executeSound_return;
		end
		
		
		function kshot:getDeathSound(use_soundpack)
			local deathSound_return = ks['deathSound'];
			if ((deathSound_return == "") or not (use_soundpack == nil)) then
				deathSound_return = defaultDeathSound(use_soundpack);
			end
			return deathSound_return;
		end
	-- play soundfiles ===================================================================================================
	
	
	-- share data ========================================================================================================
		-- send & receive event ========================================================================
			function kshot:resetLastMessageReceivedData()
				lastMessageReceivedData = "";
			end
			
			function kshot:debug_showAddonMessage(debug_prefix, debug_target, debug_event, debug_share_channel, debug_data)
				if (debug_prefix == nil) then debug_prefix = "nil"; end
				if (debug_target == nil) then debug_target = "nil"; end
				if (debug_event == nil) then debug_event = "nil"; end
				if (debug_share_channel == nil) then debug_share_channel = "nil"; end
				if (debug_data == nil) then debug_data = "nil"; end
				
				if (debug_event == "nil") then
					kshot:Print("<Killshot> - ["..debug_target.."] send something via ["..debug_share_channel.."] - ("..debug_data..")"); -- <Killshot> - [You] send [KILL] via [RAID] - (data)
				else
					kshot:Print("<Killshot> - ["..debug_target.."] send ["..debug_event.."] via ["..debug_share_channel.."] - ("..debug_data..")"); -- <Killshot> - [You] send [KILL] via [RAID] - (data)
				end
			end
			
			function kshot:SendAddonMessage(data, share_channel)
				SendAddonMessage(Prefix, data, share_channel);
				if (ks['Debug_SendData'] == true) then
					local data_array = split(data, delimiter); -- version_nr|warn_using_older_version|share_channel|event|...
					kshot:debug_showAddonMessage(Prefix, "You", data_array[4], share_channel, data);
				end
			end
			
			function kshot:AddonMessageHandler(info, prefix, data, channel, target)
				if (ks['Debug_ReceivedAllData'] == true) then
					kshot:debug_showAddonMessage(prefix, target, "nil", channel, data);
				end
				
				if not (prefix == Prefix) then return end
				local data_array = split(data, delimiter); -- version_nr|warn_using_older_version|share_channel|event|...
				if (#(data_array) <= 1) then return end
				
				kshot:checkPlayerName();
				if not (target == playername) then
					if (ks['Debug_ReceivedData_Others'] == true) then
						kshot:debug_showAddonMessage(prefix, target, data_array[4], data_array[3], data);
					end
				else
					if (ks['Debug_ReceivedData_You'] == true) then
						kshot:debug_showAddonMessage(prefix, target, data_array[4], data_array[3], data);
					end
					return
				end
				
				
				-- blocks same messages ========================== ps: share_channel is differend for the same messages, so filter it out for same-message-check
					local send_data = "";
					for i=1,#(data_array) do
						if not (i == 3) then
							send_data  = send_data .. delimiter .. data_array[i];
						end
					end
					if ((send_data == lastMessageReceivedData) and (target == lastMessageReceivedTarget)) then
						local Time = GetTime() - lastMessageReceivedTime;
						if (Time < timeBetweenSameReceives) then
							return
						end
					end
					lastMessageReceivedData = send_data;
					lastMessageReceivedTarget = target;
					lastMessageReceivedTime = GetTime();
				-- blocks same messages ==========================
				
				local event = data_array[4];
				
				-- blocks other versions =========================
					if (event == "VERSION_OUTDATED") then
						if (data_array[5] == playername) then
							if (data_array[2] == "true") then
								kshot:VersionOutOfDate();
							end
						end
						return
					end
					if not (data_array[1] == version_nr) then
						if (tonumber(data_array[1]) > tonumber(version_nr)) then -- your version is older
							if (data_array[2] == "true") then
								kshot:VersionOutOfDate();
							end
						elseif (tonumber(data_array[1]) < tonumber(version_nr)) then -- his version is older
							-- version_nr|warn_using_older_version|share_channel|VERSION_OUTDATED|to_player
							local share_channel = data_array[3];
							local sendVersionOutdatedData = version_nr .. delimiter .. warn_using_older_version .. delimiter .. share_channel .. delimiter .. "VERSION_OUTDATED" .. delimiter .. kshot:getName(target);
							kshot:SendAddonMessage(sendVersionOutdatedData, share_channel);
						end
						if not ((event == "VERSION_REQUEST") or (event == "VERSION_RESPONSE")) then return end
					end
				-- blocks other versions =========================
				
				if (event == "VERSION_REQUEST") then
					kshot:receiveVersionRequest(data);
				elseif (event == "VERSION_RESPONSE") then
					kshot:receiveVersionResponse(data);
				end
				
				if ((ks['solo'] == false) or (receiveSharedDataWhileSoloMode == true)) then
					if (event == "SHARED_DATA") then
						kshot:receiveSharedData(data);
					end
				end
				
				if (ks['solo'] == false) then
					if (event == "KILL") then
						kshot:receiveKill(data);
					elseif (event == "MULTIKILL") then
						kshot:receiveMultikill(data);
					elseif (event == "DEATH") then
						kshot:receiveDeath(data);
					end
				end
			end
		-- send & receive event ========================================================================
		
		
		-- version request & response ==================================================================
			function kshot:checkVersions(checkGuild, checkRaid, checkBG)
				kshot:checkPlayerName();
				kshot:Print(playername .. " is on version " .. version);
				if (kshot:Guild(checkGuild) == true) then
					kshot:sendVersionRequest(GUILD);
				end
				kshot:sendVersionRequest( kshot:getChannel(checkRaid, checkRaid, checkRaid, checkBG) );
			end
			
			function kshot:sendVersionRequest(share_channel)
				if( share_channel ~= nil ) then
					-- data = version_nr|warn_using_older_version|share_channel|VERSION_REQUEST|playername
					local data = version_nr .. delimiter .. warn_using_older_version .. delimiter .. share_channel .. delimiter .. "VERSION_REQUEST" .. delimiter .. playername;
					kshot:SendAddonMessage(data, share_channel);
				end
			end
			
			function kshot:receiveVersionRequest(data)
				-- data = version_nr|warn_using_older_version|share_channel|VERSION_REQUEST|playername
				local data_array = split(data, delimiter);
				kshot:sendVersionResponse(data_array[3], data_array[5]);
			end
			
			function kshot:sendVersionResponse(share_channel, to_player)
				-- data = version_nr|warn_using_older_version|share_channel|VERSION_RESPONSE|to_player|playername|version
				local data = version_nr .. delimiter .. warn_using_older_version .. delimiter .. share_channel .. delimiter .. "VERSION_RESPONSE" .. delimiter .. to_player .. delimiter .. playername .. delimiter .. version;
				kshot:SendAddonMessage(data, share_channel);
			end
			
			function kshot:receiveVersionResponse(data)
				-- data = version_nr|warn_using_older_version|share_channel|VERSION_RESPONSE|to_player|playername|version
				local data_array = split(data, delimiter);
				if (data_array[5] == playername) then
					kshot:Print(data_array[6] .. " is on version " .. data_array[7]);
				end
			end
		-- version request & response ==================================================================
		
		
		-- share data ==================================================================================
			function kshot:EchoStreakData(what, toGuild, toRaid, toBG)
				if ((kshot:Guild(toGuild) == false) and (kshot:getChannel(toRaid,toRaid,toRaid,toBG) == nil)) then
					kshot:Print("You can't send your streak-data to no-one!");
				else
					kshot:UpdateAnnounces();
					announces = announces + 1;
					if (announces < maxAnnounces) then
						local var = "";
						local whatText = "";
						if (what == "streak1") then
							var = ks_char['killingstreak'];
							whatText = "current streak";
						elseif (what == "streak2max") then
							var = ks_char['maxkillingstreak'];
							whatText = "highest streak";
						elseif (what == "streak3avg") then
							var = kshot:getStreakAverage();
							whatText = "average streak";
						elseif (what == "streak4multimax") then
							var = ks_char['maxmultistreak'];
							whatText = "highest multikill streak";
						elseif (what == "streak5multitotal") then
							var = ks_char['totalmultistreak'];
							whatText = "total multikills";
						else
							sendwhat = "streak1";
							return
						end
						kshot:Echo(toGuild, toRaid, toBG, whatText, what, var);
					else
						kshot:Print("Killsot's Anti-Spam stopped your streak-data announcement!");
					end
				end
			end
			
			function kshot:Echo(toGuild, toRaid, toBG, whatText, what, var)
				kshot:checkPlayerName();
				local anythingIsSend = false;
				
				if (kshot:Guild(toGuild) == true) then
					kshot:sendSharedData(GUILD, whatText, what, var);
					anythingIsSend = true;
				end
				if (kshot:getChannel(toRaid,toRaid,toRaid,toBG) ~= nil) then
					kshot:sendSharedData( kshot:getChannel(toRaid,toRaid,toRaid,toBG), whatText, what, var );
					anythingIsSend = true;
				end
				
				if (anythingIsSend == false) then
					kshot:Print("You can't send your streak-data to no-one!");
					announces = announces - 1;
				end
			end
			
			function kshot:sendSharedData(share_channel, whatText, what, var)
				-- data = version_nr|warn_using_older_version|share_channel|SHARED_DATA|playername|what|var
				local soundpack_nr = kshot:getSoundpackNr();
				local data = version_nr .. delimiter .. warn_using_older_version .. delimiter .. share_channel .. delimiter .. "SHARED_DATA" .. delimiter .. playername .. delimiter .. what .. delimiter .. var;
				kshot:SendAddonMessage(data, share_channel);
				kshot:Print("Your " .. whatText .. " has been sent to your " .. share_channel);
			end
			
			function kshot:receiveSharedData(data, target)
				-- data = version_nr|warn_using_older_version|share_channel|SHARED_DATA|playername|what|var
				local data_array = split(data, delimiter);
				
				local from_player = data_array[5];
				local what = data_array[6];
				local var = data_array[7];
				
				local msg = "";
				if (what == "streak1") then
					msg = from_player .. "'s current streak is: " .. var;
				elseif (what == "streak2max") then
					msg = from_player .. "'s highest streak is: " .. var;
				elseif (what == "streak3avg") then
					msg = from_player .. "'s average streak is: " .. var;
				elseif (what == "streak4multimax") then
					msg = from_player .. "'s highest multikill streak is: " .. var;
				elseif (what == "streak5multitotal") then
					msg = from_player .. "'s total multikills are: " .. var;
				else
					return
				end
				
				kshot:Print(msg);
			end
		-- share data ==================================================================================
		
		
		-- kill ========================================================================================
			function kshot:shareKill(killingstreak, raw_streakmessage, victim_data)
				 -- victim_data = victim|Arena|BG
				if (ks['solo'] == false) then
					kshot:checkPlayerName();
					
					local victim_array = split(victim_data, delimiter);
					local victim = victim_array[1];
					local in_arena = victim_array[2];
					local in_bg = victim_array[3];
					
					if (kshot:Guild(ks['SendToGuild']) == true) then
						kshot:sendKill(GUILD, killingstreak, raw_streakmessage, victim, in_arena, in_bg);
					end
					local channel = kshot:getChannel( ks['SendToRaid'], ks['SendToRaid'], ks['SendToRaid'], ks['SendToBG'] );
					if (channel ~= nil) then
						kshot:sendKill(channel, killingstreak, raw_streakmessage, victim, in_arena, in_bg);
					end
				end
			end
			
			function kshot:sendKill(share_channel, killingstreak, raw_streakmessage, victim, in_arena, in_bg)
				if (share_channel ~= nil) then
					-- data = version_nr|warn_using_older_version|share_channel|KILL|soundpack_nr|killingstreak|raw_streakmessage|playername|victim|in_arena|in_bg
					local soundpack_nr = kshot:getSoundpackNr();
					local data = version_nr .. delimiter .. warn_using_older_version .. delimiter .. share_channel .. delimiter .. "KILL" .. delimiter .. soundpack_nr .. delimiter .. killingstreak .. delimiter .. raw_streakmessage .. delimiter .. playername .. delimiter .. victim .. delimiter .. in_arena .. delimiter .. in_bg;
					kshot:SendAddonMessage(data, share_channel);
				end
			end
			
			function kshot:receiveKill(data)
				-- data = version_nr|warn_using_older_version|share_channel|KILL|soundpack_nr|killingstreak|raw_streakmessage|playername|victim|in_arena|in_bg
				local data_array = split(data, delimiter);
				local share_channel = data_array[3];
				
				if ((share_channel == GUILD) and (ks['ReceiveFromGuild'] == false)) then
					kshot:resetLastMessageReceivedData();
					return
				end
				if ((share_channel == ARENA) and (ks['ReceiveFromRaid'] == false)) then
					kshot:resetLastMessageReceivedData();
					return
				end
				if (((share_channel == PARTY) or (share_channel == PARTY_INSTANCE)) and (ks['ReceiveFromRaid'] == false)) then
					kshot:resetLastMessageReceivedData();
					return
				end
				if (((share_channel == RAID) or (share_channel == RAID_INSTANCE)) and (ks['ReceiveFromRaid'] == false)) then
					kshot:resetLastMessageReceivedData();
					return
				end
				if ((share_channel == BG) and (ks['ReceiveFromBG'] == false)) then
					kshot:resetLastMessageReceivedData();
					return
				end
				
				local soundpack_nr = data_array[5];
				local killingstreak = data_array[6];
				local raw_streakmessage = data_array[7];
				local killer = data_array[8];
				local victim_data = data_array[9] .. delimiter .. data_array[10] .. delimiter .. data_array[11];
				
				local msg = kshot:getKillMessage(raw_streakmessage, victim_data, killingstreak);
				kshot:otherKill(killer .. " " .. msg);
				if (ks['OtherKillSounds'] == true) then
					kshot:PlaySound(kshot:getKillSound(killingstreak, soundpack_nr));
				end
			end
		-- kill ========================================================================================
		
		
		-- multikill ===================================================================================
			function kshot:shareMultikill(multistreak)
				if (ks['solo'] == false) then
					kshot:checkPlayerName();
					
					if (kshot:Guild(ks['SendToGuild']) == true) then
						kshot:sendMultikill(GUILD, multistreak);
					end
					local channel = kshot:getChannel( ks['SendToRaid'], ks['SendToRaid'], ks['SendToRaid'], ks['SendToBG'] );
					if (channel ~= nil) then
						kshot:sendMultikill(channel, multistreak);
					end
				end
			end
			
			function kshot:sendMultikill(share_channel, multistreak)
				if (share_channel ~= nil) then
					-- data = version_nr|warn_using_older_version|share_channel|MULTIKILL|soundpack_nr|multistreak|playername
					local soundpack_nr = kshot:getSoundpackNr();
					local data = version_nr .. delimiter .. warn_using_older_version .. delimiter .. share_channel .. delimiter .. "MULTIKILL" .. delimiter .. soundpack_nr .. delimiter .. multistreak .. delimiter .. playername;
					kshot:SendAddonMessage(data, share_channel);
				end
			end
			
			function kshot:receiveMultikill(data)
				-- data = version_nr|warn_using_older_version|share_channel|MULTIKILL|soundpack_nr|multistreak|playername
				local data_array = split(data, delimiter);
				local share_channel = data_array[3];
				
				if ((share_channel == GUILD) and (ks['ReceiveFromGuild'] == false)) then
					kshot:resetLastMessageReceivedData();
					return
				end
				if ((share_channel == ARENA) and (ks['ReceiveFromRaid'] == false)) then
					kshot:resetLastMessageReceivedData();
					return
				end
				if (((share_channel == PARTY) or (share_channel == PARTY_INSTANCE)) and (ks['ReceiveFromRaid'] == false)) then
					kshot:resetLastMessageReceivedData();
					return
				end
				if (((share_channel == RAID) or (share_channel == RAID_INSTANCE)) and (ks['ReceiveFromRaid'] == false)) then
					kshot:resetLastMessageReceivedData();
					return
				end
				if ((share_channel == BG) and (ks['ReceiveFromBG'] == false)) then
					kshot:resetLastMessageReceivedData();
					return
				end
				
				local multistreak = data_array[6];
				local killer = data_array[7];
				
				local msg = kshot:getMultikillMessage(multistreak);
				kshot:otherMultikill(killer .. " " .. msg);
				if (ks['OtherMultikillSounds'] == true) then
					kshot:PlaySound(kshot:getMultikillSound());
				end
			end
		-- multikill ===================================================================================
		
		
		-- death =======================================================================================
			function kshot:shareDeath(killer_data)
				 -- killer_data = killername|NPC|Arena|BG
				if (ks['solo'] == false) then
					kshot:checkPlayerName();
					
					local killer_array = split(killer_data, delimiter);
					local killer = killer_array[1];
					local killer_is_npc = killer_array[2];
					local in_arena = killer_array[3];
					local in_bg = killer_array[4];
					
					if (kshot:Guild(ks['SendDeathsToGuild']) == true) then
						kshot:sendDeath(GUILD, killer, killer_is_npc, in_arena, in_bg);
					end
					local channel = kshot:getChannel( ks['SendDeathsToRaid'], ks['SendDeathsToRaid'], ks['SendDeathsToRaid'], ks['SendDeathsToBG'] );
					if (channel ~= nil) then
						kshot:sendDeath(channel, killer, killer_is_npc, in_arena, in_bg);
					end
				end
			end
			
			function kshot:sendDeath(share_channel, killer, killer_is_npc, in_arena, in_bg)
				if (share_channel ~= nil) then
					-- data = version_nr|warn_using_older_version|share_channel|DEATH|soundpack_nr|playername|killer|killer_is_npc|in_arena|in_bg|location
					local soundpack_nr = kshot:getSoundpackNr();
					local data = version_nr .. delimiter .. warn_using_older_version .. delimiter .. share_channel .. delimiter .. "DEATH" .. delimiter .. soundpack_nr .. delimiter .. playername .. delimiter .. killer .. delimiter .. killer_is_npc .. delimiter .. in_arena .. delimiter .. in_bg .. delimiter .. kshot:getLocation();
					kshot:SendAddonMessage(data, share_channel);
				end
			end
			
			function kshot:receiveDeath(data)
				-- data = version_nr|warn_using_older_version|share_channel|DEATH|soundpack_nr|playername|killer|killer_is_npc|in_arena|in_bg|location
				local data_array = split(data, delimiter);
				local share_channel = data_array[3];
				
				if ((share_channel == GUILD) and (ks['ReceiveDeathsFromGuild'] == false)) then
					kshot:resetLastMessageReceivedData();
					return
				end
				if ((share_channel == ARENA) and (ks['ReceiveDeathsFromRaid'] == false)) then
					kshot:resetLastMessageReceivedData();
					return
				end
				if (((share_channel == PARTY) or (share_channel == PARTY_INSTANCE)) and (ks['ReceiveDeathsFromRaid'] == false)) then
					kshot:resetLastMessageReceivedData();
					return
				end
				if (((share_channel == RAID) or (share_channel == RAID_INSTANCE)) and (ks['ReceiveDeathsFromRaid'] == false)) then
					kshot:resetLastMessageReceivedData();
					return
				end
				if ((share_channel == BG) and (ks['ReceiveDeathsFromBG'] == false)) then
					kshot:resetLastMessageReceivedData();
					return
				end
				
				local soundpack_nr = data_array[5];
				local victim = data_array[6];
				local killer_data = data_array[7] .. delimiter .. data_array[8] .. delimiter .. data_array[9] .. delimiter .. data_array[10];
				local killer_is_npc = data_array[8];
				local location = data_array[11];
				
				local msg = kshot:getDeathMessage(victim, killer_data);
				kshot:otherDeath(msg, location, killer_is_npc);
				
				-- sound ==========
					local playSound = false;
					if (location == "world") then
						if (killer_is_npc == "false") then
							if (ks['OtherDeathSounds_World_PvP'] == true) then
								playSound = true;
							end
						else
							if (ks['OtherDeathSounds_World_PvE'] == true) then
								playSound = true;
							end
						end
					elseif (location == "pvp") then
						if (ks['OtherDeathSounds_PvP'] == true) then
							playSound = true;
						end
					elseif (location == "pve") then
						if (ks['OtherDeathSounds_PvE'] == true) then
							playSound = true;
						end
					end
					if (playSound == true) then
						kshot:PlaySound(kshot:getDeathSound(soundpack_nr));
					end
				-- sound ==========
			end
		-- death =======================================================================================
	-- share data ========================================================================================================
	
	
	-- combat events =====================================================================================================
		function kshot:CombatLogEventHandler(info, timestamp, event, hideCaster, sourceID, sourceName, sourceFlags, sourceRaidFlags, destID, destName, destFlags, destRaidFlags, ...)
			kshot:checkPlayerName();
			if (event == nil) then return end
			if (event == "PARTY_KILL") then
				-- kill ==========================================================
					if (sourceFlags == nil) then return end
					if (destFlags == nil) then return end
					if (kshot:bitBand(sourceFlags, COMBATLOG_OBJECT_AFFILIATION_MINE)) then
						if (destName == nil) then return end
						if (kshot:bitBand(destFlags, COMBATLOG_OBJECT_TYPE_PLAYER)) then
							kshot:randomSay(kshot:getName(destName));
							kshot:randomEmote(destName);
							local VictimName = kshot:getName(destName);
							
							if (kshot:getChannel() == ARENA) then
								VictimName = VictimName .. delimiter .. "true";
							else
								VictimName = VictimName .. delimiter .. "false";
							end
							
							if (kshot:getChannel() == BG) then
								VictimName = VictimName .. delimiter .. "true";
							else
								VictimName = VictimName .. delimiter .. "false";
							end
							
							kshot:KillshotPvP(VictimName); -- victim|Arena|BG
						else
							kshot:KillshotPvE();
						end
					end
				-- kill ==========================================================
			elseif (event == "UNIT_DIED") then
				-- death =========================================================
					if (destName == nil) then return end
					if (destName == playername) then
						if (kshot:bitBand(destFlags, COMBATLOG_OBJECT_TYPE_PLAYER)) then
							local Time = GetTime() - lastDamageDealerTimeAgo;
							if (Time > timeBeforeLastDamageDealerResets) then
								lastDamageDealer = "none" .. delimiter .. "false" .. delimiter .. "false" .. delimiter .. "false";
							end
							kshot:PlayerDeath(lastDamageDealer); -- lastDamageDealer|NPC|Arena|BG
						end
					end
				-- death =========================================================
			elseif (string.find(event, "_DAMAGE")) then
				if (destName == nil) then return end
				if (sourceName == nil) then return end
				-- player receives damage (save killer's name for death) =====
					if (destName == playername) then
						if (kshot:bitBand(destFlags, COMBATLOG_OBJECT_TYPE_PLAYER)) then
							if not (sourceName == playername) then
								lastDamageDealer = kshot:getName(sourceName);
								lastDamageDealerTimeAgo = GetTime();
								
								if not (kshot:bitBand(sourceFlags, COMBATLOG_OBJECT_TYPE_PLAYER)) then -- if (source == NPC) then
									lastDamageDealer = lastDamageDealer .. delimiter .. "true";
								else
									lastDamageDealer = lastDamageDealer .. delimiter .. "false";
								end
								
								if (kshot:getChannel() == ARENA) then
									lastDamageDealer = lastDamageDealer .. delimiter .. "true";
								else
									lastDamageDealer = lastDamageDealer .. delimiter .. "false";
								end
								
								if (kshot:getChannel() == BG) then
									lastDamageDealer = lastDamageDealer .. delimiter .. "true";
								else
									lastDamageDealer = lastDamageDealer .. delimiter .. "false";
								end
							end
						end
					end
				-- player receives damage (save killer's name for death) =====
				
				-- target receives damage (execute sound) ========================
					if ((UnitName("target") == nil) or (destname == playername)) then
						lastTarget = "";
					elseif (UnitName("target") == kshot:getName(destName)) then
						if ((UnitHealth("target") <= ((UnitHealthMax("target")*ks_char['executeSoundHealthProcent'])/100)) and (UnitHealth("target") > 1)) then
							if not (destName == lastTarget) then
								lastTarget = destName;
								if not (kshot:bitBand(destFlags, COMBATLOG_OBJECT_TYPE_PLAYER)) then
									if (ks['executeSoundNPC'] == true) then
										kshot:PlaySound(kshot:getExecuteSound());
									end
								else
									if (ks['executeSoundPlayer'] == true) then
										kshot:PlaySound(kshot:getExecuteSound());
									end
								end
							end
						else
							lastTarget = "";
						end
					end
				-- target receives damage (execute sound) ========================
			end
		end
	-- combat events =====================================================================================================
	
	
	-- kill / multikill / death ==========================================================================================
		function kshot:KillshotPvE()
			if (ks['PvE'] == true) then
				local soundnr = 0;
				if (ks['PvE_Random'] == true) then
					soundnr = math.random(1, audiofiles);
				else
					killingstreakPvE = killingstreakPvE + 1;
					if (killingstreakPvE > audiofiles) then
						killingstreakPvE = 1;
					end
					soundnr = killingstreakPvE;
				end
				soundnr = 0-100-soundnr;
				kshot:PlaySound(kshot:getKillSound(soundnr));
			end
		end
		
		function kshot:KillshotPvP(victim_data) -- kill / multikill
			-- victim_data = victim|Arena|BG
			
			local useKillingstreak = 0;
			if (ks_char['enableStreakDataModifications'] == true) then
				-- modify kill vars ==========================
					ks_char['killingstreak'] = ks_char['killingstreak'] + 1;
					ks_char['totalkillingblows'] = ks_char['totalkillingblows'] + 1;
					
					if (ks_char['killingstreak'] == 1) then
						ks_char['killingstreaktimes'] = ks_char['killingstreaktimes'] + 1;
					end
					
					local killRecordImproved = false;
					if (ks_char['killingstreak'] > ks_char['maxkillingstreak']) then
						ks_char['maxkillingstreak'] = ks_char['killingstreak'];
						killRecordImproved = true;
					end
				-- modify kill vars ==========================
				-- check multikill + modify multikill vars ========
					local thismultikill = false;
					local Time = GetTime() - lastKill;
					if (Time < multikillTime) then
						multistreak = multistreak + 1;
						ks_char['totalmultistreak'] = ks_char['totalmultistreak'] + 1;
						thismultikill = true;
					else
						multistreak = 0;
					end
					lastKill = GetTime();
					
					local multikillRecordImproved = false;
					if (multistreak > ks_char['maxmultistreak']) then
						ks_char['maxmultistreak'] = multistreak;
						multikillRecordImproved = true;
					end
				-- check multikill + modify multikill vars ========
				
				useKillingstreak = ks_char['killingstreak'];
			else
				if (killingstreakNotSaved == nil) then
					killingstreakNotSaved = 0;
				end
				killingstreakNotSaved = killingstreakNotSaved + 1;
				useKillingstreak = killingstreakNotSaved;
			end
			
			if (ks['PvP'] == true) then
				local takeScreenshot = false;
				local summonRandomPet = false;
				-- kshot:randomSay() staat in CombatLogEventHandler
				-- kshot:randomEmote() staat in CombatLogEventHandler
				
				-- kill ====================================================================
					-- addon actions ========================
						local raw_kill_msg = kshot:getRandomKillMessage();
						local kill_msg = kshot:getKillMessage(raw_kill_msg, victim_data, useKillingstreak);
						
						
						if (ks['YourKillSounds'] == true) then
							kshot:PlaySound(kshot:getKillSound(useKillingstreak)); -- sound
						end
						
						kshot:shareKill(useKillingstreak, raw_kill_msg, victim_data); -- share
						
						if (ks['YourKillMessages_Emote'] == true) then
							kshot:EmoteText(kill_msg); -- emote
						end
						
						kshot:yourKill("You " .. kill_msg); -- text
						if (killRecordImproved == true) then
							kshot:yourKillRecordbreak("You have set a new record!"); -- text
							
							if (ks['ScreenshotOnNewHighestStreak'] == true) then
								takeScreenshot = true;
							end
						end
						
						
						if (ks['ScreenshotOnKill'] == true) then
							takeScreenshot = true;
						end
						if (ks_char['summon_random_pet_on_kill'] == true) then
							summonRandomPet = true;
						end
					-- addon actions ========================
				-- kill ====================================================================
				
				-- multikill ===============================================================
					if (thismultikill == true) then
						-- addon actions ====================
							local multi_msg = kshot:getMultikillMessage(multistreak);
							
							
							if (ks['YourMultikillSounds'] == true) then
								kshot:PlaySound(kshot:getMultikillSound()); -- sound
							end
							
							kshot:shareMultikill(multistreak); -- share
							
							if (ks['YourMultikillMessages_Emote'] == true) then
								kshot:EmoteText(multi_msg); -- emote
							end
							
							kshot:yourMultikill("You " .. multi_msg); -- text
							if (multikillRecordImproved == true) then
								kshot:yourMultikillRecordbreak("You have set a new multikill-streak record!"); -- text
								
								if (ks['ScreenshotOnNewHighestMultiStreak'] == true) then
									takeScreenshot = true;
								end
							end
							
							
							if (ks['ScreenshotOnMultikill'] == true) then
								takeScreenshot = true;
							end
							if (ks_char['summon_random_pet_on_multikill'] == true) then
								summonRandomPet = true;
							end
						-- addon actions ====================
					end
				-- multikill ===============================================================
				
				if (takeScreenshot == true) then
					kshot:Screenshot();
				end
				if (summonRandomPet == true) then
					kshot:SummonRandomPet();
				end
			end
		end
		
		function kshot:PlayerDeath(killer_data) -- death
			-- killer_data = killername|NPC|Arena|BG
			local killer_array = split(killer_data, delimiter);
			local killer_is_npc = killer_array[2];
			local location = kshot:getLocation();
			
			kshot:ResetStreak();
			
			local msg = kshot:getDeathMessage(playername, killer_data);
			
			
			-- sound ==========
				local playSound = false;
				if (location == "world") then
					if (killer_is_npc == "false") then
						if (ks['YourDeathSounds_World_PvP'] == true) then
							playSound = true;
						end
					else
						if (ks['YourDeathSounds_World_PvE'] == true) then
							playSound = true;
						end
					end
				elseif (location == "pvp") then
					if (ks['YourDeathSounds_PvP'] == true) then
						playSound = true;
					end
				elseif (location == "pve") then
					if (ks['YourDeathSounds_PvE'] == true) then
						playSound = true;
					end
				end
				if (playSound == true) then
					kshot:PlaySound(kshot:getDeathSound()); -- sound
				end
			-- sound ==========
			
			kshot:shareDeath(killer_data); -- share
			
			kshot:yourDeath(msg, killer_is_npc); -- text
			
			
			if (ScreenshotOnDeath == true) then
				kshot:Screenshot();
			end
		end
	-- kill / multikill / death ==========================================================================================
-- main script ===========================================================================================================


-- reset funtions ========================================================================================================
	function kshot:ResetStreak()
		if ( (ks_char['killingstreak'] == nil) or (ks_char['enableStreakDataModifications'] == true) or (ks_char['enableStreakDataModifications'] == nil) ) then
			ks_char['killingstreak'] = 0;
		else
			killingstreakNotSaved = 0;
		end
		
		killingstreakPvE = 0;
		multistreak = 0;
	end
	
	function kshot:ResetStreakData()
		saved_char = currentSavedChar;
		
		
		kshot:ResetStreak();
		
		ks_char['maxmultistreak'] = 0;
		ks_char['totalmultistreak'] = 0;
		ks_char['maxkillingstreak'] = 0;
		ks_char['totalkillingblows'] = 0;
		ks_char['killingstreaktimes'] = 0;
		
		ks_char['executeSoundHealthProcent'] = 20;
		ks_char['enableStreakDataModifications'] = true;
		
		ks_char['summon_random_pet_on_kill'] = false;
		ks_char['summon_random_pet_on_multikill'] = false;
	end
	
	function kshot:ResetColors()
		ks['Color_Kill_CombatText'] = kshot:setArray(Color_Red);
		ks['Color_Kill_ChatText'] = kshot:setArray(Color_White);
		
		ks['Color_Multikill_CombatText'] = kshot:setArray(Color_Red);
		ks['Color_Multikill_ChatText'] = kshot:setArray(Color_White);
		
		ks['Color_Death_CombatText'] = kshot:setArray(Color_Red);
		ks['Color_Death_ChatText'] = kshot:setArray(Color_White);
	end
	
	function kshot:ResetAllSettings()
		saved = currentSaved;
		
		
		ks['volume'] = 3;
		ks['volume_type'] = "type2sfx";
		ks['soundpack'] = "sp1normal";
		ks['randomKillMessages'] = 1;
		ks['killMessages'] = kshot:setArray(defaultKillMessages);
		
		ks['emotes'] = kshot:setArray(defaultEmotes);
		
		ks['sound'] = true;
		ks['scrollingtext'] = true;
		ks['chattext'] = true;
		ks['emote'] = true;
		ks['solo'] = false;
		
		ks['PvP'] = true;
		ks['PvE'] = false;
		ks['PvE_Random'] = false;
		
		ks['ScreenshotOnKill'] = false;
		ks['ScreenshotOnMultikill'] = true;
		ks['ScreenshotOnDeath'] = false;
		ks['ScreenshotOnNewHighestStreak'] = true;
		ks['ScreenshotOnNewHighestMultiStreak'] = true;
		
		ks['ResetStreakOnLogin'] = false;
		ks['ResetStreakOnZoneChange'] = false;
		
		ks['ShowStreakOnLogin'] = true;
		ks['ShowStreakOnZoneChange'] = true;
		
		ks['sendwhat'] = "streak1";
		ks['StreakAnnounceGuild'] = true;
		ks['StreakAnnounceRaid'] = true;
		ks['StreakAnnounceBG'] = true;
		
		ks['SendToGuild'] = true;
		ks['SendToRaid'] = true;
		ks['SendToBG'] = true;
		ks['ReceiveFromGuild'] = true;
		ks['ReceiveFromRaid'] = true;
		ks['ReceiveFromBG'] = true;
		ks['SendDeathsToGuild'] = true;
		ks['SendDeathsToRaid'] = true;
		ks['SendDeathsToBG'] = true;
		ks['ReceiveDeathsFromGuild'] = true;
		ks['ReceiveDeathsFromRaid'] = true;
		ks['ReceiveDeathsFromBG'] = true;
		
		ks['CheckVersionGuild'] = true;
		ks['CheckVersionRaid'] = true;
		ks['CheckVersionBG'] = true;
		
		ks['YourKillMessages_Emote'] = true;
		ks['YourKillMessages_CombatText'] = true;
		ks['YourKillMessages_ChatText'] = true;
		ks['YourKillSounds'] = true;
		ks['OtherKillMessages_CombatText'] = true;
		ks['OtherKillMessages_ChatText'] = true;
		ks['OtherKillSounds'] = true;
		
		ks['YourMultikillMessages_Emote'] = true;
		ks['YourMultikillMessages_CombatText'] = true;
		ks['YourMultikillMessages_ChatText'] = true;
		ks['YourMultikillSounds'] = true;
		ks['OtherMultikillMessages_CombatText'] = true;
		ks['OtherMultikillMessages_ChatText'] = true;
		ks['OtherMultikillSounds'] = true;
		
		-- deaths =====
			ks['YourDeathMessages_World_PvP_CombatText'] = true;
			ks['YourDeathMessages_World_PvP_ChatText'] = true; 
			ks['YourDeathSounds_World_PvP'] = true;
			
			ks['OtherDeathMessages_World_PvP_CombatText'] = true;
			ks['OtherDeathMessages_World_PvP_ChatText'] = true;
			ks['OtherDeathSounds_World_PvP'] = true;
			
			ks['YourDeathMessages_World_PvE_CombatText'] = true;
			ks['YourDeathMessages_World_PvE_ChatText'] = true;
			ks['YourDeathSounds_World_PvE'] = true;
			
			ks['OtherDeathMessages_World_PvE_CombatText'] = true;
			ks['OtherDeathMessages_World_PvE_ChatText'] = true;
			ks['OtherDeathSounds_World_PvE'] = true;
			
			ks['YourDeathMessages_PvP_CombatText'] = true;
			ks['YourDeathMessages_PvP_ChatText'] = true;
			ks['YourDeathSounds_PvP'] = true;
			
			ks['OtherDeathMessages_PvP_CombatText'] = true;
			ks['OtherDeathMessages_PvP_ChatText'] = true;
			ks['OtherDeathSounds_PvP'] = true;
			
			ks['YourDeathMessages_PvE_CombatText'] = true;
			ks['YourDeathMessages_PvE_ChatText'] = true;
			ks['YourDeathSounds_PvE'] = true;
			
			ks['OtherDeathMessages_PvE_CombatText'] = true;
			ks['OtherDeathMessages_PvE_ChatText'] = true;
			ks['OtherDeathSounds_PvE'] = true;
		-- deaths =====
		
		kshot:ResetColors();
		
		ks['executeSoundNPC'] = true;
		ks['executeSoundPlayer'] = true;
		
		ks['multikillSound'] = "";
		ks['executeSound'] = "";
		ks['deathSound'] = "";
		
		ks['Debug_SendData'] = false;
		ks['Debug_ReceivedData_Others'] = false;
		ks['Debug_ReceivedData_You'] = false;
		ks['Debug_ReceivedAllData'] = false;
		
		ks['out_of_date_messages_enabled'] = true;
		ks['time_between_out_of_date_receives'] = 10;
		ks['out_of_date_chatlines'] = 3;
		ks['download_killshot_sounds_messages_enabled'] = true;
		ks['time_between_download_killshot_sounds'] = 3;
		ks['download_killshot_sounds_chatlines'] = 3;
		ks['var_was_nil_error_enabled'] = false;
		
		ks['say_list'] = kshot:setArray(defaultSayList);
		ks['say_chance'] = 100;
	end
	
	function kshot:ResetAllSettingsAndData()
		kshot:ResetAllSettings();
		kshot:ResetStreakData();
	end
-- reset functions ========================================================================================================