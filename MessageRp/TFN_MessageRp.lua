--[[
TFN_MessageRp
tes3mp 0.8.1
---------------------------
DESCRIPTION :
Script principal for rp message in chat
---------------------------
INSTALLATION:
Save the file as TFN_MessageRp.lua inside your server/scripts/custom folder.
Edits to customScripts.lua
TFN_MessageRp = require("custom.TFN_MessageRp")
---------------------------
FUNCTION:
/chat for open menu config chat select your channel
/short before message in your chat for whisper "Cyan" 2 meters
/medium before message in your chat for speak "White" 5 meters
/long before message in your chat for cry "Orange" 10 meters
/global before message in your chat for global "Red" all world
Change the value cfg.rad, actualy: 500 ~ 5 meters
---------------------------
]]
------------
-- CONFIG --
------------
local trd = {
	short = "[Channel Whisper]\n",
	medium = "[Channel Talk]\n",
	long = "[Channel Scream]\n",
	global = "[Channel Global]\n",
	title = "CHAT MENU\n",
	selec = "\nSelect the chat channel you want to speak on\n",
	button = "Global;Whisper;Talk;Scream;Exit",
	glob = " : [Global] : ",
	shor = " : [Whisper] : ",
	medi = " : [Talk] : ",
	lon = " : [Scream] : ",
	own = "[Own] ",
	adm = "[Adm] ",
	mod = "[Mod] "
}

local cfg = {
	rad = 500
}

local gui = {
	MainGUI = 19102023
}

--------------
-- FUNCTION --
--------------
local function SendMessageToAllInCell(pid, cellDescription, message, state)
	local mult = 1	
	if state == "short" then	
		mult = 2			
	elseif state == "medium" then	
		mult = 1			
	elseif state == "long" then		
		mult = 0.5		
	end	
	local playerPosX = tes3mp.GetPosX(pid)
	local playerPosY = tes3mp.GetPosY(pid)			
	for index, targetPid in pairs(LoadedCells[cellDescription].visitors) do	
		if targetPid ~= pid and Players[targetPid] and Players[targetPid]:IsLoggedIn() then		
			local pPosX = tes3mp.GetPosX(targetPid)
			local pPosY = tes3mp.GetPosY(targetPid)
			local distance = math.sqrt((playerPosX - pPosX)^2 + (playerPosY - pPosY)^2)		
			if distance < (cfg.rad / mult) then
				tes3mp.SendMessage(targetPid, message, false)
			end
		end
	end
end

local function SendLocalMessage(pid, message, state)	
	local cellDescription = Players[pid].data.location.cell	
	if not cellDescription then return end	
	if tes3mp.IsInExterior(pid) then	
		local cellX = tonumber(string.sub(cellDescription, 1, string.find(cellDescription, ",") - 1))		
		local cellY = tonumber(string.sub(cellDescription, string.find(cellDescription, ",") + 2))		
		for x = -1, 1 do
			for y = -1, 1 do
				local tempCell = (cellX+x)..", "..(cellY+y)
				if LoadedCells[tempCell] then
					SendMessageToAllInCell(pid, tempCell, message, state)
				end
			end
		end		
	else	
		SendMessageToAllInCell(pid, cellDescription, message, state)		
	end
	tes3mp.SendMessage(pid, message, false)
end

local function customVariableShort(pid)
	Players[pid].data.customVariables.TFN_MessageRp.chat = "short"
	local message = color.Cyan..trd.short
	tes3mp.SendMessage(pid, message, false)
end

local function customVariableMedium(pid)
	Players[pid].data.customVariables.TFN_MessageRp.chat = "medium"
	local message = color.Green..trd.medium
	tes3mp.SendMessage(pid, message, false)		
end

local function customVariableLong(pid)
	Players[pid].data.customVariables.TFN_MessageRp.chat = "long"
	local message = color.Orange..trd.long
	tes3mp.SendMessage(pid, message, false)		
