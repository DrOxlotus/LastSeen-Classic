-- Namespace Variables
local addon, addonTbl = ...;

-- Module-Local Variables
local L = addonTbl.L;

-- Keybindings
BINDING_HEADER_LASTSEEN_CLASSIC = addon;
BINDING_NAME_LASTSEEN_CLASSIC_OPEN_SETTINGS = L["KEYBIND_SETTING_OPEN_SETTINGS"];

function LastSeenClassicKeyPressHandler(key)
	if key == GetBindingKey("LASTSEEN_CLASSIC_OPEN_SETTINGS") then
		addonTbl.LoadSettings(false);
	end
end