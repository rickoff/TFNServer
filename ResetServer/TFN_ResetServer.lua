--[[
TFN_ResetServer.lua
tes3mp 0.7.0
---------------------------
DESCRIPTION :

---------------------------
CONFIGURATION :

---------------------------
INSTALLATION:
Save the file as TFN_Creature.json inside your server/data/custom folder.
Save the file as TFN_Npc.json inside your server/data/custom folder.
Save the file as TFN_ListCell.json inside your server/data/custom folder.

Save the file as TFN_ResetServer.lua inside your server/scripts/custom folder.

Edits to customScripts.lua
TFN_ResetServer = require("custom.TFN_ResetServer")
---------------------------
]]
local trad = {
	RebootServer = color.Red.."!!!!! WARNING !!!!!\n"..color.Green.."Reboot server in : "
}

local config = {
	resetWorld = 60,
	resetTime = 3600,
	timerRespawn = 3600,
	NpcChangeCell = false,
	NpcProtect = true,
	CreaProtect = false
}

local TimerStart = tes3mp.CreateTimer("StartReset", time.seconds(config.resetWorld))

local cellReseting = jsonInterface.load("custom/TFN_ListCell.json")
local ListNpc = jsonInterface.load("custom/TFN_Npc.json")
local ListCrea = jsonInterface.load("custom/TFN_Creature.json")
local ListAll = {}

function CreateList()
	if config.NpcProtect == true then
		for x, slot in pairs(ListNpc) do
			ListAll[slot.refId] = ""
		end
	end
	if config.CreaProtect == true then
		for x, slot in pairs(ListCrea) do
			ListAll[slot.refId] = ""
		end
	end
end

function StartReset()
	local cell
	local Heure = os.date("%H")
	local Minute =  os.date("%M")
	if tonumber(Heure) == 06 then
		if tonumber(Minute) == 00 then	
			for x, cell in pairs(cellReseting) do
				if cell ~= nil then
					TFN_ResetServer.ResetCell(cell)
				end
			end		
		end
	elseif tonumber(Heure) == 05 then
		if tonumber(Minute) >= 45 then
			local decount = 60 - tonumber(Minute)		
			local message = (trad.RebootServer..color.Yellow..decount)	
			if tableHelper.getCount(Players) > 0 then
				Playerpid = tableHelper.getAnyValue(Players).pid			
				tes3mp.SendMessage(Playerpid, message, true)
			end
		end
	end	
	tes3mp.RestartTimer(TimerStart, time.seconds(config.resetWorld))
end

function RespawnNpc(cellDescription)
	local cell = LoadedCells[cellDescription]
	local Time = os.time()	
	if cell ~= nil then
		if TFN_HousingShop then
			local cellData = TFN_HousingShop.GetCellData(cellDescription)
			if cellData and cellData.house ~= nil then
				return
			end
		end			
		local tempCell = cell.data.entry.creationTime		
		if tempCell ~= nil then
			local calculTime = Time - tempCell		
			if calculTime > config.timerRespawn then				
				for x, index in pairs(cell.data.packets.actorList) do
					if tableHelper.containsValue(cell.data.packets.death, index, true) then
						if cell.data.objectData[index] then
							local refId = cell.data.objectData[index].refId
							local location = cell.data.objectData[index].location
							local position = { posX = location.posX, posY = location.posY, posZ = location.posZ, rotX = 0, rotY = 0, rotZ = 0 }						
							tableHelper.removeValue(cell.data.packets, index)
							cell.data.objectData[index] = nil
							tableHelper.cleanNils(cell.data.objectData)									
							if not tableHelper.containsValue(cell.data.packets.delete, index) then
								table.insert(cell.data.packets.delete, index)
								cell.data.objectData[index] = { refId = refId }					
								if tableHelper.getCount(Players) > 0 then		
									logicHandler.DeleteObjectForEveryone(cellDescription, index)
								end							
							end
							logicHandler.CreateObjectAtLocation(cellDescription, position, refId, "spawn")
						end
					end
				end									
				cell.data.entry.creationTime = os.time()
				cell:QuicksaveToDrive()
			end
		end
	end
end

