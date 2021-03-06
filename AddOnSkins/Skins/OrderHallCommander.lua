local AS = unpack(AddOnSkins)

if not AS:CheckAddOn('OrderHallCommander') then return end

function AS:OrderHallCommander(event)
	if event == "ADDON_LOADED" then
		if not OrderHallMissionFrameMissions then return end
		OrderHallMissionFrameMissions:HookScript('OnShow', function(self)
			AS:Delay(0.5, function()
				local frame = FollowerIcon:GetParent()
				if frame.IsSkinned then return end

				AS:StripTextures(frame)
				AS:SetTemplate(frame, "Transparent")
				frame:ClearAllPoints()
				frame:SetPoint("BOTTOM", OrderHallMissionFrame, "TOP", 0, 0)
				frame:SetWidth(OrderHallMissionFrame:GetWidth()+2)
				frame.IsSkinned = true

				frame = LibInitCheckbox00001:GetParent():GetParent()
				AS:StripTextures(frame)
				AS:SetTemplate(frame, 'Transparent')
				AS:SkinCloseButton(frame.Close)

				for i=1, 24 do
					if i < 10 then
						AS:SkinCheckBox(_G["LibInitCheckbox0000"..i])
					elseif i > 9 and i < 13 then
						AS:SkinSlideBar(_G["LibInitSlider000"..i])
					elseif i > 12 and i < 16 then
						AS:SkinCheckBox(_G["LibInitCheckbox000"..i])
					elseif i == 16 then
						AS:SkinDropDownBox(LibInitDropdown00016, 200)
					elseif i > 16 and i < 19 then
						AS:SkinCheckBox(_G["LibInitCheckbox000"..i])
					elseif i > 18 and i < 23 then
						AS:SkinButton(_G["LibInitButton000"..i])
					end
				end

				--frame = {OrderHallMissionFrame.MissionTab:GetChildren()}
				--AS:SkinNextPrevButton(frame[19], true)
				--frame[19]:Size(12, 12)

				--frame = {LibInitCheckbox00001:GetParent():GetParent():GetChildren()}
				--AS:SkinCloseButton(frame[1])
				--AS:StripTextures(frame[2])

				frame = {OrderHallMissionFrameMissions.CompleteDialog.BorderFrame.ViewButton:GetChildren()}
				AS:SkinButton(frame[1])
			end)
		end)
		AS:UnregisterSkinEvent('OrderHallCommander', event)
	elseif OHCGUIContainer1 and event == "GARRISON_MISSION_COMPLETE_RESPONSE" then
		if OHCGUIContainer1.IsSkinned then return end
		AS:UnregisterSkinEvent('OrderHallCommander', event)

		AS:Delay(0.1, function()
			AS:SkinFrame(OHCGUIContainer1)
			AS:SkinCloseButton(OHCGUIContainer1.Close)
		end)
	end
end

AS:RegisterSkin('OrderHallCommander', AS.OrderHallCommander, 'ADDON_LOADED', 'GARRISON_MISSION_COMPLETE_RESPONSE')
