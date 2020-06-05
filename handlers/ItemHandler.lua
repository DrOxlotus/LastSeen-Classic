local addon, addonTbl = ...;
local L = addonTbl.L;
local sourceIsKnown;

--[[
	Note 1: A source ID is a unique identifier for an individual appearance. It's possible for an item to have 2 or more source IDs, and not every
	ID may be seen. This could be due to it not being in the game as an option OR that it's no longer dropping... only time can tell.
]]

addonTbl.New = function(itemID, itemLink, itemName, itemRarity, itemType, itemSubType, itemEquipLoc, itemIcon, currentDate, currentMap, sourceType, source)

	if not source or not itemID then return end; if LastSeenClassicItemsDB[itemID] then return end;

	LastSeenClassicItemsDB[itemID] = {itemName = itemName, itemLink = itemLink, itemRarity = itemRarity, itemType = itemType, itemSubType = itemSubType, itemEquipLoc = itemEquipLoc, itemIcon = itemIcon, lootDate = currentDate, source = source, 
	location = currentMap};
	
	if addonTbl.Contains(LastSeenClassicHistoryDB, nil, "itemLink", itemLink) ~= true then
		table.insert(LastSeenClassicHistoryDB, 1, {itemLink = itemLink, itemIcon = itemIcon, lootDate = currentDate, source = source, location = currentMap});
	end
	
	LastSeenClassicLootTemplate[itemID] = {[source] = 1};
	
	if addonTbl.mode ~= L["QUIET_MODE"] then
		print(L["ADDON_NAME"] .. "Added " .. "|T" .. itemIcon .. ":0|t " .. itemLink .. " - " .. source);
	end
	
	addonTbl.RollHistory();
	
	if addonTbl.mode == L["DEBUG_MODE"] and source ~= L["AUCTION_HOUSE"] then
		if LastSeenClassicCreaturesDB[addonTbl.itemSourceCreatureID] then print(LastSeenClassicCreaturesDB[addonTbl.itemSourceCreatureID].unitName) else print(nil) end;
		if addonTbl.encounterID then print(LastSeenClassicEncountersDB[addonTbl.encounterID]) else print(nil) end;
		if LastSeenClassicQuestsDB[addonTbl.questID] then print(LastSeenClassicQuestsDB[addonTbl.questID].questTitle) else print(nil) end;
		if addonTbl.target then print(addonTbl.target) else print(nil) end;
	end
end
-- Synopsis: Responsible for adding a NEW (not seen before this moment) item to the items table.

addonTbl.Update = function(itemID, itemLink, itemName, itemRarity, itemType, itemSubType, itemEquipLoc, itemIcon, currentDate, currentMap, sourceType, source)
	if not source or not itemID then return end; -- For some reason auctions are calling this...
	
	local isSourceKnown;

	for v in pairs(LastSeenClassicItemsDB[itemID]) do
		if v == "lootDate" then if LastSeenClassicItemsDB[itemID][v] ~= currentDate then LastSeenClassicItemsDB[itemID][v] = currentDate; addonTbl.wasUpdated = true; end; end
		if v == "location" then if LastSeenClassicItemsDB[itemID][v] ~= currentMap then LastSeenClassicItemsDB[itemID][v] = currentMap; addonTbl.wasUpdated = true; end; end
		if v == "source" then if LastSeenClassicItemsDB[itemID][v] ~= source then LastSeenClassicItemsDB[itemID][v] = source; addonTbl.wasUpdated = true; end; end
	end
	
	if LastSeenClassicItemsDB[itemID]["itemIcon"] == nil then LastSeenClassicItemsDB[itemID]["itemIcon"] = itemIcon end;
	if LastSeenClassicItemsDB[itemID]["itemSubType"] == nil then LastSeenClassicItemsDB[itemID]["itemSubType"] = itemSubType end;
	if LastSeenClassicItemsDB[itemID]["itemEquipLoc"] == nil then LastSeenClassicItemsDB[itemID]["itemEquipLoc"] = itemEquipLoc end;
	
	if addonTbl.Contains(LastSeenClassicHistoryDB, nil, "itemLink", itemLink) ~= true then
		table.insert(LastSeenClassicHistoryDB, 1, {itemLink = itemLink, itemIcon = itemIcon, lootDate = currentDate, source = source, location = currentMap});
	end
	
	if LastSeenClassicLootTemplate[itemID] then -- The item has been added to the loot template database at some point in the past.
		for k, v in next, LastSeenClassicLootTemplate[itemID] do
			if (k == source) then -- An existing source was discovered; therefore we should increment that source.
				v = v + 1; LastSeenClassicLootTemplate[itemID][k] = v;
				sourceIsKnown = true;
			else
				sourceIsKnown = false;
			end
		end
		
		if not sourceIsKnown then
			LastSeenClassicLootTemplate[itemID][source] = 1;
			sourceIsKnown = ""; -- Set this boolean equal to a blank string. 
		end
	else -- The item exists in the item template database, but hasn't been inserted into the loot template database yet.
		LastSeenClassicLootTemplate[itemID] = {[source] = 1};
	end
	
	if addonTbl.wasUpdated and addonTbl.mode ~= L["QUIET_MODE"] then
		print(L["ADDON_NAME"] .. "Updated " .. "|T" .. itemIcon .. ":0|t " .. itemLink .. " - " .. source);
		addonTbl.wasUpdated = false;
	end
	
	addonTbl.RollHistory();
	
	if addonTbl.mode == L["DEBUG_MODE"] and source ~= L["AUCTION_HOUSE"] then
		if LastSeenClassicCreaturesDB[addonTbl.itemSourceCreatureID] then print(LastSeenClassicCreaturesDB[addonTbl.itemSourceCreatureID].unitName) else print(nil) end;
		if addonTbl.encounterID then print(LastSeenClassicEncountersDB[addonTbl.encounterID]) else print(nil) end;
		if LastSeenClassicQuestsDB[addonTbl.questID] then print(LastSeenClassicQuestsDB[addonTbl.questID].questTitle) else print(nil) end;
		if addonTbl.target then print(addonTbl.target) else print(nil) end;
	end
end
-- Synopsis: Responsible for updating attributes about items (such as the date they were seen) already in the items table.

addonTbl.AddItem = function(itemID, itemLink, itemName, itemRarity, itemType, itemSubType, itemEquipLoc, itemIcon, currentDate, currentMap, sourceType, source, action)

	--if itemRarity < addonTbl.rarity then return end;
	if addonTbl.Contains(addonTbl.ignoredItemCategories, nil, "itemType", itemType) then return end;
	if addonTbl.Contains(addonTbl.ignoredItemCategories, nil, "itemType", itemSubType) then return end;
	if addonTbl.Contains(addonTbl.ignoredItemCategories, nil, "itemType", itemEquipLoc) then return end;
	if addonTbl.Contains(addonTbl.ignoredItems, itemID, nil, nil) then return end;
	
	local itemSourceCreatureID = addonTbl.itemsToSource[itemID];
	
	if action == "Update" then
		addonTbl.Update(itemID, itemLink, itemName, itemRarity, itemType, itemSubType, itemEquipLoc, itemIcon, currentDate, currentMap, sourceType, source);
	else
		addonTbl.New(itemID, itemLink, itemName, itemRarity, itemType, itemSubType, itemEquipLoc, itemIcon, currentDate, currentMap, sourceType, source);
	end
end
-- Synopsis: A staging ground for items before they're passed on to the functions responsible for adding them or updating them. Helps weed out the unwanteds.