function IsCellFullyExempt(cellDescription)	
	if TFN_HousingShop then
		local cellData = TFN_HousingShop.GetCellData(cellDescription)
		if cellData and (cellData.house ~= nil) then
			return true
		end
	end	
	return false
end

function HasOnlinePlayerLoadedCellInSession(cellToCheck)
	local cell
	local useTempLoad = false	
	if type(cellToCheck) == "table" then --Was given the cell itself
		cell = cellToCheck
	else
		if LoadedCells[cellToCheck] == nil then
			logicHandler.LoadCell(cellToCheck)
			useTempLoad = true
		end
		cell = LoadedCells[cellToCheck]
	end
	local cellDescription = cell.description
	local affectedPlayers = {}
	local aPlayerHasLoaded = false
	if not tableHelper.isEmpty(cell.visitors) then
		aPlayerHasLoaded = true
		for index, pid in ipairs(cell.visitors) do
			tableHelper.insertValueIfMissing(affectedPlayers, pid)
		end
	end
	if tableHelper.isEmpty(cell.data.lastVisit) then
	else
		local mostRecent = -1
		for playerName, time in pairs(cell.data.lastVisit) do
			if time > mostRecent then
				mostRecent = time
			end
		end
		for pid, player in pairs(Players) do
			if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
				if player.initTimestamp <= mostRecent then
					tableHelper.insertValueIfMissing(affectedPlayers, pid)
					aPlayerHasLoaded = true
				end
			end
		end
	end	
	if useTempLoad then
		logicHandler.UnloadCell(cell.description)
	end	
	if aPlayerHasLoaded then
		return true, affectedPlayers
	else
		return false
	end
end

local TFN_ResetServer = {}

TFN_ResetServer.Init = function(eventStatus)
	CreateList()
	tes3mp.StartTimer(TimerStart)	
end

TFN_ResetServer.ResetCell = function(cellDescription)
	local hasPlayers, playersList = HasOnlinePlayerLoadedCellInSession(cellDescription)
	if hasPlayers then
		for index = 1, #playersList do
			local player = Players[playersList[index]]
			tes3mp.MessageBox(player.pid, -1, color.Red.."* REBOOT SERVER *")
			tes3mp.Kick(player.pid)
			player = nil
		end
	end
	if not IsCellFullyExempt(cellDescription) then
		local cell = LoadedCells[cellDescription]
		local useTemporaryLoad = false	
		if cell == nil then
			logicHandler.LoadCell(cellDescription)
			useTemporaryLoad = true
			cell = LoadedCells[cellDescription]
		end
		local oldCellData = cell.data
		local newCellData = {}
		for key, value in pairs(oldCellData) do
			if type(value) == "table" then
				newCellData[key] = {}
			end
		end	
		for packetKey, moreUselessInfo in pairs(oldCellData.packets) do
			newCellData.packets[packetKey] = {}
		end		
		local uniqueIndexesToPreserve = {}		
		for index, uniqueIndex in pairs(oldCellData.packets.place) do
			if not tableHelper.containsValue(oldCellData.packets.spawn, uniqueIndex) then
				tableHelper.insertValueIfMissing(uniqueIndexesToPreserve, uniqueIndex)
			end
		end 		
		if config.NpcChangeCell then
			if not tableHelper.isEmpty(oldCellData.packets.cellChangeTo) then
				for index, uniqueIndex in pairs(oldCellData.packets.cellChangeTo) do
					newCellData.objectData[uniqueIndex] = oldCellData.objectData[uniqueIndex]
				end
				newCellData.packets.cellChangeTo = oldCellData.packets.cellChangeTo
			end
			if not tableHelper.isEmpty(oldCellData.packets.cellChangeFrom) then
				newCellData.packets.cellChangeFrom = oldCellData.packets.cellChangeFrom
				for index, uniqueIndex in pairs(newCellData.packets.cellChangeFrom) do
					tableHelper.insertValueIfMissing(uniqueIndexesToPreserve, uniqueIndex)
				end				
			end
		end
		for packetKey, uniqueIndexList in pairs(oldCellData.packets) do
			for index, uniqueIndex in pairs(uniqueIndexList) do
				if tableHelper.containsValue(uniqueIndexesToPreserve, uniqueIndex) then
					tableHelper.insertValueIfMissing(newCellData.packets[packetKey], uniqueIndex)
				end
			end
		end

		for uniqueIndex, data in pairs(oldCellData.objectData) do
			if tableHelper.containsValue(uniqueIndexesToPreserve, uniqueIndex) then
				if newCellData.objectData[uniqueIndex] == nil then
					newCellData.objectData[uniqueIndex] = data
				end
			end
		end
		for recordType, recordEntries in pairs(oldCellData.recordLinks) do
			for recordId, uniqueIndexList in pairs(recordEntries) do
				for index = 1, #uniqueIndexList do
					if not tableHelper.containsValue(uniqueIndexesToPreserve, uniqueIndexList[index]) then
						uniqueIndexList[index] = nil
					end					
					tableHelper.cleanNils(uniqueIndexList)
					if tableHelper.isEmpty(uniqueIndexList) then
						logicHandler.GetRecordStoreByRecordId(recordId):RemoveLinkToCell(recordId, cell)
					else						
						if newCellData.recordLinks[recordType] == nil then newCellData.recordLinks[recordType] = {} end						
						newCellData.recordLinks[recordType][recordId] = uniqueIndexList
					end
				end
			end
		end
		newCellData.entry.creationTime = os.time()
		newCellData.entry.description = cellDescription
		newCellData.lastReset = os.time()
		cell.data = newCellData
		cell:QuicksaveToDrive()
		if useTemporaryLoad == true then
			logicHandler.UnloadCell(cellDescription)
		end
	end
