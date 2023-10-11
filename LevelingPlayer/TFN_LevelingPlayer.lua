--[[
TFN_LevelingPlayer by Rickoff for Tales from Nirn server 
tes3mp 0.8.1
script 0.2
---------------------------
DESCRIPTION :
Leveling sytem
---------------------------
INSTALLATION:
Save the file as TFN_LevelingPlayer.lua inside your server/scripts/custom folder.
Save the file as MenuLeveling.lua inside your scripts/menu folder
Edits to customScripts.lua
TFN_LevelingPlayer = require("custom.TFN_LevelingPlayer")
Edits to config.lua
add in config.menuHelperFiles, "MenuLeveling"
---------------------------
FUNCTION:
/level in your chat for open menu
---------------------------
]]
-- ===========
--MAIN CONFIG
-- ===========
-------------------------
local trad = {
	Feli = "You have gained a level, congratulation : ",
	Menu = "/level",
	Dep = " to spend your points",
	Xps = " skill.",
	NotPts = "You don't have enough skill points to decrease",
	NoPt =  "You don't have enough skill points, current : ",
	Req = " required : ",
	WereWolf = "Skill menu is forbidden in werewolf form"
}

local cfg = {
	levelMax = 50,
	LevelHealth = 10,
	talentProgress = 10,
	RewardPoints = 10,
	PlayerAddPoint = 555555
}

local PlayerOptionPoint = {}

local function getName(pid)
	return string.lower(Players[pid].accountName)
end

local TFN_LevelingPlayer = {}

TFN_LevelingPlayer.InputDialog = function(pid, comp, state)
	PlayerOptionPoint[getName(pid)] = {comp = comp, state = state}
	local message = "Enter the number of points"
	if state == "Add" then
		return tes3mp.InputDialog(pid, cfg.PlayerAddPoint, message, "add skill points")
	elseif state == "Remove" then
		return tes3mp.InputDialog(pid, cfg.PlayerAddPoint, message, "remove skill points")
	end
end

TFN_LevelingPlayer.OnGUIAction = function(pid, idGui, data)
	if idGui == cfg.PlayerAddPoint then
		TFN_LevelingPlayer.OnPlayerCompetence(pid, PlayerOptionPoint[getName(pid)].comp, PlayerOptionPoint[getName(pid)].state, tonumber(data))
		Players[pid].currentCustomMenu = "menu leveling"
		return true, menuHelper.DisplayMenu(pid, Players[pid].currentCustomMenu)			
	end
end	 

TFN_LevelingPlayer.OnPlayerCompetence = function(pid, Comp, State, Count)	
	local PointCount = Players[pid].data.customVariables.TfnLeveling.pointSoul	
	local Count = Count or 0
	local Check = "Nothing"
	local Type = "Nothing"	
	if Comp ~= nil then	
		if Players[pid].data.skills[Comp] then
			Type = "skill"
		elseif Players[pid].data.attributes[Comp] then
			Type = "attribute"
		end		
		if PointCount >= Count and State == "Add" then	
			if Type == "skill" then
				local skillId = tes3mp.GetSkillId(Comp)
				local valueC = Players[pid].data.skills[Comp].base + Count
				tes3mp.SetSkillBase(pid, skillId, valueC)
				Players[pid].data.customVariables.TfnLeveling.pointSoul = Players[pid].data.customVariables.TfnLeveling.pointSoul - Count	
				Players[pid].data.customVariables.TfnLeveling[Comp] = Players[pid].data.customVariables.TfnLeveling[Comp] + Count
				Check = "skill"
			else
				local attrId = tes3mp.GetAttributeId(Comp)
				local valueS = Players[pid].data.attributes[Comp].base + Count	
				tes3mp.SetAttributeBase(pid, attrId, valueS)
				Players[pid].data.customVariables.TfnLeveling.pointSoul = Players[pid].data.customVariables.TfnLeveling.pointSoul - Count
				Players[pid].data.customVariables.TfnLeveling[Comp] = Players[pid].data.customVariables.TfnLeveling[Comp] + Count
				Check = "attribute"
			end
		elseif PointCount < Count and State == "Add" then
			tes3mp.MessageBox(pid, -1, color.Default..trad.NoPt..PointCount)
		end		
		if Players[pid].data.customVariables.TfnLeveling[Comp] >= Count and State == "Remove" then	
			if Type == "skill" then		
				local skillId = tes3mp.GetSkillId(Comp)
				local valueC = Players[pid].data.skills[Comp].base - Count
				tes3mp.SetSkillBase(pid, skillId, valueC)
				Players[pid].data.customVariables.TfnLeveling.pointSoul = Players[pid].data.customVariables.TfnLeveling.pointSoul + Count	
				Players[pid].data.customVariables.TfnLeveling[Comp] = Players[pid].data.customVariables.TfnLeveling[Comp] - Count
				Check = "skill"
			else
				local attrId = tes3mp.GetAttributeId(Comp)
				local valueS = Players[pid].data.attributes[Comp].base - Count	
				tes3mp.SetAttributeBase(pid, attrId, valueS)
				Players[pid].data.customVariables.TfnLeveling.pointSoul = Players[pid].data.customVariables.TfnLeveling.pointSoul + Count
				Players[pid].data.customVariables.TfnLeveling[Comp] = Players[pid].data.customVariables.TfnLeveling[Comp] - Count
				Check = "attribute"				
			end
		elseif Players[pid].data.customVariables.TfnLeveling[Comp] < Count and State == "Remove" then
			tes3mp.MessageBox(pid, -1, color.Default..trad.NotPts)
		end		
		if Check == "attribute" then
			Players[pid]:SaveAttributes()	
			tes3mp.SendAttributes(pid)	
		elseif Check == "skill" then
			Players[pid]:SaveSkills()			
			tes3mp.SendSkills(pid)
		end
	end