end

local function customVariableGlobal(pid)
	Players[pid].data.customVariables.TFN_MessageRp.chat = "global"
	local message = color.Pink..trd.global
	tes3mp.SendMessage(pid, message, false)	
end

-------------
-- METHODS --
-------------
local TFN_MessageRp = {}

TFN_MessageRp.ShowMainGUI = function(pid)	
	local Title = (
		color.Orange..trd.title..
        color.White .. trd.selec
	)
    local Buttons = trd.button
	tes3mp.CustomMessageBox(pid, gui.MainGUI, Title, Buttons)	
end

TFN_MessageRp.OnPlayerSendMessage = function(eventStatus, pid, message)	
	local chat = Players[pid].data.customVariables.TFN_MessageRp.chat
	if message:sub(1, 1) == '/' then	
	else
		local PlayerName = Players[pid].accountName		
		local message1 = color.Grey .. PlayerName .. color.Green .. " : " .. message .. "\n"			
		if chat == "global" then
			message1 = color.Grey .. PlayerName .. color.Pink .. trd.glob .. message .. "\n"	
		elseif chat == "short" then
			message1 = color.Grey .. PlayerName .. color.Cyan .. trd.shor .. message .. "\n"	
		elseif chat == "medium" then
			message1 = color.Grey .. PlayerName .. color.Green .. trd.medi .. message .. "\n"
		elseif chat == "long" then
			message1 = color.Grey .. PlayerName .. color.Orange .. trd.lon .. message .. "\n"
		end
		if Players[pid]:IsServerStaff() then 
			if Players[pid]:IsServerOwner() then
				message1 = config.rankColors.serverOwner .. trd.own .. message1
			elseif Players[pid]:IsAdmin() then
				message1 = config.rankColors.admin .. trd.adm .. message1
			elseif Players[pid]:IsModerator() then
				message1 = config.rankColors.moderator .. trd.mod .. message1
			end
		end		
		if chat == "global" then
			tes3mp.SendMessage(pid, message1, true)
		elseif chat == "short" then
			SendLocalMessage(pid, message1, "short")
		elseif chat == "medium" then
			SendLocalMessage(pid, message1, "medium")
		elseif chat == "long" then
			SendLocalMessage(pid, message1, "long")
		end		
		return customEventHooks.makeEventStatus(false,false)			
	end		
end

TFN_MessageRp.OnGUIAction = function(eventStatus, pid, idGui, data)
	if idGui == gui.MainGUI then 
		if tonumber(data) == 0 then			
			return customVariableGlobal(pid)		
		elseif tonumber(data) == 1 then		
			return customVariableShort(pid)			
		elseif tonumber(data) == 2 then		
			return customVariableMedium(pid)			
		elseif tonumber(data) == 3 then		
			return customVariableLong(pid)		
		end
	end
end

TFN_MessageRp.OnPlayerAuthentified = function(eventStatus, pid)
	if not Players[pid].data.customVariables.TFN_MessageRp then
		Players[pid].data.customVariables.TFN_MessageRp = {chat = "global"}
	else
		Players[pid].data.customVariables.TFN_MessageRp.chat = "global"
	end
end

------------
-- EVENTS --
------------
customEventHooks.registerValidator("OnPlayerSendMessage", TFN_MessageRp.OnPlayerSendMessage)
customEventHooks.registerHandler("OnPlayerAuthentified", TFN_MessageRp.OnPlayerAuthentified)
customEventHooks.registerHandler("OnGUIAction", TFN_MessageRp.OnGUIAction)
customCommandHooks.registerCommand("chat", TFN_MessageRp.ShowMainGUI)
customCommandHooks.registerCommand("short", customVariableShort)
customCommandHooks.registerCommand("medium", customVariableMedium)
customCommandHooks.registerCommand("long", customVariableLong)
customCommandHooks.registerCommand("global", customVariableGlobal)

return TFN_MessageRp