end

TFN_ResetServer.ResetLoadCell = function(cellDescription)
	local cell = LoadedCells[cellDescription]
	local useTemporaryLoad = false	
	if cell == nil then
		logicHandler.LoadCell(cellDescription)
		useTemporaryLoad = true
		cell = LoadedCells[cellDescription]
	end
	local oldCellData = cell.data
	local newCellData = {}
	for key, value in pairs(oldCellData) do
		if type(value) == "table" then
			newCellData[key] = {}
		end
	end	
	for packetKey, moreUselessInfo in pairs(oldCellData.packets) do
		newCellData.packets[packetKey] = {}
	end	
	local uniqueIndexesToPreserve = {}	
	for index, uniqueIndex in pairs(oldCellData.packets.place) do
		if not tableHelper.containsValue(oldCellData.packets.spawn, uniqueIndex) then
			tableHelper.insertValueIfMissing(uniqueIndexesToPreserve, uniqueIndex)
		end
	end 	
	if config.NpcChangeCell then
		if not tableHelper.isEmpty(oldCellData.packets.cellChangeTo) then
			for index, uniqueIndex in pairs(oldCellData.packets.cellChangeTo) do
				newCellData.objectData[uniqueIndex] = oldCellData.objectData[uniqueIndex]
			end
			newCellData.packets.cellChangeTo = oldCellData.packets.cellChangeTo
		end
		if not tableHelper.isEmpty(oldCellData.packets.cellChangeFrom) then
			newCellData.packets.cellChangeFrom = oldCellData.packets.cellChangeFrom
			for index, uniqueIndex in pairs(newCellData.packets.cellChangeFrom) do
				tableHelper.insertValueIfMissing(uniqueIndexesToPreserve, uniqueIndex)
			end			
		end
	end
	for packetKey, uniqueIndexList in pairs(oldCellData.packets) do
		for index, uniqueIndex in pairs(uniqueIndexList) do
			if tableHelper.containsValue(uniqueIndexesToPreserve, uniqueIndex) then
				tableHelper.insertValueIfMissing(newCellData.packets[packetKey], uniqueIndex)
			end
		end
	end
	for uniqueIndex, data in pairs(oldCellData.objectData) do
		if tableHelper.containsValue(uniqueIndexesToPreserve, uniqueIndex) then
			if newCellData.objectData[uniqueIndex] == nil then
				newCellData.objectData[uniqueIndex] = data
			end
		end
	end
	for recordType, recordEntries in pairs(oldCellData.recordLinks) do		
		for recordId, uniqueIndexList in pairs(recordEntries) do
			for index = 1, #uniqueIndexList do
				if not tableHelper.containsValue(uniqueIndexesToPreserve, uniqueIndexList[index]) then
					uniqueIndexList[index] = nil
				end				
				tableHelper.cleanNils(uniqueIndexList)
				if tableHelper.isEmpty(uniqueIndexList) then
					logicHandler.GetRecordStoreByRecordId(recordId):RemoveLinkToCell(recordId, cell)
					removedLinksForType = true
				else					
					if newCellData.recordLinks[recordType] == nil then newCellData.recordLinks[recordType] = {} end					
					newCellData.recordLinks[recordType][recordId] = uniqueIndexList
				end
			end
		end
	end
	newCellData.entry.creationTime = os.time()
	newCellData.entry.description = cellDescription
	newCellData.lastReset = os.time()
	cell.data = newCellData
	cell:QuicksaveToDrive()
	if useTemporaryLoad == true then
		logicHandler.UnloadCell(cellDescription)
	end