end	

TFN_LevelingPlayer.MainMenu = function(pid)
	if not tes3mp.IsWerewolf(pid) then
		Players[pid].currentCustomMenu = "menu leveling"
		menuHelper.DisplayMenu(pid, Players[pid].currentCustomMenu)
	else
		tes3mp.MessageBox(pid, -1, trad.WereWolf)
	end
end

TFN_LevelingPlayer.OnPlayerLevelValidator = function(eventStatus, pid)	
	if Players[pid].data.stats.level >= cfg.levelMax then
		Players[pid].data.stats.level = cfg.levelMax
		Players[pid].data.stats.levelProgress = 0
		Players[pid]:LoadLevel()
		return customEventHooks.makeEventStatus(false,false)				
	end
end

TFN_LevelingPlayer.OnPlayerLevelHandler = function(eventStatus, pid)
	if Players[pid].data.stats.levelProgress >= cfg.talentProgress then			
		Players[pid].data.customVariables.TfnLeveling.pointSoul = Players[pid].data.customVariables.TfnLeveling.pointSoul + cfg.RewardPoints
		TFN_LevelingPlayer.NewLevelPlayer(pid)
		tes3mp.MessageBox(pid, -1, color.Default..trad.Feli..color.Green..trad.Menu..color.Default..trad.Dep..color.Yellow..trad.Xps)
	end
end

TFN_LevelingPlayer.NewLevelPlayer = function(pid)	
	if Players[pid].data.stats.level < cfg.levelMax then
		Players[pid].data.stats.level = Players[pid].data.stats.level + 1
		Players[pid].data.stats.levelProgress = 0 
		tes3mp.SetHealthBase(pid, (Players[pid].data.stats.healthBase + cfg.LevelHealth)) 
		Players[pid]:LoadLevel()
		Players[pid]:SaveStatsDynamic()
		tes3mp.SendStatsDynamic(pid)
	end
end

TFN_LevelingPlayer.OnPlayerAuthentified = function(eventStatus, pid)
	if not Players[pid].data.customVariables.TfnLeveling then
		Players[pid].data.customVariables.TfnLeveling = {}
		Players[pid].data.customVariables.TfnLeveling.pointSoul = 0	
		for attribute, slot in pairs(Players[pid].data.attributes) do
			Players[pid].data.customVariables.TfnLeveling[attribute] = 0
		end
		for skill, slot in pairs(Players[pid].data.skills) do
			Players[pid].data.customVariables.TfnLeveling[skill] = 0
		end			
	end
end

customCommandHooks.registerCommand("level", TFN_LevelingPlayer.MainMenu)
customEventHooks.registerValidator("OnPlayerLevel", TFN_LevelingPlayer.OnPlayerLevelValidator)
customEventHooks.registerHandler("OnPlayerLevel", TFN_LevelingPlayer.OnPlayerLevelHandler)
customEventHooks.registerHandler("OnPlayerAuthentified", TFN_LevelingPlayer.OnPlayerAuthentified)
customEventHooks.registerHandler("OnGUIAction", function(eventStatus, pid, idGui, data)
	if TFN_LevelingPlayer.OnGUIAction(pid, idGui, data) then return end
end)

return TFN_LevelingPlayer
