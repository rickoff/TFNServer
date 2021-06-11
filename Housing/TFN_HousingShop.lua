--[[
TFN_HousingShop by Rickoff
tes3mp 0.7.0
---------------------------
DESCRIPTION :
Script principal housing
---------------------------
INSTALLATION:
Require TFN_Decorate, TFN_Furniture
Save the file as TFN_HousingShop.lua inside your server/scripts/custom folder.
Save the file as TFN_Door.json inside your server/data/custom folder.
Save the folder as CellDataBase with all files contain inside your server/data/custom/CellDataBase/
Save the file as CellDataBaseStat.json inside your server/data/custom/CellDataBase folder.
Save the file as MenuHousing.lua inside your scripts/menu folder
Edits to customScripts.lua
TFN_HousingShop = require("custom.TFN_HousingShop")
Edits to config.lua
add in config.menuHelperFiles, "MenuHousing"
---------------------------
FUNCTION:
/home in your chat for open menu
---------------------------
]]
local trad = {
	WaitJail = color.White .. "You are in prison for a period of" .. color.Red .. " 5 " .. color.White .. "minutes",
	StopJail = color.White .. "Your time for" .. color.Red ..  " prison " .. color.White .. "has just ended",
	coma = "--------------------------------------- \n",
	count = "\ncost : ",
	commandInfo = ". \nWrite /houseinfo for more information.\n--------------------------------------- ",
	welcomeHouse = "Welcome home, ",
	welcome = "Welcome ",
	shop = " shop.",
	house = " house." ,
	closeHouse = "The house is locked.",
	openHouse = "The house is a shop.",
	access = "You have just entered part of ",
	questCell = "The house is currently locked, but you can enter here because it is important for a quest.",
	questPass = ", do only what you need to do for the quest.",
	Close = "The tenant has closed the house.",
	info = "Information\n",
	loc = "the rental of : ",
	endLoc = "\nThis will end the ",
	connectLoc = "\n remember to connect before the date to renew the rental.",
	setSelectHouse = "Currently selected house : ",
	nothing = "None",
	houseAct = "The house is currently ",
	closeKey = "locked. \n",
	openKey = "unlocked. \n",
	houseShop = "\nThe House is currently a Shop. \n",
	houseHouse = "\nThe House is currently a House. \n",
	statutHouse = "\nThe Statut is currently : ",	
	locTime = "\nThe house is rented until : ",
	explainHouse = (color.Yellow .. "[Select]" .. color.White .. "\nselect the house whose settings you want to change"
	..color.Yellow .. "\n\n [Add roommate]" .. color.White .. "\nadd a roommate"
	..color.Yellow .. "\n\n [Remove roommate]" .. color.White .. "\nremove a roommate \nRomates are allowed to enter your house while it is locked"
	..color.Yellow .. "\n\n [Lock]" .. color.White .. "\nlock /unlock the house \nWhen locked, no one except tenants, roommates or administrators can enter the house "
	..color.Yellow .. "\n\n [Teleport]" .. color.White .. "\nthis teleport home"
	..color.Yellow .. "\n\n [Sell]" .. color.White .. "\nto sell the house"
	..color.Yellow .. "\n\n [Shop]" .. color.White .. "\nto switch house or shop"
	..color.Yellow .. "\n\n [Statut]" .. color.White .. "\nto switch 'furniture' or 'empty' vanilla object\n(log-out/log-in require for respawn furn)"	
	),
	optMainHouse = "Select;Add roommate;Remove roommate;Lock;Teleport;Sell;Shop;Statut;Return;Close",
	coHouseInfo = color.Yellow .. "[Select]" .. color.White .. "\nselect home" .. color.Yellow .. "\n\n [Teleport]" .. color.White .. "\teleport home\n ",
	optCoHouse = "Select;Teleport;Back;Close",
	menuCat = (color.Red .. "HOUSING MENU"
	..color.Yellow .. "\n\n\n[Catalog]"
	..color.White .. "\nlist of all houses /shops"
	..color.Yellow .. "\n\n[Home / Shop]"
	..color.White .. "\nto configure the assets you own\n"
	),
	optMenuCat = "General Catalog;House Catalog;Shop Catalog;Back;Close",
	adminMenuinfo = ("#cyan. Create a new house to create and select a new house,"
	.. "or Select a house to select an existing one. \n\nEdit cell data is used to edit the information of the cell you are currently in."
	.. "If you have selected a house, you can then assign that cell to the one you selected. \n\nEdit house data is used to edit all kinds of things about the house itself."
	),
	optAdminMenu = "Create a new house;select a house;modify cell data;modify house data;close",
	selectHouseList = "Select a house from the list.",
	returnList = "* Return * \n",
	notConnect = "This player is not connected. \n",
	jail = " is in prison. \n",
	newPrice = "Enter a new price:",
	costPrice = "\n\nCost : ",
	optPrice = "Change price;Return",
	noGold = "You are poor!",
	noMoney = "You don't have enough money!",
	buyItem = "You bought an item!",
	optBuy = "Buy;Return",
	notSell = "This item is not for sale!",
	selectValidHouse = "Please select a valid house first.",
	namedHouse = "Enter a name for the house",
	houseInput = "House",
	closeAdminList = "* Close * \n",
	noSelectHouse = "You do not have the selected house.",
	Feli = "Congratulations \n",
	SellHouse = "you sold the house and got the furniture from",
	SellMeub = "you sold the house for its original price and the furniture",
	SellFor = "for",
	SellGold = "gold.",
	InfoNobody = "nobody",
	InfoCount = "The house is worth ",
	InfoOwner = "gold, currently owned by ",
	InfoIndoor = "The interior of the house consists of the following cells : \n",
	InfoContainer = " | Contains owned containers",
	InfoWay = " | Is passage required",
	InfoReset = " | Requires cell resets",
	InfoContOwner = "If a cell is marked with owned containers, it means that the containers are owned by the tenant",
	InfoWayStat = "Mandatory passages are cells to complete certain quests. Cells marked as such can still be explored by players, even if the house is locked.",
	InfoResetStat = "Cells marked as needing resets can sometimes reset some or all of their content.",
	InfoShortVal = "- Vault",
	InfoShortOwner = "- Owned by",
	WelcomeShop = "Welcome to the store.",
	PromtPrice = "Enter a new price",
	NoSelectHouseSell = "You do not have a house selected, nor are you in a house for sale.",
	ShowEditHouseMain = "'Set here as entry' indicates where players will arrive when they teleport here.\n'Set here as exit' indicates where players will be placed if kicked out.",
	ShowEditHouseEnter = "Assigned entry : ",
	ShowEditHouseNot = "None \n",
	ShowEditHouseExit = "Assigned exit : ",
	ShowEditHouseOpt = "Set price;Set tenant;Set here as entry;Set here as exit;Delete house;Close",
	PlayerSellSo = " is on sale for ",
	PlayerSellGo = " gold.",
	PlayerSellIn = "furniture you placed inside have a value of",
	PlayerSellNo = "gold. Note : Selling the house will send all furniture placed by the roommate to their furniture inventory.",
	PlayerSellBo = "Sell house + furniture; Sell house + Collect furniture; Cancel",
	PlayerSellSell = "Sell house; Cancel",
	RemoveListCo = "Select a roommate to remove. Note : Removing a roommate will return all of their furniture.",
	AddPromptName = "Enter the name of the character",
	AddPromptOpt = "add roommate",
	CellEditName = "Name : ",
	CellEditHouse = "Associated house : ",
	CellEditCont = "Containers owned : ",
	CellEditWay = "Access required : ",
	CellEditReset = "Requires resets : ",
	CellEditAtt = "Assign to selected house;Remove from selected house;Toggle containers in ownership;Toggle required access;Toggle required resets;Close",
	HouseNoExist = "Your selected house does not seem to exist anymore!",
	WarpSelect = "The teleportation feature is disabled on this server.",
	WarpNo = "You cannot teleport at this time.",
	RenewLocNo = "You cannot afford to renew this house.",
	RenewLocYe = "you have renewed the rental of \n",
	RenewLocCo = "\nUse the command" ..color.Red .. " /myhouse "..color.White.."to manage your home settings.",
	HouseInfoBuyPo = "Someone already owns this house!",
	HouseInfoBuyYe = "You already own this house.",
	HouseInfoBuyNo = "You cannot afford this house.",
	HouseInfoBuyOwner = "you are now the tenant of \n",
	Warning = "Attention\n",
	NoFindHouse = "Cannot find the selected house.",
	HouseInfoBuyDe = "you are already the tenant of",
	DeleteOwner = "Enter 'none' to delete",
	LocAct = "current tenant",
	NoDataBaseCell = "No benchmark data for this cell."	
}
	
local config = {
	defaultPrice = 5000, --The price a house defaults to when it's created
	requiredAdminRank = 1, --The admin rank required to use the admin GUI
	allowWarp = true, --Whether or not players can use the option to warp to their home
	allowWarpCo = true, --Whether or not players can use the option to warp to their home	
	logging = true, --If the script reports its own information to the server log
	chatColor = "#FFDC00", --The color used for the script's chat messages
	CountMaxOwners = 2, --The max house by player
	NextLocation = 2628000, --Time location
	Furn = true,
	Actor = true,
	AdminMainGUI = 31371,
	AdminHouseCreateGUI = 31372,
	AdminHouseSelectGUI = 31373,
	CellEditGUI = 31374,
	HouseEditGUI = 31375,
	HouseEditPriceGUI = 31376,
	HouseEditOwnerGUI = 31377,
	HouseInfoGUI = 31378,
	PlayerMainCatalogueGUI = 31379,
	PlayerAllHouseSelectGUI = 31380,
	PlayerAllHouseSelectGUI = 31381,
	PlayerAllHouseSelectGUI = 31382,
	PlayerSettingGUI = 31383,
	PlayerOwnedHouseSelect = 31384,
	PlayerAddCoOwnerGUI = 31385,
	PlayerRemoveCoOwnerGUI = 31386,
	PlayerSellConfirmGUI = 31387,
	ViewOptionsGUI = 31388,
	ViewShopOptionsGUI = 31389,
	ItemEditPriceGUI = 31390,
	PlayerSettingGUICo = 31391,
	PlayerOwnedHouseSelectCo = 31392
}

local serverConfig = require("config")
local lastEnteredHouse = {}
local adminSelectedHouse = {}
local adminHouseList = {}
local playerSelectedHouse = {}
local playerAllHouseList = {}
local playerOwnedHouseList = {}
local playerOwnedHouseListCo = {}
local playerCoOwnerList = {}
local playerViewChoice = {}
local FurnData = {}
local StaticData = {}
local DoorData = {}
local housingData = {houses = {}, cells = {}, owners = {}}

local TFN_HousingShop = {}

local function ListCheck()
	local StaticList = jsonInterface.load("custom/CellDataBase/CellDataBaseStat.json")	
	for i = 1, #StaticList do
		if config.Furn == true then
			if string.find(string.lower(StaticList[i]), "furn") then
				FurnData[string.lower(StaticList[i])] = ""		
			else
				StaticData[string.lower(StaticList[i])] = ""
			end
		else
			StaticData[string.lower(StaticList[i])] = ""
		end
	end
	local DoorList = jsonInterface.load("custom/TFN_Door.json")
	for index, item in pairs(DoorList) do
		DoorData[string.lower(item.refid)] = ""
	end
