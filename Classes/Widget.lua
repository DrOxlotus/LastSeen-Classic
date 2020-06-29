-- Namespace Variables
local addon, addonTbl = ...;

-- Module-Local Variables
local dropDownButtons = UIDropDownMenu_CreateInfo();
local L = addonTbl.L;

local function DropDownMenu_OnClick(self)
	UIDropDownMenu_SetSelectedValue(dropDownButtons.parent, self.value);
end
-- Synopsis: Changes the value of the mode dropdown to whatever the player selects.
--[[
	self: 			The button object within the dropdown menu
]]

addonTbl.CreateWidget = function(type, name, text, frameName, point, parent, relativePos, xOffset, yOffset)
	if type == "Button" then
		frameName[name] = CreateFrame("CheckButton", name, parent, "UICheckButtonTemplate");
		frameName[name]:SetPoint(point, parent, relativePos, xOffset, yOffset);
		frameName[name].text:SetText(text);
	elseif type == "DropDownMenu" then
		frameName[name] = CreateFrame("Frame", name, parent, "UIDropDownMenuTemplate");
		frameName[name]:SetPoint(point, parent, relativePos, xOffset, yOffset);
		frameName[name]:SetSize(175, 30);
		frameName[name].initialize = function(name, level)
			local selectedValue = UIDropDownMenu_GetSelectedValue(name);
			
			dropDownButtons.parent = name;
			-- Debug
			dropDownButtons.text = BINDING_HEADER_DEBUG;
			dropDownButtons.func = DropDownMenu_OnClick;
			dropDownButtons.value = BINDING_HEADER_DEBUG;
			if dropDownButtons.value == selectedValue then
				dropDownButtons.checked = true;
			else
				dropDownButtons.checked = nil;
			end
			UIDropDownMenu_AddButton(dropDownButtons);
			
			-- Normal
			dropDownButtons.text = PLAYER_DIFFICULTY1;
			dropDownButtons.func = DropDownMenu_OnClick;
			dropDownButtons.value = PLAYER_DIFFICULTY1;
			if dropDownButtons.value == selectedValue then
				dropDownButtons.checked = true;
			else
				dropDownButtons.checked = nil;
			end
			UIDropDownMenu_AddButton(dropDownButtons);
			
			-- N/A
			dropDownButtons.text = GM_SURVEY_NOT_APPLICABLE;
			dropDownButtons.func = DropDownMenu_OnClick;
			dropDownButtons.value = GM_SURVEY_NOT_APPLICABLE;
			if dropDownButtons.value == selectedValue then
				dropDownButtons.checked = true;
			else
				dropDownButtons.checked = nil;
			end
			UIDropDownMenu_AddButton(dropDownButtons);
			
		end
	elseif type == "FontString" then
		frameName[name] = frameName:CreateFontString(nil, "OVERLAY");
		frameName[name]:SetFontObject("GameFontHighlight");
		frameName[name]:SetPoint(point, parent, relativePos, xOffset, yOffset);
		frameName[name]:SetText(text);
	end
end
-- Synopsis: Creates a widget.
--[[
	name: 			Widget's name
	type: 			Widget's type (see below for supported widget types)
	text:			The text, if necessary, to use
	frameName: 		Name of the frame the widget will be added to after its creation
	point:			The position on the screen the frame should be placed. Left, Center, etc.
	parent:			The parent frame's name
	relativePos:	The position, relative to the parent, that the frame should be placed
	xOffset:		From the final position, how many pixels left or right to offset the frame
	yOffset:		From the final position, how many pixels up or down to offset the frame
	height:			The height of the widget (optional arg)
	width:			The height of the widget (optional arg)
	
	Supported Widgets:
	- Button
	- DropDownMenu
	- FontString
]]

addonTbl.UpdateWidget = function(name, frameName, text)
	frameName[name]:SetText(text);
end
-- Synopsis: Updates a widget's text.
--[[
	name: 			Widget's name
	frameName		Name of the frame that the widget sits on
	text:			The text, if necessary, to use
]]