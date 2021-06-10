--[[
TFN_Furniture by Rickoff
tes3mp 0.7.0
---------------------------
DESCRIPTION :

---------------------------
INSTALLATION:
Save the file as TFN_Furniture.lua inside your server/scripts/custom folder.
Save the file as TFN_Furnitures.json inside your server/data/custom folder.

Edits to customScripts.lua
TFN_Furniture = require("custom.TFN_Furniture")
---------------------------
]]
local trad = {
	Name = "Name: ",
	RefIndex = "(RefIndex: ",
	CountBuy = "). Purchase price: ",
	CountSell = "(Sale price: ",
	OptView = "Select;Remove;Sell;Return",
	Selected = "Selected object, use /dh to move.",
	AddObject = " has been added to your furniture inventory.",
	GoldAdd = "Gold has been added to your inventory and the furniture has been removed from the cell.",
	ListReturn = "* Return *\n",
	ChestMove = "Select a piece of furniture that you have placed in this cell. Note: The contents of containers will be lost if removed/moved.",
	PriceBuy = ". Purchase price: ",
	PriceSell = ". Purchase price: ",
	OptInv = "Place;Sell;Return",
	NoPerm = "You do not have permission to place furniture here.",
	AddGoldInv = "The gold has been added to your inventory.",
	SelectFurn = "Select the piece of furniture from your inventory with which you want to do something",
	SelectBuy = "Select an item you want to buy",
	NoPermBuy = "You can't afford to buy",
	OptMenu = "Buy;Inventory;Display;Return",
	CatMenu = "CATEGORY.\n\n",
	OptCat = "Beds;Chesty;Furn;Misc;Lighting;Rugs;Containers;Imperial;Dunmer;Return",
	MainMenu = (
	color.Green .. "WELCOME TO THE STORE.\n\n"
	..color.Yellow .. "Buy"
	..color.White .. " to buy furniture for your furniture inventory\n\n"
	..color.Yellow .. "Inventory"
	..color.White .. " to view the furniture items you own \n\n"
	..color.Yellow .. "Show "
	..color.White .. " to display a list of all the furniture you own in the cell where you are currently \n\n"
	)	
}

local config = {
	whitelist = false,
	sellbackModifier = 1.0, -- The base cost that an item is multiplied by when selling the items back (0.75 is 75%)
	cellBlackList = {},-- Add cell name in blacklist for protect add furn in cell
	CatGUI = 31362,
	MainGUI = 31363,
	BuyGUI = 31364,
	InventoryGUI = 31365,
	ViewGUI = 31366,
	InventoryOptionsGUI = 31367,
	ViewOptionsGUI = 31368
}

local furnitureData = jsonInterface.load("custom/TFN_Furnitures.json")

local furnitureActivable = {}

TFN_Furniture = {}

local showMainGUI, showBuyGUI, showInventoryGUI, showViewGUI, showInventoryOptionsGUI, showViewOptionsGUI

local playerBuyOptions = {} 
local playerInventoryOptions = {}
local playerInventoryChoice = {}
local playerViewOptions = {} 
local playerViewChoice = {}

local function getFurnitureInventoryTable()
	return WorldInstance.data.customVariables.TFN_Furniture.inventories
end

local function getPermissionsTable()
	return WorldInstance.data.customVariables.TFN_Furniture.permissions
end

local function getPlacedTable()
	return WorldInstance.data.customVariables.TFN_Furniture.placed
end

local function addPlaced(refIndex, cell, pname, refId, save)
	local placed = getPlacedTable()	
	if not placed[cell] then
		placed[cell] = {}
	end	
	placed[cell][refIndex] = {owner = pname, refId = refId}	
	if save then
		WorldInstance:QuicksaveToDrive()
	end
end

local function removePlaced(refIndex, cell, save)
	local placed = getPlacedTable()	
	placed[cell][refIndex] = nil	
	if save then
		WorldInstance:QuicksaveToDrive()
	end
end

local function getPlaced(cell)
	local placed = getPlacedTable()	
	if placed[cell] then
		return placed[cell]
	else
		return false
	end
end