end

local function msg(pid, text)
	tes3mp.SendMessage(pid, config.chatColor .. text .. "\n" .. color.Default)
end

local function Load()
	housingData = jsonInterface.load("custom/TFN_HousingShop.json")
end

local function getName(pid)
	return string.lower(Players[pid].accountName)
end

local function Save()
	jsonInterface.save("custom/TFN_HousingShop.json", housingData)
end

local function getPlayerGold(playerName)
	if playerName ~= nil then
		local player = logicHandler.GetPlayerByName(playerName)		
		if player then
			local goldLoc = inventoryHelper.getItemIndex(player.data.inventory, "gold_001", -1)
			
			if goldLoc then
				return player.data.inventory[goldLoc].count
			else
				return 0
			end
		else
			return false
		end
	end
end

local function addGold(playerName, amount)
	local player = logicHandler.GetPlayerByName(playerName)	
	if player then
		local goldLoc = inventoryHelper.getItemIndex(player.data.inventory, "gold_001", -1)
		if goldLoc then
			player.data.inventory[goldLoc].count = player.data.inventory[goldLoc].count + amount

			if player.data.inventory[goldLoc].count < 1 then
				player.data.inventory[goldLoc] = nil
			end
		else

			if amount > 0 then
				table.insert(player.data.inventory, {refId = "gold_001", count = amount, charge = -1, soul = ""})
			end
		end		
		if player:IsLoggedIn() then
			local itemref = {refId = "gold_001", count = amount, charge = -1, soul = ""}	
			player:QuicksaveToDrive()
			player:LoadItemChanges({itemref}, enumerations.inventory.ADD)
		else
			player.loggedIn = true
			player:QuicksaveToDrive()
			player.loggedIn = false
		end
		
		return true
	else
		return false
	end
end

local function removeGold(playerName, amount)
	local player = logicHandler.GetPlayerByName(playerName)
	if player then
		local goldLoc = inventoryHelper.getItemIndex(player.data.inventory, "gold_001", -1)
		
		if goldLoc then
			player.data.inventory[goldLoc].count = player.data.inventory[goldLoc].count - amount			
			if player.data.inventory[goldLoc].count < 1 then
				player.data.inventory[goldLoc] = nil
			end
		else
			if amount > 0 then
				table.insert(player.data.inventory, {refId = "gold_001", count = amount, charge = -1, soul = ""})
			end
		end		
		if player:IsLoggedIn() then

			local itemref = {refId = "gold_001", count = amount, charge = -1, soul = ""}	
			player:QuicksaveToDrive()
			player:LoadItemChanges({itemref}, enumerations.inventory.REMOVE)
		else

			player.loggedIn = true
			player:QuicksaveToDrive()
			player.loggedIn = false
		end		
		return true
	else
		return false
	end
end

local function warpPlayer(pid, cell, pos, rot)	
	tes3mp.SetCell(pid, cell)
	tes3mp.SendCell(pid)	
	tes3mp.SetPos(pid, pos.x, pos.y, pos.z)
	tes3mp.SendPos(pid)
end

local function createNewHouse(houseName)
	housingData.houses[houseName] = {
		name = houseName,
		price = config.defaultPrice,
		statut = "nothing",
		cells = {},
		doors = {}, 
		inside = {},
		outside = {}
	}
	Save()
end

local function createNewOwner(oname)
	local oname = string.lower(oname)
	housingData.owners[oname] = {
		houses = {},
	}
	Save()
end

local function createNewCell(cellDescription)
	housingData.cells[cellDescription] = {
		name = cellDescription,
		house = nil,
		ownedContainers = false,
		requiredAccess = false,
		requiresResets = false, 
		resetInfo = {}
	}
	Save()
end

local function registerName(pid)
	housingData.loginNames[getName(pid)] = Players[pid].data.login.name
end

local function deleteHouse(houseName)
	housingData.houses[houseName] = nil
	for cellName, v in pairs(housingData.cells) do
		if housingData.cells[cellName].house == houseName then
			housingData.cells[cellName].house = nil
		end
	end
	for ownerName, v in pairs(housingData.owners) do
		for cellName, slot in pairs(housingData.owners[ownerName].houses) do			
			if cellName == houseName then
				housingData.owners[ownerName].houses[cellName] = nil
			end
		end
	end	
	Save()
end

local function setHousePrice(houseName, price)
	if housingData.houses[houseName] then
			housingData.houses[houseName].price = tonumber(price) or config.defaultPrice
		Save()
	end
end

local function getHouseOwnerName(houseName)
	for pname, v in pairs(housingData.owners) do
		if housingData.owners[pname].houses[houseName] ~= nil then
			return pname
		end
	end
	return false
end

local function getHouseCoOwnerName(houseName)
	local oname = getHouseOwnerName(houseName)
	if oname then
		for coName, v in pairs(housingData.owners[oname].houses[houseName].coowners) do
			if housingData.owners[oname].houses[houseName].coowners[coName] ~= nil then
				return coName
			end
		end
	end
	return false
end

local function getCountHouseOwners(ownerName)
	local count = 0
	if housingData.owners[ownerName] then
		for x, y in pairs(housingData.owners[ownerName].houses) do
			count = count + 1
		end
		if count < config.CountMaxOwners then
			return true
		else
			return false
		end
	else
		return true
	end
end

local function getIsInHouse(pid)
	local currentCell = tes3mp.GetCell(pid)	
	if housingData.cells[currentCell] and housingData.cells[currentCell].house ~= nil then
		return housingData.cells[currentCell].house, housingData.cells[currentCell]
	else
		return false
	end
end

local function assignCellToHouse(cell, houseName)
	if housingData.houses[houseName] then
		housingData.houses[houseName].cells[cell] = true
		housingData.cells[cell].house = houseName
		Save()
	end
end

local function removeCellFromHouse(cell, houseName)
	if housingData.houses[houseName] then
		housingData.houses[houseName].cells[cell] = nil
		housingData.cells[cell].house = nil
		Save()
	end
end

local function removeHouseOwner(pid, houseName, refund, furnReturn)
	local oname = getHouseOwnerName(houseName)
	local hdata = housingData.houses[houseName]	
	if not oname or not hdata then
		return false
	end
	if refund then
		addGold(oname, hdata.price)
	end	
	if TFN_Furniture ~= nil then
		for cellName, v in pairs(hdata.cells) do
			TFN_Furniture.RemoveAllPermissions(cellName)

			for coName, v in pairs(housingData.owners[oname].houses[houseName].coowners) do
				TFN_Furniture.RemoveAllPlayerFurnitureInCell(coName, cellName, true)
			end
		end		
		if furnReturn == "return" then
			for cellName, v in pairs(hdata.cells) do
				TFN_Furniture.RemoveAllPlayerFurnitureInCell(oname, cellName, true)					
			end
			tes3mp.MessageBox(pid, -1, color.Gold..trad.Feli..color.White..trad.SellHouse..houseName..".")			
		elseif furnReturn == "sell" then
			local placedNum = 0
			local placedSellback = 0		
			for cellName, v in pairs(hdata.cells) do
				local placed = TFN_Furniture.GetPlacedInCell(cellName)
				if placed then
					for refIndex, v2 in pairs(placed) do
						if v2.owner == oname then
							placedNum = placedNum + 1
							placedSellback = placedSellback + TFN_Furniture.GetSellBackPrice(TFN_Furniture.GetFurnitureDataByRefId(v2.refId).price)
						end
					end
				end
				TFN_Furniture.RemoveAllPlayerFurnitureInCell(oname, cellName, false)
			end		
			addGold(oname, placedSellback)	
			tes3mp.MessageBox(pid, -1, color.Gold..trad.Feli..color.White..trad.SellMeub..houseName..trad.SellFor..placedSellback..trad.SellGold)				
		end
	end
	housingData.owners[oname].houses[houseName] = nil
	Save()
end

local function addHouseOwner(oname, houseName)
	local oname = string.lower(oname)
	local hdata = housingData.houses[houseName]
	if not housingData.owners[oname] then
		createNewOwner(oname)
	end
	housingData.owners[oname].houses[houseName] = {}
	housingData.owners[oname].houses[houseName].coowners = {}
	housingData.owners[oname].houses[houseName].dateLocation = os.time()	
	housingData.owners[oname].houses[houseName].isLocked = false
	housingData.owners[oname].houses[houseName].isShop = false	
	if TFN_Furniture ~= nil then
		for cellName, v in pairs(hdata.cells) do
			TFN_Furniture.AddPermission(oname, cellName)
		end
	end	
	Save()
end

local function addCoOwner(houseName, pname)
	local pname = string.lower(pname)
	local oname = getHouseOwnerName(houseName)
	local hdata = housingData.houses[houseName]	
	if pname ~= oname then
		housingData.owners[oname].houses[houseName].coowners[pname] = true
		
		if TFN_Furniture ~= nil then
			--Give the player permission to place furniture in all of the house's cells
			for cellName, v in pairs(hdata.cells) do
				TFN_Furniture.AddPermission(pname, cellName)
			end
		end
	end	
	Save()
end

local function getHouseInfoLong(houseName, toggleMeanings) --Used in GUI labels
	local text = ""
	local hdata = housingData.houses[houseName]
	if not hdata then
		return false
	end	
	text = text.."="..hdata.name.."=\n"
	local owner = trad.InfoNobody
	if getHouseOwnerName(hdata.name) then
		owner = getHouseOwnerName(hdata.name)
	end
	text = text..trad.InfoCount..hdata.price..trad.InfoOwner..owner..".\n"	
	local hasOwned, hasAccess, hasResets
	text = text..trad.InfoIndoor
	for cellName, v in pairs(hdata.cells) do
		local cdata = housingData.cells[cellName]
		local addText = "* "
		addText = addText .. cellName
		if cdata.ownedContainers then
			addText = addText..trad.InfoContainer
			hasOwned = true
		end
		if cdata.requiredAccess then
			addText = addText..trad.InfoWay
			hasAccess = true
		end
		if cdata.requiresResets then
			addText = addText..trad.InfoReset
			hasResets = true
		end
		
		addText = addText.."\n"
		text = text .. addText
	end	
	if toggleMeanings then
		if hasOwned or hasAccess or hasResets then
			text = text.."\n"
			if hasOwned then
				text = text..trad.InfoContOwner
			end
			if hasAccess then
				text = text..trad.InfoWayStat
			end
			if hasResets then
				text = text..trad.InfoResetStat
			end
		end
	end	
	return text
end

local function getHouseInfoShort(houseName)
	local text = ""
	local hdata = housingData.houses[houseName]
	if not hdata then
		return false
	end
	text = text..hdata.name	
	text = text..trad.InfoShortVal..hdata.price	
	local owner = trad.nobody
	if getHouseOwnerName(hdata.name) then
		owner = getHouseOwnerName(hdata.name)
	end	
	text = text..trad.InfoShortOwner..owner		
	return text
end

local function assignHouseInside(houseName, cell, x, y, z)
	local hdata = housingData.houses[houseName]
	if not hdata then
		return false
	end	
	hdata.inside.cell = cell
	hdata.inside.pos = {x = x, y = y, z = z}	
	Save()	
