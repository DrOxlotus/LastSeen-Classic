--[[
	NOTE: Synopses pertain to the code directly above them!
	© 2020 Oxlotus/Lightsky/Smallbuttons
]]

-- Namespace Variables
local addon, addonTbl = ...;

-- Module-Local Variables
local badDataItemCount = 0;
local container;
local currentDate;
local currentMap;
local delay = 0.3;
local epoch = 0;
local executeCodeBlock = true;
local frame = CreateFrame("Frame");
local isMerchantFrameOpen;
local isOnIsland;
local isPlayerInCombat;
local itemID;
local itemLink;
local itemName;
local itemRarity;
local itemSource;
local itemType;
local itemSubType;
local itemEquipLoc;
local itemIcon;
local L = addonTbl.L;
local playerName;
local plsEmptyVariables;

for _, event in ipairs(addonTbl.events) do
	frame:RegisterEvent(event);
end
-- Synopsis: Registers all events that the addon cares about using the events table in the corresponding table file.

local function IsPlayerInCombat()
	-- Maps can't be updated while the player is in combat.
	if UnitAffectingCombat(L["IS_PLAYER"]) then
		isPlayerInCombat = true;
	else
		isPlayerInCombat = false;
	end
end
--[[
	Synopsis: Checks to see if the player is in combat.
	Use Cases:
		- Maps can't be updated while the player is in combat.
]]

local function EmptyVariables()
	if plsEmptyVariables then
		C_Timer.After(0, function()
			C_Timer.After(1, function()
				addonTbl.encounterID = nil;
				addonTbl.itemSourceCreatureID = nil;
				addonTbl.questID = nil;
				addonTbl.target = "";
				container = "";
				executeCodeBlock = true;
				plsEmptyVariables = false;
			end);
		end);
	end
end
-- Synopsis: When executed, after 4 seconds, clear or reset the variables.

