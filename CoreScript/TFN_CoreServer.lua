--[[
TFN_CoreServer by Rickoff
tes3mp 0.8.1
---------------------------
DESCRIPTION :
CoreScript Server
---------------------------
INSTALLATION:
Save the file as TFN_CoreServer.lua inside your server/scripts/custom folder.
Edits to customScripts.lua :
TFN_CoreServer = require("custom.TFN_CoreServer")
---------------------------
]]
local trad = {
	Welcome = (
		color.Red.."Welcome to Tales From Nirn !"..
		color.Default.."\n\nthe server for the TFN community!"..
		color.Green.."\n\nReboot :"..color.White.."\nevery day at : "..color.Yellow.."6am\n"..
		color.Default.."\n\nPlease read the rules for everyone's convenience on our discord : \n"..color.Cyan.."\nhttps://discord.gg/VD7Mw4yZXN\n"..
		color.Red.."\nWarning :\n"..color.White.."\nAll forms of cheating is strictly prohibited.\n"..
		color.Green.."\nGood game everyone. \n\n"
	)
}

local cfg = {
	listCell = {"Ebonheart, Hawkmoth Legion Garrison"},
	Teleporting = true,
	Levitation = true,
	PlayerJumping = true,
	PlayerFighting = false,
	PlayerLooking = false,
	PlayerMagic = false,
	PlayerViewSwitch = false,
	VanityMode = false 
}

local TFN_CoreServer = {}

TFN_CoreServer.OnGUIAction = function(eventStatus, pid, idGui, data)
    if Players[pid] ~= nil then    
        data = tostring(data)      
	if Players[pid]:IsLoggedIn() then		
		if idGui == config.customMenuIds.confiscate and Players[pid].confiscationTargetName ~= nil then
			local targetName = Players[pid].confiscationTargetName
			local targetPlayer = logicHandler.GetPlayerByName(targetName)
			local inventoryItemIndex = data + 1
			local item = targetPlayer.data.inventory[inventoryItemIndex]
			if item ~= nil then
				inventoryHelper.addItem(Players[pid].data.inventory, item.refId, item.count, item.charge, item.enchantmentCharge, item.soul)
				Players[pid]:LoadItemChanges({item}, enumerations.inventory.ADD)
				if inventoryHelper.containsItem(targetPlayer.data.equipment, item.refId, item.charge) then
					local equipmentItemIndex = inventoryHelper.getItemIndex(targetPlayer.data.equipment, item.refId, item.charge)
					targetPlayer.data.equipment[equipmentItemIndex] = nil
				end
				targetPlayer.data.inventory[inventoryItemIndex] = nil
				tableHelper.cleanNils(targetPlayer.data.inventory)
				Players[pid]:Message("You've confiscated "..item.refId.." from "..targetName.."\n")
				if targetPlayer:IsLoggedIn() then
					targetPlayer:LoadItemChanges({item}, enumerations.inventory.REMOVE)
				end
			else
				Players[pid]:Message("Invalid item index\n")
			end
			targetPlayer:SetConfiscationState(false)
			targetPlayer:QuicksaveToDrive()
			Players[pid].confiscationTargetName = nil
		elseif idGui == config.customMenuIds.menuHelper and Players[pid].currentCustomMenu ~= nil then
			local buttonIndex = tonumber(data) + 1
			local buttonPressed = Players[pid].displayedMenuButtons[buttonIndex]
			local destination = menuHelper.GetButtonDestination(pid, buttonPressed)
			menuHelper.ProcessEffects(pid, destination.effects)
			menuHelper.DisplayMenu(pid, destination.targetMenu)
			Players[pid].previousCustomMenu = Players[pid].currentCustomMenu
			Players[pid].currentCustomMenu = destination.targetMenu
		end
	else
		if idGui == guiHelper.ID.LOGIN then
			if data == nil then
				Players[pid]:Message("Incorrect password!\n")
				guiHelper.ShowLogin(pid)
				return customEventHooks.makeEventStatus(false,false) 
			end
			Players[pid]:LoadFromDrive()
			if tostring(Players[pid].data.login.password) ~= data then
				Players[pid]:Message("Incorrect password!\n")
				guiHelper.ShowLogin(pid)
				return customEventHooks.makeEventStatus(false,false) 
			end
			if tableHelper.containsValue(banList.playerNames, string.lower(Players[pid].accountName)) == true then
				Players[pid]:SaveIpAddress()
				Players[pid]:Message(Players[pid].accountName .. " is banned from this server.\n")
				tes3mp.BanAddress(tes3mp.GetIP(pid))
			else
				Players[pid]:FinishLogin()
				Players[pid]:Message("You have successfully logged in.\n" .. config.chatWindowInstructions)
				tes3mp.CustomMessageBox(pid, -1, trad.Welcome, "Ok")
				if Players[pid].data.customVariables.Jailer == nil then
					Players[pid].data.customVariables.Jailer = false
				elseif Players[pid].data.customVariables.Jailer == true then	
					TFN_HousingShop.PunishPrison(pid)
				end						
			end
		elseif idGui == guiHelper.ID.REGISTER then
			if data == nil then
				Players[pid]:Message("Password can not be empty\n")
				guiHelper.ShowRegister(pid)
				return customEventHooks.makeEventStatus(false,false) 
			end
			Players[pid]:Register(data)
			Players[pid]:Message("You have successfully registered.\n" .. config.chatWindowInstructions)
			tes3mp.CustomMessageBox(pid, -1, trad.Welcome, "Ok")
		end
	end	
	return customEventHooks.makeEventStatus(false,false) 
    end