local function addFurnitureItem(pname, refId, count, save)
	local fInventories = getFurnitureInventoryTable()	
	if fInventories[pname] == nil then
		fInventories[pname] = {}
	end	
	fInventories[pname][refId] = (fInventories[pname][refId] or 0) + (count or 1)
	if fInventories[pname][refId] <= 0 then
		fInventories[pname][refId] = nil
	end
	
	if save then
		WorldInstance:QuicksaveToDrive()
	end
end

local function AddPreexistingObjectsTFN_Furniture(cellDescription)	
	if WorldInstance.data.customVariables ~= nil and WorldInstance.data.customVariables.TFN_Furniture ~= nil and WorldInstance.data.customVariables.TFN_Furniture.placed ~= nil then
		local placed = WorldInstance.data.customVariables.TFN_Furniture.placed
		if placed[cellDescription] ~= nil then
			local unique = {}			
			for refIndex, object in pairs(placed[cellDescription]) do
				if LoadedCells[cellDescription] then
					if not tableHelper.containsValue(LoadedCells[cellDescription].data.packets, refIndex, true) then 
						if object.loc and object.refId then
							unique[refIndex] = logicHandler.CreateObjectAtLocation(cellDescription, object.loc, object.refId, "place", object.scale)
						end
					end
				end
			end
			
			for refIndex, uniqueId in pairs(unique) do
				WorldInstance.data.customVariables.TFN_Furniture.placed[cellDescription][uniqueId] = WorldInstance.data.customVariables.TFN_Furniture.placed[cellDescription][refIndex]
				WorldInstance.data.customVariables.TFN_Furniture.placed[cellDescription][refIndex] = nil
			end
			WorldInstance:QuicksaveToDrive()
		end
	end
end

TFN_Furniture.OnServerPostInit = function(eventStatus)
	if WorldInstance.data.customVariables.TFN_Furniture == nil then
		WorldInstance.data.customVariables.TFN_Furniture = {}
		WorldInstance.data.customVariables.TFN_Furniture.placed = {}
		WorldInstance.data.customVariables.TFN_Furniture.permissions = {}
		WorldInstance.data.customVariables.TFN_Furniture.inventories = {}
		WorldInstance:QuicksaveToDrive()
	end
	local placed = getPlacedTable()
	for cell, v in pairs(placed) do
		for refIndex, v in pairs(placed[cell]) do
			placed[cell][refIndex].owner = string.lower(placed[cell][refIndex].owner)
		end
	end
	local permissions = getPermissionsTable()
		
	for cell, v in pairs(permissions) do
		local newNames = {}
		
		for pname, v in pairs(permissions[cell]) do
			table.insert(newNames, string.lower(pname))
		end		
		permissions[cell] = {}
		for k, newName in pairs(newNames) do
			permissions[cell][newName] = true
		end
	end	
	local inventories = getFurnitureInventoryTable()
	local newInventories = {}
	for pname, invData in pairs(inventories) do
		newInventories[string.lower(pname)] = invData
	end	
	WorldInstance.data.customVariables.TFN_Furniture.inventories = newInventories	
	WorldInstance:QuicksaveToDrive()
end

local function getSellValue(baseValue)
	return math.max(0, math.floor(baseValue * config.sellbackModifier))
end

local function getName(pid)
	return string.lower(Players[pid].accountName)
end

local function getObject(refIndex, cell)
	if refIndex == nil then
		return false
	end	
	if not LoadedCells[cell] then
		logicHandler.LoadCell(cell)
	end
	if LoadedCells[cell]:ContainsObject(refIndex)  then 
		return LoadedCells[cell].data.objectData[refIndex]
	else
		return false
	end	
end

local function getPlayerGold(pid)
	local goldLoc = inventoryHelper.getItemIndex(Players[pid].data.inventory, "gold_001", -1)	
	if goldLoc then
		return Players[pid].data.inventory[goldLoc].count
	else
		return 0
	end
end

local function addGold(pid, amount)
	local goldLoc = inventoryHelper.getItemIndex(Players[pid].data.inventory, "gold_001", -1)	
	if goldLoc then
		Players[pid].data.inventory[goldLoc].count = Players[pid].data.inventory[goldLoc].count + amount
	else
		table.insert(Players[pid].data.inventory, {refId = "gold_001", count = amount, charge = -1, soul = ""})
	end	
	local itemref = {refId = "gold_001", count = amount, charge = -1, soul = ""}			
	Players[pid]:QuicksaveToDrive()
	Players[pid]:LoadItemChanges({itemref}, enumerations.inventory.ADD)			
