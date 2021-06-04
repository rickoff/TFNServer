--[[
TFN_LevelingPlayer by Rickoff for Tales from Nirn server 
tes3mp 0.7.0
openmw 0.44
script 0.1
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
local trad = {}
trad.Feli = "You have gained a level, congratulation : "
trad.Menu = "/level"
trad.Dep = " to spend your points"
trad.Xps = "skill."
trad.NotPts = "You don't have enough skill points to decrease"
trad.NoPt =  "You don't have enough skill points, current : "
trad.Req = " required : "
trad.WereWolf = "Skill menu is forbidden in werewolf form"

local config = {}
config.levelMax = 50
config.PlayerAddPoint = 555555

local PlayerOptionPoint = {}

local TFN_LevelingPlayer = {}

local function getName(pid)
	return string.lower(Players[pid].accountName)
end

TFN_LevelingPlayer.InputDialog = function(pid, comp, state)
	PlayerOptionPoint[getName(pid)] = {comp = comp, state = state}
	local message = "Enter the number of points"
	if state == "Add" then
		return tes3mp.InputDialog(pid, config.PlayerAddPoint, message, "add skill points")
	elseif state == "Remove" then
		return tes3mp.InputDialog(pid, config.PlayerAddPoint, message, "remove skill points")
	end	
end

TFN_LevelingPlayer.OnGUIAction = function(pid, idGui, data)
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then 
		if idGui == config.PlayerAddPoint then
			TFN_LevelingPlayer.OnPlayerCompetence(pid, PlayerOptionPoint[getName(pid)].comp, PlayerOptionPoint[getName(pid)].state, tonumber(data))
			Players[pid].currentCustomMenu = "menu leveling"
			return true, menuHelper.DisplayMenu(pid, Players[pid].currentCustomMenu)			
		end
	end
end	 

TFN_LevelingPlayer.OnPlayerCompetence = function(pid, Comp, State, Count)
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then	
	
		local PointCount = Players[pid].data.customVariables.TfnLeveling.pointSoul
		
		local Count = Count or 0

		if Comp ~= nil and PointCount >= Count and State == "Add" then	
			if CheckComp(Comp) == "skill" then
				local skillId = tes3mp.GetSkillId(Comp)
				local valueC = Players[pid].data.skills[Comp].base + Count
				tes3mp.SetSkillBase(pid, skillId, valueC)
				Players[pid].data.customVariables.TfnLeveling.pointSoul = Players[pid].data.customVariables.TfnLeveling.pointSoul - Count	
				Players[pid].data.customVariables.TfnLeveling[Comp] = Players[pid].data.customVariables.TfnLeveling[Comp] + Count
			else
				local attrId = tes3mp.GetAttributeId(Comp)
				local valueS = Players[pid].data.attributes[Comp].base + Count	
				tes3mp.SetAttributeBase(pid, attrId, valueS)
				Players[pid].data.customVariables.TfnLeveling.pointSoul = Players[pid].data.customVariables.TfnLeveling.pointSoul - Count
				Players[pid].data.customVariables.TfnLeveling[Comp] = Players[pid].data.customVariables.TfnLeveling[Comp] + Count
			end	
		elseif Comp ~= nil and Players[pid].data.customVariables.TfnLeveling[Comp] >= Count and State == "Remove" then	
			if CheckComp(Comp) == "skill" then		
				local skillId = tes3mp.GetSkillId(Comp)
				local valueC = Players[pid].data.skills[Comp].base - Count
				tes3mp.SetSkillBase(pid, skillId, valueC)
				Players[pid].data.customVariables.TfnLeveling.pointSoul = Players[pid].data.customVariables.TfnLeveling.pointSoul + Count	
				Players[pid].data.customVariables.TfnLeveling[Comp] = Players[pid].data.customVariables.TfnLeveling[Comp] - Count
			else
				local attrId = tes3mp.GetAttributeId(Comp)
				local valueS = Players[pid].data.attributes[Comp].base - Count	
				tes3mp.SetAttributeBase(pid, attrId, valueS)
				Players[pid].data.customVariables.TfnLeveling.pointSoul = Players[pid].data.customVariables.TfnLeveling.pointSoul + Count
				Players[pid].data.customVariables.TfnLeveling[Comp] = Players[pid].data.customVariables.TfnLeveling[Comp] - Count
			end
		end

		Players[pid]:SaveAttributes()	
		Players[pid]:SaveSkills()			
		tes3mp.SendAttributes(pid)
		tes3mp.SendSkills(pid)
	end
end	

TFN_LevelingPlayer.MainMenu = function(pid)
    if Players[pid]~= nil and Players[pid]:IsLoggedIn() then
		if not tes3mp.IsWerewolf(pid) then
			Players[pid].currentCustomMenu = "menu leveling"
			menuHelper.DisplayMenu(pid, Players[pid].currentCustomMenu)
		else
			tes3mp.MessageBox(pid, -1, trad.WereWolf)
		end
	end
end

TFN_LevelingPlayer.LevelPlayer = function(eventStatus, pid)	
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then		
		local player = Players[pid]		
		if player.data.stats.level >= config.levelMax then
			player.data.stats.level = config.levelMax
			player.data.stats.levelProgress = 0
			player:LoadLevel()
			return customEventHooks.makeEventStatus(false,false)				
		end	
		TFN_LevelingPlayer.GetlevelSoul(pid)		
		player:QuicksaveToDrive()
	end
end

TFN_LevelingPlayer.GetlevelSoul = function(pid)
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		if player.data.stats.levelProgress >= 20 then			
			Players[pid].data.customVariables.TfnLeveling.pointSoul = Players[pid].data.customVariables.TfnLeveling.pointSoul + 10
			TFN_LevelingPlayer.NewLevelPlayer(pid)
			tes3mp.MessageBox(pid, -1, color.Default..trad.Feli..color.Green..trad.Menu..color.Default..trad.Dep..color.Yellow..trad.Xps)
		end
	end
end

TFN_LevelingPlayer.NewLevelPlayer = function(pid)	
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then		
		local player = Players[pid]
		if player.data.stats.level < config.levelMax then
			player.data.stats.level = player.data.stats.level + 1
			player.data.stats.levelProgress = 0 
			player:LoadLevel()
		end
		player:QuicksaveToDrive()
	end
end

TFN_LevelingPlayer.OnPlayerAddCustom = function(eventStatus, pid) 
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		if not Players[pid].data.customVariables.TfnLeveling then
			Players[pid].data.customVariables.TfnLeveling = {}
			Players[pid].data.customVariables.TfnLeveling.pointSoul = 0	
			for attribute, slot in pairs(Players[pid].data.attributes) do
				Players[pid].data.customVariables.TfnLeveling[attribute] = 0
			end
			for skill, slot in pairs(Players[pid].data.skills) do
				Players[pid].data.customVariables.TfnLeveling[skill] = 0
			end				
			Players[pid]:QuicksaveToDrive()			
		end		
	end
end

customCommandHooks.registerCommand("level", TFN_LevelingPlayer.MainMenu)
customEventHooks.registerValidator("OnPlayerLevel", TFN_LevelingPlayer.LevelPlayer)
customEventHooks.registerHandler("OnPlayerAuthentified", TFN_LevelingPlayer.OnPlayerAddCustom)
customEventHooks.registerHandler("OnGUIAction", function(eventStatus, pid, idGui, data)
	if TFN_LevelingPlayer.OnGUIAction(pid, idGui, data) then return end
end)

return TFN_LevelingPlayer
