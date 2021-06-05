--[[
TFN_SystemClass by Rickoff
tes3mp 0.7.0
---------------------------
DESCRIPTION :

---------------------------
INSTALLATION:
Save the file as TFN_SystemClass.lua inside your server/scripts/custom folder.

Edits to customScripts.lua :
TFN_SystemClass = require("custom.TFN_SystemClass")
---------------------------
]]
local trad = {}
trad.NoSkillItem = "You do not have the corresponding skill to equip this item !\n"
trad.NoSkillSpell = "You do not have the corresponding skill to learn this spell !\n"
trad.NoSkillMisc = "You do not have the corresponding skill to use this object !\n"

local VanillaClass = {}
VanillaClass.acrobat = {"acrobatics","athletics","marksman","sneak","unarmored","speechcraft","alteration","spear","handtohand","lightarmor"}
VanillaClass.agent = {"speechcraft","sneak","acrobatics","lightarmor","shortblade","mercantile","conjuration","block","unarmored","illusion"}
VanillaClass.archer = {"marksman","longblade","block","athletics","lightarmor","unarmored","spear","restoration","sneak","mediumarmor"}
VanillaClass.assassin = {"sneak","marksman","lightarmor","shortblade","acrobatics","security","longblade","alchemy","block","athletics"}
VanillaClass.barbarian = {"axe","mediumarmor","bluntweapon","athletics","block","acrobatics","lightarmor","armorer","marksman","unarmored"}
VanillaClass.bard = {"speechcraft","alchemy","acrobatics","longblade","block","mercantile","illusion","mediumarmor","enchant","security"}
VanillaClass.battlemage = {"alteration","destruction","conjuration","axe","heavyarmor","mysticism","longblade","marksman","enchant","alchemy"}
VanillaClass.crusader = {"bluntweapon","longblade","destruction","heavyarmor","block","restoration","armorer","handtohand","mediumarmor","alchemy"}
VanillaClass.healer = {"restoration","mysticism","alteration","handtohand","speechcraft","illusion","alchemy","unarmored","lightarmor","bluntweapon"}
VanillaClass.knight = {"longblade","axe","speechcraft","heavyarmor","block","restoration","mercantile","mediumarmor","enchant","armorer"}
VanillaClass.mage = {"mysticism","destruction","alteration","illusion","restoration","enchant","alchemy","unarmored","shortblade","conjuration"}
VanillaClass.monk = {"handtohand","unarmored","athletics","acrobatics","sneak","block","marksman","lightarmor","restoration","bluntweapon"}
VanillaClass.nightblade = {"mysticism","illusion","alteration","sneak","shortblade","lightarmor","unarmored","destruction","marksman","security"}
VanillaClass.pilgrim = {"speechcraft","mercantile","marksman","restoration","mediumarmor","illusion","handtohand","shortblade","block","alchemy"}
VanillaClass.rogue = {"shortblade","mercantile","axe","lightarmor","handtohand","block","mediumarmor","speechcraft","athletics","longblade"}
VanillaClass.scout = {"sneak","longblade","mediumarmor","athletics","block","marksman","alchemy","alteration","lightarmor","unarmored"}
VanillaClass.sorcerer = {"enchant","conjuration","mysticism","destruction","alteration","illusion","mediumarmor","heavyarmor","marksman","shortblade"}
VanillaClass.spellsword = {"block","restoration","longblade","destruction","alteration","bluntweapon","enchant","alchemy","mediumarmor","axe"}
VanillaClass.thief = {"security","sneak","acrobatics","lightarmor","shortblade","marksman","speechcraft","handtohand","mercantile","athletics"}
VanillaClass.warrior = {"longblade","mediumarmor","heavyarmor","athletics","block","armorer","spear","marksman","axe","bluntweapon"}
VanillaClass.witchhunter = {"conjuration","enchant","alchemy","lightarmor","marksman","unarmored","block","bluntweapon","sneak","mysticism"}

local listItems = jsonInterface.load("custom/TFN_WeaponsArmors.json")
local listSpell = jsonInterface.load("custom/TFN_Spell.json")
local listMisc = jsonInterface.load("custom/TFN_Misc.json")

local function CheckSkills(pid, skill)
	
	if Players[pid].data.customClass.minorSkills and Players[pid].data.customClass.majorSkill then
		if tableHelper.containsValue(Players[pid].data.customClass.minorSkills, skill, true) then		
			return true
		elseif tableHelper.containsValue(Players[pid].data.customClass.majorSkill, skill, true) then
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

TFN_SystemClass.OnPlayerQuickKeys = function(eventStatus, pid)
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		local reloadAtEnd = false
		for index = 0, tes3mp.GetQuickKeyChangesSize(pid) - 1 do
			local slot = tes3mp.GetQuickKeySlot(pid, index)
			local itemRefId = tes3mp.GetQuickKeyItemId(pid, index)
			if itemRefId ~= "" then
				if listMisc[string.lower(itemRefId)] then
					local Skill = listMisc[string.lower(itemRefId)].skill 
					if CheckSkills(pid, Skill) == false then
						tes3mp.MessageBox(pid, -1, trad.NoSkillMisc..color.Red..Skill)
						Players[pid].data.quickKeys[slot] = {
							keyType = 0,
							itemId = "Misc_Potion_Cheap_01"
						}						
						reloadAtEnd = true
					end
				end
			end
		end
		if reloadAtEnd == true then
			logicHandler.RunConsoleCommandOnPlayer(pid, "player->additem Misc_Potion_Cheap_01 1")		
			Players[pid]:LoadQuickKeys() 
			logicHandler.RunConsoleCommandOnPlayer(pid, "player->removeitem Misc_Potion_Cheap_01 1")			
			return customEventHooks.makeEventStatus(false, false)
		end
	end
end

TFN_SystemClass.OnPlayerAuthentified = function(eventStatus, pid)
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		TFN_SystemClass.OnPlayerEquipment(true, pid)		
	end
end

customEventHooks.registerHandler("OnPlayerAuthentified", TFN_SystemClass.OnPlayerAuthentified)
customEventHooks.registerValidator("OnPlayerEquipment", TFN_SystemClass.OnPlayerEquipment)
customEventHooks.registerValidator("OnPlayerSpellbook", TFN_SystemClass.OnPlayerSpellbook)
customEventHooks.registerValidator("OnPlayerItemUse", TFN_SystemClass.OnPlayerItemUse)
customEventHooks.registerValidator("OnPlayerQuickKeys", TFN_SystemClass.OnPlayerQuickKeys)

return TFN_SystemClass