frame:SetScript("OnEvent", function(self, event, ...)

	if event == "CHAT_MSG_LOOT" then
		if LastSeenQuestsDB[addonTbl.questID] then return end;
		
		local text, name = ...; name = string.match(name, "(.*)-");
		if name == playerName then
			text = string.match(text, L["LOOT_ITEM_PUSHED_SELF"] .. "(.*).");
			if text then
				if container ~= "" then
					local itemID, itemType, itemSubType, itemEquipLoc, itemIcon = GetItemInfoInstant(text);
					itemName = (GetItemInfo(text));
					itemRarity = select(3, GetItemInfo(text));	

					if itemRarity < addonTbl.rarity then return end;
					if addonTbl.Contains(addonTbl.whitelistedItems, itemID, nil, nil) then
						-- Continue
					elseif addonTbl.Contains(addonTbl.ignoredItemCategories, nil, "itemType", itemType) then return;
					elseif addonTbl.Contains(addonTbl.ignoredItemCategories, nil, "itemType", itemSubType) then return;
					elseif addonTbl.Contains(addonTbl.ignoredItemCategories, nil, "itemType", itemEquipLoc) then return;
					elseif addonTbl.Contains(addonTbl.ignoredItems, itemID, nil, nil) then return end;
					
					if LastSeenClassicItemsDB[itemID] then
						addonTbl.AddItem(itemID, text, itemName, itemRarity, itemType, itemSubType, itemEquipLoc, itemIcon, L["DATE"], addonTbl.currentMap, "Container", container, "Update");
					else
						addonTbl.AddItem(itemID, text, itemName, itemRarity, itemType, itemSubType, itemEquipLoc, itemIcon, L["DATE"], addonTbl.currentMap, "Container", container, "New");
					end
				end
			end
		end
	end
	-- Synopsis: When the player is rewarded an item, usually when the player didn't loot anything by action, track it using the source of said item. Typically, we would see this occur in many cases,
	-- but we really only care about acquisition via creatures like unlootable world bosses.
	
	if event == "INSTANCE_GROUP_SIZE_CHANGED" or "ZONE_CHANGED_NEW_AREA" then
		if IsPlayerInCombat() then -- Maps can't be updated in combat.
			while isPlayerInCombat do
				C_Timer.After(0, function() C_Timer.After(3, function() IsPlayerInCombat() end); end);
			end
		end
		
		C_Timer.After(0, function() C_Timer.After(3, function() addonTbl.GetCurrentMap() end); end); -- Wait 3 seconds before asking the game for the new map.
	end
	-- Synopsis: Get the player's map when they change zones or enter instances.
	
	if event == "ITEM_LOCK_CHANGED" then
		local bagID, slotID = ...;
		if tonumber(bagID) and tonumber(slotID) then
			local _, _, _, _, _, isLootable, _, _, _, id = GetContainerItemInfo(bagID, slotID)
			if isLootable then container = GetItemInfo(id) end;
		end
	end
	
	if event == "LOOT_CLOSED" then
		EmptyVariables();
	end
	-- Synopsis: When the loot window is closed, call the EmptyVariables function.
	
	if event == "LOOT_OPENED" then
		plsEmptyVariables = true;
		local lootSlots = GetNumLootItems(); addonTbl.lootSlots = lootSlots;
		if lootSlots < 1 then return end;
		
		if addonTbl.lootFast then
			if (GetTime() - epoch) >= delay then
				for slot = lootSlots, 1, -1 do
					addonTbl.GetItemInfo(GetLootSlotLink(slot), slot);
					if addonTbl.doNotLoot == false then
						LootSlot(slot);
					end
				end
			end
			epoch = GetTime();
		else
			for slot = lootSlots, 1, -1 do
				addonTbl.GetItemInfo(GetLootSlotLink(slot), slot);
			end
		end
	end
	--[[
		Synopsis: Fires when the loot window is opened in MOST situations.
		Use Case(s):
			- Creatures
			- Objects
	]]
	
	if event == "MODIFIER_STATE_CHANGED" then
		local key, down = ...;
		if down == 1 then
			if key == "LSHIFT" or key == "RSHIFT" then
				addonTbl.doNotLoot = true;
			end
		else
			addonTbl.doNotLoot = false;
		end
	end
	-- Synopsis: Allows players to prevent the game from looting items like lockboxes.
	
	if event == "NAME_PLATE_UNIT_ADDED" then
		local unit = ...;
		addonTbl.AddCreatureByNameplate(unit, L["DATE"]);
	end
	-- Synopsis: When a nameplate appears on the screen, pass the GUID down the pipeline so it can be scanned for the creature's name.
	
	if event == "PLAYER_LOGIN" and addonTbl.isLastSeenClassicLoaded then
		addonTbl.InitializeSavedVars(); -- Initialize the tables if they're nil. This is usually only for players that first install the addon.
		EmptyVariables();
		
		addonTbl.LoadSettings(true);
		addonTbl.SetLocale(LastSeenClassicSettingsCacheDB["locale"]); LastSeenClassicSettingsCacheDB["locale"] = addonTbl["locale"];
		addonTbl.GetCurrentMap();
		playerName = UnitName("player");
		print(L["ADDON_NAME"] .. L["INFO_MSG_ADDON_LOAD_SUCCESSFUL"]);
		-- Synopsis: Stuff that needs to be checked or loaded into memory at logon or reload.

		for k, v in pairs(LastSeenClassicItemsDB) do -- If there are any items with bad data found or are in the ignored database, then simply remove them.
			if not addonTbl.DataIsValid(k) then
				table.insert(addonTbl.removedItems, v.itemLink);
				LastSeenClassicItemsDB[k] = nil;
				badDataItemCount = badDataItemCount + 1;
			end
			-- Synopsis: Check to see if any fields for the item return nil, if so, then remove the item from the items table.
			if addonTbl.ignoredItems[k] then
				table.insert(addonTbl.removedItems, v.itemLink);
				LastSeenClassicItemsDB[k] = nil;
				badDataItemCount = badDataItemCount + 1;
			end
			-- Synopsis: If the item is found on the addon-controlled ignores table, then remove it from the items table. Sometimes stuff slipped through the cracks.
		end

		if badDataItemCount > 0 and addonTbl.mode ~= GM_SURVEY_NOT_APPLICABLE then
			print(L["ADDON_NAME"] .. badDataItemCount .. L["ERROR_MSG_BAD_DATA"]);
			badDataItemCount = 0;
		end
	end
	
	if event == "PLAYER_LOGOUT" then
		addonTbl.itemsToSource = {}; -- Items looted from creatures are stored here and compared against the creature table to find where they dropped from, they are stored here until the below scenario occurs.
		addonTbl.removedItems = {}; -- When items with 'bad' data are removed, they are stored here until the below scenario occurs.
	end
	-- Synopsis: Clear out data that's no longer needed when the player logs off or reloads their user interface.
	
	if event == "UNIT_SPELLCAST_SENT" then
		local unit, target, _, spellID = ...; local spellName = GetSpellInfo(spellID);
		if unit == string.lower(L["IS_PLAYER"]) then
			if addonTbl.Contains(L["SPELL_NAMES"], nil, "spellName", spellName) then
				if spellName == L["SPELL_NAMES"][2]["spellName"] then -- Fishing
					addonTbl.target = L["SPELL_NAMES"][2]["spellName"];
				else
					addonTbl.target = target;
				end
			end
		end
	end
	-- Synopsis: Used to capture the name of an object that the player loots.
	
	if event == "UPDATE_MOUSEOVER_UNIT" then
		addonTbl.AddCreatureByMouseover("mouseover", L["DATE"]);
	end
	-- Synopsis: When the player hovers over a target without a nameplate, or the player doesn't use nameplates, send the GUID down the pipeline so it can be scanned for the creature's name.
end);

GameTooltip:HookScript("OnTooltipSetItem", addonTbl.OnTooltipSetItem);
ItemRefTooltip:HookScript("OnTooltipSetItem", addonTbl.OnTooltipSetItem);