end

local function removeGold(pid, amount)
	local goldLoc = inventoryHelper.getItemIndex(Players[pid].data.inventory, "gold_001", -1)	
	Players[pid].data.inventory[goldLoc].count = Players[pid].data.inventory[goldLoc].count - amount	
	local itemref = {refId = "gold_001", count = amount, charge = -1, soul = ""}			
	Players[pid]:QuicksaveToDrive()
	Players[pid]:LoadItemChanges({itemref}, enumerations.inventory.REMOVE)			
end

local function getFurnitureData(refId)
	if furnitureData[refId] then
		return furnitureData[refId], refId
	else
		return false
	end
end

local function hasPlacePermission(pname, cell)
	local perms = getPermissionsTable()	
	if not config.whitelist then
		return true
	end	
	if perms[cell] then
		if perms[cell]["all"] or perms[cell][pname] then
			return true
		else
			return false
		end
	else
		return false
	end
end

local function getPlayerFurnitureInventory(pid)
	local invlist = getFurnitureInventoryTable()
	local pname = getName(pid)	
	if invlist[pname] == nil then
		invlist[pname] = {}
		WorldInstance:QuicksaveToDrive()
	end	
	return invlist[pname]
end

local function getSortedPlayerFurnitureInventory(pid)
	local inv = getPlayerFurnitureInventory(pid)
	local sorted = {}	
	for refId, amount in pairs(inv) do
		local name = getFurnitureData(refId).name
		if name then
			table.insert(sorted, {name = name, count = amount, refId = refId})
		end
	end	
	return sorted
end

local function placeFurniture(refId, loc, cell)
	local mpNum = WorldInstance:GetCurrentMpNum() + 1
	local location = {
		posX = loc.x, posY = loc.y, posZ = loc.z,
		rotX = 0, rotY = 0, rotZ = 0
	}
	local refIndex =  0 .. "-" .. mpNum
	local scale = 1	
	WorldInstance:SetCurrentMpNum(mpNum)
	tes3mp.SetCurrentMpNum(mpNum)	
	if not LoadedCells[cell] then
		logicHandler.LoadCell(cell)
	end
	LoadedCells[cell]:InitializeObjectData(refIndex, refId)
	LoadedCells[cell].data.objectData[refIndex].location = location
	LoadedCells[cell].data.objectData[refIndex].scale = scale
	table.insert(LoadedCells[cell].data.packets.scale, refIndex)
	table.insert(LoadedCells[cell].data.packets.place, refIndex)
	for onlinePid, player in pairs(Players) do
		if player:IsLoggedIn() then
			tes3mp.InitializeEvent(onlinePid)
			tes3mp.SetEventCell(cell)
			tes3mp.SetObjectRefId(refId)
			tes3mp.SetObjectRefNumIndex(0)
			tes3mp.SetObjectMpNum(mpNum)
			tes3mp.SetObjectPosition(location.posX, location.posY, location.posZ)
			tes3mp.SetObjectRotation(location.rotX, location.rotY, location.rotZ)
			tes3mp.SetObjectScale(scale)
			tes3mp.AddWorldObject()
			tes3mp.SendObjectPlace()
		end
	end	
	LoadedCells[cell]:QuicksaveToDrive()	
	return refIndex
end

local function removeFurniture(refIndex, cell)
	if LoadedCells[cell] == nil then
		logicHandler.LoadCell(cell)
	end	
	if LoadedCells[cell]:ContainsObject(refIndex) and not tableHelper.containsValue(LoadedCells[cell].data.packets.delete, refIndex) then
		local splitIndex = refIndex:split("-")		
		for onlinePid, player in pairs(Players) do
			if player:IsLoggedIn() then
				tes3mp.InitializeEvent(onlinePid)
				tes3mp.SetEventCell(cell)
				tes3mp.SetObjectRefNumIndex(splitIndex[1])
				tes3mp.SetObjectMpNum(splitIndex[2])
				tes3mp.AddWorldObject()
				tes3mp.SendObjectDelete()
			end
		end		
		LoadedCells[cell]:DeleteObjectData(refIndex)
		LoadedCells[cell]:QuicksaveToDrive()
	end
end

