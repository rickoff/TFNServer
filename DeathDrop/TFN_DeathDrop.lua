--[[
TFN_TFN_DeathDrop by Rickoff
tes3mp 0.7.0
---------------------------
DESCRIPTION :
Drop on the ground after death a gold
---------------------------
INSTALLATION:
Save the file as TFN_DeathDrop.lua inside your server/scripts/custom folder.

Edits to customScripts.lua
TFN_DeathDrop = require("custom.TFN_DeathDrop")

]]
local trad = {}
trad.Gold = " gold."
trad.Lose = "You lost : "

local config = {}
config.pourcent = 5

local TFN_DeathDrop = {}

TFN_DeathDrop.Drop = function(eventStatus, pid)
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		if eventStatus.validCustomHandlers then
			local player = Players[pid]
			local goldLoc = inventoryHelper.getItemIndex(player.data.inventory, "gold_001", -1)
			
			if goldLoc then
				local item = player.data.inventory[goldLoc]	
				local mpNum = WorldInstance:GetCurrentMpNum() + 1
				local cell = tes3mp.GetCell(pid)
				if cell ~= nil then
					logicHandler.LoadCell(cell)
					local location = {
						posX = tes3mp.GetPosX(pid), posY = tes3mp.GetPosY(pid), posZ = tes3mp.GetPosZ(pid),
						rotX = tes3mp.GetRotX(pid), rotY = 0, rotZ = tes3mp.GetRotZ(pid)
					}
					local refId = item.refId
					local totalcount = item.count
					local removeGold = math.floor((totalcount * config.pourcent) / 100)
					local reste = totalcount - removeGold
					local refIndex =  0 .. "-" .. mpNum
					local itemref = {refId = "gold_001", count = (removeGold), charge = -1, soul = ""}		
					player.data.inventory[goldLoc].count = reste
					Players[pid]:QuicksaveToDrive()
					Players[pid]:LoadItemChanges({itemref}, enumerations.inventory.REMOVE)	
					tes3mp.MessageBox(pid, -1, color.White..trad.Lose..color.Red..removeGold..color.White..trad.Gold)
					
					WorldInstance:SetCurrentMpNum(mpNum)
					tes3mp.SetCurrentMpNum(mpNum)

					LoadedCells[cell]:InitializeObjectData(refIndex, refId)		
					LoadedCells[cell].data.objectData[refIndex].location = location		
					LoadedCells[cell].data.objectData[refIndex].goldValue = removeGold		
					table.insert(LoadedCells[cell].data.packets.place, refIndex)

					for onlinePid, player in pairs(Players) do
						if Players[onlinePid] ~= nil and Players[onlinePid]:IsLoggedIn() then
							tes3mp.InitializeEvent(onlinePid)
							tes3mp.SetEventCell(cell)
							tes3mp.SetObjectRefId(refId)
							tes3mp.SetObjectCount(removeGold)
							tes3mp.SetObjectRefNumIndex(0)
							tes3mp.SetObjectMpNum(mpNum)
							tes3mp.SetObjectPosition(location.posX, location.posY, location.posZ)
							tes3mp.SetObjectRotation(location.rotX, location.rotY, location.rotZ)
							tes3mp.AddWorldObject()
							tes3mp.SendObjectPlace()
						end
					end
					LoadedCells[cell]:QuicksaveToDrive()
				end
			end
		end
	end
end

customEventHooks.registerHandler("OnPlayerDeath", TFN_DeathDrop.Drop)

return TFN_DeathDrop
