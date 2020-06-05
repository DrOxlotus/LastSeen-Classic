local addon, addonTbl = ...;

local L = setmetatable({}, { __index = function(t, k)
	local text = tostring(k);
	rawset(t, k, text);
	return text;
end });

local LOCALE = GetLocale();

if LOCALE == "deDE" then -- German
	addonTbl.L = L;

	-- GENERAL
	L["ADDON_NAME"] 							= "|cff00ccff" .. addon .. "|r: ";
	L["ADDON_NAME_SETTINGS"] 					= "|cff00ccff" .. addon .. "|r";
	L["RELEASE"] 								= "[" .. GetAddOnMetadata(addon, "Version") .. "] ";
	L["DATE"]									= date("%m/%d/%Y");
	-- START AUCTION HOUSE SECTION --	
	L["AUCTION_HOUSE"] 							= "Auktionshaus";
	L["AUCTION_WON_SUBJECT"] 					= "Auktion gewonnen:";
	-- COMMANDS
	L["CMD_DISCORD"]							= "zwietracht";
	L["CMD_HISTORY"] 							= "geschichte";
	L["CMD_IMPORT"] 							= "importieren";
	L["CMD_LOOT"] 								= "beute";
	L["CMD_REMOVE"] 							= "entfernen";
	L["CMD_REMOVE_SHORT"] 						= "rm";
	L["CMD_SEARCH"] 							= "suchen";
	L["CMD_VIEW"] 								= "ansehen";
	L["SEARCH_OPTION_C"] 						= "c";
	L["SEARCH_OPTION_I"] 						= "i";
	L["SEARCH_OPTION_Q"] 						= "q";
	L["SEARCH_OPTION_Z"] 						= "z";
	-- CONSTANTS	
	L["LOOT_ITEM_PUSHED_SELF"] 					= "Ihr bekommt einen Gegenstand: ";
	L["LOOT_ITEM_SELF"] 						= "Ihr erhaltet Beute: ";
	-- ERROR MESSAGES	
	L["ERROR_MSG_BAD_DATA"] 					= " elemente, die aufgrund fehlender oder beschädigter Informationen entfernt wurden.";
	L["ERROR_MSG_BAD_REQUEST"] 					= "Schlechte Anfrage. Bitte versuchen Sie es erneut.";
	L["ERROR_MSG_CANT_ADD"] 					= "Angegebenes Element kann nicht hinzugefügt werden.";
	L["ERROR_MSG_CANT_COMPLETE_REQUEST"] 		= "Antrag kann nicht abgeschlossen werden: ";
	L["ERROR_MSG_INVALID_GUID_OR_UNITNAME"]		= "Ungültige GUID oder Einheitsname! Machen Sie einen Screenshot und melden Sie sich bei Discord!";
	L["ERROR_MSG_NO_ITEMS_FOUND"] 				= "Keine elemente gefunden.";
	L["ERROR_MSG_UNKNOWN_SOURCE"] 				= " wurde von einer unbekannten Quelle geplündert. Die Quelle wurde als \"Verschiedenes\" festgelegt.";
	-- INFORMATIONAL MESSAGES		
	L["INFO_MSG_ADDON_LOAD_SUCCESSFUL"] 		= "Erfolgreich geladen!";
	L["INFO_MSG_IGNORED_ITEM"] 					= "Dieser Punkt wird automatisch ignoriert.";
	L["INFO_MSG_ITEM_REMOVED"] 					= " erfolgreich entfernt.";
	L["INFO_MSG_LOOT_ENABLED"] 					= "Beute Schnellmodus aktiviert.";
	L["INFO_MSG_LOOT_DISABLED"] 				= "Beute Schnellmodus deaktiviert.";
	L["INFO_MSG_MISCELLANEOUS"]					= "Verschiedene Funktionen";
	L["INFO_MSG_POSTMASTER"]					= "Der Postmeister";
	L["INFO_MSG_RESULTS"]						= " ergebnis(se)";
	-- OBJECT TYPES			
	L["IS_CREATURE"] 							= "Kreatur";
	L["IS_PLAYER"] 								= "Spieler";
	L["IS_VEHICLE"] 							= "Fahrzeug";
	L["IS_UNKNOWN"]								= "Unbekannt";
	-- MODE NAMES --			
	L["DEBUG_MODE"] 							= "Debug";
	L["NORMAL_MODE"] 							= "Normal";
	L["QUIET_MODE"] 							= "Ruhig";
	-- MODE DESCRIPTIONS --			
	L["DEBUG_MODE_DESC"] 						= "Normaler Modus mit variabler Ausgabe.\n";
	L["NORMAL_MODE_DESC"] 						= "Zeigt neue und aktualisierte Artikel an.\n";
	L["QUIET_MODE_DESC"] 						= "Keine Ausgabe!\n";
	-- OTHER
	L["SPELL_NAMES"] = {
		{
			["spellName"] 						= "Einsammeln",
		},						
		{						
			["spellName"] 						= "Angeln",
		},						
		{						
			["spellName"] 						= "Toga durchsuchen",
		},						
		{						
			["spellName"] 						= "Kräutersammeln",
		},						
		{						
			["spellName"] 						= "Plündern",
		},						
		{						
			["spellName"] 						= "Bergbau",
		},						
		{						
			["spellName"] 						= "Öffnen",
		},						
		{						
			["spellName"] 						= "Kürschnerei",
		},						
		{						
			["spellName"] 						= "Untersuchen",
		},
	};
return end;