local function getAvailableFurnitureStock(pid)	
	local options = {}	
	for refId, slot in pairs(furnitureData) do
		table.insert(options, slot)
	end	
	return options	
end

local function getPlayerPlacedInCell(pname, cell)
	local cellPlaced = getPlaced(cell)	
	if not cellPlaced then
		return false
	end	
	local list = {}
	for refIndex, data in pairs(cellPlaced) do
		if data.owner == pname then
			table.insert(list, refIndex)
		end
	end	
	if #list > 0 then
		return list
	else
		return false
	end
end

local function addFurnitureData(data)
	local fdata, loc = getFurnitureData(data.refId)	
	if fdata then
		furnitureData[loc] = data
	else
		table.insert(furnitureData, data)
	end
end

TFN_Furniture.AddFurnitureData = function(data)
	addFurnitureData(data)
end

TFN_Furniture.AddPermission = function(pname, cell)
	local perms = getPermissionsTable()	
	if not perms[cell] then
		perms[cell] = {}
	end	
	perms[cell][pname] = true
	WorldInstance:QuicksaveToDrive()
end

TFN_Furniture.RemovePermission = function(pname, cell)
	local perms = getPermissionsTable()	
	if not perms[cell] then
		return
	end	
	perms[cell][pname] = nil	
	WorldInstance:QuicksaveToDrive()
end

TFN_Furniture.RemoveAllPermissions = function(cell)
	local perms = getPermissionsTable()	
	perms[cell] = nil
	WorldInstance:QuicksaveToDrive()
end

TFN_Furniture.RemoveAllPlayerFurnitureInCell = function(pname, cell, returnToOwner)
	local placed = getPlacedTable()
	local cInfo = placed[cell] or {}	
	for refIndex, info in pairs(cInfo) do
		if info.owner == pname then
			if returnToOwner then
				addFurnitureItem(info.owner, info.refId, 1, false)
			end
			removeFurniture(refIndex, cell)
			removePlaced(refIndex, cell, false)
		end
	end
	WorldInstance:QuicksaveToDrive()
end

TFN_Furniture.RemoveAllFurnitureInCell = function(cell, returnToOwner)
	local placed = getPlacedTable()
	local cInfo = placed[cell] or {}	
	for refIndex, info in pairs(cInfo) do
		if returnToOwner then
			addFurnitureItem(info.owner, info.refId, 1, false)
		end
		removeFurniture(refIndex, cell)
		removePlaced(refIndex, cell, false)
	end
	WorldInstance:QuicksaveToDrive()
end

TFN_Furniture.TransferOwnership = function(refIndex, cell, playerCurrentName, playerToName, save)
	local placed = getPlacedTable()	
	if placed[cell] and placed[cell][refIndex] and (placed[cell][refIndex].owner == playerCurrentName or not playerCurrentName) then
		placed[cell][refIndex].owner = playerToName
	end	
	if save then
		WorldInstance:QuicksaveToDrive()
	end	
	if playerCurrentName and logicHandler.IsPlayerNameLoggedIn(playerCurrentName) then
		TFN_Decorate.SetSelectedObject(logicHandler.GetPlayerByName(playerCurrentName).pid, "")
	end
end

TFN_Furniture.TransferAllOwnership = function(cell, playerCurrentName, playerToName, save)
	local placed = getPlacedTable()	
	if not placed[cell] then
		return false
	end	
	for refIndex, info in pairs(placed[cell]) do
		if not playerCurrentName or info.owner == playerCurrentName then
			placed[cell][refIndex].owner = playerToName
		end
	end	
	if save then
		WorldInstance:QuicksaveToDrive()
	end	
	if playerCurrentName and logicHandler.IsPlayerNameLoggedIn(playerCurrentName) then
		TFN_Decorate.SetSelectedObject(logicHandler.GetPlayerByName(playerCurrentName).pid, "")
	end
end

TFN_Furniture.GetSellBackPrice = function(value)
	return getSellValue(value)
end

TFN_Furniture.GetFurnitureDataByRefId = function(refId)
	return getFurnitureData(refId)
end

TFN_Furniture.GetPlacedInCell = function(cell)
	return getPlaced(cell)
end