end

local function assignHouseOutside(houseName, cell, x, y, z)
	local hdata = housingData.houses[houseName]
	if not hdata then
		return false
	end	
	hdata.outside.cell = cell
	hdata.outside.pos = {x = x, y = y, z = z}	
	Save()	
end

local function isOwner(pname, houseName)
	local pname = string.lower(pname)
	if getHouseOwnerName(houseName) == pname then
		return true
	else
		return false
	end
end

local function isCoOwner(pname, houseName)
	local pname = string.lower(pname)
	local oname = getHouseOwnerName(houseName)
	if oname then
		for coOwner, v in pairs(housingData.owners[oname].houses[houseName].coowners) do
			if pname == string.lower(coOwner) then
				return true
			end
		end
	end
	return false
end

local function isLocked(houseName)
	if getHouseOwnerName(houseName) then
		return housingData.owners[getHouseOwnerName(houseName)].houses[houseName].isLocked
	else
		return false
	end
end

local function isShop(houseName)
	if getHouseOwnerName(houseName) then
		return housingData.owners[getHouseOwnerName(houseName)].houses[houseName].isShop
	else
		return false
	end
end

local function isAllowedEnter(pid, cell)
	local pname = getName(pid)
	local cdata = housingData.cells[cell]	
	if not cdata or cdata.house == nil then
		return true, "no data"
	end	
	local hdata = housingData.houses[cdata.house]	
	if not hdata then
		return true, "no data"
	end	
	if isLocked(hdata.name) then
		if isOwner(pname, hdata.name) then
			return true, "owner"
		elseif isCoOwner(pname, hdata.name) then
			return true, "coowner"
		elseif Players[pid].data.settings.staffRank == 2 then --Moderators/Admins should always be allowed to enter
			return true, "admin"
		elseif cdata.requiredAccess then
			return true, "access"
		else
			return false, "close"
		end
	elseif not getHouseOwnerName(hdata.name) then --There's no owner
		return true, "unowned"
	else
		return true, "unlocked"
	end	
	if isShop(hdata.name) then
		if isOwner(pname, hdata.name) then
			return true, "owner"
		elseif isCoOwner(pname, hdata.name) then
			return true, "coowner"
		elseif Players[pid].data.settings.staffRank == 2 then --Moderators/Admins should always be allowed to enter
			return true, "admin"
		elseif cdata.requiredAccess then
			return true, "access"
		else
			return false, "close"
		end
	elseif not getHouseOwnerName(hdata.name) then --There's no owner
		return true, "unowned"
	else
		return true, "unlocked"
	end	
end

local function onLockStatusChange(houseName)
	local hdata = housingData.houses[houseName]
	local destinationCell, destinationPos
	if hdata.outside.cell then 
		destinationCell = hdata.outside.cell
		destinationPos = hdata.outside.pos
	else
		destinationCell = serverConfig.defaultSpawnCell
		destinationPos = {x = serverConfig.defaultSpawnPos[1], y = serverConfig.defaultSpawnPos[2], z = serverConfig.defaultSpawnPos[3]}
	end	
	if isLocked(houseName) then
		for playerId, player in pairs(Players) do
			if player:IsLoggedIn() then
				local inHouse, cdata = getIsInHouse(playerId)			
				if inHouse == houseName then
					local canEnter, reason = isAllowedEnter(playerId, cdata.name)
					if reason == "owner" or reason == "coowner" or reason == "admin" then
					
					elseif reason == "access" then
						msg(playerId, trad.LockQuestPass)
					else
						warpPlayer(playerId, destinationCell, destinationPos)
						msg(playerId, trad.Close)
					end
				end
			end
		end
	end	
end

local function onShopStatusChange(houseName)
	local hdata = housingData.houses[houseName]
	local destinationCell, destinationPos
	if hdata.outside.cell then
		destinationCell = hdata.outside.cell
		destinationPos = hdata.outside.pos
	else
		destinationCell = serverConfig.defaultSpawnCell
		destinationPos = {x = serverConfig.defaultSpawnPos[1], y = serverConfig.defaultSpawnPos[2], z = serverConfig.defaultSpawnPos[3]}
	end
	if isShop(houseName) then
		for playerId, player in pairs(Players) do
			if player:IsLoggedIn() then
				local inHouse, cdata = getIsInHouse(playerId)
				
				if inHouse == houseName then
					local canEnter, reason = isAllowedEnter(playerId, cdata.name)
					if reason == "owner" or reason == "coowner" or reason == "admin" then
					else
						msg(playerId, trad.WelcomeShop)
					end
				end
			end
		end
	end	
end

local function removeCoOwner(houseName, pname)
	local pname = string.lower(pname)
	local oname = getHouseOwnerName(houseName)
	local hdata = housingData.houses[houseName]	
	housingData.owners[oname].houses[houseName].coowners[pname] = nil	
	if TFN_Furniture ~= nil then
		for cellName, v in pairs(hdata.cells) do
			TFN_Furniture.RemovePermission(pname, cellName)
			TFN_Furniture.RemoveAllPlayerFurnitureInCell(pname, cellName, true)
		end
	end	
	Save()
	onLockStatusChange(houseName)
	onShopStatusChange(houseName)
end

local function canWarp(pid)
	return config.allowWarp
end

local function canWarpCo(pid)
	return config.allowWarpCo
end

local function unlockChecks(cell)	
	local changes = false
	for houseName, hdata in pairs(housingData.houses) do
		for cellName, ddata in pairs(hdata.doors) do
			if cellName == cell then
				if LoadedCells[cell] == nil then
					logicHandler.LoadCell(cell)
				end
				
				for i, doorData in pairs(ddata) do
					local refIndex = doorData.refIndex
					local refId = doorData.refId
					if not LoadedCells[cell]:ContainsObject(refIndex) then
						LoadedCells[cell]:InitializeObjectData(refIndex, refId)
						changes = true
					end
					
					if not LoadedCells[cell].data.objectData[refIndex].lockLevel or LoadedCells[cell].data.objectData[refIndex].lockLevel ~= 0 then
						LoadedCells[cell].data.objectData[refIndex].lockLevel = 0
						tableHelper.insertValueIfMissing(LoadedCells[cell].data.packets.lock, refIndex)
						changes = true
					end
				end
				
			end
		end
	end	
	if changes then
		LoadedCells[cell]:QuicksaveToDrive()
		for playerId, player in pairs(Players) do
			if player:IsLoggedIn() then
				LoadedCells[cell]:SendObjectsLocked(playerId)
			end
		end
	end
end

local function onDirtyThief(pid, houseName)
	local destinationCell, destinationPos
	local hdata = housingData.houses[houseName]
	if hdata then
		if hdata.outside.cell then
			destinationCell = hdata.outside.cell
			destinationPos = hdata.outside.pos
		else
			destinationCell = serverConfig.defaultSpawnCell
			destinationPos = {x = serverConfig.defaultSpawnPos[1], y = serverConfig.defaultSpawnPos[2], z = serverConfig.defaultSpawnPos[3]}
		end	
		warpPlayer(pid, destinationCell, destinationPos)	
		Players[pid].currentCustomMenu = "menu prison house"--Avertisseent
		menuHelper.DisplayMenu(pid, Players[pid].currentCustomMenu)	
	end
end

local function showAdminMain(pid)
	local message = ""
	if adminSelectedHouse[getName(pid)] then
		message = message..color.White..trad.setSelectHouse..color.Yellow..adminSelectedHouse[getName(pid)].."\n\n\n"
	end
	message = message..trad.adminMenuinfo
	return tes3mp.CustomMessageBox(pid, config.AdminMainGUI, message, trad.optAdminMenu)
end

local function showHouseEditPricePrompt(pid)
	local message = trad.PromtPrice
	return tes3mp.InputDialog(pid, config.HouseEditPriceGUI, message, "")
end

local function showHouseEditMain(pid)
	local message = getHouseInfoLong(adminSelectedHouse[getName(pid)], false)
	message = message.."\n\n"	
	message = message..trad.ShowEditHouseMain	
	message = message.."\n\n"	
	local hdata = housingData.houses[adminSelectedHouse[getName(pid)]]
	message = message..trad.ShowEditHouseEnter
	if not hdata.inside.cell then
		message = message..trad.ShowEditHouseNot
	else
		message = message.."Cell - "..hdata.inside.cell.." | Pos - ".. math.floor(hdata.inside.pos.x + 0.5)..", ".. math.floor(hdata.inside.pos.y + 0.5)..", ".. math.floor(hdata.inside.pos.z + 0.5).."\n"
	end
	message = message..trad.ShowEditHouseExit
	if not hdata.outside.cell then
		message = message..trad.ShowEditHouseNot
	else
		message = message.."Cell - "..hdata.outside.cell.." | Pos - ".. math.floor(hdata.outside.pos.x + 0.5)..", ".. math.floor(hdata.outside.pos.y + 0.5)..", ".. math.floor(hdata.outside.pos.z + 0.5).."\n"
	end	
	return tes3mp.CustomMessageBox(pid, config.HouseEditGUI, message, trad.ShowEditHouseOpt)
end

local function showHouseInfo(pid)
	local message = ""
	local hdata
	local pcell = tes3mp.GetCell(pid)
	if housingData.cells[pcell] and housingData.cells[pcell].house and housingData.houses[housingData.cells[pcell].house] then
		hdata = housingData.houses[housingData.cells[pcell].house]
		playerSelectedHouse[getName(pid)] = hdata.name
	end	
	if hdata then
		message = message..getHouseInfoLong(hdata.name, true)
	else
		message = message..trad.NoSelectHouseSell
		playerSelectedHouse[getName(pid)] = nil
	end	
	return tes3mp.CustomMessageBox(pid, config.HouseInfoGUI, message, trad.optBuy)
end

local function showHouseInfoSelected(pid)
	local message = ""
	local hdata
	if not playerSelectedHouse[getName(pid)] or not housingData.houses[playerSelectedHouse[getName(pid)]] then
		local pcell = tes3mp.GetCell(pid)
		if housingData.cells[pcell] and housingData.cells[pcell].house and housingData.houses[housingData.cells[pcell].house] then
			hdata = housingData.houses[housingData.cells[pcell].house]
			playerSelectedHouse[getName(pid)] = hdata.name
		end
	else
		hdata = housingData.houses[playerSelectedHouse[getName(pid)]]
	end	
	if hdata then
		message = message .. getHouseInfoLong(hdata.name, true)
	else
		message = message ..trad.NoSelectHouseSell
		playerSelectedHouse[getName(pid)] = nil
	end	
	return tes3mp.CustomMessageBox(pid, config.HouseInfoGUI, message, trad.optBuy)
end

local function showUserMain(pid)
	local message = color.Red..trad.menuCat
	tes3mp.CustomMessageBox(pid, config.PlayerMainCatalogueGUI, message, trad.optMenuCat)
end

