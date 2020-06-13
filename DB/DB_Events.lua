local addon, addonTbl = ...; addon = "|cffb19cd9" .. addon .. "|r";
local L = addonTbl.L;

local events = {
	"INSTANCE_GROUP_SIZE_CHANGED",
	"LOOT_CLOSED",
	"LOOT_OPENED",
	"NAME_PLATE_UNIT_ADDED",
	"PLAYER_LOGIN",
	"PLAYER_LOGOUT",
	"UNIT_SPELLCAST_SENT",
	"UPDATE_MOUSEOVER_UNIT",
	"ZONE_CHANGED_NEW_AREA"
};
-- Synopsis: These are events that must occur before the addon will take action. Each event is documented in main.lua.

addonTbl.events = events;