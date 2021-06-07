--[[
TFN_Decorate by Rickoff
tes3mp 0.7.0
---------------------------
DESCRIPTION :

---------------------------
INSTALLATION:
Save the file as TFN_Decorate.lua inside your server/scripts/custom folder.

Edits to customScripts.lua
TFN_Decorate = require("custom.TFN_Decorate")

Edits cell/base.lua :
add in function SaveObjectsPlaced under self.data.objectData[uniqueIndex].location = location
self.data.objectData[uniqueIndex].scale = 1
tableHelper.insertValueIfMissing(self.data.packets.scale, uniqueIndex)
---------------------------
]]
local config = {
	MainId = 31360,
	PromptId = 31361
}
------
local trad = {
	prompt = "] - Enter a number to add / subtract",
	rotx = "Turn X",
	roty = "Turn Y",
	rotz = "Turn Z",
	movn = "+/- North",
	move = "+/- East",
	movup = "+/- Height",
	up = "Up",
	down = "Down",
	east = "East",
	west = "West",
	north = "North",
	sud = "South",
	bigger = "Bigger",
	Lower = "Smaller",
	drop = "Grab",
	noselect = "No object selected.",
	nooption = "Object cannot be modified.",
	placeobjet = "The object has just been placed.",
	warningcell = "Be careful, the object is leaving the area !!!",
	info = "To place the object, switch to stealth mode.\nTo rotate, take out your weapon or your magic.",
	opt1 = "Choose an option. Your current article : ",
	opt2 = "Adjust North;Adjust East;Adjust Height;Turn X;Turn Y;Turn Z;Up;Down;East;West;North;South;Bigger;Smaller;Grab;Return" 
}
------

local TimerDrop = tes3mp.CreateTimer("StartDrop", time.seconds(0.01))
local playerSelectedObject = {}
local playerCurrentMode = {}
local playersTab = { player = {} }

local TFN_Decorate = {}

function StartDrop()	
	for pid, value in pairs(playersTab.player) do
		if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
			local namep = playersTab.player[pid].name
			for pid1, value in pairs(Players) do	
				if Players[pid1] ~= nil and Players[pid1]:IsLoggedIn() then			
					local name = Players[pid1].name
					if name == namep then
						TFN_Decorate.moveObject(pid1)
					end
				end
			end
		end
	end
end

local function getObject(refIndex, cell)
	if refIndex == nil then
		return false
	end

	if LoadedCells[cell]:ContainsObject(refIndex) then 
		return LoadedCells[cell].data.objectData[refIndex]
	else
		return false
	end	
end

local function resendPlaceToAll(refIndex, cell)
	local object = getObject(refIndex, cell)
	local refId = object.refId
	local count = object.count or 1
	local charge = object.charge or -1
	local posX, posY, posZ = object.location.posX, object.location.posY, object.location.posZ
	local rotX, rotY, rotZ = object.location.rotX, object.location.rotY, object.location.rotZ
	local scale = object.scale or 1

	local refIndex = refIndex
	
	local inventory = object.inventory or nil
	
	local splitIndex = refIndex:split("-")

	for pid, pdata in pairs(Players) do
		if Players[pid]:IsLoggedIn() then
			--First, delete the original
			tes3mp.InitializeEvent(pid)
			tes3mp.SetEventCell(cell)
			tes3mp.SetObjectRefNumIndex(0)
			tes3mp.SetObjectMpNum(splitIndex[2])
			tes3mp.AddWorldObject() --?
			tes3mp.SendObjectDelete()
			
			--Now remake it
			tes3mp.InitializeEvent(pid)
			tes3mp.SetEventCell(cell)
			tes3mp.SetObjectRefId(refId)
			tes3mp.SetObjectCount(count)
			tes3mp.SetObjectCharge(charge)
			tes3mp.SetObjectPosition(posX, posY, posZ)
			tes3mp.SetObjectRotation(rotX, rotY, rotZ)
			tes3mp.SetObjectScale(scale)
			tes3mp.SetObjectRefNumIndex(0)
			tes3mp.SetObjectMpNum(splitIndex[2])
			if inventory then
				for itemIndex, item in pairs(inventory) do
					tes3mp.SetContainerItemRefId(item.refId)
					tes3mp.SetContainerItemCount(item.count)
					tes3mp.SetContainerItemCharge(item.charge)
					tes3mp.AddContainerItem()
				end
			end
			
			tes3mp.AddWorldObject()
			tes3mp.SendObjectPlace()
			tes3mp.SendObjectScale()
			if inventory then
				tes3mp.SendContainer()
			end
		end
	end
	if WorldMining then
		if WorldInstance.data.customVariables.WorldMining.placed[cell] then
			if WorldInstance.data.customVariables.WorldMining.placed[cell][refIndex] then
				WorldInstance.data.customVariables.WorldMining.placed[cell][refIndex]["loc"] = object.location
				WorldInstance.data.customVariables.WorldMining.placed[cell][refIndex]["scale"] = object.scale
				WorldInstance:QuicksaveToDrive()
			end
		end
	end
	if EcarlateFurniture then
		if WorldInstance.data.customVariables.EcarlateFurniture.placed[cell] then	
			if WorldInstance.data.customVariables.EcarlateFurniture.placed[cell][refIndex] then
				WorldInstance.data.customVariables.EcarlateFurniture.placed[cell][refIndex]["loc"] = object.location
				WorldInstance.data.customVariables.EcarlateFurniture.placed[cell][refIndex]["scale"] = object.scale
				WorldInstance:QuicksaveToDrive()
			end	
		end
	end
	LoadedCells[cell]:QuicksaveToDrive()
