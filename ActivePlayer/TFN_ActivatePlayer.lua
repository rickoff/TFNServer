--[[
TFN_ActivatePlayer by Rickoff
tes3mp 0.8.1
---------------------------
DESCRIPTION :
Active player for resurrect
---------------------------
INSTALLATION:
Save the file as TFN_ActivatePlayer.lua inside your server/scripts/custom folder.
Edits to customScripts.lua :
TFN_ActivatePlayer = require("custom.TFN_ActivatePlayer")
---------------------------
USE:
/res in chat for open menu resurrection
]]
local cfg = {
	pourcent = 25
}

local gui = {
	ResurectGUI = 10102023,
	ResurectTargetGUI = 11102023
}

local function GetName(pid)
	return string.lower(Players[pid].accountName)
end

local function ResurrectProcess(pid)	
	local currentResurrectType
	if config.respawnAtImperialShrine == true then
		if config.respawnAtTribunalTemple == true then
			if math.random() > 0.5 then
				currentResurrectType = enumerations.resurrect.IMPERIAL_SHRINE
			else
				currentResurrectType = enumerations.resurrect.TRIBUNAL_TEMPLE
			end
		else
			currentResurrectType = enumerations.resurrect.IMPERIAL_SHRINE
		end
	elseif config.respawnAtTribunalTemple == true then
		currentResurrectType = enumerations.resurrect.TRIBUNAL_TEMPLE
	elseif config.defaultRespawnCell ~= nil then
		currentResurrectType = enumerations.resurrect.REGULAR
		tes3mp.SetCell(pid, config.defaultRespawnCell)
		tes3mp.SendCell(pid)
		if config.defaultRespawnPos ~= nil and config.defaultRespawnRot ~= nil then
			tes3mp.SetPos(pid, config.defaultRespawnPos[1], config.defaultRespawnPos[2], config.defaultRespawnPos[3])
			tes3mp.SetRot(pid, config.defaultRespawnRot[1], config.defaultRespawnRot[2])
			tes3mp.SendPos(pid)
		end
	end
	local message = "You have been revived"
	if currentResurrectType == enumerations.resurrect.IMPERIAL_SHRINE then
		message = message .. " at the nearest shrine"
	elseif currentResurrectType == enumerations.resurrect.TRIBUNAL_TEMPLE then
		message = message .. " to the nearest temple"
	end
	message = message .. ".\n"
	if Players[pid].data.shapeshift.isWerewolf == true then
		Players[pid]:SetWerewolfState(false)
	end
	contentFixer.UnequipDeadlyItems(pid)
	tes3mp.Resurrect(pid, currentResurrectType)
	tes3mp.SendMessage(pid, message, false)
end

local function ResurrectPlayer(pid)
	tes3mp.Resurrect(tonumber(pid), 0)
	local PlayerHealthBase = tes3mp.GetHealthBase(pid)
	local Pourcent = (PlayerHealthBase * cfg.pourcent) / 100
	tes3mp.SetHealthCurrent(pid, Pourcent)
	tes3mp.SendStatsDynamic(pid)
end

local function ShowResurectGUI(pid)
	local message = (
		color.Red.."You are unconcious.\n"..
		color.White.."You can wait for another player\n"..
		color.White.."or respawn at the nearest temple."
	)
	local bouton = "Respawn;Wait"
	tes3mp.CustomMessageBox(pid, gui.ResurectGUI, message, bouton)
end

local function ShowResurectTargetGUI(pid, targetPid)
	local targetName = GetName(targetPid)
	local message = (
		color.White.."Do you want to "..
		color.Gold.."help\n"..
		color.White..targetName.." ?"
	)
	local bouton = "Patch them up;Leave them there"
	tes3mp.CustomMessageBox(pid, gui.ResurectTargetGUI, message, bouton)
end

local TFN_ActivatePlayer = {}

TFN_ActivatePlayer.OnObjectActivate = function(eventStatus, pid, cellDescription, objects, players)	
	local TargetPid
	for _, object in pairs(players) do
		TargetPid = object.pid
	end	
	if Players[TargetPid] and Players[TargetPid]:IsLoggedIn() then		
		Players[pid].data.targetPid = TargetPid	
		Players[TargetPid].data.targetPid = pid			
		local PlayerActivatedHealth = tes3mp.GetHealthCurrent(TargetPid)	
		if PlayerActivatedHealth <= 0 then
			ShowResurectTargetGUI(pid, TargetPid)
		end
	end
end

TFN_ActivatePlayer.OnDeathTimeExpirationValidator = function(eventStatus, pid)
	return customEventHooks.makeEventStatus(false,true)
end

TFN_ActivatePlayer.OnDeathTimeExpirationHandler = function(eventStatus, pid)
	if eventStatus.validCustomHandlers then
		ShowResurectGUI(pid)
	end
end		

TFN_ActivatePlayer.CommandRes = function(pid)
	local PlayerActivatedHealth = tes3mp.GetHealthCurrent(pid)	
	if PlayerActivatedHealth <= 0 then
		ShowResurectGUI(pid)
	end
end

TFN_ActivatePlayer.OnGuiMenu = function(eventStatus, pid, idGui, data)
	if idGui == gui.ResurectGUI then		
		if tonumber(data) == 0 then
			ResurrectProcess(pid)			
		end
	end	
	if idGui == gui.ResurectTargetGUI then		
		if tonumber(data) == 0 then
			ResurrectPlayer(Players[pid].data.targetPid)
		end
	end	
end

customEventHooks.registerHandler("OnGUIAction", TFN_ActivatePlayer.OnGuiMenu)
customEventHooks.registerHandler("OnObjectActivate", TFN_ActivatePlayer.OnObjectActivate)
customEventHooks.registerValidator("OnDeathTimeExpiration", TFN_ActivatePlayer.OnDeathTimeExpirationValidator)
customEventHooks.registerHandler("OnDeathTimeExpiration", TFN_ActivatePlayer.OnDeathTimeExpirationHandler)
customCommandHooks.registerCommand("res", TFN_ActivatePlayer.CommandRes)

return TFN_ActivatePlayer
