--[[
TFN_SystemClass by Rickoff
tes3mp 0.7.0
---------------------------
DESCRIPTION :
class system limiting the use of weapons, armor, various items and sort according to the corresponding talent.
---------------------------
INSTALLATION:
Save the file as TFN_SystemClass.lua inside your server/scripts/custom folder.

Edits to customScripts.lua :
TFN_SystemClass = require("custom.TFN_SystemClass")
---------------------------
]]
local trad = {
	NoSkillItem = "You do not have the corresponding skill to equip this item !\n",
	NoSkillSpell = "You do not have the corresponding skill to learn this spell !\n",
	NoSkillMisc = "You do not have the corresponding skill to use this object !\n"
}

local VanillaClass = {
	acrobat = {"acrobatics","athletics","marksman","sneak","unarmored","speechcraft","alteration","spear","handtohand","lightarmor"},
	agent = {"speechcraft","sneak","acrobatics","lightarmor","shortblade","mercantile","conjuration","block","unarmored","illusion"},
	archer = {"marksman","longblade","block","athletics","lightarmor","unarmored","spear","restoration","sneak","mediumarmor"},
	assassin = {"sneak","marksman","lightarmor","shortblade","acrobatics","security","longblade","alchemy","block","athletics"},
	barbarian = {"axe","mediumarmor","bluntweapon","athletics","block","acrobatics","lightarmor","armorer","marksman","unarmored"},
	bard = {"speechcraft","alchemy","acrobatics","longblade","block","mercantile","illusion","mediumarmor","enchant","security"},
	battlemage = {"alteration","destruction","conjuration","axe","heavyarmor","mysticism","longblade","marksman","enchant","alchemy"},
	crusader = {"bluntweapon","longblade","destruction","heavyarmor","block","restoration","armorer","handtohand","mediumarmor","alchemy"},
	healer = {"restoration","mysticism","alteration","handtohand","speechcraft","illusion","alchemy","unarmored","lightarmor","bluntweapon"},
	knight = {"longblade","axe","speechcraft","heavyarmor","block","restoration","mercantile","mediumarmor","enchant","armorer"},
	mage = {"mysticism","destruction","alteration","illusion","restoration","enchant","alchemy","unarmored","shortblade","conjuration"},
	monk = {"handtohand","unarmored","athletics","acrobatics","sneak","block","marksman","lightarmor","restoration","bluntweapon"},
	nightblade = {"mysticism","illusion","alteration","sneak","shortblade","lightarmor","unarmored","destruction","marksman","security"},
	pilgrim = {"speechcraft","mercantile","marksman","restoration","mediumarmor","illusion","handtohand","shortblade","block","alchemy"},
	rogue = {"shortblade","mercantile","axe","lightarmor","handtohand","block","mediumarmor","speechcraft","athletics","longblade"},
	scout = {"sneak","longblade","mediumarmor","athletics","block","marksman","alchemy","alteration","lightarmor","unarmored"},
	sorcerer = {"enchant","conjuration","mysticism","destruction","alteration","illusion","mediumarmor","heavyarmor","marksman","shortblade"},
	spellsword = {"block","restoration","longblade","destruction","alteration","bluntweapon","enchant","alchemy","mediumarmor","axe"},
	thief = {"security","sneak","acrobatics","lightarmor","shortblade","marksman","speechcraft","handtohand","mercantile","athletics"},
	warrior = {"longblade","mediumarmor","heavyarmor","athletics","block","armorer","spear","marksman","axe","bluntweapon"},
	witchhunter = {"conjuration","enchant","alchemy","lightarmor","marksman","unarmored","block","bluntweapon","sneak","mysticism"}
}

local listItems = jsonInterface.load("custom/TFN_WeaponsArmors.json")
local listSpell = jsonInterface.load("custom/TFN_Spell.json")
local listMisc = jsonInterface.load("custom/TFN_Misc.json")

local function CheckSkills(pid, skill)	
	if skill == "nothing" then return false end
	if Players[pid].data.customClass.minorSkills and Players[pid].data.customClass.majorSkills then	
		if tableHelper.containsValue(Players[pid].data.customClass, skill, true) then		
			return true
		else
			return false
		end
	else
		local Class = Players[pid].data.character.class	
		if tableHelper.containsValue(VanillaClass[Class], skill, true) then
			return true
		else
			return false
		end
	end
end

local TFN_SystemClass = {}

TFN_SystemClass.OnServerInit = function(eventStatus)
	local weaponsCustom = jsonInterface.load("recordstore/weapon.json")
	for index, item in pairs(weaponsCustom.generatedRecords) do
		local Slot = weaponsCustom.generatedRecords[index]
		listItems[string.lower(index)] = listItems[string.lower(Slot.baseId)]
	end
	local armorCustom = jsonInterface.load("recordstore/armor.json")
	for index, item in pairs(armorCustom.generatedRecords) do
		local Slot = armorCustom.generatedRecords[index]
		listItems[string.lower(index)] = listItems[string.lower(Slot.baseId)]
	end
end