end

local function showPromptGUI(pid)
	local message = "[" .. playerCurrentMode[tes3mp.GetName(pid)] .. trad.prompt
	tes3mp.InputDialog(pid, config.PromptId, message, "")
end

local function onEnterPrompt(pid, data)
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		local cell = tes3mp.GetCell(pid)
		local pname = tes3mp.GetName(pid)
		local mode = playerCurrentMode[pname]
		local data = tonumber(data) or 0
		local object = getObject(playerSelectedObject[pname], cell)
		local cellSize = 8192	
		local checkPosSafe = true	
		if not object then
			tes3mp.MessageBox(pid, -1, trad.noselect)		
			return false
		else
			if object.scale == nil then object.scale = 1 end		
			local scaling = object.scale 
			if mode == trad.rotx then
				local curDegrees = math.deg(object.location.rotX)
				local newDegrees = (curDegrees + data) % 360
				object.location.rotX = math.rad(newDegrees)
			elseif mode == trad.roty then
				local curDegrees = math.deg(object.location.rotY)
				local newDegrees = (curDegrees + data) % 360
				object.location.rotY = math.rad(newDegrees)
			elseif mode == trad.rotz then
				local curDegrees = math.deg(object.location.rotZ)
				local newDegrees = (curDegrees + data) % 360
				object.location.rotZ = math.rad(newDegrees)
			elseif mode == trad.movn then
				object.location.posY = object.location.posY + data
			elseif mode == trad.move then
				object.location.posX = object.location.posX + data
			elseif mode == trad.movup then
				object.location.posZ = object.location.posZ + data
			elseif mode == trad.up then
				object.location.posZ = object.location.posZ + 10
			elseif mode == trad.down then
				object.location.posZ = object.location.posZ - 10
			elseif mode == trad.east then
				object.location.posX = object.location.posX + 10
			elseif mode == trad.west then
				object.location.posX = object.location.posX - 10
			elseif mode == trad.north then
				object.location.posY = object.location.posY + 10
			elseif mode == trad.sud then
				object.location.posY = object.location.posY - 10
			elseif mode == trad.bigger then
				if scaling ~= nil then
					if scaling < 2 then
						object.scale = object.scale + 0.1
					else
						object.scale = object.scale
					end
				else
					tes3mp.MessageBox(pid, -1, trad.nooption)		
				end
			elseif mode == trad.Lower then
				if scaling ~= nil then
					if scaling > 0.1 then
						object.scale = object.scale - 0.1
					else
						object.scale = object.scale
					end
				else
					tes3mp.MessageBox(pid, -1, trad.nooption)		
				end		
			elseif mode == "return" then
				object.location.posY = object.location.posY		
				return
			end
		end

		if tes3mp.IsInExterior(pid) then
			local correctGridX = math.floor(object.location.posX / cellSize)
			local correctGridY = math.floor(object.location.posY / cellSize)
			if LoadedCells[cell].gridX ~= correctGridX or LoadedCells[cell].gridY ~= correctGridY then
				checkPosSafe = false
			end
		end
		if checkPosSafe == true then		
			resendPlaceToAll(playerSelectedObject[pname], cell)
		else
			tes3mp.MessageBox(pid, -1, trad.warningcell)
		end
	end
