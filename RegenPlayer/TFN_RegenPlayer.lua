--[[
TFN_RegenPlayer by Rickoff for Tales from Nirn server
tes3mp 0.7.0
openmw 0.44
script 0.1
---------------------------
DESCRIPTION :
natural regen health for players
---------------------------
INSTALLATION:
Save the file as TFN_RegenPlayer.lua inside your server/scripts/custom folder.

Edits to customScripts.lua
TFN_RegenPlayer = require("custom.TFN_RegenPlayer")
]]

local TFN_RegenPlayer = {}

TFN_RegenPlayer.OnServerInit = function(eventStatus)	
	local spellCustom = jsonInterface.load("recordstore/spell.json")
	local recordStore = RecordStores["spell"]
	if not tableHelper.containsValue(spellCustom.permanentRecords, "natural_regen_health") then
		local recordTable = {
		  name = "Health Regen",
		  subtype = 1,
		  cost = 1,
		  flags = 0,
		  effects = {{
			  id = 75,
			  attribute = -1,
			  skill = -1,
			  rangeType = 0,
			  area = 0,
			  duration = 0,
			  magnitudeMax = 1,
			  magnitudeMin = 1
			}}
		}
		recordStore.data.permanentRecords["natural_regen_health"] = recordTable
	end	
    recordStore:Save()		
end	

TFN_RegenPlayer.OnPlayerAuthentified = function(eventStatus, pid)
    if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		if not tableHelper.containsValue(Players[pid].data.spellbook, "natural_regen_health") then	
			logicHandler.RunConsoleCommandOnPlayer(pid, "player->addspell natural_regen_health", false)
		end
	end
end

customEventHooks.registerHandler("OnServerInit", TFN_RegenPlayer.OnServerInit)
customEventHooks.registerHandler("OnPlayerAuthentified", TFN_RegenPlayer.OnPlayerAuthentified)

return TFN_RegenPlayer