showViewOptionsGUI = function(pid, loc)
	local message = ""
	local choice = playerViewOptions[getName(pid)][loc]
	local fdata = getFurnitureData(choice.refId)
	message = message..trad.Name..fdata.name..trad.RefIndex..choice.refIndex..trad.CountBuy..fdata.price..trad.CountSell..getSellValue(fdata.price)..")"	
	playerViewChoice[getName(pid)] = choice
	tes3mp.CustomMessageBox(pid, config.ViewOptionsGUI, message, trad.OptView)
end

local function onViewOptionSelect(pid)
	local pname = getName(pid)
	local choice = playerViewChoice[pname]
	local cell = tes3mp.GetCell(pid)	
	if getObject(choice.refIndex, cell) then
		TFN_Decorate.SetSelectedObject(pid, choice.refIndex)
		tes3mp.MessageBox(pid, -1, trad.Selected)
	end
end

local function onViewOptionPutAway(pid)
	local pname = getName(pid)
	local choice = playerViewChoice[pname]
	local cell = tes3mp.GetCell(pid)
	
	if getObject(choice.refIndex, cell) then
		removeFurniture(choice.refIndex, cell)
		removePlaced(choice.refIndex, cell, true)
		addFurnitureItem(pname, choice.refId, 1, true)
		tes3mp.MessageBox(pid, -1, getFurnitureData(choice.refId).name..trad.AddObject)
	end
end

local function onViewOptionSell(pid)
	local pname = getName(pid)
	local choice = playerViewChoice[pname]
	local cell = tes3mp.GetCell(pid)	
	if getObject(choice.refIndex, cell) then
		local saleGold = getSellValue(getFurnitureData(choice.refId).price)
		addGold(pid, saleGold)
		removeFurniture(choice.refIndex, cell)
		removePlaced(choice.refIndex, cell, true)
		tes3mp.MessageBox(pid, -1, saleGold ..trad.GoldAdd)
	end
end

