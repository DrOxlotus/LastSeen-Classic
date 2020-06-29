local addon, addonTbl = ...;
local L = addonTbl.L;

local events = {
	"CHAT_MSG_LOOT",
	"INSTANCE_GROUP_SIZE_CHANGED",
	"ITEM_LOCK_CHANGED",
	"LOOT_CLOSED",
	"LOOT_OPENED",
	"MODIFIER_STATE_CHANGED",
	"NAME_PLATE_UNIT_ADDED",
	"PLAYER_LOGIN",
	"PLAYER_LOGOUT",
	"UPDATE_MOUSEOVER_UNIT",
	"UNIT_SPELLCAST_SENT",
	"ZONE_CHANGED_NEW_AREA"
};
-- Synopsis: These are events that must occur before the addon will take action. Each event is documented in main.lua.

addonTbl.events = events;