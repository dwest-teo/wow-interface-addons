if not(GetLocale() == "koKR") then
    return;
end

local L = WeakAuras.L

-- Options translation
L["1 Match"] = "1개 일치"
L["Actions"] = "동작"
L["Activate when the given aura(s) |cFFFF0000can't|r be found"] = "주어진 오라가 |cFFFF0000없을 때|r 활성화"
L["Add a new display"] = "새 디스플레이 추가"
L["Add Dynamic Text"] = "유동적 텍스트 추가"
L["Addon"] = "애드온"
L["Addons"] = "애드온"
L["Add to group %s"] = "%s 그룹에 추가"
L["Add to new Dynamic Group"] = "새 유동적 그룹에 추가"
L["Add to new Group"] = "새 그룹에 추가"
L["Add Trigger"] = "활성 조건 추가"
L["A group that dynamically controls the positioning of its children"] = "포함된 개체들의 배열을 유동적으로 조절하는 그룹"
L["Align"] = "정렬"
L["Allow Full Rotation"] = "전체 회전 허용"
L["Alpha"] = "투명도"
L["Anchor"] = "기준"
L["Anchor Point"] = "기준점"
L["Angle"] = "각도"
L["Animate"] = "애니메이션"
L["Animated Expand and Collapse"] = "확장 / 접기 애니메이션"
L["Animation relative duration description"] = [=[
애니메이션의 지속시간은 디스플레이의 지속시간에 상대적입니다, 분수 (1/2), 백분율 (50%), 또는 소수 (0.5)로 표현합니다.
|cFFFF0000참고:|r 디스플레이가 진행 시간이 없으면 (비-지속적 이벤트 활성 조건, 지속시간이 없는 오라, 등등), 애니메이션은 재생되지 않습니다.

|cFF4444FF예제:|r
애니메이션의 지속시간을 |cFF00CC0010%|r로 설정하고, 디스플레이의 활성 조건이 20초 지속 버프일 때, 시작 애니메이션은 2초 동안 재생됩니다.
애니메이션의 지속시간을 |cFF00CC0010%|r로 설정하고, 디스플레이의 활성 조건이 지속시간이 없는 버프일 때, 시작 애니메이션은 재생되지 않습니다 (지속시간을 따로 설정했더라도)."
]=]
L["Animations"] = "애니메이션"
L["Animation Sequence"] = "애니메이션 순서"
L["Aquatic"] = "바다표범"
L["Aura (Paladin)"] = "오라"
L["Aura(s)"] = "오라"
L["Auto"] = "자동"
L["Auto-cloning enabled"] = "자동 복제 활성화"
L["Automatic Icon"] = "자동 아이콘"
L["Backdrop Color"] = "배경 색상"
L["Backdrop Style"] = "배경 스타일"
L["Background"] = "배경"
L["Background Color"] = "배경 색상"
L["Background Inset"] = "배경 축소"
L["Background Offset"] = "배경 위치"
L["Background Texture"] = "배경 무늬"
L["Bar Alpha"] = "바 투명도"
L["Bar Color"] = "바 색상"
L["Bar Color Settings"] = "바 색상 설정"
L["Bar in Front"] = "바를 테두리 앞으로"
L["Bar Texture"] = "바 무늬"
L["Battle"] = "전투"
L["Bear"] = "곰"
L["Berserker"] = "광폭"
L["Blend Mode"] = "혼합 모드"
L["Blood"] = "혈기"
L["Border"] = "테두리"
L["Border Color"] = "테두리 색상"
L["Border Inset"] = "테두리 삽입"
L["Border Offset"] = "테두리 위치"
L["Border Settings"] = "테두리 설정"
L["Border Size"] = "테두리 크기"
L["Border Style"] = "테두리 모양"
L["Bottom Text"] = "아래쪽 텍스트"
L["Button Glow"] = "버튼 반짝임"
L["Can be a name or a UID (e.g., party1). Only works on friendly players in your group."] = "이름이나 유닛ID (예. party1) 가능. 그룹에 있는 아군 플레이어만 작동합니다."
L["Cancel"] = "취소"
L["Cat"] = "표범"
L["Change the name of this display"] = "이 디스플레이의 이름 변경"
L["Channel Number"] = "채널 번호"
L["Check On..."] = "확인..."
L["Choose"] = "선택"
L["Choose Trigger"] = "활성 조건 선택"
L["Choose whether the displayed icon is automatic or defined manually"] = "아이콘을 자동으로 표시할 지 또는 수동 지정할 지 선택하세요"
L["Clone option enabled dialog"] = [=[
|cFFFF0000자동복제|r 옵션을 활성화 했습니다.

|cFFFF0000자동복제|r는 디스플레이를 자동으로 복사하여 여러 정보를 표시하게 합니다.
이 디스플레이를 |cFF22AA22유동적 그룹|r에 넣을 때까지, 복제된 모든 디스플레이가 표시됩니다.

이 디스플레이를 새로운 |cFF22AA22유동적 그룹|r으로 옮길까요?]=]
L["Close"] = "닫기"
L["Collapse"] = "접기"
L["Collapse all loaded displays"] = "불러온 모든 디스플레이 접기"
L["Collapse all non-loaded displays"] = "불러오지 않은 모든 디스플레이 접기"
L["Color"] = "색상"
L["Compress"] = "누르기"
L["Concentration"] = "집중"
L["Constant Factor"] = "고정 요소"
L["Control-click to select multiple displays"] = "Control-클릭 - 여러 디스플레이 선택"
L["Controls the positioning and configuration of multiple displays at the same time"] = "동시에 여러 디스플레이의 위치와 설정을 조절합니다"
L["Convert to..."] = "...로 변환하기"
L["Cooldown"] = "재사용 대기시간"
L["Copy"] = "복사"
L["Copy settings from..."] = "...로 부터 설정 복사"
L["Copy settings from another display"] = "다른 디스플레이에서 설정 복사"
L["Copy settings from %s"] = "%s에서 설정 복사"
L["Count"] = "횟수"
L["Creating buttons: "] = "버튼 생성:"
L["Creating options: "] = "옵션 생성:"
L["Crop X"] = "X 자르기"
L["Crop Y"] = "Y 자르기"
L["Crusader"] = "성전사"
L["Custom Code"] = "사용자 설정 코드"
L["Custom Trigger"] = "사용자 설정 활성 조건"
L["Custom trigger event tooltip"] = [=[
사용자 설정 활성 조건을 확인할 이벤트를 선택하세요.
콤마와 공백을 사용해 여러 이벤트를 선택할 수 있습니다.

|cFF4444FF예제:|r
UNIT_POWER, UNIT_AURA PLAYER_TARGET_CHANGED]=]
L["Custom trigger status tooltip"] = [=[
사용자 설정 활성 조건을 확인할 이벤트를 선택하세요.
상태 형식 조건이면 특정 이벤트는 독립 변수없이 WeakAuras에 의해 불러와집니다.
콤마와 공백을 사용해 여러 이벤트를 선택할 수 있습니다.

|cFF4444FF예제:|r
UNIT_POWER, UNIT_AURA PLAYER_TARGET_CHANGED]=]
L["Custom Untrigger"] = "사용자 설정 비활성 조건"
L["Custom untrigger event tooltip"] = [=[
사용자 설정 비활성 조건을 확인할 이벤트를 선택하세요.
활성 조건과 다른 이벤트도 상관 없습니다.
콤마와 공백을 사용해 여러 이벤트를 선택할 수 있습니다.

|cFF4444FF예제:|r
UNIT_POWER, UNIT_AURA PLAYER_TARGET_CHANGED]=]
L["Death"] = "죽음"
L["Death Rune"] = "죽음의 룬"
L["Debuff Type"] = "약화 효과 유형"
L["Defensive"] = "방어"
L["Delete"] = "삭제"
L["Delete all"] = "모두 삭제"
L["Delete children and group"] = "자식과 그룹 삭제"
L["Deletes this display - |cFF8080FFShift|r must be held down while clicking"] = "이 디스플레이 삭제 - |cFF8080FFShift|r키를 누르고 클릭해야 합니다"
L["Delete Trigger"] = "활성 조건 삭제"
L["Desaturate"] = "흑백"
L["Devotion"] = "헌신"
L["Disabled"] = "비활성화됨"
L["Discrete Rotation"] = "90도 단위 회전"
L["Display"] = "디스플레이"
L["Display Icon"] = "디스플레이 아이콘"
L["Display Text"] = "디스플레이 텍스트"
L["Distribute Horizontally"] = "가로로 퍼뜨리기"
L["Distribute Vertically"] = "세로로 퍼뜨리기"
L["Do not copy any settings"] = "설정을 복사하지 않음"
L["Do not group this display"] = "이 디스플레이 그룹화하지 않음"
L["-- Do not remove this comment, it is part of this trigger: "] = "-- 이 주석을 삭제하지 마세요, 다음 디스플레이의 조건 코드입니다: "
L["Duplicate"] = "복사"
L["Duration Info"] = "지속시간 정보"
L["Duration (s)"] = "지속시간 (초)"
L["Dynamic Group"] = "유동적 그룹"
L["Dynamic text tooltip"] = [=[
이 텍스트를 유동적으로 만들 수 있는 특별 코드들입니다:

|cFFFF0000%p|r - 진행 - 타이머의 남은 시간, 또는 비-타이머 값
|cFFFF0000%t|r - 전체 - 타이머의 최대 지속시간, 또는 최대 비-타이머 값
|cFFFF0000%n|r - 이름 - 디스플레이의 이름 (보통 오라 이름), 또는 유동적 이름이 없을 때 디스플레이의 ID
|cFFFF0000%i|r - 아이콘 - 디스플레이와 연관된 아이콘
|cFFFF0000%s|r - 중첩 - 오라의 중첩 횟수 (보통)
|cFFFF0000%c|r - 사용자 설정 - 표시할 string 값을 반환하는 사용자 설정 Lua 함수 정의를 허용합니다]=]
L["Enabled"] = "활성화됨"
L["End Angle"] = "종료 각도"
L["Enter an aura name, partial aura name, or spell id"] = "오라 이름 / 오라의 부분 이름 / 주문ID를 입력하세요"
L["Event Type"] = "이벤트 유형"
L["Expand"] = "확장"
L["Expand all loaded displays"] = "불러온 모든 디스플레이 확장"
L["Expand all non-loaded displays"] = "불러오지 않은 모드 디스플레이 확장"
L["Expand Text Editor"] = "텍스트 편집창 확장"
L["Expansion is disabled because this group has no children"] = "이 그룹은 자식이 없기 떄문에 확장이 비활성화되었습니다"
L["Export"] = "내보내기"
L["Export to Lua table..."] = "Lua table로 내보내기"
L["Export to string..."] = "문자열로 내보내기"
L["Fade"] = "사라짐"
L["Finish"] = "종료"
L["Fire Resistance"] = "화염 저항"
L["Flight(Non-Feral)"] = "폭풍날개(비-야성)"
L["Font"] = "글꼴"
L["Font Flags"] = "글꼴 효과"
L["Font Size"] = "글꼴 크기"
L["Font Type"] = "글꼴 종류"
L["Foreground Color"] = "앞면 색상"
L["Foreground Texture"] = "앞면 무늬"
L["Form (Druid)"] = "변신"
L["Form (Priest)"] = "형상"
L["Form (Shaman)"] = "변신"
L["Form (Warlock)"] = "변신"
L["Frame"] = "프레임"
L["Frame Strata"] = "프레임 우선순위"
L["Frost"] = "냉기"
L["Frost Resistance"] = "냉기 저항"
L["Full Scan"] = "전체 스캔"
L["Ghost Wolf"] = "늑대 정령"
L["Glow Action"] = "반짝임 동작"
L["Group aura count description"] = [=[디스플레이 조건을 충족하기 위해 주어진 오라에 영향을 받는 한명 이상의 %s 멤버의 숫자.
정수를 입력하면 (예. 5), 영향을 받는 공격대원의 숫자를 입력된 숫자와 비교합니다.
소수 (예. 0.5), 분수 (예. 1/2), 또는 백분율 (예. 50%%)을 입력하면, %s중 일부가 영향을 받아야 합니다.

|cFF4444FF예제:|r
|cFF00CC00> 0|r %s 중 아무나 영향 받을 때 발생
|cFF00CC00= 100%%|r %s 중 모두가 영향 받을 때 발생
|cFF00CC00!= 2|r 영향 받는 %s 멤버의 숫자가 2가 아닐 때 발생
|cFF00CC00<= 0.8|r %s 중 80%% 이하가 영향 받을 때 발생 (5명 파티원중 4명, 10명 공격대원 중 8명 또는 25명 공격대원중 20명)
|cFF00CC00> 1/2|r %s의 절반 이상이 영향 받을 때 발생
|cFF00CC00>= 0|r 상관없이, 항상 발생
]=]
L["Group Member Count"] = "그룹원 수"
L["Group (verb)"] = "그룹화하기"
L["Height"] = "높이"
L["Hide On"] = "숨기기 옵션"
L["Hide this group's children"] = "이 그룹의 자식 숨기기"
L["Hide When Not In Group"] = "파티중이 아닐 때 숨기기"
L["Horizontal Align"] = "가로 정렬"
L["Icon Color"] = "아이콘 색상"
L["Icon Info"] = "아이콘 정보"
L["Icon Inset"] = "아이템 축소"
L["Ignored"] = "무시됨"
L["Ignore GCD"] = "GCD 무시"
L["%i Matches"] = "%i개 일치"
L["Import"] = "가져오기"
L["Import a display from an encoded string"] = "암호화된 문자열에서 디스플레이 가져오기"
L["Justify"] = "정렬"
L["Left Text"] = "왼쪽 텍스트"
L["Load"] = "불러오기"
L["Loaded"] = "불러옴"
L["Main"] = "메인"
L["Main Trigger"] = "메인 활성 조건"
L["Mana (%)"] = "마나 (%)"
L["Manage displays defined by Addons"] = "애드온에 의해 정의된 디스플레이 관리"
L["Message Prefix"] = "메시지 접두사"
L["Message Suffix"] = "메시지 접미사"
L["Metamorphosis"] = "탈태"
L["Mirror"] = "뒤집기"
L["Model"] = "모델"
L["Moonkin/Tree/Flight(Feral)"] = "달빛야수/생명의 나무/폭풍날개(야성)"
L["Move Down"] = "아래로 이동"
L["Move this display down in its group's order"] = "그룹에서 이 디스플레이의 순서를 밑으로 내립니다"
L["Move this display up in its group's order"] = "그룹에서 이 디스플레이의 순서를 위로 올립니다"
L["Move Up"] = "위로 이동"
L["Multiple Displays"] = "다중 디스플레이"
L["Multiple Triggers"] = "다중 활성 조건"
L["Multiselect ignored tooltip"] = [=[
|cFFFF0000무시|r - |cFF777777단일|r - |cFF777777다중|r
디스플레이를 불러오는 데 영향을 주지 않습니다]=]
L["Multiselect multiple tooltip"] = [=[
|cFF777777무시|r - |cFF777777단일|r - |cFF00FF00다중|r
선택한 것중 하나라도 일치할 때 불러옵니다]=]
L["Multiselect single tooltip"] = [=[
|cFF777777무시|r - |cFF00FF00단일|r - |cFF777777다중|r
선택한 한가지만 일치할 때 불러옴]=]
L["Must be spelled correctly!"] = "철자가 정확해야 합니다!"
L["Name Info"] = "이름 정보"
L["Negator"] = "Not" -- Needs review
L["New"] = "새로 만들기"
L["Next"] = "다음"
L["No"] = "아니오"
L["No Children"] = "자식 없음"
L["Not all children have the same value for this option"] = "모든 자식의 이 옵션 값이 같지 않습니다"
L["Not Loaded"] = "불러오지 않음"
L["No tooltip text"] = "툴팁 텍스트 없음"
L["% of Progress"] = "% 진행"
L["Okay"] = "확인"
L["On Hide"] = "숨겨질 때"
L["Only match auras cast by people other than the player"] = "플레이어가 아닌 다른 사람이 시전한 오라와 일치할때만"
L["Only match auras cast by the player"] = "플레이어가 시전한 오라와 일치할때만"
L["On Show"] = "표시될 때"
L["Operator"] = "연산자"
L["or"] = "혹은"
L["Orientation"] = "방향"
L["Other"] = "기타"
L["Outline"] = "외곽선"
L["Own Only"] = "내 것만"
L["Player Character"] = "플레이어 캐릭터"
L["Play Sound"] = "소리 재생"
L["Portrait Zoom"] = "초상화 확대"
L["Presence (DK)"] = "형상"
L["Presence (Rogue)"] = "상태"
L["Prevents duration information from decreasing when an aura refreshes. May cause problems if used with multiple auras with different durations."] = "오라가 갱신 됐을 때 지속시간이 감소 하지 않게 합니다. 다른 지속시간을 가진 여러 오라를 사용할 때 문제가 발생할 수 있습니다."
L["Primary"] = "주"
L["Progress Bar"] = "진행 바"
L["Progress Texture"] = "진행 무늬"
L["Put this display in a group"] = "이 디스플레이를 그룹에 포함시키기"
L["Ready For Use"] = "사용 가능"
L["Re-center X"] = "내부 X 좌표"
L["Re-center Y"] = "내부 Y 좌표"
L["Remaining Time Precision"] = "남은 시간 정확도"
L["Remove this display from its group"] = "그룹에서 이 디스플레이 삭제"
L["Rename"] = "이름 변경"
L["Requesting display information"] = "디스플레이 정보 요청중"
L["Required For Activation"] = "활성화 필요"
L["Retribution"] = "징벌"
L["Right-click for more options"] = "RightClick - 추가 옵션"
L["Right Text"] = "오른쪽 텍스트"
L["Rotate"] = "회전"
L["Rotate In"] = "시계방향 회전"
L["Rotate Out"] = "반시계방향 회전"
L["Rotate Text"] = "텍스트 회전"
L["Rotation"] = "회전"
L["Rotation Mode"] = "회전 모드"
L["Same"] = "동일한"
L["Search"] = "검색"
L["Secondary"] = "부"
L["Select the auras you always want to be listed first"] = "목록에서 첫번째로 보여질 오라를 선택하세요"
L["Send To"] = "보내기..."
L["Set tooltip description"] = "툴팁 설명 설정"
L["Shadow Dance"] = "어둠의 춤"
L["Shadowform"] = "어둠의 형상"
L["Shadow Resistance"] = "암흑 저항"
L["Shift-click to create chat link"] = "Shift-클릭 - |cFF8800FF[채팅 링크] 생성"
L["Show all matches (Auto-clone)"] = "모든 일치 표시 (자동복제)"
L["Show players that are |cFFFF0000not affected"] = "|cFFFF0000영향받지 않은|r 플레이어 표시"
L["Shows a 3D model from the game files"] = "게임 데이터의 3D 모델 보이기"
L["Shows a custom texture"] = "사용자 설정 무늬 표시"
L["Shows a progress bar with name, timer, and icon"] = "이름 / 타이머 / 아이콘의 진행 바 보이기"
L["Shows a spell icon with an optional a cooldown overlay"] = "재사용 대기시간 오버레이를 표시할 수 있는 주문 아이콘 표시"
L["Shows a texture that changes based on duration"] = "지속시간에 따라 변화하는 무늬 보이기"
L["Shows one or more lines of text, which can include dynamic information such as progress or stacks"] = "여러 줄의 문자를 표시합니다, 진행 시간 또는 중첩과 같은 여러 정보를 포함할 수 있습니다"
L["Shows the remaining or expended time for an aura or timed event"] = "오라 또는 지속 이벤트의 남은 시간 또는 진행 시간을 표시합니다"
L["Show this group's children"] = "이 그룹의 자식 보이기"
L["Size"] = "크기"
L["Slide"] = "슬라이드"
L["Slide In"] = "안으로 슬라이드"
L["Slide Out"] = "바깥으로 슬라이드"
L["Sort"] = "정렬"
L["Sound"] = "소리"
L["Sound Channel"] = "소리 채널"
L["Sound File Path"] = "소리 파일 경로"
L["Sound Kit ID"] = "Sound Kit ID"
L["Space"] = "공간"
L["Space Horizontally"] = "수평 공간"
L["Space Vertically"] = "수직 공간"
L["Spell ID"] = "주문 ID"
L["Spell ID dialog"] = [=[|cFFFF0000주문 ID|r로 오라를 선택했습니다.

기본적으로, |cFF8800FFWeakAuras|r는 이름이 같지만 |cFFFF0000주문 ID|r가 다른 오라를 구별할 수 없습니다.
하지만, 전체 스캔 옵션을 사용하면, |cFF8800FFWeakAuras|r는 특정 |cFFFF0000주문 ID|r를 검색할 수 있습니다.

이 |cFFFF0000주문 ID|r로 구별하기 위해 전체 스캔 옵션을 사용할까요?]=]
L["Stack Count"] = "중첩 횟수"
L["Stack Count Position"] = "중첩 횟수 위치"
L["Stack Info"] = "중첩 정보"
L["Stacks Settings"] = "중첩 설정"
L["Stagger"] = "계단식 배치"
L["Stance (Warrior)"] = "태세"
L["Start"] = "시작"
L["Start Angle"] = "시작 각도"
L["Stealable"] = "훔치기 가능"
L["Stealthed"] = "은신 중"
L["Sticky Duration"] = "지속시간 고정"
L["Temporary Group"] = "임시 그룹"
L["Text"] = "텍스트"
L["Text Color"] = "텍스트 색상"
L["Text Position"] = "텍스트 위치"
L["Text Settings"] = "텍스트 설정"
L["Texture"] = "무늬"
L["Texture Info"] = "무늬 정보"
L["The children of this group have different display types, so their display options cannot be set as a group."] = "이 그룹의 자식들은 다른 디스플레이 형식을 가지고 있어서, 디스플레이 옵션을 그룹으로 설정할 수 없습니다."
L["The duration of the animation in seconds."] = "애니메이션 지속시간 (초)"
L["The type of trigger"] = "활성 조건의 유형"
L["This condition will not be tested"] = "이 상태는 테스트되지 않음"
L["This display is currently loaded"] = "이 디스플레이는 현재 불러왔습니다"
L["This display is not currently loaded"] = "이 디스플레이는 현재 불러오지 않았습니다"
L["This display will only show when |cFF00FF00%s"] = "이 디스플레이는 |cFF00FF00%s|r일 때만 표시됩니다"
L["This display will only show when |cFFFF0000 Not %s"] = "이 디스플레이는 |cFFFF0000%s|r|1이;가; 아닐 때만 표시됩니다"
L["This region of type \"%s\" has no configuration options."] = "\"%s\" 형식은 설정 옵션이 없습니다."
L["Time in"] = "시간 단위"
L["Timer"] = "타이머"
L["Timer Settings"] = "타이머 설정"
L["Toggle the visibility of all loaded displays"] = "불러온 모든 디스플레이 표시 전환"
L["Toggle the visibility of all non-loaded displays"] = "불러오지 않은 모든 디스플레이 표시 토글"
L["Toggle the visibility of this display"] = "이 디스플레이 표시 전환"
L["to group's"] = "그룹 기준"
L["Tooltip"] = "툴팁"
L["Tooltip on Mouseover"] = "마우스오버 툴팁"
L["Top Text"] = "상단 텍스트"
L["to screen's"] = "화면 기준"
L["Total Time Precision"] = "전체 시간 정확도"
L["Tracking"] = "추적"
L["Travel"] = "날쌘 동물"
L["Trigger"] = "활성 조건"
L["Trigger %d"] = "%d 활성 조건"
L["Triggers"] = "활성 조건"
L["Type"] = "유형"
L["Ungroup"] = "그룹해제"
L["Unholy"] = "부정"
L["Unit Exists"] = "유닛 존재"
L["Unlike the start or finish animations, the main animation will loop over and over until the display is hidden."] = "시작 또는 종료 애니메이션과 달리 메인 애니메이션은 디스플레이가 숨겨질 때까지 계속 반복됩니다."
L["Unstealthed"] = "은신 안함"
L["Update Custom Text On..."] = "사용자 설정 문자 갱신 중..."
L["Use Full Scan (High CPU)"] = "전체 스캔 사용 (높은 CPU 사용률)"
L["Use tooltip \"size\" instead of stacks"] = "중첩 대신 툴팁 \"크기\" 사용"
L["Vertical Align"] = "수직 정렬"
L["View"] = "보기"
L["Width"] = "너비"
L["X Offset"] = "X 좌표"
L["X Scale"] = "가로 크기"
L["Yes"] = "네"
L["Y Offset"] = "Y 좌표"
L["Y Scale"] = "세로 크기"
L["Z Offset"] = "Z 좌표"
L["Zoom"] = "확대"
L["Zoom In"] = "확대"
L["Zoom Out"] = "축소"



