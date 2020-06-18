local addon, addonTbl = ...;

local L = addonTbl.L;

SLASH_LastSeen1 = "/ls";
SLASH_LastSeen2 = "/lastseen";
SlashCmdList["LastSeen"] = function(cmd, editbox)
	local _, _, cmd, args = string.find(cmd, "%s?(%w+)%s?(.*)");

	if not cmd or cmd == "" then
		addonTbl.LoadSettings(false);
	elseif cmd == L["CMD_REMOVE"] or cmd == L["CMD_REMOVE_SHORT"] then -- Removes an item from the items table. Accepts an ID or link.
		addonTbl.Remove(args);
	elseif cmd == L["CMD_SEARCH"] and args ~= "" then -- Searches the items table for matches to the query. Accepts creatures, items, quests, and zones.
		addonTbl.Search(args);
	elseif cmd == L["CMD_VIEW"] then -- When items with bad data are removed, this command allows the player to view them before they are removed, or report them.
		if next(addonTbl.removedItems) ~= nil then
			for k, v in pairs(addonTbl.removedItems) do
				print(k .. ": " .. v);
			end
		end
	elseif cmd == L["CMD_HISTORY"] then -- Allows the player to view the last 20 items they've acquired. This is persistent between sessions and characters.
		addonTbl.GetTable(LastSeenClassicHistoryDB);
	elseif cmd == L["CMD_MAN"] then -- Allows the player to ask the addon for command usage.
		addonTbl.Manual(args);
	elseif cmd == L["CMD_DISCORD"] then -- Gives the player the link to the Discord server.
		print(L["ADDON_NAME"] .. "https://discord.gg/9GFDsgy");
	end
end
