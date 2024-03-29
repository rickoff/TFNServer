--[[
TFN_RegenPlayer by Rickoff for Tales from Nirn server
tes3mp 0.8.1
---------------------------
DESCRIPTION :
natural regen health for players
---------------------------
INSTALLATION:
Save the file as TFN_RegenPlayer.lua inside your server/scripts/custom folder.
Edits to customScripts.lua
TFN_RegenPlayer = require("custom.TFN_RegenPlayer")
]]
local tabSpell = {"natural_fortify_attack", "natural_fortify_speed", "natural_regen_health", "natural_regen_stamina", "natural_regen_mana"}

local function AddSpell(pid, listSpell)
	local Change = false
	tes3mp.ClearSpellbookChanges(pid)
	tes3mp.SetSpellbookChangesAction(pid, enumerations.spellbook.ADD)
	for _, spellId in ipairs(listSpell) do
		if not tableHelper.containsValue(Players[pid].data.spellbook, spellId) then	
			tes3mp.AddSpell(pid, spellId)
			table.insert(Players[pid].data.spellbook, spellId)
			Change = true	
		end	
	end
	if Change then
		tes3mp.SendSpellbookChanges(pid)		
	end
end

local TFN_RegenPlayer = {}

TFN_RegenPlayer.OnServerInit = function(eventStatus)	
	local spellCustom = jsonInterface.load("recordstore/spell.json")
	local recordStore = RecordStores["spell"]	
	if not recordStore.data.permanentRecords["natural_fortify_attack"] then
		local recordTable = {
		  name = "Fortify Attack",
		  subtype = 1,
		  cost = 1,
		  flags = 0,
		  effects = {{
			  id = 117,
			  attribute = -1,
			  skill = -1,
			  rangeType = 0,
			  area = 0,
			  duration = 1,
			  magnitudeMax = 1000,
			  magnitudeMin = 1000
			}}
		}
		recordStore.data.permanentRecords["natural_fortify_attack"] = recordTable
	end
	if not recordStore.data.permanentRecords["natural_fortify_speed"] then
		local recordTable = {
		  name = "Fortify Speed",
		  subtype = 1,
		  cost = 1,
		  flags = 0,
		  effects = {{
			  id = 79,
			  attribute = 4,
			  skill = -1,
			  rangeType = 0,
			  area = 0,
			  duration = -1,
			  magnitudeMax = 20,
			  magnitudeMin = 20
			}}
		}
		recordStore.data.permanentRecords["natural_fortify_speed"] = recordTable
	end	
	if not recordStore.data.permanentRecords["natural_regen_health"] then
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
	if not recordStore.data.permanentRecords["natural_regen_stamina"] then
		local recordTable = {
		  name = "Stamina Regen",
		  subtype = 1,
		  cost = 1,
		  flags = 0,
		  effects = {{
			  id = 77,
			  attribute = -1,
			  skill = -1,
			  rangeType = 0,
			  area = 0,
			  duration = 1,
			  magnitudeMax = 1,
			  magnitudeMin = 1
			}}
		}
		recordStore.data.permanentRecords["natural_regen_stamina"] = recordTable
	end	
	if not tableHelper.containsValue(spellCustom.permanentRecords, "natural_regen_mana") then
		local recordTable = {
		  name = "Mana Regen",
		  subtype = 1,
		  cost = 1,
		  flags = 0,
		  effects = {{
			  id = 76,
			  attribute = -1,
			  skill = -1,
			  rangeType = 0,
			  area = 0,
			  duration = 1,
			  magnitudeMax = 1,
			  magnitudeMin = 1
			}}
		}
		recordStore.data.permanentRecords["natural_regen_mana"] = recordTable
	end		
	recordStore:Save()		
end	

TFN_RegenPlayer.OnPlayerAuthentified = function(eventStatus, pid)
	AddSpell(pid, tabSpell)
end

customEventHooks.registerHandler("OnServerInit", TFN_RegenPlayer.OnServerInit)
customEventHooks.registerHandler("OnPlayerAuthentified", TFN_RegenPlayer.OnPlayerAuthentified)

return TFN_RegenPlayer