local function showPlayerSettingsMainCo(pid)
	local message = ""
	if playerSelectedHouse[getName(pid)] and getHouseCoOwnerName(playerSelectedHouse[getName(pid)]) ~= getName(pid) then
		playerSelectedHouse[getName(pid)] = nil
	end
	message = message..color.White..trad.setSelectHouse..color.Yellow..(playerSelectedHouse[getName(pid)] or trad.nothing).."\n\n\n"	
	if playerSelectedHouse[getName(pid)] then
		local hdata = housingData.houses[playerSelectedHouse[getName(pid)]]		
		message = message .. trad.houseAct
		if hdata then
			if isLocked(hdata.name) then
				message = message..trad.closeKey
			else
				message = message..trad.openKey
			end
			
			if isShop(hdata.name) then
				message = message..trad.houseShop
			else
				message = message..trad.houseHouse
			end	

			if hdata.statut then
				message = message..trad.statutHouse..hdata.statut.."\n"
			end				
		end
	end	
	message = message .. "\n"
	message = message ..trad.coHouseInfo	
	return tes3mp.CustomMessageBox(pid, config.PlayerSettingGUICo, message, trad.optCoHouse)
end

local function showAdminHouseSelect(pid)
	local message = trad.selectHouseList
	local options = {}	
	local list = trad.closeAdminList	
	for houseName, v in pairs(housingData.houses) do
		table.insert(options, houseName)
	end
	table.sort(options, function(a,b) return a<b end)	
	for i=1, #options do
		list = list .. options[i]
		if not (i == #options) then
			list = list .. "\n"
		end
	end	
	adminHouseList[getName(pid)] = options
	return tes3mp.ListBox(pid, config.AdminHouseSelectGUI, message, list)
end

local function showHouseCreate(pid)
	local message = trad.namedHouse
	return tes3mp.InputDialog(pid, config.AdminHouseCreateGUI, message, trad.houseInput)
end

local function showPlayerSellOptions(pid)
	local message = ""
	local buttons = ""	
	local hdata = housingData.houses[playerSelectedHouse[getName(pid)]]
	if TFN_Furniture ~= nil then
		local placedNum = 0
		local placedSellback = 0
		
		for cellName, v in pairs(hdata.cells) do
			local placed = TFN_Furniture.GetPlacedInCell(cellName)
			if placed then
				for refIndex, v2 in pairs(placed) do
					if v2.owner == getName(pid) then
						placedNum = placedNum + 1
						if TFN_Furniture.GetFurnitureDataByRefId(v2.refId).price then
							placedSellback = placedSellback + TFN_Furniture.GetSellBackPrice(TFN_Furniture.GetFurnitureDataByRefId(v2.refId).price)
						end
					end
				end
			end
		end	
		message = message..hdata.name..trad.PlayerSellSo..hdata.price..trad.PlayerSellGo..placedNum..trad.PlayerSellIn..placedSellback..trad.PlayerSellNo
		buttons = trad.PlayerSellBo
	else
		message = message .. hdata.name ..trad.PlayerSellSo..hdata.price..trad.PlayerSellGo
		buttons = trad.PlayerSellSell
	end	
	tes3mp.CustomMessageBox(pid, config.PlayerSellConfirmGUI, message, buttons)
end

local function showPlayerSettingsRemoveList(pid)
	local message = trad.RemoveListCo
	local options = {}	
	local list = trad.closeAdminList
	local coOwners = housingData.owners[getName(pid)].houses[playerSelectedHouse[getName(pid)]].coowners	
	for coname, v in pairs(coOwners) do
		table.insert(options, coname)
	end
	for i=1, #options do
		list = list .. options[i]
		if not (i == #options) then
			list = list .. "\n"
		end
	end	
	playerCoOwnerList[getName(pid)] = options
	return tes3mp.ListBox(pid, config.PlayerRemoveCoOwnerGUI, message, list)
end

local function showPlayerSettingsAddPrompt(pid)
	local message = trad.AddPromptName
	return tes3mp.InputDialog(pid, config.PlayerAddCoOwnerGUI, message, trad.AddPromptOpt)
end

local function showPlayerSettingsOwnedListCo(pid)
	local message = trad.selectHouseList
	local options = {}	
	local list = trad.returnList	
	for houseName, v in pairs(housingData.houses) do
		if getHouseCoOwnerName(houseName) == getName(pid) then
			table.insert(options, houseName)
		end
	end
	for i=1, #options do
		list = list .. options[i]
		if not (i == #options) then
			list = list .. "\n"
		end
	end	
	playerOwnedHouseListCo[getName(pid)] = options
	return tes3mp.ListBox(pid, config.PlayerOwnedHouseSelectCo, message, list)
end

local function showPlayerSettingsMain(pid)
	local message = ""
	if playerSelectedHouse[getName(pid)] and getHouseOwnerName(playerSelectedHouse[getName(pid)]) ~= getName(pid) then
		playerSelectedHouse[getName(pid)] = nil
	end	
	message = message..color.White..trad.setSelectHouse..color.Yellow..(playerSelectedHouse[getName(pid)] or trad.nothing) .. "\n\n\n"	
	if playerSelectedHouse[getName(pid)] then
		local hdata = housingData.houses[playerSelectedHouse[getName(pid)]]
		local odata = housingData.owners[getName(pid)].houses[playerSelectedHouse[getName(pid)]]
		message = message..trad.houseAct
		if hdata then
			if isLocked(hdata.name) then
				message = message..trad.closeKey
			else
				message = message..trad.openKey
			end
			
			if isShop(hdata.name) then
				message = message..trad.houseShop
			else
				message = message..trad.houseHouse 
			end	
			
			if hdata.statut then
				message = message..trad.statutHouse..hdata.statut.."\n"
			end				
		end
		if odata then
			local DateLastLocation = odata.dateLocation + config.NextLocation
			local DateNextLocation = os.date("%d", DateLastLocation).."/"..os.date("%m", DateLastLocation).."/"..os.date("%Y", DateLastLocation)..""
			
			message = message..trad.locTime..color.White..DateNextLocation.."\n"
		end
	end	
	message = message.."\n"
	message = message..trad.explainHouse	
	return tes3mp.CustomMessageBox(pid, config.PlayerSettingGUI, message, trad.optMainHouse)
end

local function showCellEditMain(pid)
	local cell = tes3mp.GetCell(pid)
	local message = ""
	if not housingData.cells[cell] then
		createNewCell(cell)
	end	
	local cdata = housingData.cells[cell]
	message = message..trad.CellEditName..cdata.name.."\n"
	message = message..trad.CellEditHouse..(cdata.house or "no data").."\n"
	message = message..trad.CellEditCont..tostring(cdata.ownedContainers).."\n"
	message = message..trad.CellEditWay..tostring(cdata.requiredAccess).."\n"
	message = message..trad.CellEditReset..tostring(cdata.requiresResets).."\n"	
	return tes3mp.CustomMessageBox(pid, config.CellEditGUI, message, trad.CellEditAtt)
end

local function onHouseEditPricePrompt(pid, data)
	local price
	if data == nil or data == "" or not tonumber(data) or tonumber(data) < 0 then
		price = config.defaultPrice
	else
		price = data
	end	
	if housingData.houses[adminSelectedHouse[getName(pid)]] then
		setHousePrice(adminSelectedHouse[getName(pid)], price)
		return showHouseEditMain(pid)
	else
		tes3mp.MessageBox(pid,-1, trad.HouseNoExist)
	end
end

local function onPlayerSellHouseAndFurniture(pid)
	removeHouseOwner(pid, playerSelectedHouse[getName(pid)], true, "sell")
end

local function onPlayerSellHouseAndCollect(pid)
	removeHouseOwner(pid, playerSelectedHouse[getName(pid)], true, "return")
end

local function onPlayerSellHouse(pid)
	removeHouseOwner(pid, playerSelectedHouse[getName(pid)], true)
end

local function onCoOwnerRemoveSelect(pid, index)
	removeCoOwner(playerSelectedHouse[getName(pid)], playerCoOwnerList[getName(pid)][index])
	return showPlayerSettingsMain(pid)
end

local function onPlayerSettingsAddPrompt(pid, data)
	if data == nil or data == "" then

	else
		addCoOwner(playerSelectedHouse[getName(pid)], string.lower(data))
	end
	return showPlayerSettingsMain(pid)
end

local function showPlayerSettingsOwnedList(pid)
	local message = trad.selectHouseList
	local options = {}	
	local list =  trad.returnList	
	for houseName, v in pairs(housingData.houses) do
		if getHouseOwnerName(houseName) == getName(pid) then
			table.insert(options, houseName)
		end
	end
	for i=1, #options do
		list = list .. options[i]
		if not (i == #options) then
			list = list .. "\n"
		end
	end	
	playerOwnedHouseList[getName(pid)] = options
	return tes3mp.ListBox(pid, config.PlayerOwnedHouseSelect, message, list)
end

local function showAllHousesList(pid)
	local message = trad.selectHouseList
	local options = {}	
	local list = trad.returnList	
	for houseName, v in pairs(housingData.houses) do
		table.insert(options, houseName)
	end
	table.sort(options, function(a,b) return a<b end)
	for i=1, #options do
		list = list .. options[i]
		if not (i == #options) then
			list = list .. "\n"
		end
	end	
	playerAllHouseList[getName(pid)] = options
	return tes3mp.ListBox(pid, config.PlayerAllHouseSelectGUI, message, list)
end

local function showSellHousesList(pid)
	local message = trad.selectHouseList
	local cellNameCell
	local options = {}	
	local list = trad.returnList
	local listBlackList = {}
	for ownerName, v in pairs(housingData.owners) do
		for cellName, x in pairs(housingData.owners[ownerName].houses) do
			table.insert(listBlackList, cellName)
		end
	end
	if listBlackList ~= nil then
		for houseName, v in pairs(housingData.houses) do
			if not tableHelper.containsValue(listBlackList, houseName, true) then
				table.insert(options, houseName)
			end
		end
	end
	table.sort(options, function(a,b) return a<b end)	
	for i=1, #options do
		list = list .. options[i]
		if not (i == #options) then
			list = list .. "\n"
		end
	end	
	playerAllHouseList[getName(pid)] = options
	return tes3mp.ListBox(pid, config.PlayerAllHouseSelectGUI, message, list)
end

local function showShopHousesList(pid)
	local message = trad.selectHouseList
	local options = {}	
	local list = trad.returnList
	
	for houseName, v in pairs(housingData.houses) do
		if isShop(houseName) then
			table.insert(options, houseName)
		end
	end
	table.sort(options, function(a,b) return a<b end)	
	for i=1, #options do
		list = list .. options[i]
		if not (i == #options) then
			list = list .. "\n"
		end
	end	
	playerAllHouseList[getName(pid)] = options
	return tes3mp.ListBox(pid, config.PlayerAllHouseSelectGUI, message, list)
end

local function onPlayerOwnedHouseSelect(pid, index)
	playerSelectedHouse[getName(pid)] = playerOwnedHouseList[getName(pid)][index]
	return
end

local function onPlayerOwnedHouseSelectCo(pid, index)
	playerSelectedHouse[getName(pid)] = playerOwnedHouseListCo[getName(pid)][index]
	return
end

local function onPlayerSettingsOwned(pid)
	showPlayerSettingsOwnedList(pid)
end

local function onPlayerSettingsOwnedCo(pid)
	showPlayerSettingsOwnedListCo(pid)
end

local function onPlayerSettingsAdd(pid)
	if playerSelectedHouse[getName(pid)] then
		showPlayerSettingsAddPrompt(pid)
	else
		return tes3mp.MessageBox(pid, -1, trad.noSelectHouse)
	end
end

local function onPlayerSelectRemove(pid)
	if playerSelectedHouse[getName(pid)] then
		showPlayerSettingsRemoveList(pid)
	else
		return tes3mp.MessageBox(pid, -1, trad.noSelectHouse)
	end
end

local function onPlayerSelectLock(pid)
	if playerSelectedHouse[getName(pid)] then
		housingData.owners[getName(pid)].houses[playerSelectedHouse[getName(pid)]].isLocked = (not housingData.owners[getName(pid)].houses[playerSelectedHouse[getName(pid)]].isLocked)
		Save()
		onLockStatusChange(playerSelectedHouse[getName(pid)])
	else
		return tes3mp.MessageBox(pid, -1, trad.noSelectHouse)
	end
	return showPlayerSettingsMain(pid)
end

local function onPlayerSelectWarp(pid)
	if not canWarp(pid) then
		local message
		if config.allowWarp == false then
			message = trad.WarpSelect
		else
			message = trad.WarpNo
		end
		return false, tes3mp.MessageBox(pid, -1, message, false)
	end	
	if playerSelectedHouse[getName(pid)] then
		local destinationCell
		local destinationPos
		
		local hdata = housingData.houses[playerSelectedHouse[getName(pid)]]

		if not hdata.inside.cell then
			for cellName, v in pairs(hdata.cells) do
				destinationCell = cellName
				break
			end
			destinationPos = {x = 0, y = 0, z = 0}
		else
			destinationCell = hdata.inside.cell
			destinationPos = hdata.inside.pos
		end
		warpPlayer(pid, destinationCell, destinationPos)
	else
		return tes3mp.MessageBox(pid, -1, trad.noSelectHouse)
	end
end

local function onPlayerSelectWarpCo(pid)
	if not canWarpCo(pid) then
		local message
		if config.allowWarpCo == false then
			message = trad.WarpSelect
		else
			message = trad.WarpNo
		end
		return false, tes3mp.MessageBox(pid, -1, message, false)
	end	
	if playerSelectedHouse[getName(pid)] then
		local destinationCell
		local destinationPos
		
		local hdata = housingData.houses[playerSelectedHouse[getName(pid)]]

		if not hdata.inside.cell then
			for cellName, v in pairs(hdata.cells) do
				destinationCell = cellName
				break
			end
			destinationPos = {x = 0, y = 0, z = 0}
		else
			destinationCell = hdata.inside.cell
			destinationPos = hdata.inside.pos
		end
		warpPlayer(pid, destinationCell, destinationPos)
	else
		return tes3mp.MessageBox(pid, -1, trad.noSelectHouse)
	end
end

local function onPlayerSelectSell(pid)
	if playerSelectedHouse[getName(pid)] then
		showPlayerSellOptions(pid)
	else
		return tes3mp.MessageBox(pid, -1, trad.noSelectHouse)
	end
end

local function onPlayerShopHouse(pid)
	if playerSelectedHouse[getName(pid)] then
		housingData.owners[getName(pid)].houses[playerSelectedHouse[getName(pid)]].isShop = (not housingData.owners[getName(pid)].houses[playerSelectedHouse[getName(pid)]].isShop)
		Save()
		onShopStatusChange(playerSelectedHouse[getName(pid)])
	else
		return tes3mp.MessageBox(pid, -1, trad.noSelectHouse)
	end
	return showPlayerSettingsMain(pid)	
end

local function onPlayerChangeStatut(pid)
	if playerSelectedHouse[getName(pid)] then
		local hdata = housingData.houses[playerSelectedHouse[getName(pid)]].statut
		if hdata == "empty" then
			housingData.houses[playerSelectedHouse[getName(pid)]].statut = "furn"
		else
			housingData.houses[playerSelectedHouse[getName(pid)]].statut = "empty"
		end
		Save()
	else
		return tes3mp.MessageBox(pid, -1, trad.noSelectHouse)
	end
	return showPlayerSettingsMain(pid)	
end

local function onPlayerRenewLocation(pid)
	if playerSelectedHouse[getName(pid)] then
		local hdata = housingData.houses[playerSelectedHouse[getName(pid)]]
		local odata = housingData.owners[getName(pid)].houses[playerSelectedHouse[getName(pid)]]		
		if hdata then
			if getPlayerGold(getName(pid)) < hdata.price then
				return tes3mp.MessageBox(pid, -1, trad.RenewLocNo)
			end	
			removeGold(getName(pid), hdata.price)
			odata.dateLocation = os.time()
			Save()
			return tes3mp.MessageBox(pid, -1, color.Gold..trad.Feli..color.White..trad.RenewLocYe..color.Green..hdata.name..color.White..trad.RenewLocCo)			
		end	
	else
		return tes3mp.MessageBox(pid, -1, trad.noSelectHouse)
	end
end

local function onPlayerAllHouseSelect(pid, index)
	playerSelectedHouse[getName(pid)] = playerAllHouseList[getName(pid)][index]
	return showHouseInfoSelected(pid)
end

local function onPlayerMainList(pid)
	showAllHousesList(pid)
end

local function onPlayerSellList(pid)
	showSellHousesList(pid)
end

local function onPlayerShopList(pid)
	showShopHousesList(pid)
end

local function onPlayerMainEdit(pid)
	showPlayerSettingsMain(pid)
end

local function onPlayerMainEditCo(pid)
	showPlayerSettingsMainCo(pid)
end

local function onHouseInfoBuy(pid)
	local hdata = housingData.houses[playerSelectedHouse[getName(pid)]]
	if hdata then
		if getHouseOwnerName(hdata.name) and getHouseOwnerName(hdata.name) ~= getName(pid) then
			return tes3mp.MessageBox(pid, -1, trad.HouseInfoBuyPo)
		elseif getHouseOwnerName(hdata.name) == getName(pid) then
			return tes3mp.MessageBox(pid, -1, trad.HouseInfoBuyYe)
		else
			if getPlayerGold(getName(pid)) < hdata.price then
				return tes3mp.MessageBox(pid, -1, trad.HouseInfoBuyNo)
			end
			if getCountHouseOwners(getName(pid)) == true then
				removeGold(getName(pid), hdata.price)
				addHouseOwner(getName(pid), hdata.name)
				return tes3mp.MessageBox(pid, -1, color.Gold..trad.Feli..color.White..trad.HouseInfoBuyOwner..color.Green..hdata.name..color.White..trad.RenewLocCo)
			else
				return tes3mp.MessageBox(pid, -1, color.Red..trad.Warning..color.White..trad.HouseInfoBuyDe..config.CountMaxOwners..trad.house..color.White..trad.RenewLocCo)
			end
		end
	else
		return tes3mp.MessageBox(pid, -1, trad.NoFindHouse)
	end
end

local function showHouseEditOwnerPrompt(pid)
	local message = trad.DeleteOwner
	return tes3mp.InputDialog(pid, config.HouseEditOwnerGUI, message, trad.LocAct)
end

local function onHouseEditOwnerPrompt(pid, data)
	if data == nil or data == "" or string.lower(data) == "none" then
		removeHouseOwner(pid, adminSelectedHouse[getName(pid)], true, "return")
	else
		if string.lower(data) == getHouseOwnerName(adminSelectedHouse[getName(pid)]) then
		else
			removeHouseOwner(pid, adminSelectedHouse[getName(pid)], true, "return")
			addHouseOwner(data, adminSelectedHouse[getName(pid)])
		end
	end
	return showHouseEditMain(pid)
end

local function onHouseEditPrice(pid)
	return showHouseEditPricePrompt(pid)
end

local function onHouseEditOwner(pid)
	return showHouseEditOwnerPrompt(pid)
end

local function onHouseEditDeleteHouse(pid)
	deleteHouse(adminSelectedHouse[getName(pid)])
	adminSelectedHouse[getName(pid)] = nil
	return showAdminMain(pid)
end

local function onHouseEditInside(pid)
	return assignHouseInside(adminSelectedHouse[getName(pid)], tes3mp.GetCell(pid), tes3mp.GetPosX(pid), tes3mp.GetPosY(pid), tes3mp.GetPosZ(pid)), showHouseEditMain(pid)
end

local function onHouseEditOutside(pid)
	return assignHouseOutside(adminSelectedHouse[getName(pid)], tes3mp.GetCell(pid), tes3mp.GetPosX(pid), tes3mp.GetPosY(pid), tes3mp.GetPosZ(pid)), showHouseEditMain(pid)
end

local function onCellEditAssign(pid)
	local cell = tes3mp.GetCell(pid)
	local pname = getName(pid)	
	if adminSelectedHouse[pname] and housingData.houses[adminSelectedHouse[pname]] and assignCellToHouse then
		local cellData = jsonInterface.load("custom/CellDataBase/"..cell..".json")	
		if cellData == nil then
			tes3mp.MessageBox(pid, -1, trad.NoDataBaseCell)
			return
		end	
		assignCellToHouse(cell, adminSelectedHouse[pname])
		return true, showCellEditMain(pid, adminSelectedHouse[pname])
	end
end

local function onCellEditRemove(pid)
	local cell = tes3mp.GetCell(pid)
	local pname = getName(pid)	
	if adminSelectedHouse[pname] and housingData.houses[adminSelectedHouse[pname]] then
		removeCellFromHouse(cell, adminSelectedHouse[pname])
		return true, showCellEditMain(pid)
	end
end

local function onCellEditContainers(pid)
	local cell = tes3mp.GetCell(pid)	
	if housingData.cells[cell] then
		housingData.cells[cell].ownedContainers = (not housingData.cells[cell].ownedContainers)
		Save()
		return true, showCellEditMain(pid)
	end
end

local function onCellEditAccess(pid)
	local cell = tes3mp.GetCell(pid)	
	if housingData.cells[cell] then
		housingData.cells[cell].requiredAccess = (not housingData.cells[cell].requiredAccess)
		Save()
		return true, showCellEditMain(pid)
	end
end

local function onCellEditResets(pid)
	local cell = tes3mp.GetCell(pid)	
	if housingData.cells[cell] then
		housingData.cells[cell].requiresResets = (not housingData.cells[cell].requiresResets)
		Save()
		return true, showCellEditMain(pid)
	end
end

local function onAdminHouseSelect(pid, index)
	adminSelectedHouse[getName(pid)] = adminHouseList[getName(pid)][index]
	return
end

local function onHouseCreatePrompt(pid, data)
	createNewHouse(data)
	adminSelectedHouse[getName(pid)] = data
end

local function onAdminMainCreate(pid)
	return showHouseCreate(pid)
end

local function onAdminMainSelect(pid)
	return showAdminHouseSelect(pid)
end

local function onAdminMainCellEdit(pid)
	return showCellEditMain(pid)
end

local function onAdminMainHouseEdit(pid)
	local pname = getName(pid)
	if not adminSelectedHouse[pname] or not housingData.houses[adminSelectedHouse[pname]] then
		return tes3mp.MessageBox(pid,-1, trad.selectValidHouse)
	else
		return showHouseEditMain(pid)
	end
end

TFN_HousingShop.OnGUIAction = function(eventStatus, pid, idGui, data)
	if idGui == config.AdminMainGUI then --Admin Main
		if tonumber(data) == 0 then --Create New House
			onAdminMainCreate(pid)
			return true
		elseif tonumber(data) == 1 then --Select House
			onAdminMainSelect(pid)
			return true
		elseif tonumber(data) == 2 then --Edit Cell Data
			onAdminMainCellEdit(pid)
			return true
		elseif tonumber(data) == 3 then --Edit House Data
			onAdminMainHouseEdit(pid)
			return true
		elseif tonumber(data) == 4 then --Close
			--Do nothing
			return true
		end		
	elseif idGui == config.AdminHouseCreateGUI then --House Naming Prompt
		if data ~= nil and data ~= "" then
			onHouseCreatePrompt(pid, data)
		end
		return true, showAdminMain(pid)
	elseif idGui == config.AdminHouseSelectGUI then --Admin House Selector
		if tonumber(data) == 0 or tonumber(data) == 18446744073709551615 then --Close/Nothing Selected
			--Do nothing
			return true, showAdminMain(pid)
		else
			onAdminHouseSelect(pid, tonumber(data))
			return true, showAdminMain(pid)
		end
	elseif idGui == config.CellEditGUI then --Edit Cells Main
		if tonumber(data) == 0 then -- Assign to Selected House
			onCellEditAssign(pid)
			return true
		elseif tonumber(data) == 1 then -- Remove From Selected House
			onCellEditRemove(pid)
			return true
		elseif tonumber(data) == 2 then --Toggle Owned Containers
			onCellEditContainers(pid)
			return true
		elseif tonumber(data) == 3 then --Toggle Required Access
			onCellEditAccess(pid)
			return true
		elseif tonumber(data) == 4 then --Toggle Requires Resets
			onCellEditResets(pid)
			return true
		else -- Close
			--Do nothing
			return true, showAdminMain(pid)
		end
	elseif idGui == config.HouseEditGUI then --Edit House Main
		if tonumber(data) == 0 then -- Set Price
			onHouseEditPrice(pid)
			return true
		elseif tonumber(data) == 1 then -- Set Owner
			onHouseEditOwner(pid)
			return true
		elseif tonumber(data) == 2 then -- Set Entrance
			onHouseEditInside(pid)
			return true
		elseif tonumber(data) == 3 then -- Set Exit
			onHouseEditOutside(pid)
			return true	
		elseif tonumber(data) == 4 then -- Delete House
			onHouseEditDeleteHouse(pid)
			return true
		else --Close
			--Do nothing
			return true, showAdminMain(pid)
		end
	elseif idGui == config.HouseEditPriceGUI then --Edit House Price Prompt
		onHouseEditPricePrompt(pid, data)
		return true
	elseif idGui == config.HouseEditOwnerGUI then --Edit House Owner Prompt
		onHouseEditOwnerPrompt(pid, data)
		return true
	elseif idGui == config.HouseInfoGUI then -- House Info
		if tonumber(data) == 0 then --Buy
			onHouseInfoBuy(pid)
			return true
		else
			--Do nothing
			return true
		end
	elseif idGui == config.PlayerMainCatalogueGUI then -- Player Main
		if tonumber(data) == 0 then --List all Houses
			onPlayerMainList(pid)
			return true
		elseif tonumber(data) == 1 then --List sell Houses
			onPlayerSellList(pid)
			return true
		elseif tonumber(data) == 2 then --List shop Houses
			onPlayerShopList(pid)
			return true		
		elseif tonumber(data) == 3 then --Return Menu
			Players[pid].currentCustomMenu = "menu housing"--main menu
			return true, menuHelper.DisplayMenu(pid, Players[pid].currentCustomMenu)				
		else --Close
			--Do nothing
			return true
		end	
	elseif idGui == config.PlayerAllHouseSelectGUI then --Player All House List Select
		if tonumber(data) == 0 or tonumber(data) == 18446744073709551615 then --Close/Nothing Selected
			--Do nothing
			return true, showUserMain(pid)
		else
			onPlayerAllHouseSelect(pid, tonumber(data))
			return true
		end	
	elseif idGui == config.PlayerSettingGUI then --Player Setting Main
		if tonumber(data) == 0 then --Select Owned House
			onPlayerSettingsOwned(pid)
			return true
		elseif tonumber(data) == 1 then --Add Co-owner
			onPlayerSettingsAdd(pid)
			return true
		elseif tonumber(data) == 2 then --Remove Co-owner
			onPlayerSelectRemove(pid)
			return true
		elseif tonumber(data) == 3 then --Lock House
			onPlayerSelectLock(pid)
			return true
		elseif tonumber(data) == 4 then --Warp to House
			onPlayerSelectWarp(pid)
			return true
		elseif tonumber(data) == 5 then --Sell House
			onPlayerSelectSell(pid)
			return true
		elseif tonumber(data) == 6 then --Shop House
			onPlayerShopHouse(pid)
			return true
		elseif tonumber(data) == 7 then --Statut empty furniture
			onPlayerChangeStatut(pid)
			return true					
		elseif tonumber(data) == 8 then --Return
			Players[pid].currentCustomMenu = "menu housing"--main menu
			return true, menuHelper.DisplayMenu(pid, Players[pid].currentCustomMenu)		
		else --Close
			--Do nothing
			return true
		end	
	elseif idGui == config.PlayerSettingGUICo then --Player Setting Main Copro
		if tonumber(data) == 0 then --Select Owned House
			onPlayerSettingsOwnedCo(pid)
			return true
		elseif tonumber(data) == 1 then --Warp to House
			onPlayerSelectWarpCo(pid)
			return true
		elseif tonumber(data) == 2 then --Return
			Players[pid].currentCustomMenu = "menu housing"--main menu
			return true, menuHelper.DisplayMenu(pid, Players[pid].currentCustomMenu)		
		else --Close
			--Do nothing
			return true
		end			
	elseif idGui == config.PlayerOwnedHouseSelect then --Player Owned House Select
		if tonumber(data) == 0 or tonumber(data) == 18446744073709551615 then --Close/Nothing Selected
			--Do nothing
			return true, showPlayerSettingsMain(pid)
		else
			onPlayerOwnedHouseSelect(pid, tonumber(data))
			return true, showPlayerSettingsMain(pid)
		end
	elseif idGui == config.PlayerOwnedHouseSelectCo then --Player CO-Owned House Select
		if tonumber(data) == 0 or tonumber(data) == 18446744073709551615 then --Close/Nothing Selected
			--Do nothing
			return true, showPlayerSettingsMainCo(pid)
		else
			onPlayerOwnedHouseSelectCo(pid, tonumber(data))
			return true, showPlayerSettingsMainCo(pid)
		end		
	elseif idGui == config.PlayerAddCoOwnerGUI then --Player CoOwner Add Prompt
		onPlayerSettingsAddPrompt(pid, data)
		return true	
	elseif idGui == config.PlayerRemoveCoOwnerGUI then --Player CoOwner Remove Select
		if tonumber(data) == 0 or tonumber(data) == 18446744073709551615 then --Close/Nothing Selected
			--Do nothing
			return true, showPlayerSettingsMain(pid)
		else
			onCoOwnerRemoveSelect(pid, tonumber(data))
			return true, showPlayerSettingsMain(pid)
		end
	elseif idGui == config.PlayerSellConfirmGUI then
		if tonumber(data) == 0 then --Sell House/Sell House + Furniture
			if TFN_Furniture ~= nil then
				onPlayerSellHouseAndFurniture(pid)
				return true
			else
				onPlayerSellHouse(pid)
				return true
			end
		elseif tonumber(data) == 1 then --Cancel/Sell House + Collect furniture
			if TFN_Furniture ~= nil then
				onPlayerSellHouseAndCollect(pid)
				return true
			else
				--Do nothing, because cancel
				return true, showPlayerSettingsMain(pid)
			end
		elseif tonumber(data) == 2 then -- [Impossible]/Cancel
			--Can only get this far if in TFN_Furniture mode, so no need to check
			--Do nothing
			return true, showPlayerSettingsMain(pid)
		end
	elseif idGui == config.ViewOptionsGUI then --Edite Price Item
		if tonumber(data) == 0 then --Change price item activated
			TFN_HousingShop.onViewOptionSelect(pid)
			return true
		else
			return true
		end
	elseif idGui == config.ViewShopOptionsGUI then --Shop Price Item
		if tonumber(data) == 0 then --Change price item activated
			TFN_HousingShop.onShopOptionSelect(pid)
			return true
		else
			return true
		end		
    elseif idGui == config.ItemEditPriceGUI then
        if tonumber(data) == 0 or tonumber(data) == 18446744073709551615 then --Close/Nothing Selected
            --Do nothing
            return true
        else
            TFN_HousingShop.addPriceItem(pid, tonumber(data))
            return true
        end  		
	end
end

TFN_HousingShop.MainMenuHouse = function(pid)
    if Players[pid]~= nil and Players[pid]:IsLoggedIn() then
		Players[pid].currentCustomMenu = "menu housing"
		menuHelper.DisplayMenu(pid, Players[pid].currentCustomMenu)	
	end
end
	
TFN_HousingShop.OnUserMyHouse = function(pid)
	return onPlayerMainEdit(pid)
end

TFN_HousingShop.OnUserCopro = function(pid)
	return onPlayerMainEditCo(pid)
end

TFN_HousingShop.OnUserCommand = function(pid)
	return showUserMain(pid)
end

TFN_HousingShop.OnInfoCommand = function(pid)
	return showHouseInfo(pid)
end

TFN_HousingShop.OnAdminCommand = function(pid)
	local rank = Players[pid].data.settings.staffRank
	if rank < config.requiredAdminRank then
		return false
	end
	return showAdminMain(pid)	
end

TFN_HousingShop.OnPlayerCellChange = function(eventStatus, pid)
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		local currentCell = tes3mp.GetCell(pid)	
		if housingData.cells[currentCell] and housingData.cells[currentCell].house ~= nil then
			local hdata = housingData.houses[housingData.cells[currentCell].house]
			unlockChecks(currentCell)			
			local canEnter, enterReason = isAllowedEnter(pid, currentCell)
			if enterReason == "unowned" then
				if lastEnteredHouse[getName(pid)] ~= hdata.name then
					msg(pid, trad.coma..hdata.name..trad.count..hdata.price..trad.commandInfo)
				end
			elseif enterReason == "unlocked" then				
				if lastEnteredHouse[getName(pid)] ~= hdata.name then
					if isOwner(getName(pid), hdata.name) or isCoOwner(getName(pid), hdata.name) then
						msg(pid, trad.welcomeHouse.. Players[pid].accountName..".")
					else
						if isShop(hdata.name) then					
							Players[pid].data["itemPickUpBlocked"] = 1				
							msg(pid, trad.welcome..getHouseOwnerName(hdata.name)..trad.shop)	
						else
							Players[pid].data["itemPickUpBlocked"] = 1					
							msg(pid, trad.welcome..getHouseOwnerName(hdata.name)..trad.house)	
						end
					end
				end			
			elseif enterReason == "owner" or enterReason == "coowner" then
				if lastEnteredHouse[getName(pid)] ~= hdata.name then 
					local message = trad.welcomeHouse.. Players[pid].accountName.."."
					if isLocked(hdata.name) then
						message = message..trad.closeHouse			
					end
					if isShop(hdata.name) then
						message = message..trad.openHouse			
					end					
					msg(pid, message)
				end				
			elseif enterReason == "Admin" then 
				msg(pid, trad.welcome..getHouseOwnerName(hdata.name)..trad.closeHouse)
			elseif enterReason == "access" then
				local message = trad.access..getHouseOwnerName(hdata.name)..trad.questCell..getHouseOwnerName(hdata.name)..trad.questPass
				msg(pid, message)
				tes3mp.MessageBox(pid, -1, message)
			elseif canEnter == false then
				msg(pid, trad.Close)
				local destinationCell, destinationPos
				if hdata.outside.cell then 
					destinationCell = hdata.outside.cell
					destinationPos = hdata.outside.pos
				else
					destinationCell = serverConfig.defaultSpawnCell
					destinationPos = {x = serverConfig.defaultSpawnPos[1], y = serverConfig.defaultSpawnPos[2], z = serverConfig.defaultSpawnPos[3]}
				end
				warpPlayer(pid, destinationCell, destinationPos)
			end		
			lastEnteredHouse[getName(pid)] = hdata.name
		else
			if Players[pid].data["itemPickUpBlocked"] == 1 then
				Players[pid].data["itemPickUpBlocked"] = 0
			end
			lastEnteredHouse[getName(pid)] = nil
		end
	end	
end

TFN_HousingShop.OnObjectLock = function(eventStatus, pid, cellDescription)
	unlockChecks(cellDescription)
end

TFN_HousingShop.OnContainer = function(eventStatus, pid, cellDescription, objects)
	local ObjectIndex
	for _, object in pairs(objects) do
		ObjectIndex = object.uniqueIndex
		ObjectRefid = object.refId
	end	
	if ObjectIndex ~= nil and ObjectRefid ~= nil then
		tes3mp.ReadLastEvent()
		local action = tes3mp.GetEventAction()
		if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then	
			local houseName, cdata = getIsInHouse(pid)			
			if houseName then		
				if getHouseOwnerName(houseName) then
					if string.sub(ObjectIndex, 1, 1) == "0" then				
						if action == enumerations.container.REMOVE then
							if not isOwner(getName(pid), houseName) and not isCoOwner(getName(pid), houseName) then
								local dirtyThief = true
								for index, resetData in pairs(cdata.resetInfo) do
									if resetData.refIndex == ObjectIndex then
										dirtyThief = false
										break
									end
								end
								
								if dirtyThief then
									onDirtyThief(pid, houseName)
									return customEventHooks.makeEventStatus(false,false)
								end
							end
						elseif action == enumerations.container.SET then
							if not isOwner(getName(pid), houseName) and not isCoOwner(getName(pid), houseName) then
								local dirtyThief = true
								for index, resetData in pairs(cdata.resetInfo) do
									if resetData.refIndex == ObjectIndex then
										dirtyThief = false
										break
									end
								end
								if dirtyThief then
									onDirtyThief(pid, houseName)
									return customEventHooks.makeEventStatus(false,false)
								end							
							end
						end
					end
				end
			end
		end
	end
end

TFN_HousingShop.OnActivatedObject = function(eventStatus, pid, cellDescription, objects)
	local ObjectIndex
	local ObjectRefid
	for _, object in pairs(objects) do
		ObjectIndex = object.uniqueIndex
		ObjectRefid = object.refId
	end	
	if ObjectIndex ~= nil and ObjectRefid ~= nil then
		if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
			local houseName, cdata = getIsInHouse(pid)
			local hdata = housingData.houses[houseName]		
			if houseName then
				if getHouseOwnerName(houseName) then
					if not DoorData[string.lower(ObjectRefid)]then
						if not isShop(hdata.name) then	
							if not isOwner(getName(pid), houseName) and not isCoOwner(getName(pid), houseName) then
								local dirtyThief = true
								for index, resetData in pairs(cdata.resetInfo) do
									if resetData.refIndex == ObjectIndex then
										dirtyThief = false
									end
								end
									
								if dirtyThief then
									return customEventHooks.makeEventStatus(false,false)
								end
							end
						else
							if not isOwner(getName(pid), houseName) and not isCoOwner(getName(pid), houseName) then
								TFN_HousingShop.showShopOptionGUI(pid, ObjectRefid)
								return customEventHooks.makeEventStatus(false,false)
							else
								TFN_HousingShop.showViewOptionsGUI(pid, ObjectRefid)
								return customEventHooks.makeEventStatus(false,false) 
							end
						end
					end
				end
			end
		end
	end
end

TFN_HousingShop.OnObjectDelete = function(eventStatus, pid, cellDescription, objects)
	local ObjectIndex
	local ObjectRefid
	for _, object in pairs(objects) do
		ObjectIndex = object.uniqueIndex
		ObjectRefid = object.refId
	end	
	if ObjectIndex ~= nil and ObjectRefid ~= nil then
		if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
			local houseName, cdata = getIsInHouse(pid)
			local hdata = housingData.houses[houseName]		
			if houseName then
				if getHouseOwnerName(houseName) then			
					if string.sub(ObjectIndex, 1, 1) == "0" then	
						if not isShop(hdata.name) then	
							if not isOwner(getName(pid), houseName) and not isCoOwner(getName(pid), houseName) then
								local dirtyThief = true
								for index, resetData in pairs(cdata.resetInfo) do
									if resetData.refIndex == ObjectIndex then
										dirtyThief = false
									end
								end
									
								if dirtyThief then
									onDirtyThief(pid, houseName)
									return customEventHooks.makeEventStatus(false,false)
								end
							end
						else
							if not isOwner(getName(pid), houseName) and not isCoOwner(getName(pid), houseName) then
								local dirtyThief = true
								for index, resetData in pairs(cdata.resetInfo) do
									if resetData.refIndex == ObjectIndex then
										dirtyThief = false
									end
								end					
								if dirtyThief then			
									local removedCount = 1
									local existingIndex = nil				
									for slot, item in pairs(Players[pid].data.inventory) do
										if Players[pid].data.inventory[slot].refId == ObjectRefid then
											existingIndex = slot
										end
									end			 
									if existingIndex ~= nil then
										local inventoryItem = Players[pid].data.inventory[existingIndex]			
										local itemid = inventoryItem.refId				
										for slot, inv in pairs(Players[pid].data.equipment) do
											if inv.refId == itemid then
												Players[pid].data.equipment[slot] = nil
											end    
										end							
										inventoryItem.count = inventoryItem.count - removedCount					
										if inventoryItem.count < 1 then
											inventoryItem = nil
										end			 
										Players[pid].data.inventory[existingIndex] = inventoryItem
										local itemref = {refId = ObjectRefid, count = 1, charge = -1}
										Players[pid]:QuicksaveToDrive()
										Players[pid]:LoadItemChanges({itemref}, enumerations.inventory.REMOVE)		
										onDirtyThief(pid, houseName)
										return customEventHooks.makeEventStatus(false,false)
									end
								end
							end
						end
					end
				end
			end
		end
	end
end

TFN_HousingShop.ReloadData = function()
	housingData = jsonInterface.load("custom/TFN_HousingShop.json")
end

TFN_HousingShop.OnServerPostInit = function(eventStatus)
	ListCheck()
	local file = io.open(tes3mp.GetDataPath().. "/custom/TFN_HousingShop.json", "r")
	if file ~= nil then
		io.close()
		Load()
	else
		Save()
	end
end

TFN_HousingShop.showShopOptionGUI = function(pid, refId)
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then	
		local choice = refId
		local message = choice
		local cellId = tes3mp.GetCell(pid)
		local cell = LoadedCells[cellId]
		local price 
		for index, uniqueIndex in pairs(cell.data.objectData) do
			if cell.data.objectData[index].refId == choice then
				price = cell.data.objectData[index].price
				if price == nil then
					cell.data.objectData[index].price = 0
					price = cell.data.objectData[index].price
				end
				message = color.Red..message.." "..color.Yellow..trad.costPrice..color.White..price
			end
		end 
		if price ~= nil and price > 0 then
			playerViewChoice[getName(pid)] = choice
			tes3mp.CustomMessageBox(pid, config.ViewShopOptionsGUI, message, trad.optBuy)
		else
			tes3mp.MessageBox(pid, -1, trad.notSell)
		end
	end
end

TFN_HousingShop.onShopOptionSelect = function(pid)
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		local choice = playerViewChoice[getName(pid)] 
		local cellId = tes3mp.GetCell(pid)
		local cell = LoadedCells[cellId]
		local price
		local count
		for index, uniqueIndex in pairs(cell.data.objectData) do
			if cell.data.objectData[index].refId == choice then
				price = cell.data.objectData[index].price
				break
			end
		end	
		if price ~= nil then
			local goldLoc = inventoryHelper.getItemIndex(Players[pid].data.inventory, "gold_001", -1)
			if goldLoc == nil then
				tes3mp.MessageBox(pid, -1, trad.noGold)
			elseif goldLoc then
				local goldcount = Players[pid].data.inventory[goldLoc].count		
				if goldcount < price then
					tes3mp.MessageBox(pid, -1, trad.noMoney)
				elseif goldcount >= price then
					for _, uniqueIndex in pairs(cell.data.packets.place) do			
						if cell.data.objectData[uniqueIndex].refId == choice then
							tableHelper.removeValue(cell.data.packets.place, uniqueIndex)
							cell.data.objectData[uniqueIndex] = nil
							tableHelper.cleanNils(cell.data.objectData)									
							logicHandler.DeleteObjectForEveryone(cellId, uniqueIndex)	
						end
					end
					cell:QuicksaveToDrive()		
					Players[pid].data.inventory[goldLoc].count = Players[pid].data.inventory[goldLoc].count - price
					tes3mp.MessageBox(pid, -1, trad.buyItem)
					table.insert(Players[pid].data.inventory, {refId = choice, count = 1, charge = -1, soul = ""})	
					local itemref1 = {refId = choice, count = 1 , charge = -1, soul = ""}				
					local itemref = {refId = "gold_001", count = price, charge = -1, soul = ""}			
					Players[pid]:QuicksaveToDrive()
					Players[pid]:LoadItemChanges({itemref}, enumerations.inventory.REMOVE)
					Players[pid]:LoadItemChanges({itemref1}, enumerations.inventory.ADD)
					local hdata = housingData.houses[housingData.cells[cellId].house]
					local existingPlayer = getHouseOwnerName(hdata.name)
					local player = logicHandler.GetPlayerByName(existingPlayer)
					local goldLocSeller = nil					
					for slot, item in pairs(player.data.inventory) do
						if item.refId == "gold_001" then
							goldLocSeller = slot
						end
					end					
					if goldLocSeller ~= nil then
						player.data.inventory[goldLocSeller].count = player.data.inventory[goldLocSeller].count + price					
						if player:IsLoggedIn() then
							local itemref = {refId = "gold_001", count = price, charge = -1, soul = ""}	
							player:QuicksaveToDrive()
							player:LoadItemChanges({itemref}, enumerations.inventory.ADD)						
						else
							player.loggedIn = true
							player:QuicksaveToDrive()
							player.loggedIn = false
						end
					else
						table.insert(player.data.inventory, {refId = "gold_001", count = price, charge = -1, soul = ""})	
						if player:IsLoggedIn() then
							local itemref = {refId = "gold_001", count = price, charge = -1, soul = ""}	
							player:QuicksaveToDrive()
							player:LoadItemChanges({itemref}, enumerations.inventory.ADD)
						else
							player.loggedIn = true
							player:QuicksaveToDrive()
							player.loggedIn = false
						end
					end				
				end
			end
		end
	end
end

TFN_HousingShop.showViewOptionsGUI = function(pid, refId)
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		local choice = refId
		local message = choice
		local cellId = tes3mp.GetCell(pid)
		local cell = LoadedCells[cellId]
		local price 
		for index, uniqueIndex in pairs(cell.data.objectData) do
			if cell.data.objectData[index].refId == choice then
				price = cell.data.objectData[index].price
				if price == nil then
					cell.data.objectData[index].price = 0
					price = cell.data.objectData[index].price
				end
				message = color.Red..message.." "..color.Yellow..trad.costPrice..color.White..price
			end
		end  
		playerViewChoice[getName(pid)] = choice
		tes3mp.CustomMessageBox(pid, config.ViewOptionsGUI, message, trad.optPrice)
	end
end
 
TFN_HousingShop.onViewOptionSelect = function(pid)
    TFN_HousingShop.showEditPricePrompt(pid)
end

TFN_HousingShop.showEditPricePrompt = function(pid)
    local itemchoice = playerViewChoice[getName(pid)]
    local message = trad.newPrice
    return tes3mp.InputDialog(pid, config.ItemEditPriceGUI, message, "")
end
 
TFN_HousingShop.addPriceItem = function(pid, price)
    local choice = playerViewChoice[getName(pid)] 
	local cellId = tes3mp.GetCell(pid)
	local cell = LoadedCells[cellId]	
	for index, uniqueIndex in pairs(cell.data.objectData) do
		if cell.data.objectData[index].refId == choice then
			cell.data.objectData[index].price = price
		end
	end
	cell:QuicksaveToDrive()
end

TFN_HousingShop.GetCellData = function(cell)
	return housingData.cells[cell] or false
end

TFN_HousingShop.GetHouseData = function(houseName)
	return housingData.houses[houseName] or false
end

TFN_HousingShop.GetOwnerData = function(ownerName)
	local oname = string.lower(ownerName)
	return housingData.owners[oname] or false
end

TFN_HousingShop.Save = function()
	return Save()
end

TFN_HousingShop.CreateNewHouse = function(houseName)
	return createNewHouse(houseName)
end

TFN_HousingShop.CreateNewCell = function(cellDescription)
	return createNewCell(cellDescription)
end

TFN_HousingShop.CreateNewOwner = function(oname)
	return createNewOwner(oname)
end

TFN_HousingShop.GetHouseOwnerName = function(houseName)
	return getHouseOwnerName(houseName)
end

TFN_HousingShop.GetHouseCoOwnerName = function(houseName)
	return getHouseCoOwnerName(houseName)
end

TFN_HousingShop.GetIsInHouse = function(pid)
	return getIsInHouse(pid)
end

TFN_HousingShop.IsOwner = function(pname, houseName)
	return isOwner(pname, houseName)
end

TFN_HousingShop.IsCoOwner = function(pname, houseName)
	return isCoOwner(pname, houseName)
end

TFN_HousingShop.IsLocked = function(houseName)
	return isLocked(houseName)
end

TFN_HousingShop.IsShop = function(houseName)
	return isShop(houseName)
end

TFN_HousingShop.MainMenu = function(houseName)
    if Players[pid]~= nil and Players[pid]:IsLoggedIn() then
		Players[pid].currentCustomMenu = "menu housing"
		menuHelper.DisplayMenu(pid, Players[pid].currentCustomMenu)	
	end
end

TFN_HousingShop.PunishPrison = function(pid)
    if Players[pid]~= nil and Players[pid]:IsLoggedIn() then
		local targetPlayerName = Players[pid].name
		local msg = color.Orange.."SERVER : "..targetPlayerName..trad.jail
		local cell = "Ebonheart, Hawkmoth Legion Garrison"		
		tes3mp.SetCell(pid, cell)
		tes3mp.SendCell(pid)	
		tes3mp.SetPos(pid, 756, 2560, -383)
		tes3mp.SetRot(pid, 0, 0)
		tes3mp.SendPos(pid)	
		tes3mp.SendMessage(pid, msg, true)
		if Players[pid].data.customVariables.Jailer == nil then
			Players[pid].data.customVariables.Jailer = true
		else	
			Players[pid].data.customVariables.Jailer = true
		end
		local TimerJail = tes3mp.CreateTimer("EventJail", time.seconds(300))
		tes3mp.StartTimer(TimerJail)
		tes3mp.MessageBox(pid, -1, trad.WaitJail)		
		function EventJail()
			for pid, player in pairs(Players) do
				if Players[pid] ~= nil and player:IsLoggedIn() then
					if Players[pid].data.customVariables.Jailer == true then
						Players[pid].data.customVariables.Jailer = false
						tes3mp.MessageBox(pid, -1, trad.StopJail)
						tes3mp.SetCell(pid, "-3, -2")  
						tes3mp.SetPos(pid, -23974, -15787, 505)
						tes3mp.SetRot(pid, 0, 0)
						tes3mp.SendCell(pid)    
						tes3mp.SendPos(pid)
					end
				end
			end
		end
	else
		message = color.Gold..trad.notConnect
		tes3mp.SendMessage(pid, message, false)	
	end	
end

TFN_HousingShop.PunishKick = function(pid) -- Used to send a player into the kick
	Players[pid]:Kick()
end

TFN_HousingShop.OnPlayerAuthentified = function(eventStatus, pid)
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		if not housingData.owners[getName(pid)] then return end
		local odata = housingData.owners[getName(pid)].houses
		if odata then
			for houseName, y in pairs(odata) do
				if os.time() > odata[houseName].dateLocation + config.NextLocation then
					removeHouseOwner(pid, houseName, true, "return")
				else
					odata[houseName].dateLocation = os.time()
					Save()
					local DateNextLocation = os.date("%d", odata[houseName].dateLocation + config.NextLocation).."/"..os.date("%m", odata[houseName].dateLocation + config.NextLocation).."/"..os.date("%Y", odata[houseName].dateLocation + config.NextLocation)..""
					tes3mp.MessageBox(pid, -1, color.Red..trad.info..color.White..trad.loc..color.Green..houseName..color.White..trad.endLoc..color.Red..DateNextLocation..color.White..trad.connectLoc)	 
				end
			end
		end
	end
end

TFN_HousingShop.CleanCell = function(cellDescription, Stat)
	if cellDescription ~= nil then
		local cell = LoadedCells[cellDescription]
		local cellData = jsonInterface.load("custom/CellDataBase/"..cellDescription..".json")	
		if cellData == nil then
			return 
		end
		local useTemporaryLoad = false	
		if cell == nil then
			logicHandler.LoadCell(cellDescription)
			useTemporaryLoad = true
			cell = LoadedCells[cellDescription]	
		end
		for refNum, slot in pairs(cellData.objects) do
			local deleted = false
			local uniqueIndex = refNum.."-0"
			local refId = string.lower(slot.refId)
			if not StaticData[refId] and not DoorData[refId] then
				if config.Actor == true then
					if Stat == "furn" then
						if tableHelper.containsValue(cell.data.packets.delete, uniqueIndex) then
							tableHelper.removeValue(cell.data.packets, uniqueIndex)
							cell.data.objectData[uniqueIndex] = nil		
							tableHelper.cleanNils(cell.data.objectData)	
						end
					end
					if Stat == "empty" then
						deleted = true
					elseif Stat == "nothing" and not FurnData[refId] then
						deleted = true						
					elseif Stat == "furn" and not FurnData[refId] then
						deleted = true
					end
				else
					if not tableHelper.containsValue(cell.data.packets.actorList, uniqueIndex, true) then
						if Stat == "empty" then
							deleted = true
						elseif Stat == "nothing" and not FurnData[refId] then
							deleted = true						
						elseif Stat == "furn" and not FurnData[refId] then
							deleted = true
						end
					end
				end
			end
			if deleted == true then
				if cell.data.objectData[uniqueIndex] then
					tableHelper.removeValue(cell.data.packets, uniqueIndex)
					cell.data.objectData[uniqueIndex] = nil		
					tableHelper.cleanNils(cell.data.objectData)							
				end
				if not tableHelper.containsValue(cell.data.packets.delete, uniqueIndex) then
					table.insert(cell.data.packets.delete, uniqueIndex)
					cell.data.objectData[uniqueIndex] = { refId = refId }					
					if tableHelper.getCount(Players) > 0 then		
						logicHandler.DeleteObjectForEveryone(cellDescription, uniqueIndex)
					end							
				end
			end
		end
		cell:QuicksaveToDrive()
		if useTemporaryLoad == true then
			logicHandler.UnloadCell(cellDescription)
		end
	end
end

TFN_HousingShop.OnCellLoad = function(eventStatus, pid, cellDescription)
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		if housingData.cells[cellDescription] and housingData.cells[cellDescription].house ~= nil then
			if housingData.houses[housingData.cells[cellDescription].house].statut == nil then
				housingData.houses[housingData.cells[cellDescription].house].statut = "nothing"
			end				
			local Stat = housingData.houses[housingData.cells[cellDescription].house].statut 		
			TFN_HousingShop.CleanCell(cellDescription, Stat)
		end
	end
end

customCommandHooks.registerCommand("home", TFN_HousingShop.MainMenuHouse)
customCommandHooks.registerCommand("myhouse", TFN_HousingShop.OnUserMyHouse)
customCommandHooks.registerCommand("roommate", TFN_HousingShop.OnUserCopro)
customCommandHooks.registerCommand("catalog", TFN_HousingShop.OnUserCommand)
customCommandHooks.registerCommand("adminhouse", TFN_HousingShop.OnAdminCommand)
customCommandHooks.registerCommand("houseinfo", TFN_HousingShop.OnInfoCommand)
customEventHooks.registerHandler("OnGUIAction", function(eventStatus, pid, idGui, data)
	TFN_HousingShop.OnGUIAction(eventStatus, pid, idGui, data) 
end)
customEventHooks.registerHandler("OnServerPostInit", TFN_HousingShop.OnServerPostInit)
customEventHooks.registerHandler("OnPlayerCellChange", TFN_HousingShop.OnPlayerCellChange)
customEventHooks.registerHandler("OnObjectLock", TFN_HousingShop.OnObjectLock)
customEventHooks.registerHandler("OnPlayerAuthentified", TFN_HousingShop.OnPlayerAuthentified)
customEventHooks.registerValidator("OnCellLoad", TFN_HousingShop.OnCellLoad)
customEventHooks.registerValidator("OnContainer", TFN_HousingShop.OnContainer)
customEventHooks.registerValidator("OnObjectDelete", TFN_HousingShop.OnObjectDelete)
customEventHooks.registerValidator("OnObjectActivate", TFN_HousingShop.OnActivatedObject)

return TFN_HousingShop
