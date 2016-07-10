local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs", "zhTW")
if not L then return end

-- These localization strings are translated on WoWAce: http://www.wowace.com/addons/big-wigs/localization/
L["about"] = "關於"
L["activeBossModules"] = "啟動首領模組："
L["advanced"] = "進階選項"
L["allRightsReserved"] = "保留所有權利"
L["alphaOutdated"] = "Big Wigs α 測試版已過期。（/bwv）。"
L["alphaRelease"] = "你所使用的 Big Wigs %s 為“α測試版”（修訂號%d）"
L["already_registered"] = "|cffff0000警告：|r |cff00ff00%s|r（|cffffff00%s|r）在 Big Wigs 中已經存在模組，但存在模組仍試圖重新註冊。可能由於更新失敗的原因，通常表示您有兩份模組拷貝在您插件的檔案夾中。建議刪除所有 Big Wigs 檔案夾並重新安裝。"
L["altpower"] = "顯示替代能量"
L["ALTPOWER"] = "顯示替代能量"
L["altpower_desc"] = "顯示替代能量視窗，顯示團隊成員的替代能量值。"
L["ALTPOWER_desc"] = "玩家在一些首領戰鬥中會使用替代能量機制。替代能量視窗讓玩家快速查看團隊中誰有最少或最多替代能量，對特定戰術或分配會有幫助。"
L["back"] = "<< 返回"
L["BAR"] = "計時條"
L["BAR_desc"] = "在適當時會為首領技能顯示計時條。如果你想隱藏此技能的計時條，停用此選項。"
L["berserk"] = "狂暴"
L["berserk_desc"] = "為首領狂暴顯示計時條及警報。"
L["best"] = "最快："
L["blizzRestrictionsConfig"] = "由於暴雪的限制，要打開選項配置需要離開戰鬥，或是在戰鬥之前。"
L["blizzRestrictionsZone"] = "由於暴雪的戰鬥限制需要等待戰鬥結束以完成載入。"
L["chatMessages"] = "聊天框體訊息"
L["chatMessagesDesc"] = "除了顯示設定，輸出所有 Big Wigs 訊息到預設聊天框體。"
L["colors"] = "顏色"
L["configure"] = "配置"
L["contact"] = "聯繫方式"
L["coreAddonDisabled"] = "當%s被停用時，Big Wigs 將無法正常運作。你可以在角色選單的插件面板中啟用它們。"
L["COUNTDOWN"] = "倒數"
L["COUNTDOWN_desc"] = "啟用後，倒數最後五秒會顯示聲音及文字。想像有人在你的畫面中央以巨大的數字倒數 \"5... 4... 3... 2... 1...\"。"
L["dbmFaker"] = "假裝我是使用 DBM"
L["dbmFakerDesc"] = "如果一個 DBM 使用者作版本檢查以確認哪些人用了 DBM 的時候，他們會看到你在名單之上。當你的公會強制要求使用DBM，這是很有用的。"
L["dbmUsers"] = "使用 DBM："
L["developers"] = "開發者"
L["DISPEL"] = "只對驅散和打斷"
L["DISPEL_desc"] = "如果你希望在你不能打斷或驅散的情況下仍然警報此技能，停用此選項。"
L["dispeller"] = "|cFFFF0000只警報驅散和打斷。|r"
L["EMPHASIZE"] = "強調"
L["EMPHASIZE_desc"] = "啟用後會強調所有與此技能相關的訊息，使它們更大和更容易看到。你可於選項\"訊息\"調整強調訊息的字型及大小。"
L["extremelyOutdated"] = "|cffff0000警告：|r 你的 Big Wigs 已經過期超過80個修訂版本了！！此版本可能有許多臭蟲（Bug）、功能缺失或完全不正確的計時器。“強烈”建議升級。"
L["finishedLoading"] = "戰鬥已經結束，Big Wigs現在完成載入。"
L["FLASH"] = "閃爍"
L["FLASH_desc"] = "有些技能可能比其他的更重要。如果你希望此技能施放時閃爍螢幕，啟用此選項。"
L["flashScreen"] = "螢幕閃爍"
L["flashScreenDesc"] = "某些技能極其重要到需要充分被重視。當這些能力對你造成影響時 Big Wigs 可以使螢幕閃爍。"
L["flex"] = "彈性"
L["healer"] = "|cFFFF0000只警報治療。|r"
L["HEALER"] = "只對治療"
L["HEALER_desc"] = "有些技能只對治療重要。如果想無視你的職業一律看到此技能警報，停用此選項。"
L["heroic"] = "英雄模式"
L["heroic10"] = "10人英雄"
L["heroic25"] = "25人英雄"
L["ICON"] = "標記"
L["ICON_desc"] = "Big Wigs 可以根據技能用圖示標記人物。這將使他們更容易被辨認。"
L["introduction"] = "歡迎使用 Big Wigs 戲弄各個首領。請繫好安全帶，吃吃花生並享受這次旅行。它不會吃了你的孩子，但會協助你的團隊與新的首領進行戰鬥就如同享受饕餮大餐一樣。"
L["ircChannel"] = "#bigwigs 頻道位於 irc.freenode.net"
L["kills"] = "擊殺："
L["lfr"] = "隨機團隊"
L["license"] = "許可"
L["listAbilities"] = "列出技能到團隊聊天"
L["ME_ONLY"] = "只對自身"
L["ME_ONLY_desc"] = "當啟用此選項時只有對你有影響的技能訊息才會被顯示。比如，“炸彈：玩家”將只會在你是炸彈時顯示。"
L["MESSAGE"] = "訊息"
L["MESSAGE_desc"] = "大多數首領技能會有一條或多條訊息被 Big Wigs 顯示在螢幕上。如停用此選項，若此技能有訊息也不會顯示。"
L["minimapIcon"] = "小地圖圖示"
L["minimapToggle"] = "打開或關閉小地圖圖示。"
L["missingAddOn"] = "請注意這個區域需要此 |cFF436EEE%s|r 計時器掛件才能顯示。"
L["modulesDisabled"] = "所有運行中的模組都已停用。"
L["modulesReset"] = "所有運行中的模組都已重置。"
L["mythic"] = "傳奇"
L["newReleaseAvailable"] = "有新的 Big Wigs 正式版可用。（/bwv）你可以訪問 curse.com，wowinterface.com，wowace.com 或使用 Curse 更新器來更新到新的正式版。"
L["noBossMod"] = "沒有首領模組："
L["norm10"] = "10人"
L["norm25"] = "25人"
L["normal"] = "普通模式"
L["officialRelease"] = "你所使用的 Big Wigs %s 為官方正式版（修訂號%d）"
L["offline"] = "離線"
L["oldVersionsInGroup"] = "在你隊伍裡使用舊版本或沒有使用 Big Wigs。你可以用 /bwv 獲得詳細內容。"
L["outOfDate"] = "過期："
L["PROXIMITY"] = "玩家雷達"
L["PROXIMITY_desc"] = "有些技能有時會要求團隊散開。玩家雷達為此技能獨立顯示一個視窗告訴你誰離你過近是並且是不安全的。"
L["PULSE"] = "脈衝"
L["PULSE_desc"] = "除了螢幕閃爍之外，也可以使特定技能的圖示隨之顯示在你的螢幕上，以提高注意力。"
L["raidIcons"] = "團隊標記"
L["raidIconsDesc"] = [=[團隊中有些首領模塊使用團隊標記來為某些中了特定技能的隊員打上標記。例如類似“炸彈”類或心靈控制的技能。如果你關閉此功能，你將不會給隊員打標記。

|cffff4411只有團隊領袖或被提升為助理時才可以這麼做！|r]=]
L["removeAddon"] = "請移除“|cFF436EEE%s|r”，其已被“|cFF436EEE%s|r”所替代。"
L["resetPositions"] = "重置位置"
L["SAY"] = "說"
L["SAY_desc"] = "對話泡泡容易被看見。Big Wigs 將以白頻訊息通知附近的人你中了什麼技能。"
L["selectEncounter"] = "選擇戰鬥"
L["severelyOutdated"] = "|cffff0000你的 Big Wigs 已經過期超過150个修訂版本了！！*強烈建議*你更新，以防止與其他玩家發生同步衝突的問題！|r"
L["slashDescBreak"] = "|cFFFED000/break:|r 發送休息時間到團隊。"
L["slashDescConfig"] = "|cFFFED000/bw:|r 開啟 Big Wigs 配置。"
L["slashDescLocalBar"] = "|cFFFED000/localbar:|r 創建一個只有自身可見的自訂計時條。"
L["slashDescPull"] = "|cFFFED000/pull:|r 發送拉怪倒數提示到團隊。"
L["slashDescRaidBar"] = "|cFFFED000/raidbar:|r 發送自訂計時條到團隊。"
L["slashDescRange"] = "|cFFFED000/range:|r 開啟範圍偵測。"
L["slashDescTitle"] = "|cFFFED000命令行：|r"
L["slashDescVersion"] = "|cFFFED000/bwv:|r 進行 Big Wigs 版本檢測。"
L["sound"] = "音效"
L["sourceCheckout"] = "你所使用的 Big Wigs %s 為從源直接檢出的。"
L["stages"] = "階段"
L["stages_desc"] = "對應首領的不同階段啟用相關功能，如玩家雷達、計時條等。"
L["statistics"] = "統計"
L["tank"] = "|cFFFF0000只警報坦克。|r"
L["TANK"] = "只對坦克"
L["TANK_desc"] = "有些技能只對坦克重要。如果想無視職業看到這些技能警報，停用此選項。"
L["tankhealer"] = "|cFFFF0000只警報坦克&治療。|r"
L["TANK_HEALER"] = "只對坦克和治療"
L["TANK_HEALER_desc"] = "有些技能只對坦克和治療重要。如果想無視職業看到這些技能警報，停用此選項。"
L["test"] = "測試"
L["testBarsBtn"] = "創建測試計時條"
L["testBarsBtn_desc"] = "創建一個測試計時條以測試當前顯示設定。"
L["thanks"] = "感謝他們在各個領域的開發與幫助"
L["toggleAnchorsBtn"] = "切換錨點"
L["toggleAnchorsBtn_desc"] = "切換顯示或隱藏全部錨點。"
L["tooltipHint"] = [=[|cffeda55f點擊|r圖示重置所有運作中的模組。
|cffeda55fAlt-點擊|r可以禁用所有首領模組。
|cffeda55f右擊|r打開選項。]=]
L["upToDate"] = "已更新："
L["VOICE"] = "語音"
L["VOICE_desc"] = "如果安裝了語音插件，此選項可以開啟並播放警報音效文件。"
L["warmup"] = "預備"
L["warmup_desc"] = "首領戰鬥之前的預備時間。"
L["website"] = "網站"
L["wipes"] = "團滅："
L["zoneMessages"] = "顯示區域訊息"
L["zoneMessagesDesc"] = "此選項於進入區域時提示可安裝的 Big Wigs 模組。建議啟用此選項，因為當我們為一個新區域建立 Big Wigs 模組，這將會是唯一的提示安裝訊息。"

