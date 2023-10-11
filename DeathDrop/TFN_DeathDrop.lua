--[[
TFN_TFN_DeathDrop by Rickoff
tes3mp 0.8.1
---------------------------
DESCRIPTION :
Drop on the ground after death a gold
---------------------------
INSTALLATION:
Save the file as TFN_DeathDrop.lua inside your server/scripts/custom folder.

Edits to customScripts.lua
TFN_DeathDrop = require("custom.TFN_DeathDrop")

]]
local trad = {
	Gold = " gold.",
	Lose = "You lost "
}

local cfg = {
	pourcent = 5
}

local TFN_DeathDrop = {}

TFN_DeathDrop.OnPlayerDeath = function(eventStatus, pid)
	if eventStatus.validCustomHandlers then
		local goldLoc = inventoryHelper.getItemIndex(Players[pid].data.inventory, "gold_001", -1)		
		if goldLoc then
			local item = Players[pid].data.inventory[goldLoc]	
			local mpNum = WorldInstance:GetCurrentMpNum() + 1
			local cellDescription = tes3mp.GetCell(pid)
			if cellDescription then
				logicHandler.LoadCell(cellDescription)
				local location = {
					posX = tes3mp.GetPosX(pid), posY = tes3mp.GetPosY(pid), posZ = tes3mp.GetPosZ(pid),
					rotX = tes3mp.GetRotX(pid), rotY = 0, rotZ = tes3mp.GetRotZ(pid)
				}
				local refId = item.refId
				local totalcount = item.count
				local removeGold = math.floor((totalcount * cfg.pourcent) / 100)
				local reste = totalcount - removeGold
				local refIndex =  0 .. "-" .. mpNum
				local itemref = {refId = refId, count = removeGold, charge = -1, enchantmentCharge = -1, soul = ""}		
				Players[pid].data.inventory[goldLoc].count = reste
				Players[pid]:LoadItemChanges({itemref}, enumerations.inventory.REMOVE)	
				tes3mp.MessageBox(pid, -1, color.White..trad.Lose..color.Red..removeGold..color.White..trad.Gold)				
				logicHandler.CreateObjectAtLocation(cellDescription, location, dataTableBuilder.BuildObjectData(refId), "place")
			end
		end
	end
end

customEventHooks.registerHandler("OnPlayerDeath", TFN_DeathDrop.OnPlayerDeath)

return TFN_DeathDrop