end

local function showMainGUI(pid)
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		--Determine if the player has an item
		local currentItem = "None" --default
		local selected = playerSelectedObject[tes3mp.GetName(pid)]
		local object = getObject(selected, tes3mp.GetCell(pid))
		
		if selected and object then --If they have an entry and it isn't gone
			currentItem = object.refId .. " (" .. selected .. ")"
		end
		
		local message = trad.opt1 .. currentItem
		tes3mp.CustomMessageBox(pid, config.MainId, message, trad.opt2)
	end
end

local function setSelectedObject(pid, refIndex)
	playerSelectedObject[tes3mp.GetName(pid)] = refIndex
end

TFN_Decorate.StartDropTimer = function()
	tes3mp.StartTimer(TimerDrop)
end

TFN_Decorate.SetSelectedObject = function(pid, refIndex)
	setSelectedObject(pid, refIndex)
end

TFN_Decorate.OnObjectPlace = function(eventStatus, pid, cellDescription)
	--Get the last event, which should hopefully be the place packet
	tes3mp.ReadLastEvent()
	
	--Get the refIndex of the first item in the object place packet (in theory, there should only by one)
	local refIndex = tes3mp.GetObjectRefNumIndex(0) .. "-" .. tes3mp.GetObjectMpNum(0)
	
	--Record that item as the last one the player interacted with in this cell
	setSelectedObject(pid, refIndex)
end

TFN_Decorate.OnGUIAction = function(pid, idGui, data)
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		local pname = tes3mp.GetName(pid)
		
		if idGui == config.MainId then
			if tonumber(data) == 0 then --Move North
				playerCurrentMode[pname] = trad.movn
				showPromptGUI(pid)
				return true
			elseif tonumber(data) == 1 then --Move East
				playerCurrentMode[pname] = trad.move
				showPromptGUI(pid)
				return true
			elseif tonumber(data) == 2 then --Move Up
				playerCurrentMode[pname] = trad.movup
				showPromptGUI(pid)
				return true
			elseif tonumber(data) == 3 then --Rotate X
				playerCurrentMode[pname] = trad.rotx
				showPromptGUI(pid)
				return true
			elseif tonumber(data) == 4 then --Rotate Y
				playerCurrentMode[pname] = trad.roty
				showPromptGUI(pid)
				return true
			elseif tonumber(data) == 5 then --Rotate Z
				playerCurrentMode[pname] = trad.rotz
				showPromptGUI(pid)
				return true
			elseif tonumber(data) == 6 then --Monter
				playerCurrentMode[pname] = trad.up
				onEnterPrompt(pid, 0)			
				return true, showMainGUI(pid)
			elseif tonumber(data) == 7 then --Descendre
				playerCurrentMode[pname] = trad.down
				onEnterPrompt(pid, 0)			
				return true, showMainGUI(pid)
			elseif tonumber(data) == 8 then --Est
				playerCurrentMode[pname] = trad.east
				onEnterPrompt(pid, 0)			
				return true, showMainGUI(pid)	
			elseif tonumber(data) == 9 then --Ouest
				playerCurrentMode[pname] = trad.west
				onEnterPrompt(pid, 0)			
				return true, showMainGUI(pid)
			elseif tonumber(data) == 10 then --Nord
				playerCurrentMode[pname] = trad.north
				onEnterPrompt(pid, 0)			
				return true, showMainGUI(pid)
			elseif tonumber(data) == 11 then --Sud
				playerCurrentMode[pname] = trad.sud
				onEnterPrompt(pid, 0)
				return true, showMainGUI(pid)
			elseif tonumber(data) == 12 then --Agrandir
				playerCurrentMode[pname] = trad.bigger
				onEnterPrompt(pid, 0)			
				return true, showMainGUI(pid)
			elseif tonumber(data) == 13 then --Reduire
				playerCurrentMode[pname] = trad.Lower
				onEnterPrompt(pid, 0)
				return true, showMainGUI(pid)	
			elseif tonumber(data) == 14 then --Attraper
				playersTab.player[pid] = {name = Players[pid].name}
				tes3mp.MessageBox(pid, -1, trad.info)	
				TFN_Decorate.StartDropTimer()
				return true				
			elseif tonumber(data) == 15 then --Close
				--Do nothing
				Players[pid].currentCustomMenu = "menu immobilier"--main menu
				return true, menuHelper.DisplayMenu(pid, Players[pid].currentCustomMenu)
			end
		elseif idGui == config.PromptId then
			if data ~= nil and data ~= "" and tonumber(data) then
				onEnterPrompt(pid, data)
			end
			
			playerCurrentMode[tes3mp.GetName(pid)] = nil
			return true, showMainGUI(pid)
		end
	end