showViewGUI = function(pid)
	local pname = getName(pid)
	local cell = tes3mp.GetCell(pid)
	local options = getPlayerPlacedInCell(pname, cell)	
	local list = trad.ListReturn
	local newOptions = {}	
	if options and #options > 0 then
		for i = 1, #options do
			local object = getObject(options[i], cell)			
			if object then
				local furnData = getFurnitureData(object.refId)				
				list = list..furnData.name..color.Red.." Index:"..color.White..options[i]
				if not(i == #options) then
					list = list .. "\n"
				end				
				table.insert(newOptions, {refIndex = options[i], refId = object.refId})
			end
		end
	end	
	playerViewOptions[pname] = newOptions
	tes3mp.ListBox(pid, config.ViewGUI, trad.ChestMove, list)
end

local function onViewChoice(pid, loc)
	showViewOptionsGUI(pid, loc)
end

showInventoryOptionsGUI = function(pid, loc)
	local message = ""
	local choice = playerInventoryOptions[getName(pid)][loc]
	local fdata = getFurnitureData(choice.refId)
	message = message..trad.Name..choice.name..trad.PriceBuy..fdata.price..trad.PriceSell..getSellValue(fdata.price)..")"
	playerInventoryChoice[getName(pid)] = choice
	tes3mp.CustomMessageBox(pid, config.InventoryOptionsGUI, message, trad.OptInv)
end

local function onInventoryOptionPlace(pid)
	local pname = getName(pid)
	local curCell = tes3mp.GetCell(pid)
	local choice = playerInventoryChoice[pname]
	local playerAngle = tes3mp.GetRotZ(pid)
	if playerAngle > 3.0 then
		playerAngle = 3.0
	elseif playerAngle < -3.0 then
		playerAngle = -3.0
	end
	local PosX = (100 * math.sin(playerAngle) + tes3mp.GetPosX(pid))
	local PosY = (100 * math.cos(playerAngle) + tes3mp.GetPosY(pid))
	local PosZ = tes3mp.GetPosZ(pid)		
	if config.whitelist and not hasPlacePermission(pname, curCell) then
		tes3mp.MessageBox(pid, -1, trad.NoPerm)
		return false
	elseif tableHelper.containsValue(config.cellBlackList, curCell, true) and not Players[pid]:IsServerStaff() then
		tes3mp.MessageBox(pid, -1, Trad.NoPerm)
		return false
	end
	addFurnitureItem(pname, choice.refId, -1, true)
	local pPos = {x = PosX, y = PosY, z = PosZ}
	local furnRefIndex = placeFurniture(choice.refId, pPos, curCell)
	addPlaced(furnRefIndex, curCell, pname, choice.refId, true)
	TFN_Decorate.SetSelectedObject(pid, furnRefIndex)
	TFN_Decorate.OnGUIAction(pid, 31360, 14)	
end


local function onInventoryOptionSell(pid)
	local pname = getName(pid)
	local choice = playerInventoryChoice[pname]	
	local saleGold = getSellValue(getFurnitureData(choice.refId).price)
	addGold(pid, saleGold)
	addFurnitureItem(pname, choice.refId, -1, true)
	tes3mp.MessageBox(pid, -1, saleGold ..trad.AddGoldInv)
end

showInventoryGUI = function(pid)
	local options = getSortedPlayerFurnitureInventory(pid)
	local list = trad.ListReturn
	for i = 1, #options do
		list = list .. options[i].name .. " (" .. options[i].count .. ")"
		if not(i == #options) then
			list = list .. "\n"
		end
	end	
	playerInventoryOptions[getName(pid)] = options
	tes3mp.ListBox(pid, config.InventoryGUI, trad.SelectFurn, list)
end

local function onInventoryChoice(pid, loc)
	showInventoryOptionsGUI(pid, loc)
end

showBuyGUI = function(pid, cat)
	local options = getAvailableFurnitureStock(pid)
	local opt = {}
	local list = trad.ListReturn	
	for i = 1, #options do
		if (options[i].cat == cat) then
			list = list .. options[i].name .. " (" .. options[i].price .. ")\n"
			table.insert(opt, options[i])
		end		
	end	
	playerBuyOptions[getName(pid)] = opt
	tes3mp.ListBox(pid, config.BuyGUI, color.CornflowerBlue ..trad.SelectBuy.. color.Default, list)
end
	
local function onBuyChoice(pid, loc)
	local pgold = getPlayerGold(pid)
	local choice = playerBuyOptions[getName(pid)][loc]	
	if pgold < choice.price then
		tes3mp.MessageBox(pid, -1, trad.NoPermBuy.. choice.name .. ".")
		return false
	else
		removeGold(pid, choice.price)
		addFurnitureItem(getName(pid), choice.refId, 1, true)		
		tes3mp.MessageBox(pid, -1, "" .. choice.name .. trad.AddObject)
		return true	
	end	
end

showMainGUI = function(pid)
	tes3mp.CustomMessageBox(pid, config.MainGUI, trad.MainMenu, trad.OptMenu)
end

local function onMainBuy(pid)
	local message = color.Green..trad.CatMenu
	tes3mp.CustomMessageBox(pid, config.CatGUI, message, trad.OptCat)
end

local function onMainInventory(pid)
	showInventoryGUI(pid)
end

local function onMainView(pid)
	showViewGUI(pid)
end

TFN_Furniture.OnGUIAction = function(pid, idGui, data)	
	if idGui == config.MainGUI then -- Main
		if tonumber(data) == 0 then --Buy
			onMainBuy(pid)
			return true
		elseif tonumber(data) == 1 then -- Inventory
			onMainInventory(pid)
			return true
		elseif tonumber(data) == 2 then -- View
			onMainView(pid)
			return true
		elseif tonumber(data) == 3 then -- Close
			Players[pid].currentCustomMenu = "menu housing"--main menu
			return true, menuHelper.DisplayMenu(pid, Players[pid].currentCustomMenu)
		end
	elseif idGui == config.CatGUI then -- Cat
		if tonumber(data) == 0 then--beds
			showBuyGUI(pid, "Beds")
			return true
		elseif tonumber(data) == 1 then 
			showBuyGUI(pid, "Chesty")
			return true
		elseif tonumber(data) == 2 then 
			showBuyGUI(pid, "Furniture")
			return true
		elseif tonumber(data) == 3 then
			showBuyGUI(pid, "Misc")
			return true
		elseif tonumber(data) == 4 then 
			showBuyGUI(pid, "Lighting")
			return true
		elseif tonumber(data) == 5 then 
			showBuyGUI(pid, "Rugs")
			return true
		elseif tonumber(data) == 6 then 
			showBuyGUI(pid, "Containers")
			return true
		elseif tonumber(data) == 7 then
			showBuyGUI(pid, "Imperial")
			return true
		elseif tonumber(data) == 8 then 
			showBuyGUI(pid, "Dunmer")
			return true
		elseif tonumber(data) == 9 then -- Close
			Players[pid].currentCustomMenu = "menu housing"--main menu
			return true, menuHelper.DisplayMenu(pid, Players[pid].currentCustomMenu)
		end	
	elseif idGui == config.BuyGUI then -- Buy
		if tonumber(data) == 0 or tonumber(data) == 18446744073709551615 then --Close/Nothing Selected
			return showMainGUI(pid)
		else
			onBuyChoice(pid, tonumber(data))
			return onMainBuy(pid)
		end
	elseif idGui == config.InventoryGUI then --Inventory main
		if tonumber(data) == 0 or tonumber(data) == 18446744073709551615 then --Close/Nothing Selected
			return showMainGUI(pid)
		else
			onInventoryChoice(pid, tonumber(data))
			return true 
		end
	elseif idGui == config.InventoryOptionsGUI then --Inventory options
		if tonumber(data) == 0 then --Place
			onInventoryOptionPlace(pid)
			return true
		elseif tonumber(data) == 1 then --Sell
			onInventoryOptionSell(pid)
			return onMainInventory
		else --Close
			return showMainGUI(pid)
		end
	elseif idGui == config.ViewGUI then --View
		if tonumber(data) == 0 or tonumber(data) == 18446744073709551615 then --Close/Nothing Selected
			return showMainGUI(pid)
		else
			onViewChoice(pid, tonumber(data))
			return true
		end
	elseif idGui == config.ViewOptionsGUI then -- View Options
		if tonumber(data) == 0 then --Select
			onViewOptionSelect(pid)
			return true
		elseif tonumber(data) == 1 then --Put away
			onViewOptionPutAway(pid)
			return onMainView(pid)
		elseif tonumber(data) == 2 then --Sell
			onViewOptionSell(pid)
			return onMainView(pid)		
		else 
			return showMainGUI(pid)
		end
	end
end

TFN_Furniture.OnCommand = function(pid)
	showMainGUI(pid)
end

TFN_Furniture.OnObjectActivate = function(eventStatus, pid, cellDescription, objects)
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		local ObjectIndex
		local ObjectRefid
		local pname = getName(pid)
		for _, object in pairs(objects) do
			ObjectIndex = object.uniqueIndex
			ObjectRefid = object.refId
		end	
		if ObjectIndex ~= nil and ObjectRefid ~= nil then
			local placedItem = getPlayerPlacedInCell(pname, cellDescription)
			if placedItem ~= false then
				if tableHelper.containsValue(placedItem, ObjectIndex, true) then
					tes3mp.MessageBox(pid, -1, color.Red.."Index: "..color.White..ObjectIndex)
				end
			end
			if tableHelper.containsValue(furnitureActivable, string.lower(ObjectRefid), true) then
				local placedItem = getPlayerPlacedInCell(pname, cellDescription)
				if placedItem ~= false then
					if tableHelper.containsValue(placedItem, ObjectIndex, true) then
						TFN_Decorate.SetSelectedObject(logicHandler.GetPlayerByName(Players[pid].name).pid, ObjectIndex)
						return customEventHooks.makeEventStatus(false,false)
					end
				else
					return customEventHooks.makeEventStatus(false,false)
				end
			end
		end
	end
end

TFN_Furniture.OnPlayerCellChange = function(eventStatus, pid)
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		local cellDescription = tes3mp.GetCell(pid)
		if cellDescription then
			AddPreexistingObjectsTFN_Furniture(cellDescription)
		end
	end
end

customEventHooks.registerValidator("OnObjectActivate", TFN_Furniture.OnObjectActivate)
customEventHooks.registerHandler("OnPlayerCellChange", TFN_Furniture.OnPlayerCellChange)		
customCommandHooks.registerCommand("furn", TFN_Furniture.OnCommand)
customEventHooks.registerHandler("OnGUIAction", function(eventStatus, pid, idGui, data)
	if TFN_Furniture.OnGUIAction(pid, idGui, data) then return end
end)
customEventHooks.registerHandler("OnServerPostInit", TFN_Furniture.OnServerPostInit)

return TFN_Furniture
