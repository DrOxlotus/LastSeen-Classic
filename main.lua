--[[
	NOTE: Synopses pertain to the code directly above them!
	© 2020 Oxlotus/Lightsky/Smallbuttons
]]

-- Namespace Variables
local addon, addonTbl = ...;
local L = addonTbl.L;

-- Module-Local Variables
local badDataItemCount = 0;
local currentDate;
local currentMap;
local delay = 0.3;
local epoch = 0;
local executeCodeBlock = true;
local frame = CreateFrame("Frame");
local isMerchantFrameOpen;
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
local playerName;
local plsEmptyVariables;

for _, event in ipairs(addonTbl.events) do
	frame:RegisterEvent(event);
end
-- Synopsis: Registers all events that the addon cares about using the events table in the corresponding table file.

local function InitializeTable(tbl)
	tbl = {};
	return tbl;
end
-- Synopsis: Used to create EMPTY tables, instead of leaving them nil.

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
				addonTbl.target = "";
				executeCodeBlock = true;
				plsEmptyVariables = false;
			end);
		end);
	end
end
-- Synopsis: When executed, after 4 seconds, clear or reset the variables.

frame:SetScript("OnEvent", function(self, event, ...)
	
	if event == "INSTANCE_GROUP_SIZE_CHANGED" or "ZONE_CHANGED_NEW_AREA" then
		
		if IsPlayerInCombat() then
			while isPlayerInCombat do
				C_Timer.After(0, function() C_Timer.After(3, function() IsPlayerInCombat() end); end);
			end
		end
		
		C_Timer.After(0, function() C_Timer.After(3, function() addonTbl.GetCurrentMap() end); end);
	end
	-- Synopsis: Get the player's map when they change zones or enter instances.
	
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
	
	if event == "NAME_PLATE_UNIT_ADDED" then
		local unit = ...;
		addonTbl.AddCreatureByNameplate(unit, L["DATE"]);
	end
	-- Synopsis: When a nameplate appears on the screen, pass the GUID down the pipeline so it can be scanned for the creature's name.
	
	if event == "PLAYER_LOGIN" and addonTbl.isLastSeenLoaded then
		if LastSeenClassicMapsDB == nil then LastSeenClassicMapsDB = InitializeTable(LastSeenClassicMapsDB) end;
		if LastSeenClassicCreaturesDB == nil then LastSeenClassicCreaturesDB = InitializeTable(LastSeenClassicCreaturesDB) end;
		if LastSeenClassicEncountersDB == nil then LastSeenClassicEncountersDB = InitializeTable(LastSeenClassicEncountersDB) end;
		if LastSeenClassicItemsDB == nil then LastSeenClassicItemsDB = InitializeTable(LastSeenClassicItemsDB) end;
		if LastSeenClassicQuestsDB == nil then LastSeenClassicQuestsDB = InitializeTable(LastSeenClassicQuestsDB) end;
		if LastSeenClassicSettingsCacheDB == nil then LastSeenClassicSettingsCacheDB = InitializeTable(LastSeenClassicSettingsCacheDB) end;
		if LastSeenClassicLootTemplate == nil then LastSeenClassicLootTemplate = InitializeTable(LastSeenClassicLootTemplate) end;
		if LastSeenClassicHistoryDB == nil then LastSeenClassicHistoryDB = InitializeTable(LastSeenClassicHistoryDB) end;
		-- Synopsis: Initialize the tables if they're nil. This is usually only for players that first install the addon.
		
		LastSeenClassicIgnoredItemsDB = {};
		-- Synopsis: Empty tables that will no longer be used. These tables will eventually be removed from the addon altogether.
		
		addonTbl.LoadSettings(true);
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
			if type(v.itemRarity) == "string" then
				local temporaryRarity = v.itemRarity;
				v.itemRarity = v.itemType;
				v.itemType = temporaryRarity;
			end
			-- Synopsis: For a short period of time, itemRarity and itemType were flipped in a function call. This works to correct them and flip them back.
			if v.itemRarity < 2 then
				table.insert(addonTbl.removedItems, v.itemLink);
				LastSeenClassicItemsDB[k] = nil;
				badDataItemCount = badDataItemCount + 1;
			end
			-- Synopsis: If someone used LastSeen2 for a short period of time, then they will have Common (white) quality quest rewards that need to be removed.
		end

		if badDataItemCount > 0 and addonTbl.mode ~= L["QUIET_MODE"] then
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
				addonTbl.target = target;
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