TFN_SystemClass.OnPlayerEquipment = function(eventStatus, pid)
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
	    local reloadAtEnd = false
		for index = 0, tes3mp.GetEquipmentSize() - 1 do
			local itemRefId = tes3mp.GetEquipmentItemRefId(pid, index)
			if itemRefId ~= "" then
				if listItems[string.lower(itemRefId)] then
					local Skill = listItems[string.lower(itemRefId)].skill 
					if CheckSkills(pid, Skill) == false then
						tes3mp.MessageBox(pid, -1, trad.NoSkillItem..color.Red..Skill)
						reloadAtEnd = true
					end
				end
			end
		end
		if reloadAtEnd == true then
			Players[pid]:LoadEquipment()
			return customEventHooks.makeEventStatus(false, false)
		end
	end
end

TFN_SystemClass.OnPlayerSpellbook = function(eventStatus, pid)
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		local action = tes3mp.GetSpellbookChangesAction(pid)
	    local reloadAtEnd = false		
		for index = 0, tes3mp.GetSpellbookChangesSize(pid) - 1 do
			local spellId = tes3mp.GetSpellId(pid, index)
			if action == enumerations.spellbook.ADD then
				if spellId ~= "" then
					if listSpell[string.lower(spellId)] then
						local Skill = listSpell[string.lower(spellId)].skill 
						if CheckSkills(pid, Skill) == false then
							tes3mp.MessageBox(pid, -1, trad.NoSkillSpell..color.Red..Skill)
							reloadAtEnd = true
						end
					end
				end			
			end
		end
		if reloadAtEnd == true then
			Players[pid]:LoadSpellbook()
			return customEventHooks.makeEventStatus(false, false)
		end		
	end
end

TFN_SystemClass.OnPlayerItemUse = function(eventStatus, pid, itemRefId)
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		if itemRefId ~= "" then
			if listMisc[string.lower(itemRefId)] then
				local Skill = listMisc[string.lower(itemRefId)].skill 
				if CheckSkills(pid, Skill) == false then
					tes3mp.MessageBox(pid, -1, trad.NoSkillMisc..color.Red..Skill)
					return customEventHooks.makeEventStatus(false, false)
				end
			end
		end			
	end
end

TFN_SystemClass.OnRecordDynamic = function(eventStatus, pid)
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		local weaponsCustom = jsonInterface.load("recordstore/weapon.json")
		for index, item in pairs(weaponsCustom.generatedRecords) do
			local Slot = weaponsCustom.generatedRecords[index]
			listItems[string.lower(index)] = listItems[string.lower(Slot.baseId)]
		end
		local armorCustom = jsonInterface.load("recordstore/armor.json")
		for index, item in pairs(armorCustom.generatedRecords) do
			local Slot = armorCustom.generatedRecords[index]
			listItems[string.lower(index)] = listItems[string.lower(Slot.baseId)]
		end
	end
end

TFN_SystemClass.OnPlayerAuthentified = function(eventStatus, pid)
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		TFN_SystemClass.OnCheckEquipment(pid)
		TFN_SystemClass.OnCheckSpellbook(pid)		
	end
end

TFN_SystemClass.OnCheckEquipment = function(pid)
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
	    local reloadAtEnd = false
		for index, slot in pairs(Players[pid].data.equipment) do
			local itemRefId = slot.refId
			if itemRefId ~= "" then
				if listItems[string.lower(itemRefId)] then
					local Skill = listItems[string.lower(itemRefId)].skill 
					if CheckSkills(pid, Skill) == false then
						Players[pid].data.equipment[index] = nil
						reloadAtEnd = true
					end
				end
			end
		end
		if reloadAtEnd == true then		
			Players[pid]:QuicksaveToDrive()
			Players[pid]:LoadEquipment()
			tableHelper.cleanNils(Players[pid].data.equipment)			
		end
	end
end

TFN_SystemClass.OnCheckSpellbook = function(pid)
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
	    local reloadAtEnd = false		
		for index, spellId in pairs(Players[pid].data.spellbook) do
			if spellId ~= "" then
				if listSpell[string.lower(spellId)] then
					local Skill = listSpell[string.lower(spellId)].skill 
					if CheckSkills(pid, Skill) == false then
						Players[pid].data.spellbook[index] = nil
						reloadAtEnd = true
					end
				end
			end			
		end
		if reloadAtEnd == true then	
			Players[pid]:QuicksaveToDrive()		
			Players[pid]:LoadSpellbook()
			tableHelper.cleanNils(Players[pid].data.spellbook)				
		end		
	end
end

customEventHooks.registerHandler("OnServerInit", TFN_SystemClass.OnServerInit)
customEventHooks.registerHandler("OnRecordDynamic", TFN_SystemClass.OnRecordDynamic)
customEventHooks.registerHandler("OnPlayerAuthentified", TFN_SystemClass.OnPlayerAuthentified)
customEventHooks.registerValidator("OnPlayerEquipment", TFN_SystemClass.OnPlayerEquipment)
customEventHooks.registerValidator("OnPlayerSpellbook", TFN_SystemClass.OnPlayerSpellbook)
customEventHooks.registerValidator("OnPlayerItemUse", TFN_SystemClass.OnPlayerItemUse)
customEventHooks.registerValidator("OnPlayerQuickKeys", TFN_SystemClass.OnPlayerQuickKeys)

return TFN_SystemClass

