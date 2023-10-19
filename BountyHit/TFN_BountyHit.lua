--[[
TFN_BountyHit by Rickoff
tes3mp 0.8.1
---------------------------
DESCRIPTION :

---------------------------
INSTALLATION:
Save the file as TFN_BountyHit.lua inside your server/scripts/custom folder.
Edits to customScripts.lua :
TFN_BountyHit = require("custom.TFN_BountyHit")
---------------------------
]]
local cfg = {
    Bounty = 100,
	Distance = 2500
}

local function GetName(pid)
    return string.lower(Players[pid].accountName)
end

local function GetAdjacentCells(cellDescription)
	local cellX = tonumber(string.sub(cellDescription, 1, string.find(cellDescription, ",") - 1))
	local cellY = tonumber(string.sub(cellDescription, string.find(cellDescription, ",") + 2))
	local adjacentCells = {}
	for dx = -1, 1 do
		for dy = -1, 1 do
			local adjacentX = cellX + dx
			local adjacentY = cellY + dy
			local tempCell = (adjacentX..", "..adjacentY)
			table.insert(adjacentCells, tempCell)
		end
	end
	return adjacentCells
end

local function GetGuard(pid, cellDescription)
	local playerPosX = tes3mp.GetPosX(pid)
	local playerPosY = tes3mp.GetPosY(pid)
	if LoadedCells[cellDescription].isExterior then
		local listCell = GetAdjacentCells(cellDescription)
		for _, adjacentCell in ipairs(listCell) do
			LoadedCells[adjacentCell]:SaveActorPositions()		
			for _, uniqueIndex in ipairs(LoadedCells[adjacentCell].data.packets.actorList) do
				if LoadedCells[adjacentCell].data.objectData[uniqueIndex] 
				and string.find(LoadedCells[adjacentCell].data.objectData[uniqueIndex].refId, "guard") then
					if LoadedCells[adjacentCell].data.objectData[uniqueIndex].location then				
						local actorPosX = LoadedCells[adjacentCell].data.objectData[uniqueIndex].location.posX
						local actorPosY = LoadedCells[adjacentCell].data.objectData[uniqueIndex].location.posY			
						local distance = math.sqrt((playerPosX - actorPosX)^2 + (playerPosY - actorPosY)^2)
						if distance <= cfg.Distance then				
							return true
						end
					end
				end
			end
		end
	else
		LoadedCells[cellDescription]:SaveActorPositions()
		for _, uniqueIndex in ipairs(LoadedCells[cellDescription].data.packets.actorList) do
			if LoadedCells[cellDescription].data.objectData[uniqueIndex] 
			and string.find(LoadedCells[cellDescription].data.objectData[uniqueIndex].refId, "guard") then
				if LoadedCells[cellDescription].data.objectData[uniqueIndex].location then
					local actorPosX = LoadedCells[cellDescription].data.objectData[uniqueIndex].location.posX
					local actorPosY = LoadedCells[cellDescription].data.objectData[uniqueIndex].location.posY				
					local distance = math.sqrt((playerPosX - actorPosX)^2 + (playerPosY - actorPosY)^2  									
					if distance <= cfg.Distance then				
						return true
					end
				end
			end
		end
	end
	return false
end

local TFN_BountyHit = {}

TFN_BountyHit.OnObjectHit = function(eventStatus, pid, cellDescription, objects, targetPlayers)   
    for targetPid, targetPlayer in pairs(targetPlayers) do  
        local targetPlayerName = GetName(targetPid)     
        if targetPlayer.hittingPid and targetPlayer.hit.success then
            if GetGuard(pid, cellDescription) then
                Players[pid].data.fame.bounty = Players[pid].data.fame.bounty + cfg.Bounty                
                tes3mp.SetBounty(pid, Players[pid].data.fame.bounty)                
                tes3mp.SendBounty(pid)                
                tes3mp.MessageBox(pid, -1, "Your bounty just increased by "..cfg.Bounty.."\nfor hitting : "..targetPlayerName)                
            end
        end
    end
end

customEventHooks.registerHandler("OnObjectHit", TFN_BountyHit.OnObjectHit)

return TFN_BountyHit