end

TFN_CoreServer.OnPlayerCellChange = function(eventStatus, pid, playerPacket, previousCellDescription)	
	local cellDescription = playerPacket.location.cell
	local BlockCurrent 	
	if Players[pid].data.customVariables.Block == nil then
		Players[pid].data.customVariables.Block = false		
		BlockCurrent = Players[pid].data.customVariables.Block
	else
		BlockCurrent = Players[pid].data.customVariables.Block
	end		
	if tableHelper.containsValue(cfg.listCell, cellDescription) and BlockCurrent == false then
		if cfg.Teleporting == true then logicHandler.RunConsoleCommandOnPlayer(pid, "DisableTeleporting", false) end
		if cfg.Levitation == true then logicHandler.RunConsoleCommandOnPlayer(pid, "DisableLevitation", false) end
		if cfg.PlayerFighting == true then logicHandler.RunConsoleCommandOnPlayer(pid, "DisablePlayerFighting", false) end
		if cfg.PlayerJumping == true then logicHandler.RunConsoleCommandOnPlayer(pid, "DisablePlayerJumping", false) end
		if cfg.PlayerLooking == true then logicHandler.RunConsoleCommandOnPlayer(pid, "DisablePlayerLooking", false) end
		if cfg.PlayerMagic == true then logicHandler.RunConsoleCommandOnPlayer(pid, "DisablePlayerMagic", false) end
		if cfg.PlayerViewSwitch == true then logicHandler.RunConsoleCommandOnPlayer(pid, "DisablePlayerViewSwitch", false) end
		if cfg.VanityMode == true then logicHandler.RunConsoleCommandOnPlayer(pid, "DisableVanityMode", false) end
		local skillId = tes3mp.GetSkillId("Sneak")			
		tes3mp.SetSkillDamage(pid, skillId, 200)
		tes3mp.SendSkills(pid)
		Players[pid].data.customVariables.Block = true		
	elseif not tableHelper.containsValue(cfg.listCell, cellDescription) and BlockCurrent == true then
		if cfg.Teleporting == true then logicHandler.RunConsoleCommandOnPlayer(pid, "EnableTeleporting", false) end
		if cfg.Levitation == true then logicHandler.RunConsoleCommandOnPlayer(pid, "EnableLevitation", false) end
		if cfg.PlayerFighting == true then logicHandler.RunConsoleCommandOnPlayer(pid, "EnablePlayerFighting", false) end
		if cfg.PlayerJumping == true then logicHandler.RunConsoleCommandOnPlayer(pid, "EnablePlayerJumping", false) end
		if cfg.PlayerLooking == true then logicHandler.RunConsoleCommandOnPlayer(pid, "EnablePlayerLooking", false) end
		if cfg.PlayerMagic == true then logicHandler.RunConsoleCommandOnPlayer(pid, "EnablePlayerMagic", false) end
		if cfg.PlayerViewSwitch == true then logicHandler.RunConsoleCommandOnPlayer(pid, "EnablePlayerViewSwitch", false) end
		if cfg.VanityMode == true then logicHandler.RunConsoleCommandOnPlayer(pid, "EnableVanityMode", false) end
		local skillId = tes3mp.GetSkillId("Sneak")			
		tes3mp.SetSkillDamage(pid, skillId, 0)
		tes3mp.SendSkills(pid)			
		Players[pid].data.customVariables.Block = false 	
	end	
end

TFN_CoreServer.OnPlayerDeath = function(eventStatut, pid)	
	logicHandler.RunConsoleCommandOnPlayer(pid, "DisablePlayerControls", false)
end

TFN_CoreServer.OnPlayerResurrect = function(eventStatut, pid)
	logicHandler.RunConsoleCommandOnPlayer(pid, "EnablePlayerControls", false)	
end

customEventHooks.registerHandler("OnPlayerResurrect", TFN_CoreServer.OnPlayerResurrect)
customEventHooks.registerHandler("OnPlayerDeath", TFN_CoreServer.OnPlayerDeath)
customEventHooks.registerHandler("OnPlayerCellChange", TFN_CoreServer.OnPlayerCellChange)
customEventHooks.registerValidator("OnGUIAction", TFN_CoreServer.OnGUIAction)

return TFN_CoreServer