end

TFN_Decorate.moveObject = function(pid)
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then	
		local cellSize = 8192	
		local cell = tes3mp.GetCell(pid)
		local pname = tes3mp.GetName(pid)
		local object = getObject(playerSelectedObject[pname], cell)	
		local drawState = tes3mp.GetDrawState(pid)
		if not object then
			tes3mp.MessageBox(pid, -1, trad.noselect)	
			return false
		else
			local playerAngleZ = tes3mp.GetRotZ(pid)
			if playerAngleZ > 3.0 then
				playerAngleZ = 3.0
			elseif playerAngleZ < -3.0 then
				playerAngleZ = -3.0
			end
			local playerAngleX = tes3mp.GetRotX(pid)
			if playerAngleX > 1.5 then
				playerAngleX = 1.5
			elseif playerAngleX < -1.5 then
				playerAngleX = -1.5
			end			
			local PosX = (200 * math.sin(playerAngleZ) + tes3mp.GetPosX(pid))
			local PosY = (200 * math.cos(playerAngleZ) + tes3mp.GetPosY(pid))
			local PosZ = (200 * math.sin(-playerAngleX) + (tes3mp.GetPosZ(pid) + 100))
			if tes3mp.IsInExterior(pid) == true then
				local correctGridX = math.floor(PosX / cellSize)
				local correctGridY = math.floor(PosY / cellSize)

				if LoadedCells[cell].gridX ~= correctGridX or LoadedCells[cell].gridY ~= correctGridY then
					PosX = tes3mp.GetPosX(pid)
					PosY = tes3mp.GetPosY(pid)
					PosZ = (tes3mp.GetPosZ(pid) - 10000)
					tes3mp.MessageBox(pid, -1, trad.warningcell)	
				end
			end			
			if drawState == 1 then
				local curDegrees = math.deg(object.location.rotZ)
				local newDegrees = (curDegrees + 1) % 360
				object.location.rotZ = math.rad(newDegrees)
			elseif drawState == 2 then
				local curDegrees = math.deg(object.location.rotX)
				local newDegrees = (curDegrees + 1) % 360
				object.location.rotX = math.rad(newDegrees)
			end			
			object.location.posX = PosX
			object.location.posY = PosY
			object.location.posZ = PosZ
			resendPlaceToAll(playerSelectedObject[pname], cell)			
		end
		if tes3mp.GetSneakState(pid) then			
			tes3mp.MessageBox(pid, -1, trad.placeobjet)	
			playersTab.player[pid] = nil		
			return false
		else
			tes3mp.RestartTimer(TimerDrop, time.seconds(0.01))	
		end
	end
end

TFN_Decorate.OnCheckStateMove = function(eventStatus, pid)
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then 
		if playersTab.player[pid] and getObject(playerSelectedObject[tes3mp.GetName(pid)], tes3mp.GetCell(pid)) then
			return customEventHooks.makeEventStatus(false,false)
		end
	end
end

TFN_Decorate.OnPlayerCellChange = function(eventStatus, pid)
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then 
		playerSelectedObject[tes3mp.GetName(pid)] = nil
		if playersTab.player[pid] then
			playersTab.player[pid] = nil
		end
	end
end

TFN_Decorate.OnCommand = function(pid)
	showMainGUI(pid)
end

TFN_Decorate.PlayerConnect = function(eventStatus, pid)
	if playersTab.player[pid] then
		playersTab.player[pid] = nil
	end
end

customEventHooks.registerValidator("OnObjectActivate", TFN_Decorate.OnCheckStateMove)
customCommandHooks.registerCommand("dh", TFN_Decorate.OnCommand)
customEventHooks.registerHandler("OnGUIAction", function(eventStatus, pid, idGui, data)
	if TFN_Decorate.OnGUIAction(pid, idGui, data) then return end
end)
customEventHooks.registerHandler("OnObjectPlace", TFN_Decorate.OnObjectPlace)
customEventHooks.registerHandler("OnPlayerCellChange", TFN_Decorate.OnPlayerCellChange)
customEventHooks.registerHandler("OnPlayerAuthentified", TFN_Decorate.PlayerConnect)

return TFN_Decorate
