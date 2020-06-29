-- Namespace Variables
local addon, addonTbl = ...;

-- Module-Local Variables
local frame;
local isFrameVisible;
local L = addonTbl.L;

local function ShowTooltip(self, text)
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
	GameTooltip:SetText(text);
	GameTooltip:Show();
end
-- Displays a custom tooltip.
--[[
	self:			This is the instance of the GameTooltip object
	text:			Text to display when the tooltip is shown
]]

local function HideTooltip(self)
	if GameTooltip:GetOwner() == self then
		GameTooltip:Hide();
	end
end
-- Synopsis: Hides a custom tooltip.
--[[
	self:			This is the instance of the GameTooltip object
]]

local function PlaySound(soundKit)
	PlaySound(soundKit);
end
-- Synopsis: Plays the provided soundkit.
--[[
	soundKit:		Name of the soundkit to play (https://github.com/Gethe/wow-ui-source/blob/live/SharedXML/SoundKitConstants.lua)
]]

local function Hide(frame)
	isFrameVisible = false;
	frame:Hide();
end
-- Synopsis: Hides the provided frame from the screen.
--[[
	frame:			Name of the frame to hide
]]

local function Show(frame)
	if isFrameVisible then
		Hide(frame);
	else
		isFrameVisible = true;
		
		-- WIDGETS
		if not frame["title"] then -- If title doesn't exist, then it's likely that none of the other widgets exist.
			addonTbl.CreateWidget("FontString", "title", L["RELEASE"] .. L["ADDON_NAME_SETTINGS"], frame, "CENTER", frame.TitleBg, "CENTER", 5, 0);
			addonTbl.CreateWidget("FontString", "itemCounter", addonTbl.GetCount(LastSeenClassicItemsDB), frame, "CENTER", frame, "CENTER", 0, -10);
			addonTbl.CreateWidget("Button", "showSourcesCheckButton", L["SHOW_SOURCES"], frame, "CENTER", frame, "CENTER", -60, -35);
			addonTbl.CreateWidget("DropDownMenu", "modeDropDownMenu", "", frame, "CENTER", frame, "CENTER", 0, 15);
		elseif frame["itemCounter"] then -- If the widgets were already created, we don't want to recreate the itemCounter widget, but update it.
			addonTbl.UpdateWidget("itemCounter", frame, addonTbl.GetCount(LastSeenClassicItemsDB));
		end
		
		if frame then
			frame:SetMovable(true);
			frame:EnableMouse(true);
			frame:RegisterForDrag("LeftButton");
			frame:SetScript("OnDragStart", frame.StartMoving);
			frame:SetScript("OnDragStop", frame.StopMovingOrSizing);
			frame:ClearAllPoints();
			frame:SetPoint("CENTER", WorldFrame, "CENTER");
		end
		
		-- FRAME BEHAVIORS
			-- Settings Frame X Button
		frame.CloseButton:SetScript("OnClick", function(self) Hide(frame) end); -- When the player selects the X on the frame, hide it. Same behavior as typing the command consecutively.
			-- Mode DropDown Menu
		frame.modeDropDownMenu:SetScript("OnEnter", function(self) ShowTooltip(self, L["MODE_DESCRIPTIONS"]) end); -- When the player hovers over the dropdown menu, display a custom tooltip.
		frame.modeDropDownMenu:SetScript("OnLeave", function(self) HideTooltip(self) end); -- When the player is no longer hovering, hide the tooltip.
		if LastSeenClassicSettingsCacheDB["mode"] then
			UIDropDownMenu_SetText(modeDropDownMenu, LastSeenClassicSettingsCacheDB["mode"]);
		end
			-- Show Sources Check Button
		if LastSeenClassicSettingsCacheDB["showSources"] then
			frame.showSourcesCheckButton:SetChecked(true);
			addonTbl.showSources = true;
		else
			frame.showSourcesCheckButton:SetChecked(false);
			addonTbl.showSources = false;
		end
		frame.showSourcesCheckButton:SetScript("OnClick", function(self, event, arg1)
			if self:GetChecked() then
				addonTbl.showSources = true;
				LastSeenClassicSettingsCacheDB.showSources = true;
			else
				addonTbl.showSources = false;
				LastSeenClassicSettingsCacheDB.showSources = false;
			end
		end);
		frame.showSourcesCheckButton:SetScript("OnEnter", function(self) ShowTooltip(self, L["SHOW_SOURCES_DESC"]) end); -- When the player hovers over the show sources check button, display a custom tooltip.
		frame.showSourcesCheckButton:SetScript("OnLeave", function(self) HideTooltip(self) end); -- When the player is no longer hovering, hide the tooltip.
		
		frame:Show();
	end
end
-- Synopsis: Displays the provided frame on screen.
--[[
	frame:			Name of the frame to display
]]

addonTbl.CreateFrame = function(name, height, width)
	-- If the frame is already created, then call the Show function instead.
	if not frame then
		frame = CreateFrame("Frame", name, UIParent, "BasicFrameTemplateWithInset");
		frame:SetSize(height, width);
		Show(frame);
	else
		Show(frame);
	end
end
-- Synopsis: Responsible for building a frame.
--[[
	name:			Name of the frame
	height:			The height, in pixels, of the frame
	width:			The width or length, in pixels, of the frame
]]