end

TFN_ResetServer.CheckCellReset = function(cellDescription)	
	local useTempLoad = false
	if LoadedCells[cellDescription] == nil then
		logicHandler.LoadCell(cellDescription)
		useTempLoad = true
	end	
	local cell = LoadedCells[cellDescription]
	if not cell.data.lastReset then
		cell.data.lastReset = os.time()
		cell:Save()
	end	
	local denyReasons = {}	
	if config.resetTime < 0 then
		denyReasons.automaticDisabled = true
	end	
	if os.time() - cell.data.lastReset < config.resetTime then
		denyReasons.time = true
	end	
	if IsCellFullyExempt(cellDescription) then
		denyReasons.fullyExempt = true
	end
	local playerHasLoaded, affectedPlayers = HasOnlinePlayerLoadedCellInSession(cellDescription)
	if playerHasLoaded then
		denyReasons.clientMemory = true
	end
	if cell:GetVisitorCount() > 0 then
		denyReasons.visitors = true
	end
	if useTempLoad then
		logicHandler.UnloadCell(cellDescription)
	end
	if not tableHelper.isEmpty(denyReasons) then
		return false, denyReasons
	end
	return true
end

TFN_ResetServer.OnCellLoadValidator = function(eventStatus, pid, cellDescription)
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		if TFN_ResetServer.CheckCellReset(cellDescription) then
			TFN_ResetServer.ResetLoadCell(cellDescription)
		end	
	end
end

TFN_ResetServer.OnObjectDeleteValidator = function(eventStatus, pid, cellDescription, objects)
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		local ObjectIndex
		local ObjectRefid
		if TFN_HousingShop then
			local cellData = TFN_HousingShop.GetCellData(cellDescription)
			if cellData == true then
				for _, object in pairs(objects) do
					ObjectIndex = object.uniqueIndex
					ObjectRefid = object.refId
				end	
				if ObjectIndex ~= nil and ObjectRefid ~= nil then
					if ListAll[string.lower(ObjectRefid)] then
						return customEventHooks.makeEventStatus(false,false) 
					end
				end	
			end
		else
			for _, object in pairs(objects) do
				ObjectIndex = object.uniqueIndex
				ObjectRefid = object.refId
			end	
			if ObjectIndex ~= nil and ObjectRefid ~= nil then
				if ListAll[string.lower(ObjectRefid)] then
					return customEventHooks.makeEventStatus(false,false) 
				end
			end	
		end
	end
end

TFN_ResetServer.OnCellLoadHandler = function(eventStatus, pid, cellDescription)
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		RespawnNpc(cellDescription)
	end
end

TFN_ResetServer.OnBigResetCommand = function(pid)
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() and Players[pid]:IsServerStaff() then
		for x, cell in pairs(cellReseting) do
			if cell ~= nil then
				TFN_ResetServer.ResetCell(cell)
			end
		end	
	end
end

customEventHooks.registerHandler("OnServerInit",TFN_ResetServer.Init)
customEventHooks.registerValidator("OnCellLoad",TFN_ResetServer.OnCellLoadValidator)
customEventHooks.registerValidator("OnObjectDelete",TFN_ResetServer.OnObjectDeleteValidator)
customEventHooks.registerHandler("OnCellLoad",TFN_ResetServer.OnCellLoadHandler)
customCommandHooks.registerCommand("bigreset",TFN_ResetServer.OnBigResetCommand)

return TFN_ResetServer
