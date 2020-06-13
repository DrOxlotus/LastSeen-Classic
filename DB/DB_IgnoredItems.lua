local addon, addonTbl = ...; addon = "|cffb19cd9" .. addon .. "|r";
local L = addonTbl.L;

-- TODO: Reconsider the approach to ignoring specific items.
local ignoredItems = {
	[11736] 		= "Libram of Resilience",
	[21218] 		= "Blue Qiraji Resonating Crystal",
    [21321] 		= "Red Qiraji Resonating Crystal",
    [21323] 		= "Green Qiraji Resonating Crystal",
    [21324] 		= "Yellow Qiraji Resonating Crystal",
};

addonTbl.ignoredItems = ignoredItems;