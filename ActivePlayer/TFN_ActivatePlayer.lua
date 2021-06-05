--[[
TFN_ActivatePlayer by Rickoff
tes3mp 0.7.0
---------------------------
DESCRIPTION :
Active player for resurrect
---------------------------
INSTALLATION:
Save the file as TFN_ActivatePlayer.lua inside your server/scripts/custom folder.
Save the file as MenuActive.lua inside your server/scripts/menu folder.
Edits to customScripts.lua :
TFN_ActivatePlayer = require("custom.TFN_ActivatePlayer")
Edits to config.lua :
add in config.menuHelperFiles, "MenuActive"
]]
local config = {}
config.pourcent = 25

local TFN_ActivatePlayer = {}

TFN_ActivatePlayer.ResurrectPlayer = function(pid)
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then	
		tes3mp.Resurrect(tonumber(pid), 0)
		local PlayerHealthBase = tes3mp.GetHealthBase(pid)
		local Pourcent = (PlayerHealthBase * config.pourcent) / 100
		tes3mp.SetHealthCurrent(pid, Pourcent)
		tes3mp.SendStatsDynamic(pid)
	end
end

TFN_ActivatePlayer.OnCheckStatePlayer = function(eventStatus, pid, cellDescription, objects, players)
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then	
		local PlayerPid
		for _, object in pairs(players) do
			PlayerPid = object.pid
		end	
		if Players[PlayerPid] ~= nil and Players[PlayerPid]:IsLoggedIn() then		
			Players[pid].data.targetPid = PlayerPid	
			Players[PlayerPid].data.targetPid = pid			
			local PlayerActivatedHealth = tes3mp.GetHealthCurrent(PlayerPid)	
			if PlayerActivatedHealth <= 0 then
				Players[pid].currentCustomMenu = "resurrect player"--Menu Resurrect
				menuHelper.DisplayMenu(pid, Players[pid].currentCustomMenu)				
			end
		end
	end
end

TFN_ActivatePlayer.OnDeathTime = function(eventStatus, pid)
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then 
		return customEventHooks.makeEventStatus(false,true)
	end
end

TFN_ActivatePlayer.OnDeathTimeExpiration = function(eventStatus, pid)
	if eventStatus.validCustomHandlers then
		local state = false
		if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
			for slot, k in pairs(Players[pid].data.spellbook) do
				if Players[pid].data.spellbook[slot] == "vampire sun damage" then
					state = true
					break
				end
			end	
			if state == false then
				Players[pid].currentCustomMenu = "resurrect"--Menu Resurrect
				menuHelper.DisplayMenu(pid, Players[pid].currentCustomMenu)	
			else 
				Players[pid].currentCustomMenu = "resurrectvamp"--Menu Resurrect Vamp
				menuHelper.DisplayMenu(pid, Players[pid].currentCustomMenu)	
			end
		end
	end
end

TFN_ActivatePlayer.ResVamp = function(pid)
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		contentFixer.UnequipDeadlyItems(pid)		
		tes3mp.SetCell(pid, "Balmora, temple") 			
		tes3mp.SetPos(pid, 3664, 4256, 14816)		
		tes3mp.SendCell(pid)    
		tes3mp.SendPos(pid)	
		tes3mp.Resurrect(pid,0)
	end
end		

TFN_ActivatePlayer.Res = function(pid)
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		Players[pid]:Resurrect()
	end
end

TFN_ActivatePlayer.ResurrectCheck = function(eventStatus, pid)
	TFN_ActivatePlayer.ResurrectProcess(pid)
	return customEventHooks.makeEventStatus(false,false)	
end	

TFN_ActivatePlayer.ResurrectProcess = function(pid)	
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then	
		if DragonDoor then
			DragonDoor.OnPlayerConnect(true, pid)
		end	
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
end

customEventHooks.registerHandler("OnObjectActivate", TFN_ActivatePlayer.OnCheckStatePlayer)
customEventHooks.registerValidator("OnPlayerResurrect", TFN_ActivatePlayer.ResurrectCheck)
customEventHooks.registerValidator("OnDeathTimeExpiration", TFN_ActivatePlayer.OnDeathTime)
customEventHooks.registerHandler("OnDeathTimeExpiration", TFN_ActivatePlayer.OnDeathTimeExpiration)
customCommandHooks.registerCommand("resurrectvamp", TFN_ActivatePlayer.ResVamp)
customCommandHooks.registerCommand("resurrect", TFN_ActivatePlayer.Res)

return TFN_ActivatePlayer
