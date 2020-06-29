local addon, addonTbl = ...;

local function CountItemsSeen(tbl)
	local count = 0;
	for k, v in pairs(tbl) do
		count = count + 1;
	end
	return count;
end

local settingsFrame = CreateFrame("Frame", "LastSeenSettingsFrame", UIParent, "BasicFrameTemplateWithInset");
local L = addonTbl.L;
local SETTINGS = {};
local modeList;
local areOptionsOpen = false;

local function GetOptions(arg)
	if LastSeenClassicSettingsCacheDB[arg] ~= nil then
		addonTbl[arg] = LastSeenClassicSettingsCacheDB[arg];
		return addonTbl[arg];
	else
		if arg == "mode" then
			LastSeenClassicSettingsCacheDB[arg] = L["NORMAL_MODE"]; addonTbl[arg] = LastSeenClassicSettingsCacheDB[arg];
			return addonTbl[arg];
		end
		if arg == "rarity" then
			LastSeenClassicSettingsCacheDB[arg] = 1; addonTbl[arg] = LastSeenClassicSettingsCacheDB[arg];
			return addonTbl[arg];
		end
		if arg == "showSources" then
			LastSeenClassicSettingsCacheDB[arg] = false; addonTbl[arg] = LastSeenClassicSettingsCacheDB[arg];
			return addonTbl[arg];
		end
		if arg == "locale" then
			LastSeenClassicSettingsCacheDB[arg] = "enUS"; addonTbl[arg] = LastSeenClassicSettingsCacheDB[arg];
			return addonTbl[arg];
		end
	end
end
-- Synopsis: When the addon is loaded into memory after login, the addon will ask the cache for the last known
-- value of the mode, rarity, and lootFast variables.



addonTbl.LoadSettings = function(doNotOpen)
	if doNotOpen then
		LastSeenClassicSettingsCacheDB = {mode = GetOptions("mode"), rarity = GetOptions("rarity"), lootFast = GetOptions("lootFast"), showSources = GetOptions("showSources"), locale = GetOptions("locale")};
	else
		addonTbl.CreateFrame("LastSeenClassicSettingsFrame", 200, 125);
	end
end
--[[
	Synopsis: Loads either the settings from the cache or loads the settings frame.
	Use Case(s):
		true: If 'doNotOpen' is true, then the addon made the call so it can load the settings from the cache.
		false: If 'doNotOpen' is false, then the player made the call so the settings menu should be shown (or closed if already open.)
]]