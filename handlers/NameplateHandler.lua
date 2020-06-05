local addon, addonTbl = ...;
local L = addonTbl.L;

local playerName = UnitName(L["IS_PLAYER"]);

addonTbl.AddCreatureByMouseover = function(unit, seenDate)
	if UnitGUID(unit) ~= nil then
		local guid = UnitGUID(unit);
		local entityType, _, _, _, _, creatureID, _ = strsplit("-", guid);
		creatureID = tonumber(creatureID);
		if entityType == L["IS_CREATURE"] or entityType == L["IS_VEHICLE"] then
			local unitname = UnitName(unit);
			if not LastSeenClassicCreaturesDB[creatureID] and not UnitIsFriend(unit, L["IS_PLAYER"]) then
				LastSeenClassicCreaturesDB[creatureID] = {unitName = unitname};
			elseif LastSeenClassicCreaturesDB[creatureID] and not UnitIsFriend(unit, L["IS_PLAYER"]) then
				if LastSeenClassicCreaturesDB[creatureID]["seen"] == nil then
					LastSeenClassicCreaturesDB[creatureID] = {unitName = unitname};
				end
				if LastSeenClassicCreaturesDB[creatureID]["unitName"] == "Unknown" then -- LOCALIZE ME
					LastSeenClassicCreaturesDB[creatureID]["unitName"] = UnitName(unit);
				end
			end
		end
	end
end

addonTbl.AddCreatureByNameplate = function(unit, seenDate)
	local guid = UnitGUID(unit);
	local unitName = UnitName(unit);
	if guid and unitName then
		local entityType, _, _, _, _, creatureID, _ = strsplit("-", guid);
	else
		if addonTbl.mode == L["DEBUG_MODE"] then
			print(L["ADDON_NAME"] .. L["ERROR_MSG_INVALID_GUID_OR_UNITNAME"])
		end
		return;
	end
	creatureID = tonumber(creatureID);
	if entityType == L["IS_CREATURE"] or entityType == L["IS_VEHICLE"] then
		if not LastSeenClassicCreaturesDB[creatureID] and not UnitIsFriend(unit, L["IS_PLAYER"]) then
			LastSeenClassicCreaturesDB[creatureID] = {unitName = unitName};
		elseif LastSeenClassicCreaturesDB[creatureID] and not UnitIsFriend(unit, L["IS_PLAYER"]) then
			if LastSeenClassicCreaturesDB[creatureID]["seen"] == nil then
				LastSeenClassicCreaturesDB[creatureID] = {unitName = unitName};
			end
			if LastSeenClassicCreaturesDB[creatureID]["unitName"] == L["IS_UNKNOWN"] then
				LastSeenClassicCreaturesDB[creatureID]["unitName"] = UnitName(unit);
			end
		end
	end
end
