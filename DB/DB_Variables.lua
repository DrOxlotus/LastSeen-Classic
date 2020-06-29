local addon, addonTbl = ...;
local L = addonTbl.L;

-- ARRAYS (TABLES)
local itemsToSource 										= {}; -- The data here is temporary intentionally.
local removedItems 											= {};
addonTbl.itemsToSource 										= itemsToSource;
addonTbl.removedItems 										= removedItems;

-- BOOLEANS
local doNotIgnore 											= false;
local doNotLoot;
local doNotUpdate 											= false;
local isInInstance 											= false;
local isLastSeenClassicLoaded 								= IsAddOnLoaded("LastSeen-Classic");
local wasUpdated 											= false;
addonTbl.doNotIgnore 										= doNotIgnore;
addonTbl.doNotLoot 											= doNotLoot;
addonTbl.doNotUpdate 										= doNotUpdate;
addonTbl.isInInstance 										= isInInstance;
addonTbl.isLastSeenClassicLoaded 							= isLastSeenClassicLoaded;
addonTbl.wasUpdated 										= wasUpdated;

-- INTEGERS
local itemSourceCreatureID 									= 0;
local maxHistoryEntries										= 20;
addonTbl.itemSourceCreatureID 								= itemSourceCreatureID;
addonTbl.maxHistoryEntries									= maxHistoryEntries;

-- STRINGS
local currentMap 											= "";
local query 												= "";
addonTbl.currentMap 										= currentMap;
addonTbl.query 												= query;