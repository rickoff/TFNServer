--[[
TFN_LevelingPlayer by Rickoff for Tales from Nirn server 
tes3mp 0.7.0
openmw 0.44
script 0.1
---------------------------
DESCRIPTION :
Leveling sytem
---------------------------
INSTALLATION:
Save the file as TFN_LevelingPlayer.lua inside your server/scripts/custom folder.
Save the file as MenuLeveling.lua inside your scripts/menu folder

Edits to customScripts.lua
TFN_LevelingPlayer = require("custom.TFN_LevelingPlayer")

Edits to config.lua
add in config.menuHelperFiles, "MenuLeveling"
---------------------------
FUNCTION:
/level in your chat for open menu
---------------------------
]]
-- ===========
--MAIN CONFIG
-- ===========
-------------------------
local trad = {}
trad.Feli = "You have gained a level, congratulation : "
trad.Menu = "/level"
trad.Dep = " to spend your points"
trad.Xps = "skill."
trad.NotPts = "You don't have enough skill points to decrease"
trad.NoPt =  "You don't have enough skill points, current : "
trad.Req = " required : "
trad.WereWolf = "Skill menu is forbidden in werewolf form"

local config = {}
config.levelMax = 50
config.PlayerAddPoint = 555555

local PlayerOptionPoint = {}

local TFN_LevelingPlayer = {}

local function getName(pid)
	return string.lower(Players[pid].accountName)
end

TFN_LevelingPlayer.InputDialog = function(pid, comp, state)
	PlayerOptionPoint[getName(pid)] = {comp = comp, state = state}
	local message = "Enter the number of points"
	if state == "Add" then
		return tes3mp.InputDialog(pid, config.PlayerAddPoint, message, "add skill points")
	elseif state == "Remove" then
		return tes3mp.InputDialog(pid, config.PlayerAddPoint, message, "remove skill points")
	end	
end

TFN_LevelingPlayer.OnGUIAction = function(pid, idGui, data)
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then 
		if idGui == config.PlayerAddPoint then
			TFN_LevelingPlayer.OnPlayerCompetence(pid, PlayerOptionPoint[getName(pid)].comp, PlayerOptionPoint[getName(pid)].state, tonumber(data))
			Players[pid].currentCustomMenu = "menu leveling"
			return true, menuHelper.DisplayMenu(pid, Players[pid].currentCustomMenu)			
		end
	end
end	 

TFN_LevelingPlayer.GetlevelSoul = function(pid)
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		if player.data.stats.levelProgress >= 20 then			
			Players[pid].data.customVariables.TfnLeveling.pointSoul = Players[pid].data.customVariables.TfnLeveling.pointSoul + 10
			TFN_LevelingPlayer.NewLevelPlayer(pid)
			TFN_LevelingPlayer.NewLevelPlayerStats(pid)
			tes3mp.MessageBox(pid, -1, color.Default..trad.Feli..color.Green..trad.Menu..color.Default..trad.Dep..color.Yellow..trad.Xps)
		end
	end
end

TFN_LevelingPlayer.OnPlayerCompetence = function(Pid, Comp, State, Count)
	if Players[Pid] ~= nil and Players[Pid]:IsLoggedIn() then
		local levelSoul = Players[Pid].data.customVariables.TfnLeveling.levelSoul	
		local PointCount = Players[Pid].data.customVariables.TfnLeveling.pointSoul
		local HungerCount = Players[Pid].data.customVariables.TfnLeveling.hungerCount
		local ThirstCount = Players[Pid].data.customVariables.TfnLeveling.thirstCount
		local SleepCount = Players[Pid].data.customVariables.TfnLeveling.sleepCount
		local ForceCount = Players[Pid].data.customVariables.TfnLeveling.forceCount
		local EnduranceCount = Players[Pid].data.customVariables.TfnLeveling.enduranceCount
		local AgiliteCount = Players[Pid].data.customVariables.TfnLeveling.agiliteCount
		local RapiditeCount = Players[Pid].data.customVariables.TfnLeveling.rapiditeCount
		local IntelligenceCount = Players[Pid].data.customVariables.TfnLeveling.intelligenceCount
		local VolonteCount = Players[Pid].data.customVariables.TfnLeveling.volonteCount
		local PersonnaliteCount = Players[Pid].data.customVariables.TfnLeveling.personnaliteCount
		local ChanceCount = Players[Pid].data.customVariables.TfnLeveling.chanceCount
		local BlockCount = Players[Pid].data.customVariables.TfnLeveling.blockCount
		local AlchemyCount = Players[Pid].data.customVariables.TfnLeveling.alchemyCount
		local HandtohandCount = Players[Pid].data.customVariables.TfnLeveling.handtohandCount
		local ConjurationCount = Players[Pid].data.customVariables.TfnLeveling.conjurationCount
		local ShortbladeCount = Players[Pid].data.customVariables.TfnLeveling.shortbladeCount
		local AlterationCount = Players[Pid].data.customVariables.TfnLeveling.alterationCount
		local MediumarmorCount = Players[Pid].data.customVariables.TfnLeveling.mediumarmorCount
		local HeavyarmorCount = Players[Pid].data.customVariables.TfnLeveling.heavyarmorCount
		local BluntweaponCount = Players[Pid].data.customVariables.TfnLeveling.bluntweaponCount
		local MarksmanCount = Players[Pid].data.customVariables.TfnLeveling.marksmanCount
		local AcrobaticsCount = Players[Pid].data.customVariables.TfnLeveling.acrobaticsCount
		local SneakCount = Players[Pid].data.customVariables.TfnLeveling.sneakCount
		local LightarmorCount = Players[Pid].data.customVariables.TfnLeveling.lightarmorCount
		local LongbladeCount = Players[Pid].data.customVariables.TfnLeveling.longbladeCount
		local ArmorerCount = Players[Pid].data.customVariables.TfnLeveling.armorerCount
		local SpeechcraftCount = Players[Pid].data.customVariables.TfnLeveling.speechcraftCount
		local AxeCount = Players[Pid].data.customVariables.TfnLeveling.axeCount
		local SecurityCount = Players[Pid].data.customVariables.TfnLeveling.securityCount
		local EnchantCount = Players[Pid].data.customVariables.TfnLeveling.enchantCount
		local DestructionCount = Players[Pid].data.customVariables.TfnLeveling.destructionCount
		local AthleticsCount = Players[Pid].data.customVariables.TfnLeveling.athleticsCount
		local IllusionCount = Players[Pid].data.customVariables.TfnLeveling.illusionCount
		local MysticismCount = Players[Pid].data.customVariables.TfnLeveling.mysticismCount
		local SpearCount = Players[Pid].data.customVariables.TfnLeveling.spearCount
		local MercantileCount = Players[Pid].data.customVariables.TfnLeveling.mercantileCount
		local RestorationCount = Players[Pid].data.customVariables.TfnLeveling.restorationCount
		local UnarmoredCount = Players[Pid].data.customVariables.TfnLeveling.unarmoredCount
		
		local Count = Count
		if Count == nil then Count = 0 end
		
		if PointCount == nil then
			Players[Pid].data.customVariables.TfnLeveling.pointSoul = 0
			PointCount = Players[Pid].data.customVariables.TfnLeveling.pointSoul			
		end	
		
		if levelSoul == nil then
			Players[Pid].data.customVariables.TfnLeveling.levelSoul = 1
			levelSoul = Players[Pid].data.customVariables.TfnLeveling.levelSoul	
		end
		
		if ForceCount == nil then
			Players[Pid].data.customVariables.TfnLeveling.forceCount = 0
			ForceCount = Players[Pid].data.customVariables.TfnLeveling.forceCount			
		end	
		if EnduranceCount == nil then
			Players[Pid].data.customVariables.TfnLeveling.enduranceCount = 0
			EnduranceCount = Players[Pid].data.customVariables.TfnLeveling.enduranceCount			
		end	
		if AgiliteCount == nil then
			Players[Pid].data.customVariables.TfnLeveling.agiliteCount = 0
			AgiliteCount = Players[Pid].data.customVariables.TfnLeveling.agiliteCount			
		end
		if RapiditeCount == nil then
			Players[Pid].data.customVariables.TfnLeveling.rapiditeCount = 0
			RapiditeCount = Players[Pid].data.customVariables.TfnLeveling.rapiditeCount			
		end
		if IntelligenceCount == nil then
			Players[Pid].data.customVariables.TfnLeveling.intelligenceCount = 0
			IntelligenceCount = Players[Pid].data.customVariables.TfnLeveling.intelligenceCount			
		end
		if VolonteCount == nil then
			Players[Pid].data.customVariables.TfnLeveling.volonteCount = 0
			VolonteCount = Players[Pid].data.customVariables.TfnLeveling.volonteCount			
		end
		if PersonnaliteCount == nil then
			Players[Pid].data.customVariables.TfnLeveling.personnaliteCount = 0
			PersonnaliteCount = Players[Pid].data.customVariables.TfnLeveling.personnaliteCount			
		end
		if ChanceCount == nil then
			Players[Pid].data.customVariables.TfnLeveling.chanceCount = 0
			ChanceCount = Players[Pid].data.customVariables.TfnLeveling.chanceCount			
		end
		if HungerCount == nil then
			Players[Pid].data.customVariables.TfnLeveling.hungerCount = 0
			HungerCount = Players[Pid].data.customVariables.TfnLeveling.hungerCount			
		end
		if ThirstCount == nil then
			Players[Pid].data.customVariables.TfnLeveling.thirstCount = 0
			ThirstCount = Players[Pid].data.customVariables.TfnLeveling.thirstCount			
		end	
		if SleepCount == nil then
			Players[Pid].data.customVariables.TfnLeveling.sleepCount = 0
			SleepCount = Players[Pid].data.customVariables.TfnLeveling.sleepCount			
		end
		if BlockCount == nil then
			Players[Pid].data.customVariables.TfnLeveling.blockCount = 0
			BlockCount = Players[Pid].data.customVariables.TfnLeveling.blockCount		
		end		
		if AlchemyCount == nil then
			Players[Pid].data.customVariables.TfnLeveling.alchemyCount = 0
			AlchemyCount = Players[Pid].data.customVariables.TfnLeveling.alchemyCount		
		end	
		if HandtohandCount == nil then
			Players[Pid].data.customVariables.TfnLeveling.handtohandCount = 0
			HandtohandCount = Players[Pid].data.customVariables.TfnLeveling.handtohandCount		
		end	
		if ConjurationCount == nil then
			Players[Pid].data.customVariables.TfnLeveling.conjurationCount = 0
			ConjurationCount = Players[Pid].data.customVariables.TfnLeveling.conjurationCount		
		end	
		if ShortbladeCount == nil then
			Players[Pid].data.customVariables.TfnLeveling.shortbladeCount = 0
			ShortbladeCount = Players[Pid].data.customVariables.TfnLeveling.shortbladeCount		
		end		
		if AlterationCount == nil then
			Players[Pid].data.customVariables.TfnLeveling.alterationCount = 0
			AlterationCount = Players[Pid].data.customVariables.TfnLeveling.alterationCount		
		end	
		if MediumarmorCount == nil then
			Players[Pid].data.customVariables.TfnLeveling.mediumarmorCount = 0
			MediumarmorCount = Players[Pid].data.customVariables.TfnLeveling.mediumarmorCount		
		end	
		if HeavyarmorCount == nil then
			Players[Pid].data.customVariables.TfnLeveling.heavyarmorCount = 0
			HeavyarmorCount = Players[Pid].data.customVariables.TfnLeveling.heavyarmorCount		
		end	
		if BluntweaponCount == nil then
			Players[Pid].data.customVariables.TfnLeveling.bluntweaponCount = 0
			BluntweaponCount = Players[Pid].data.customVariables.TfnLeveling.bluntweaponCount		
		end	
		if MarksmanCount == nil then
			Players[Pid].data.customVariables.TfnLeveling.marksmanCount = 0
			MarksmanCount = Players[Pid].data.customVariables.TfnLeveling.marksmanCount		
		end	
		if AcrobaticsCount == nil then
			Players[Pid].data.customVariables.TfnLeveling.acrobaticsCount = 0
			AcrobaticsCount = Players[Pid].data.customVariables.TfnLeveling.acrobaticsCount		
		end	
		if SneakCount == nil then
			Players[Pid].data.customVariables.TfnLeveling.sneakCount = 0
			SneakCount = Players[Pid].data.customVariables.TfnLeveling.sneakCount		
		end	
		if LightarmorCount == nil then
			Players[Pid].data.customVariables.TfnLeveling.lightarmorCount = 0
			LightarmorCount = Players[Pid].data.customVariables.TfnLeveling.lightarmorCount		
		end	
		if LongbladeCount == nil then
			Players[Pid].data.customVariables.TfnLeveling.longbladeCount = 0
			LongbladeCount = Players[Pid].data.customVariables.TfnLeveling.longbladeCount		
		end		
		if ArmorerCount == nil then
			Players[Pid].data.customVariables.TfnLeveling.armorerCount = 0
			ArmorerCount = Players[Pid].data.customVariables.TfnLeveling.armorerCount		
		end		
		if SpeechcraftCount == nil then
			Players[Pid].data.customVariables.TfnLeveling.speechcraftCount = 0
			SpeechcraftCount = Players[Pid].data.customVariables.TfnLeveling.speechcraftCount		
		end	
		if AxeCount == nil then
			Players[Pid].data.customVariables.TfnLeveling.axeCount = 0
			AxeCount = Players[Pid].data.customVariables.TfnLeveling.axeCount		
		end		
		if SecurityCount == nil then
			Players[Pid].data.customVariables.TfnLeveling.securityCount = 0
			SecurityCount = Players[Pid].data.customVariables.TfnLeveling.securityCount		
		end	
		if EnchantCount == nil then
			Players[Pid].data.customVariables.TfnLeveling.enchantCount = 0
			EnchantCount = Players[Pid].data.customVariables.TfnLeveling.enchantCount		
		end		
		if DestructionCount == nil then
			Players[Pid].data.customVariables.TfnLeveling.destructionCount = 0
			DestructionCount = Players[Pid].data.customVariables.TfnLeveling.destructionCount		
		end	
		if AthleticsCount == nil then
			Players[Pid].data.customVariables.TfnLeveling.athleticsCount = 0
			AthleticsCount = Players[Pid].data.customVariables.TfnLeveling.athleticsCount		
		end	
		if IllusionCount == nil then
			Players[Pid].data.customVariables.TfnLeveling.illusionCount = 0
			IllusionCount = Players[Pid].data.customVariables.TfnLeveling.illusionCount		
		end	
		if MysticismCount == nil then
			Players[Pid].data.customVariables.TfnLeveling.mysticismCount = 0
			MysticismCount = Players[Pid].data.customVariables.TfnLeveling.mysticismCount		
		end	
		if SpearCount == nil then
			Players[Pid].data.customVariables.TfnLeveling.spearCount = 0
			SpearCount = Players[Pid].data.customVariables.TfnLeveling.spearCount		
		end	
		if MercantileCount == nil then
			Players[Pid].data.customVariables.TfnLeveling.mercantileCount = 0
			MercantileCount = Players[Pid].data.customVariables.TfnLeveling.mercantileCount		
		end	
		if RestorationCount == nil then
			Players[Pid].data.customVariables.TfnLeveling.restorationCount = 0
			RestorationCount = Players[Pid].data.customVariables.TfnLeveling.restorationCount		
		end		
		if UnarmoredCount == nil then
			Players[Pid].data.customVariables.TfnLeveling.unarmoredCount = 0
			UnarmoredCount = Players[Pid].data.customVariables.TfnLeveling.unarmoredCount		
		end	
		
		if Comp == "Strength" and PointCount >= Count and State == "Add" then
			local attrId = tes3mp.GetAttributeId("Strength")
			local valueS = Players[Pid].data.attributes.Strength.base + Count	
			tes3mp.SetAttributeBase(Pid, attrId, valueS)
			Players[Pid].data.customVariables.TfnLeveling.pointSoul = Players[Pid].data.customVariables.TfnLeveling.pointSoul - Count
			Players[Pid].data.customVariables.TfnLeveling.forceCount = Players[Pid].data.customVariables.TfnLeveling.forceCount + Count
		elseif Comp == "Strength" and ForceCount >= Count and State == "Remove" then	
			local attrId = tes3mp.GetAttributeId("Strength")
			local valueS = Players[Pid].data.attributes.Strength.base - Count	
			tes3mp.SetAttributeBase(Pid, attrId, valueS)
			Players[Pid].data.customVariables.TfnLeveling.pointSoul = Players[Pid].data.customVariables.TfnLeveling.pointSoul + Count
			Players[Pid].data.customVariables.TfnLeveling.forceCount = Players[Pid].data.customVariables.TfnLeveling.forceCount - Count				
		elseif Comp == "Strength" and PointCount < Count then
			tes3mp.MessageBox(Pid, -1, color.Default..trad.NoPt..color.Green.. PointCount ..color.Default..trad.Req..color.Yellow..Count..".")					
		end

		if Comp == "Endurance" and PointCount >= Count and State == "Add" then
			local attrId2 = tes3mp.GetAttributeId("Endurance")	
			local valueS2 = Players[Pid].data.attributes.Endurance.base + Count	
			tes3mp.SetAttributeBase(Pid, attrId2, valueS2)
			Players[Pid].data.customVariables.TfnLeveling.pointSoul = Players[Pid].data.customVariables.TfnLeveling.pointSoul - Count
			Players[Pid].data.customVariables.TfnLeveling.enduranceCount = Players[Pid].data.customVariables.TfnLeveling.enduranceCount + Count				
		elseif Comp == "Endurance" and EnduranceCount >= Count and State == "Remove" then
			local attrId2 = tes3mp.GetAttributeId("Endurance")	
			local valueS2 = Players[Pid].data.attributes.Endurance.base - Count	
			tes3mp.SetAttributeBase(Pid, attrId2, valueS2)
			Players[Pid].data.customVariables.TfnLeveling.pointSoul = Players[Pid].data.customVariables.TfnLeveling.pointSoul + Count
			Players[Pid].data.customVariables.TfnLeveling.enduranceCount = Players[Pid].data.customVariables.TfnLeveling.enduranceCount - Count				
		elseif Comp == "Endurance" and PointCount < Count then
			tes3mp.MessageBox(Pid, -1, color.Default..trad.NoPt..color.Green.. PointCount ..color.Default..trad.Req..color.Yellow..Count..".")					
		end
	
		if Comp == "Agility" and PointCount >= Count and State == "Add" then
			local attrId = tes3mp.GetAttributeId("Agility")	
			local valueS = Players[Pid].data.attributes.Agility.base + Count	
			tes3mp.SetAttributeBase(Pid, attrId, valueS)
			Players[Pid].data.customVariables.TfnLeveling.pointSoul = Players[Pid].data.customVariables.TfnLeveling.pointSoul - Count
			Players[Pid].data.customVariables.TfnLeveling.agiliteCount = Players[Pid].data.customVariables.TfnLeveling.agiliteCount + Count
		elseif Comp == "Agility" and AgiliteCount >= Count and State == "Remove" then
			local attrId = tes3mp.GetAttributeId("Agility")	
			local valueS = Players[Pid].data.attributes.Agility.base - Count	
			tes3mp.SetAttributeBase(Pid, attrId, valueS)
			Players[Pid].data.customVariables.TfnLeveling.pointSoul = Players[Pid].data.customVariables.TfnLeveling.pointSoul + Count
			Players[Pid].data.customVariables.TfnLeveling.agiliteCount = Players[Pid].data.customVariables.TfnLeveling.agiliteCount - Count				
		elseif Comp == "Agility" and PointCount < Count then
			tes3mp.MessageBox(Pid, -1, color.Default..trad.NoPt..color.Green.. PointCount ..color.Default..trad.Req..color.Yellow..Count..".")								
		end
		
		if Comp == "Speed" and PointCount >= Count and State == "Add" then
			local attrId2 = tes3mp.GetAttributeId("Speed")		
			local valueS2 = Players[Pid].data.attributes.Speed.base + Count
			tes3mp.SetAttributeBase(Pid, attrId2, valueS2)	
			Players[Pid].data.customVariables.TfnLeveling.pointSoul = Players[Pid].data.customVariables.TfnLeveling.pointSoul - Count
			Players[Pid].data.customVariables.TfnLeveling.rapiditeCount	 = Players[Pid].data.customVariables.TfnLeveling.rapiditeCount + Count
		elseif Comp == "Speed" and RapiditeCount >= Count and State == "Remove" then
			local attrId2 = tes3mp.GetAttributeId("Speed")		
			local valueS2 = Players[Pid].data.attributes.Speed.base - Count
			tes3mp.SetAttributeBase(Pid, attrId2, valueS2)	
			Players[Pid].data.customVariables.TfnLeveling.pointSoul = Players[Pid].data.customVariables.TfnLeveling.pointSoul + Count
			Players[Pid].data.customVariables.TfnLeveling.rapiditeCount	 = Players[Pid].data.customVariables.TfnLeveling.rapiditeCount - Count				
		elseif Comp == "Speed" and PointCount < Count then
			tes3mp.MessageBox(Pid, -1, color.Default..trad.NoPt..color.Green.. PointCount ..color.Default..trad.Req..color.Yellow..Count..".")								
		end	
			
		if Comp == "Intelligence" and PointCount >= Count and State == "Add" then
			local attrId = tes3mp.GetAttributeId("Intelligence")	
			local valueS = Players[Pid].data.attributes.Intelligence.base + Count	
			tes3mp.SetAttributeBase(Pid, attrId, valueS)
			Players[Pid].data.customVariables.TfnLeveling.pointSoul = Players[Pid].data.customVariables.TfnLeveling.pointSoul - Count
			Players[Pid].data.customVariables.TfnLeveling.intelligenceCount	 = Players[Pid].data.customVariables.TfnLeveling.intelligenceCount + Count
		elseif Comp == "Intelligence" and IntelligenceCount >= Count and State == "Remove" then
			local attrId = tes3mp.GetAttributeId("Intelligence")	
			local valueS = Players[Pid].data.attributes.Intelligence.base - Count	
			tes3mp.SetAttributeBase(Pid, attrId, valueS)
			Players[Pid].data.customVariables.TfnLeveling.pointSoul = Players[Pid].data.customVariables.TfnLeveling.pointSoul + Count
			Players[Pid].data.customVariables.TfnLeveling.intelligenceCount	 = Players[Pid].data.customVariables.TfnLeveling.intelligenceCount - Count		
		elseif Comp == "Intelligence" and PointCount < Count then
			tes3mp.MessageBox(Pid, -1, color.Default..trad.NoPt..color.Green.. PointCount ..color.Default..trad.Req..color.Yellow..Count..".")								
		end
		
		if Comp == "Willpower" and PointCount >= Count and State == "Add" then
			local attrId2 = tes3mp.GetAttributeId("Willpower")		
			local valueS2 = Players[Pid].data.attributes.Willpower.base + Count
			tes3mp.SetAttributeBase(Pid, attrId2, valueS2)	
			Players[Pid].data.customVariables.TfnLeveling.pointSoul = Players[Pid].data.customVariables.TfnLeveling.pointSoul - Count
			Players[Pid].data.customVariables.TfnLeveling.volonteCount = Players[Pid].data.customVariables.TfnLeveling.volonteCount + Count
		elseif Comp == "Willpower" and VolonteCount >= Count and State == "Remove" then
			local attrId2 = tes3mp.GetAttributeId("Willpower")		
			local valueS2 = Players[Pid].data.attributes.Willpower.base - Count
			tes3mp.SetAttributeBase(Pid, attrId2, valueS2)	
			Players[Pid].data.customVariables.TfnLeveling.pointSoul = Players[Pid].data.customVariables.TfnLeveling.pointSoul + Count
			Players[Pid].data.customVariables.TfnLeveling.volonteCount = Players[Pid].data.customVariables.TfnLeveling.volonteCount - Count				
		elseif Comp == "Willpower" and PointCount < Count then
			tes3mp.MessageBox(Pid, -1, color.Default..trad.NoPt..color.Green.. PointCount ..color.Default..trad.Req..color.Yellow..Count..".")								
		end
		
		if Comp == "Personality" and PointCount >= Count and State == "Add" then
			local attrId = tes3mp.GetAttributeId("Personality")	
			local valueS = Players[Pid].data.attributes.Personality.base + Count	
			tes3mp.SetAttributeBase(Pid, attrId, valueS)
			Players[Pid].data.customVariables.TfnLeveling.pointSoul = Players[Pid].data.customVariables.TfnLeveling.pointSoul - Count
			Players[Pid].data.customVariables.TfnLeveling.personnaliteCount	= Players[Pid].data.customVariables.TfnLeveling.personnaliteCount + Count
		elseif Comp == "Personality" and PersonnaliteCount >= Count and State == "Remove" then
			local attrId = tes3mp.GetAttributeId("Personality")	
			local valueS = Players[Pid].data.attributes.Personality.base - Count	
			tes3mp.SetAttributeBase(Pid, attrId, valueS)
			Players[Pid].data.customVariables.TfnLeveling.pointSoul = Players[Pid].data.customVariables.TfnLeveling.pointSoul + Count
			Players[Pid].data.customVariables.TfnLeveling.personnaliteCount	= Players[Pid].data.customVariables.TfnLeveling.personnaliteCount - Count			
		elseif Comp == "Personality" and PointCount < Count then
			tes3mp.MessageBox(Pid, -1, color.Default..trad.NoPt..color.Green.. PointCount ..color.Default..trad.Req..color.Yellow..Count..".")								
		end
					
		if Comp == "Luck" and PointCount >= Count and State == "Add" then
			local attrId2 = tes3mp.GetAttributeId("Luck")		
			local valueS2 = Players[Pid].data.attributes.Luck.base + Count
			tes3mp.SetAttributeBase(Pid, attrId2, valueS2)	
			Players[Pid].data.customVariables.TfnLeveling.pointSoul = Players[Pid].data.customVariables.TfnLeveling.pointSoul - Count
			Players[Pid].data.customVariables.TfnLeveling.chanceCount = Players[Pid].data.customVariables.TfnLeveling.chanceCount + Count
		elseif Comp == "Luck" and ChanceCount >= Count and State == "Remove" then
			local attrId2 = tes3mp.GetAttributeId("Luck")		
			local valueS2 = Players[Pid].data.attributes.Luck.base - Count
			tes3mp.SetAttributeBase(Pid, attrId2, valueS2)	
			Players[Pid].data.customVariables.TfnLeveling.pointSoul = Players[Pid].data.customVariables.TfnLeveling.pointSoul + Count
			Players[Pid].data.customVariables.TfnLeveling.chanceCount = Players[Pid].data.customVariables.TfnLeveling.chanceCount - Count				
		elseif Comp == "Luck" and PointCount < Count then
			tes3mp.MessageBox(Pid, -1, color.Default..trad.NoPt..color.Green.. PointCount ..color.Default..trad.Req..color.Yellow..Count..".")								
		end	
		
		if Comp == "Block" and PointCount >= Count and State == "Add" then
			local skillId = tes3mp.GetSkillId("Block")
			local valueC = Players[Pid].data.skills.Block.base + Count
			tes3mp.SetSkillBase(Pid, skillId, valueC)			
			Players[Pid].data.customVariables.TfnLeveling.pointSoul = Players[Pid].data.customVariables.TfnLeveling.pointSoul - Count
			Players[Pid].data.customVariables.TfnLeveling.blockCount = Players[Pid].data.customVariables.TfnLeveling.blockCount + Count	
		elseif Comp == "Block" and BlockCount >= Count and State == "Remove" then
			local skillId = tes3mp.GetSkillId("Block")
			local valueC = Players[Pid].data.skills.Block.base - Count
			tes3mp.SetSkillBase(Pid, skillId, valueC)			
			Players[Pid].data.customVariables.TfnLeveling.pointSoul = Players[Pid].data.customVariables.TfnLeveling.pointSoul + Count
			Players[Pid].data.customVariables.TfnLeveling.blockCount = Players[Pid].data.customVariables.TfnLeveling.blockCount - Count	
		elseif Comp == "Block" and BlockCount < Count and State == "Remove" then
			tes3mp.MessageBox(Pid, -1, color.Default..trad.NotPts)					
		elseif Comp == "Block" and PointCount < Count and State == "Add" then
			tes3mp.MessageBox(Pid, -1, color.Default..trad.NoPt..color.Green.. PointCount ..color.Default..trad.Req..color.Yellow..Count..".")								
		end
	
		if Comp == "Alchemy" and PointCount >= Count and State == "Add" then
			local skillId = tes3mp.GetSkillId("Alchemy")
			local valueC = Players[Pid].data.skills.Alchemy.base + Count
			tes3mp.SetSkillBase(Pid, skillId, valueC)			
			Players[Pid].data.customVariables.TfnLeveling.pointSoul = Players[Pid].data.customVariables.TfnLeveling.pointSoul - Count
			Players[Pid].data.customVariables.TfnLeveling.alchemyCount = Players[Pid].data.customVariables.TfnLeveling.alchemyCount + Count					
		elseif Comp == "Alchemy" and AlchemyCount >= Count and State == "Remove" then
			local skillId = tes3mp.GetSkillId("Alchemy")
			local valueC = Players[Pid].data.skills.Alchemy.base - Count
			tes3mp.SetSkillBase(Pid, skillId, valueC)			
			Players[Pid].data.customVariables.TfnLeveling.pointSoul = Players[Pid].data.customVariables.TfnLeveling.pointSoul + Count
			Players[Pid].data.customVariables.TfnLeveling.alchemyCount = Players[Pid].data.customVariables.TfnLeveling.alchemyCount - Count	
		elseif Comp == "Alchemy" and AlchemyCount < Count and State == "Remove" then
			tes3mp.MessageBox(Pid, -1, color.Default..trad.NotPts)						
		elseif Comp == "Alchemy" and PointCount < Count and State == "Add" then
			tes3mp.MessageBox(Pid, -1, color.Default..trad.NoPt..color.Green.. PointCount ..color.Default..trad.Req..color.Yellow..Count..".")								
		end
	
		if Comp == "Handtohand" and PointCount >= Count and State == "Add" then
			local skillId = tes3mp.GetSkillId("Handtohand")
			local valueC = Players[Pid].data.skills.Handtohand.base + Count
			tes3mp.SetSkillBase(Pid, skillId, valueC)			
			Players[Pid].data.customVariables.TfnLeveling.pointSoul = Players[Pid].data.customVariables.TfnLeveling.pointSoul - Count
			Players[Pid].data.customVariables.TfnLeveling.handtohandCount = Players[Pid].data.customVariables.TfnLeveling.handtohandCount + Count					
		elseif Comp == "Handtohand" and HandtohandCount >= Count and State == "Remove" then
			local skillId = tes3mp.GetSkillId("Handtohand")
			local valueC = Players[Pid].data.skills.Handtohand.base - Count
			tes3mp.SetSkillBase(Pid, skillId, valueC)			
			Players[Pid].data.customVariables.TfnLeveling.pointSoul = Players[Pid].data.customVariables.TfnLeveling.pointSoul + Count
			Players[Pid].data.customVariables.TfnLeveling.handtohandCount = Players[Pid].data.customVariables.TfnLeveling.handtohandCount - Count
		elseif Comp == "Handtohand" and HandtohandCount < Count and State == "Remove" then
			tes3mp.MessageBox(Pid, -1, color.Default..trad.NotPts)						
		elseif Comp == "Handtohand" and PointCount < Count and State == "Add" then
			tes3mp.MessageBox(Pid, -1, color.Default..trad.NoPt..color.Green.. PointCount ..color.Default..trad.Req..color.Yellow..Count..".")								
		end
	
		if Comp == "Conjuration" and PointCount >= Count and State == "Add" then
			local skillId = tes3mp.GetSkillId("Conjuration")
			local valueC = Players[Pid].data.skills.Conjuration.base + Count
			tes3mp.SetSkillBase(Pid, skillId, valueC)			
			Players[Pid].data.customVariables.TfnLeveling.pointSoul = Players[Pid].data.customVariables.TfnLeveling.pointSoul - Count
			Players[Pid].data.customVariables.TfnLeveling.conjurationCount = Players[Pid].data.customVariables.TfnLeveling.conjurationCount + Count
		elseif Comp == "Conjuration" and ConjurationCount >= Count and State == "Remove" then
			local skillId = tes3mp.GetSkillId("Conjuration")
			local valueC = Players[Pid].data.skills.Conjuration.base - Count
			tes3mp.SetSkillBase(Pid, skillId, valueC)			
			Players[Pid].data.customVariables.TfnLeveling.pointSoul = Players[Pid].data.customVariables.TfnLeveling.pointSoul + Count
			Players[Pid].data.customVariables.TfnLeveling.conjurationCount = Players[Pid].data.customVariables.TfnLeveling.conjurationCount - Count	
		elseif Comp == "Conjuration" and ConjurationCount < Count and State == "Remove" then
			tes3mp.MessageBox(Pid, -1, color.Default..trad.NotPts)					
		elseif Comp == "Conjuration" and PointCount < Count and State == "Add" then
			tes3mp.MessageBox(Pid, -1, color.Default..trad.NoPt..color.Green.. PointCount ..color.Default..trad.Req..color.Yellow..Count..".")								
		end
		
		if Comp == "Shortblade" and PointCount >= Count and State == "Add" then
			local skillId = tes3mp.GetSkillId("Shortblade")
			local valueC = Players[Pid].data.skills.Shortblade.base + Count
			tes3mp.SetSkillBase(Pid, skillId, valueC)			
			Players[Pid].data.customVariables.TfnLeveling.pointSoul = Players[Pid].data.customVariables.TfnLeveling.pointSoul - Count
			Players[Pid].data.customVariables.TfnLeveling.shortbladeCount = Players[Pid].data.customVariables.TfnLeveling.shortbladeCount + Count
		elseif Comp == "Shortblade" and ShortbladeCount >= Count and State == "Remove" then
			local skillId = tes3mp.GetSkillId("Shortblade")
			local valueC = Players[Pid].data.skills.Shortblade.base - Count
			tes3mp.SetSkillBase(Pid, skillId, valueC)			
			Players[Pid].data.customVariables.TfnLeveling.pointSoul = Players[Pid].data.customVariables.TfnLeveling.pointSoul + Count
			Players[Pid].data.customVariables.TfnLeveling.shortbladeCount = Players[Pid].data.customVariables.TfnLeveling.shortbladeCount - Count	
		elseif Comp == "Shortblade" and ShortbladeCount < Count and State == "Remove" then
			tes3mp.MessageBox(Pid, -1, color.Default..trad.NotPts)						
		elseif Comp == "Shortblade" and PointCount < Count and State == "Add" then
			tes3mp.MessageBox(Pid, -1, color.Default..trad.NoPt..color.Green.. PointCount ..color.Default..trad.Req..color.Yellow..Count..".")								
		end
	
		if Comp == "Alteration" and PointCount >= Count and State == "Add" then
			local skillId = tes3mp.GetSkillId("Alteration")
			local valueC = Players[Pid].data.skills.Alteration.base + Count
			tes3mp.SetSkillBase(Pid, skillId, valueC)			
			Players[Pid].data.customVariables.TfnLeveling.pointSoul = Players[Pid].data.customVariables.TfnLeveling.pointSoul - Count
			Players[Pid].data.customVariables.TfnLeveling.alterationCount = Players[Pid].data.customVariables.TfnLeveling.alterationCount + Count
		elseif Comp == "Alteration" and AlterationCount >= Count and State == "Remove" then
			local skillId = tes3mp.GetSkillId("Alteration")
			local valueC = Players[Pid].data.skills.Alteration.base - Count
			tes3mp.SetSkillBase(Pid, skillId, valueC)			
			Players[Pid].data.customVariables.TfnLeveling.pointSoul = Players[Pid].data.customVariables.TfnLeveling.pointSoul + Count
			Players[Pid].data.customVariables.TfnLeveling.alterationCount = Players[Pid].data.customVariables.TfnLeveling.alterationCount - Count	
		elseif Comp == "Alteration" and AlterationCount < Count and State == "Remove" then
			tes3mp.MessageBox(Pid, -1, color.Default..trad.NotPts)					
		elseif Comp == "Alteration" and PointCount < Count and State == "Add" then
			tes3mp.MessageBox(Pid, -1, color.Default..trad.NoPt..color.Green.. PointCount ..color.Default..trad.Req..color.Yellow..Count..".")								
		end
		
		if Comp == "Mediumarmor" and PointCount >= Count and State == "Add" then
			local skillId = tes3mp.GetSkillId("Mediumarmor")
			local valueC = Players[Pid].data.skills.Mediumarmor.base + Count
			tes3mp.SetSkillBase(Pid, skillId, valueC)			
			Players[Pid].data.customVariables.TfnLeveling.pointSoul = Players[Pid].data.customVariables.TfnLeveling.pointSoul - Count
			Players[Pid].data.customVariables.TfnLeveling.mediumarmorCount = Players[Pid].data.customVariables.TfnLeveling.mediumarmorCount + Count
		elseif Comp == "Mediumarmor" and MediumarmorCount >= Count and State == "Remove" then
			local skillId = tes3mp.GetSkillId("Mediumarmor")
			local valueC = Players[Pid].data.skills.Mediumarmor.base - Count
			tes3mp.SetSkillBase(Pid, skillId, valueC)			
			Players[Pid].data.customVariables.TfnLeveling.pointSoul = Players[Pid].data.customVariables.TfnLeveling.pointSoul + Count
			Players[Pid].data.customVariables.TfnLeveling.mediumarmorCount = Players[Pid].data.customVariables.TfnLeveling.mediumarmorCount - Count	
		elseif Comp == "Mediumarmor" and MediumarmorCount < Count and State == "Remove" then
			tes3mp.MessageBox(Pid, -1, color.Default..trad.NotPts)						
		elseif Comp == "Mediumarmor" and PointCount < Count and State == "Add" then
			tes3mp.MessageBox(Pid, -1, color.Default..trad.NoPt..color.Green.. PointCount ..color.Default..trad.Req..color.Yellow..Count..".")								
		end
		
		if Comp == "Heavyarmor" and PointCount >= Count and State == "Add" then
			local skillId = tes3mp.GetSkillId("Heavyarmor")
			local valueC = Players[Pid].data.skills.Heavyarmor.base + Count
			tes3mp.SetSkillBase(Pid, skillId, valueC)			
			Players[Pid].data.customVariables.TfnLeveling.pointSoul = Players[Pid].data.customVariables.TfnLeveling.pointSoul - Count
			Players[Pid].data.customVariables.TfnLeveling.heavyarmorCount = Players[Pid].data.customVariables.TfnLeveling.heavyarmorCount + Count
		elseif Comp == "Heavyarmor" and HeavyarmorCount >= Count and State == "Remove" then
			local skillId = tes3mp.GetSkillId("Heavyarmor")
			local valueC = Players[Pid].data.skills.Heavyarmor.base - Count
			tes3mp.SetSkillBase(Pid, skillId, valueC)			
			Players[Pid].data.customVariables.TfnLeveling.pointSoul = Players[Pid].data.customVariables.TfnLeveling.pointSoul + Count
			Players[Pid].data.customVariables.TfnLeveling.heavyarmorCount = Players[Pid].data.customVariables.TfnLeveling.heavyarmorCount - Count
		elseif Comp == "Heavyarmor" and HeavyarmorCount < Count and State == "Remove" then
			tes3mp.MessageBox(Pid, -1, color.Default..trad.NotPts)						
		elseif Comp == "Heavyarmor" and PointCount < Count and State == "Add" then
			tes3mp.MessageBox(Pid, -1, color.Default..trad.NoPt..color.Green.. PointCount ..color.Default..trad.Req..color.Yellow..Count..".")								
		end
	
		if Comp == "Bluntweapon" and PointCount >= Count and State == "Add" then
			local skillId = tes3mp.GetSkillId("Bluntweapon")
			local valueC = Players[Pid].data.skills.Bluntweapon.base + Count
			tes3mp.SetSkillBase(Pid, skillId, valueC)			
			Players[Pid].data.customVariables.TfnLeveling.pointSoul = Players[Pid].data.customVariables.TfnLeveling.pointSoul - Count
			Players[Pid].data.customVariables.TfnLeveling.bluntweaponCount = Players[Pid].data.customVariables.TfnLeveling.bluntweaponCount + Count
		elseif Comp == "Bluntweapon" and BluntweaponCount >= Count and State == "Remove" then
			local skillId = tes3mp.GetSkillId("Bluntweapon")
			local valueC = Players[Pid].data.skills.Bluntweapon.base - Count
			tes3mp.SetSkillBase(Pid, skillId, valueC)			
			Players[Pid].data.customVariables.TfnLeveling.pointSoul = Players[Pid].data.customVariables.TfnLeveling.pointSoul + Count
			Players[Pid].data.customVariables.TfnLeveling.bluntweaponCount = Players[Pid].data.customVariables.TfnLeveling.bluntweaponCount - Count	
		elseif Comp == "Bluntweapon" and BluntweaponCount < Count and State == "Remove" then
			tes3mp.MessageBox(Pid, -1, color.Default..trad.NotPts)						
		elseif Comp == "Bluntweapon" and PointCount < Count and State == "Add" then
			tes3mp.MessageBox(Pid, -1, color.Default..trad.NoPt..color.Green.. PointCount ..color.Default..trad.Req..color.Yellow..Count..".")								
		end
		
		if Comp == "Marksman" and PointCount >= Count and State == "Add" then
			local skillId = tes3mp.GetSkillId("Marksman")
			local valueC = Players[Pid].data.skills.Marksman.base + Count
			tes3mp.SetSkillBase(Pid, skillId, valueC)			
			Players[Pid].data.customVariables.TfnLeveling.pointSoul = Players[Pid].data.customVariables.TfnLeveling.pointSoul - Count
			Players[Pid].data.customVariables.TfnLeveling.marksmanCount	= Players[Pid].data.customVariables.TfnLeveling.marksmanCount + Count	
		elseif Comp == "Marksman" and MarksmanCount >= Count and State == "Remove" then
			local skillId = tes3mp.GetSkillId("Marksman")
			local valueC = Players[Pid].data.skills.Marksman.base - Count
			tes3mp.SetSkillBase(Pid, skillId, valueC)			
			Players[Pid].data.customVariables.TfnLeveling.pointSoul = Players[Pid].data.customVariables.TfnLeveling.pointSoul + Count
			Players[Pid].data.customVariables.TfnLeveling.marksmanCount	= Players[Pid].data.customVariables.TfnLeveling.marksmanCount - Count
		elseif Comp == "Marksman" and MarksmanCount < Count and State == "Remove" then
			tes3mp.MessageBox(Pid, -1, color.Default..trad.NotPts)						
		elseif Comp == "Marksman" and PointCount < Count and State == "Add" then
			tes3mp.MessageBox(Pid, -1, color.Default..trad.NoPt..color.Green.. PointCount ..color.Default..trad.Req..color.Yellow..Count..".")								
		end
	
		if Comp == "Acrobatics" and PointCount >= Count and State == "Add" then
			local skillId = tes3mp.GetSkillId("Acrobatics")
			local valueC = Players[Pid].data.skills.Acrobatics.base + Count
			tes3mp.SetSkillBase(Pid, skillId, valueC)			
			Players[Pid].data.customVariables.TfnLeveling.pointSoul = Players[Pid].data.customVariables.TfnLeveling.pointSoul - Count
			Players[Pid].data.customVariables.TfnLeveling.acrobaticsCount = Players[Pid].data.customVariables.TfnLeveling.acrobaticsCount + Count
		elseif Comp == "Acrobatics" and AcrobaticsCount >= Count and State == "Remove" then
			local skillId = tes3mp.GetSkillId("Acrobatics")
			local valueC = Players[Pid].data.skills.Acrobatics.base - Count
			tes3mp.SetSkillBase(Pid, skillId, valueC)			
			Players[Pid].data.customVariables.TfnLeveling.pointSoul = Players[Pid].data.customVariables.TfnLeveling.pointSoul + Count
			Players[Pid].data.customVariables.TfnLeveling.acrobaticsCount = Players[Pid].data.customVariables.TfnLeveling.acrobaticsCount - Count
		elseif Comp == "Acrobatics" and AcrobaticsCount < Count and State == "Remove" then
			tes3mp.MessageBox(Pid, -1, color.Default..trad.NotPts)					
		elseif Comp == "Acrobatics" and PointCount < Count and State == "Add" then
			tes3mp.MessageBox(Pid, -1, color.Default..trad.NoPt..color.Green.. PointCount ..color.Default..trad.Req..color.Yellow..Count..".")								
		end
	
		if Comp == "Sneak" and PointCount >= Count and State == "Add" then
			local skillId = tes3mp.GetSkillId("Sneak")
			local valueC = Players[Pid].data.skills.Sneak.base + Count
			tes3mp.SetSkillBase(Pid, skillId, valueC)			
			Players[Pid].data.customVariables.TfnLeveling.pointSoul = Players[Pid].data.customVariables.TfnLeveling.pointSoul - Count
			Players[Pid].data.customVariables.TfnLeveling.sneakCount = Players[Pid].data.customVariables.TfnLeveling.sneakCount	+ Count	
		elseif Comp == "Sneak" and SneakCount >= Count and State == "Remove" then
			local skillId = tes3mp.GetSkillId("Sneak")
			local valueC = Players[Pid].data.skills.Sneak.base - Count
			tes3mp.SetSkillBase(Pid, skillId, valueC)			
			Players[Pid].data.customVariables.TfnLeveling.pointSoul = Players[Pid].data.customVariables.TfnLeveling.pointSoul + Count
			Players[Pid].data.customVariables.TfnLeveling.sneakCount = Players[Pid].data.customVariables.TfnLeveling.sneakCount	- Count	
		elseif Comp == "Sneak" and SneakCount < Count and State == "Remove" then
			tes3mp.MessageBox(Pid, -1, color.Default..trad.NotPts)				
		elseif Comp == "Sneak" and PointCount < Count and State == "Add" then
			tes3mp.MessageBox(Pid, -1, color.Default..trad.NoPt..color.Green.. PointCount ..color.Default..trad.Req..color.Yellow..Count..".")								
		end
	
		if Comp == "Lightarmor" and PointCount >= Count and State == "Add" then
			local skillId = tes3mp.GetSkillId("Lightarmor")
			local valueC = Players[Pid].data.skills.Lightarmor.base + Count
			tes3mp.SetSkillBase(Pid, skillId, valueC)			
			Players[Pid].data.customVariables.TfnLeveling.pointSoul = Players[Pid].data.customVariables.TfnLeveling.pointSoul - Count
			Players[Pid].data.customVariables.TfnLeveling.lightarmorCount = Players[Pid].data.customVariables.TfnLeveling.lightarmorCount + Count
		elseif Comp == "Lightarmor" and LightarmorCount >= Count and State == "Remove" then
			local skillId = tes3mp.GetSkillId("Lightarmor")
			local valueC = Players[Pid].data.skills.Lightarmor.base - Count
			tes3mp.SetSkillBase(Pid, skillId, valueC)			
			Players[Pid].data.customVariables.TfnLeveling.pointSoul = Players[Pid].data.customVariables.TfnLeveling.pointSoul + Count
			Players[Pid].data.customVariables.TfnLeveling.lightarmorCount = Players[Pid].data.customVariables.TfnLeveling.lightarmorCount - Count
		elseif Comp == "Lightarmor" and LightarmorCount < Count and State == "Remove" then
			tes3mp.MessageBox(Pid, -1, color.Default..trad.NotPts)					
		elseif Comp == "Lightarmor" and PointCount < Count and State == "Add" then
			tes3mp.MessageBox(Pid, -1, color.Default..trad.NoPt..color.Green.. PointCount ..color.Default..trad.Req..color.Yellow..Count..".")								
		end
	
		if Comp == "Longblade" and PointCount >= Count and State == "Add" then
			local skillId = tes3mp.GetSkillId("Longblade")
			local valueC = Players[Pid].data.skills.Longblade.base + Count
			tes3mp.SetSkillBase(Pid, skillId, valueC)			
			Players[Pid].data.customVariables.TfnLeveling.pointSoul = Players[Pid].data.customVariables.TfnLeveling.pointSoul - Count
			Players[Pid].data.customVariables.TfnLeveling.longbladeCount = Players[Pid].data.customVariables.TfnLeveling.longbladeCount + Count
		elseif Comp == "Longblade" and LongbladeCount >= Count and State == "Remove" then
			local skillId = tes3mp.GetSkillId("Longblade")
			local valueC = Players[Pid].data.skills.Longblade.base - Count
			tes3mp.SetSkillBase(Pid, skillId, valueC)			
			Players[Pid].data.customVariables.TfnLeveling.pointSoul = Players[Pid].data.customVariables.TfnLeveling.pointSoul + Count
			Players[Pid].data.customVariables.TfnLeveling.longbladeCount = Players[Pid].data.customVariables.TfnLeveling.longbladeCount - Count
		elseif Comp == "Longblade" and LongbladeCount < Count and State == "Remove" then
			tes3mp.MessageBox(Pid, -1, color.Default..trad.NotPts)					
		elseif Comp == "Longblade" and PointCount < Count and State == "Add" then
			tes3mp.MessageBox(Pid, -1, color.Default..trad.NoPt..color.Green.. PointCount ..color.Default..trad.Req..color.Yellow..Count..".")								
		end
	
		if Comp == "Armorer" and PointCount >= Count and State == "Add" then
			local skillId = tes3mp.GetSkillId("Armorer")
			local valueC = Players[Pid].data.skills.Armorer.base + Count
			tes3mp.SetSkillBase(Pid, skillId, valueC)			
			Players[Pid].data.customVariables.TfnLeveling.pointSoul = Players[Pid].data.customVariables.TfnLeveling.pointSoul - Count
			Players[Pid].data.customVariables.TfnLeveling.armorerCount = Players[Pid].data.customVariables.TfnLeveling.armorerCount + Count
		elseif Comp == "Armorer" and ArmorerCount >= Count and State == "Remove" then
			local skillId = tes3mp.GetSkillId("Armorer")
			local valueC = Players[Pid].data.skills.Armorer.base - Count
			tes3mp.SetSkillBase(Pid, skillId, valueC)			
			Players[Pid].data.customVariables.TfnLeveling.pointSoul = Players[Pid].data.customVariables.TfnLeveling.pointSoul + Count
			Players[Pid].data.customVariables.TfnLeveling.armorerCount = Players[Pid].data.customVariables.TfnLeveling.armorerCount - Count
		elseif Comp == "Armorer" and ArmorerCount < Count and State == "Remove" then
			tes3mp.MessageBox(Pid, -1, color.Default..trad.NotPts)					
		elseif Comp == "Armorer" and PointCount < Count and State == "Add" then
			tes3mp.MessageBox(Pid, -1, color.Default..trad.NoPt..color.Green.. PointCount ..color.Default..trad.Req..color.Yellow..Count..".")								
		end
		
		if Comp == "Speechcraft" and PointCount >= Count and State == "Add" then
			local skillId = tes3mp.GetSkillId("Speechcraft")
			local valueC = Players[Pid].data.skills.Speechcraft.base + Count
			tes3mp.SetSkillBase(Pid, skillId, valueC)			
			Players[Pid].data.customVariables.TfnLeveling.pointSoul = Players[Pid].data.customVariables.TfnLeveling.pointSoul - Count
			Players[Pid].data.customVariables.TfnLeveling.speechcraftCount = Players[Pid].data.customVariables.TfnLeveling.speechcraftCount + Count
		elseif Comp == "Speechcraft" and SpeechcraftCount >= Count and State == "Remove" then
			local skillId = tes3mp.GetSkillId("Speechcraft")
			local valueC = Players[Pid].data.skills.Speechcraft.base - Count
			tes3mp.SetSkillBase(Pid, skillId, valueC)			
			Players[Pid].data.customVariables.TfnLeveling.pointSoul = Players[Pid].data.customVariables.TfnLeveling.pointSoul + Count
			Players[Pid].data.customVariables.TfnLeveling.speechcraftCount = Players[Pid].data.customVariables.TfnLeveling.speechcraftCount - Count	
		elseif Comp == "Speechcraft" and SpeechcraftCount < Count and State == "Remove" then
			tes3mp.MessageBox(Pid, -1, color.Default..trad.NotPts)					
		elseif Comp == "Speechcraft" and PointCount < Count and State == "Add" then
			tes3mp.MessageBox(Pid, -1, color.Default..trad.NoPt..color.Green.. PointCount ..color.Default..trad.Req..color.Yellow..Count..".")								
		end
		
		if Comp == "Axe" and PointCount >= Count and State == "Add" then
			local skillId = tes3mp.GetSkillId("Axe")
			local valueC = Players[Pid].data.skills.Axe.base + Count
			tes3mp.SetSkillBase(Pid, skillId, valueC)			
			Players[Pid].data.customVariables.TfnLeveling.pointSoul = Players[Pid].data.customVariables.TfnLeveling.pointSoul - Count
			Players[Pid].data.customVariables.TfnLeveling.axeCount = Players[Pid].data.customVariables.TfnLeveling.axeCount + Count
		elseif Comp == "Axe" and AxeCount >= Count and State == "Remove" then
			local skillId = tes3mp.GetSkillId("Axe")
			local valueC = Players[Pid].data.skills.Axe.base - Count
			tes3mp.SetSkillBase(Pid, skillId, valueC)			
			Players[Pid].data.customVariables.TfnLeveling.pointSoul = Players[Pid].data.customVariables.TfnLeveling.pointSoul + Count
			Players[Pid].data.customVariables.TfnLeveling.axeCount = Players[Pid].data.customVariables.TfnLeveling.axeCount - Count
		elseif Comp == "Axe" and AxeCount < Count and State == "Remove" then
			tes3mp.MessageBox(Pid, -1, color.Default..trad.NotPts)				
		elseif Comp == "Axe" and PointCount < Count and State == "Add" then
			tes3mp.MessageBox(Pid, -1, color.Default..trad.NoPt..color.Green.. PointCount ..color.Default..trad.Req..color.Yellow..Count..".")								
		end

		if Comp == "Security" and PointCount >= Count and State == "Add" then
			local skillId = tes3mp.GetSkillId("Security")
			local valueC = Players[Pid].data.skills.Security.base + Count
			tes3mp.SetSkillBase(Pid, skillId, valueC)			
			Players[Pid].data.customVariables.TfnLeveling.pointSoul = Players[Pid].data.customVariables.TfnLeveling.pointSoul - Count
			Players[Pid].data.customVariables.TfnLeveling.securityCount = Players[Pid].data.customVariables.TfnLeveling.securityCount + Count
		elseif Comp == "Security" and SecurityCount >= Count and State == "Remove" then
			local skillId = tes3mp.GetSkillId("Security")
			local valueC = Players[Pid].data.skills.Security.base - Count
			tes3mp.SetSkillBase(Pid, skillId, valueC)			
			Players[Pid].data.customVariables.TfnLeveling.pointSoul = Players[Pid].data.customVariables.TfnLeveling.pointSoul + Count
			Players[Pid].data.customVariables.TfnLeveling.securityCount = Players[Pid].data.customVariables.TfnLeveling.securityCount - Count
		elseif Comp == "Security" and SecurityCount < Count and State == "Remove" then
			tes3mp.MessageBox(Pid, -1, color.Default..trad.NotPts)				
		elseif Comp == "Security" and PointCount < Count and State == "Add" then
			tes3mp.MessageBox(Pid, -1, color.Default..trad.NoPt..color.Green.. PointCount ..color.Default..trad.Req..color.Yellow..Count..".")								
		end
	
		if Comp == "Enchant" and PointCount >= Count and State == "Add" then
			local skillId = tes3mp.GetSkillId("Enchant")
			local valueC = Players[Pid].data.skills.Enchant.base + Count
			tes3mp.SetSkillBase(Pid, skillId, valueC)			
			Players[Pid].data.customVariables.TfnLeveling.pointSoul = Players[Pid].data.customVariables.TfnLeveling.pointSoul - Count
			Players[Pid].data.customVariables.TfnLeveling.enchantCount = Players[Pid].data.customVariables.TfnLeveling.enchantCount + Count
		elseif Comp == "Enchant" and EnchantCount >= Count and State == "Remove" then
			local skillId = tes3mp.GetSkillId("Enchant")
			local valueC = Players[Pid].data.skills.Enchant.base - Count
			tes3mp.SetSkillBase(Pid, skillId, valueC)			
			Players[Pid].data.customVariables.TfnLeveling.pointSoul = Players[Pid].data.customVariables.TfnLeveling.pointSoul + Count
			Players[Pid].data.customVariables.TfnLeveling.enchantCount = Players[Pid].data.customVariables.TfnLeveling.enchantCount - Count
		elseif Comp == "Enchant" and EnchantCount < Count and State == "Remove" then
			tes3mp.MessageBox(Pid, -1, color.Default..trad.NotPts)				
		elseif Comp == "Enchant" and PointCount < Count and State == "Add" then
			tes3mp.MessageBox(Pid, -1, color.Default..trad.NoPt..color.Green.. PointCount ..color.Default..trad.Req..color.Yellow..Count..".")								
		end
	
		if Comp == "Destruction" and PointCount >= Count and State == "Add" then
			local skillId = tes3mp.GetSkillId("Destruction")
			local valueC = Players[Pid].data.skills.Destruction.base + Count
			tes3mp.SetSkillBase(Pid, skillId, valueC)			
			Players[Pid].data.customVariables.TfnLeveling.pointSoul = Players[Pid].data.customVariables.TfnLeveling.pointSoul - Count
			Players[Pid].data.customVariables.TfnLeveling.destructionCount = Players[Pid].data.customVariables.TfnLeveling.destructionCount + Count
		elseif Comp == "Destruction" and DestructionCount >= Count and State == "Remove" then
			local skillId = tes3mp.GetSkillId("Destruction")
			local valueC = Players[Pid].data.skills.Destruction.base - Count
			tes3mp.SetSkillBase(Pid, skillId, valueC)			
			Players[Pid].data.customVariables.TfnLeveling.pointSoul = Players[Pid].data.customVariables.TfnLeveling.pointSoul + Count
			Players[Pid].data.customVariables.TfnLeveling.destructionCount = Players[Pid].data.customVariables.TfnLeveling.destructionCount - Count
		elseif Comp == "Destruction" and DestructionCount < Count and State == "Remove" then
			tes3mp.MessageBox(Pid, -1, color.Default..trad.NotPts)				
		elseif Comp == "Destruction" and PointCount < Count and State == "Add" then
			tes3mp.MessageBox(Pid, -1, color.Default..trad.NoPt..color.Green.. PointCount ..color.Default..trad.Req..color.Yellow..Count..".")								
		end
	
		if Comp == "Athletics" and PointCount >= Count and State == "Add" then
			local skillId = tes3mp.GetSkillId("Athletics")
			local valueC = Players[Pid].data.skills.Athletics.base + Count
			tes3mp.SetSkillBase(Pid, skillId, valueC)			
			Players[Pid].data.customVariables.TfnLeveling.pointSoul = Players[Pid].data.customVariables.TfnLeveling.pointSoul - Count
			Players[Pid].data.customVariables.TfnLeveling.athleticsCount = Players[Pid].data.customVariables.TfnLeveling.athleticsCount + Count
		elseif Comp == "Athletics" and AthleticsCount >= Count and State == "Remove" then
			local skillId = tes3mp.GetSkillId("Athletics")
			local valueC = Players[Pid].data.skills.Athletics.base - Count
			tes3mp.SetSkillBase(Pid, skillId, valueC)			
			Players[Pid].data.customVariables.TfnLeveling.pointSoul = Players[Pid].data.customVariables.TfnLeveling.pointSoul + Count
			Players[Pid].data.customVariables.TfnLeveling.athleticsCount = Players[Pid].data.customVariables.TfnLeveling.athleticsCount - Count	
		elseif Comp == "Athletics" and AthleticsCount < Count and State == "Remove" then
			tes3mp.MessageBox(Pid, -1, color.Default..trad.NotPts)				
		elseif Comp == "Athletics" and PointCount < Count and State == "Add" then
			tes3mp.MessageBox(Pid, -1, color.Default..trad.NoPt..color.Green.. PointCount ..color.Default..trad.Req..color.Yellow..Count..".")								
		end
	
		if Comp == "Illusion" and PointCount >= Count and State == "Add" then
			local skillId = tes3mp.GetSkillId("Illusion")
			local valueC = Players[Pid].data.skills.Illusion.base + Count
			tes3mp.SetSkillBase(Pid, skillId, valueC)			
			Players[Pid].data.customVariables.TfnLeveling.pointSoul = Players[Pid].data.customVariables.TfnLeveling.pointSoul - Count
			Players[Pid].data.customVariables.TfnLeveling.illusionCount	= Players[Pid].data.customVariables.TfnLeveling.illusionCount + Count
		elseif Comp == "Illusion" and IllusionCount >= Count and State == "Remove" then
			local skillId = tes3mp.GetSkillId("Illusion")
			local valueC = Players[Pid].data.skills.Illusion.base - Count
			tes3mp.SetSkillBase(Pid, skillId, valueC)			
			Players[Pid].data.customVariables.TfnLeveling.pointSoul = Players[Pid].data.customVariables.TfnLeveling.pointSoul + Count
			Players[Pid].data.customVariables.TfnLeveling.illusionCount	= Players[Pid].data.customVariables.TfnLeveling.illusionCount - Count
		elseif Comp == "Illusion" and IllusionCount < Count and State == "Remove" then
			tes3mp.MessageBox(Pid, -1, color.Default..trad.NotPts)				
		elseif Comp == "Illusion" and PointCount < Count and State == "Add" then
			tes3mp.MessageBox(Pid, -1, color.Default..trad.NoPt..color.Green.. PointCount ..color.Default..trad.Req..color.Yellow..Count..".")								
		end
	
		if Comp == "Mysticism" and PointCount >= Count and State == "Add" then
			local skillId = tes3mp.GetSkillId("Mysticism")
			local valueC = Players[Pid].data.skills.Mysticism.base + Count
			tes3mp.SetSkillBase(Pid, skillId, valueC)			
			Players[Pid].data.customVariables.TfnLeveling.pointSoul = Players[Pid].data.customVariables.TfnLeveling.pointSoul - Count
			Players[Pid].data.customVariables.TfnLeveling.mysticismCount = Players[Pid].data.customVariables.TfnLeveling.mysticismCount + Count
		elseif Comp == "Mysticism" and MysticismCount >= Count and State == "Remove" then
			local skillId = tes3mp.GetSkillId("Mysticism")
			local valueC = Players[Pid].data.skills.Mysticism.base - Count
			tes3mp.SetSkillBase(Pid, skillId, valueC)			
			Players[Pid].data.customVariables.TfnLeveling.pointSoul = Players[Pid].data.customVariables.TfnLeveling.pointSoul + Count
			Players[Pid].data.customVariables.TfnLeveling.mysticismCount = Players[Pid].data.customVariables.TfnLeveling.mysticismCount - Count
		elseif Comp == "Mysticism" and MysticismCount < Count and State == "Remove" then
			tes3mp.MessageBox(Pid, -1, color.Default..trad.NotPts)				
		elseif Comp == "Mysticism" and PointCount < Count and State == "Add" then
			tes3mp.MessageBox(Pid, -1, color.Default..trad.NoPt..color.Green.. PointCount ..color.Default..trad.Req..color.Yellow..Count..".")								
		end
	
		if Comp == "Spear" and PointCount >= Count and State == "Add" then
			local skillId = tes3mp.GetSkillId("Spear")
			local valueC = Players[Pid].data.skills.Spear.base + Count
			tes3mp.SetSkillBase(Pid, skillId, valueC)			
			Players[Pid].data.customVariables.TfnLeveling.pointSoul = Players[Pid].data.customVariables.TfnLeveling.pointSoul - Count
			Players[Pid].data.customVariables.TfnLeveling.spearCount = Players[Pid].data.customVariables.TfnLeveling.spearCount + Count
		elseif Comp == "Spear" and SpearCount >= Count and State == "Remove" then
			local skillId = tes3mp.GetSkillId("Spear")
			local valueC = Players[Pid].data.skills.Spear.base - Count
			tes3mp.SetSkillBase(Pid, skillId, valueC)			
			Players[Pid].data.customVariables.TfnLeveling.pointSoul = Players[Pid].data.customVariables.TfnLeveling.pointSoul + Count
			Players[Pid].data.customVariables.TfnLeveling.spearCount = Players[Pid].data.customVariables.TfnLeveling.spearCount - Count
		elseif Comp == "Spear" and SpearCount < Count and State == "Remove" then
			tes3mp.MessageBox(Pid, -1, color.Default..trad.NotPts)					
		elseif Comp == "Spear" and PointCount < Count and State == "Add" then
			tes3mp.MessageBox(Pid, -1, color.Default..trad.NoPt..color.Green.. PointCount ..color.Default..trad.Req..color.Yellow..Count..".")								
		end
	
		if Comp == "Mercantile" and PointCount >= Count and State == "Add" then
			local skillId = tes3mp.GetSkillId("Mercantile")
			local valueC = Players[Pid].data.skills.Mercantile.base + Count
			tes3mp.SetSkillBase(Pid, skillId, valueC)			
			Players[Pid].data.customVariables.TfnLeveling.pointSoul = Players[Pid].data.customVariables.TfnLeveling.pointSoul - Count
			Players[Pid].data.customVariables.TfnLeveling.mercantileCount = Players[Pid].data.customVariables.TfnLeveling.mercantileCount + Count
		elseif Comp == "Mercantile" and MercantileCount >= Count and State == "Remove" then
			local skillId = tes3mp.GetSkillId("Mercantile")
			local valueC = Players[Pid].data.skills.Mercantile.base - Count
			tes3mp.SetSkillBase(Pid, skillId, valueC)			
			Players[Pid].data.customVariables.TfnLeveling.pointSoul = Players[Pid].data.customVariables.TfnLeveling.pointSoul + Count
			Players[Pid].data.customVariables.TfnLeveling.mercantileCount = Players[Pid].data.customVariables.TfnLeveling.mercantileCount - Count
		elseif Comp == "Mercantile" and MercantileCount < Count and State == "Remove" then
			tes3mp.MessageBox(Pid, -1, color.Default..trad.NotPts)					
		elseif Comp == "Mercantile" and PointCount < Count and State == "Add" then
			tes3mp.MessageBox(Pid, -1, color.Default..trad.NoPt..color.Green.. PointCount ..color.Default..trad.Req..color.Yellow..Count..".")								
		end

		if Comp == "Restoration" and PointCount >= Count and State == "Add" then
			local skillId = tes3mp.GetSkillId("Restoration")
			local valueC = Players[Pid].data.skills.Restoration.base + Count
			tes3mp.SetSkillBase(Pid, skillId, valueC)			
			Players[Pid].data.customVariables.TfnLeveling.pointSoul = Players[Pid].data.customVariables.TfnLeveling.pointSoul - Count
			Players[Pid].data.customVariables.TfnLeveling.restorationCount = Players[Pid].data.customVariables.TfnLeveling.restorationCount + Count
		elseif Comp == "Restoration" and RestorationCount >= Count and State == "Remove" then
			local skillId = tes3mp.GetSkillId("Restoration")
			local valueC = Players[Pid].data.skills.Restoration.base - Count
			tes3mp.SetSkillBase(Pid, skillId, valueC)			
			Players[Pid].data.customVariables.TfnLeveling.pointSoul = Players[Pid].data.customVariables.TfnLeveling.pointSoul + Count
			Players[Pid].data.customVariables.TfnLeveling.restorationCount = Players[Pid].data.customVariables.TfnLeveling.restorationCount - Count
		elseif Comp == "Restoration" and RestorationCount < Count and State == "Remove" then
			tes3mp.MessageBox(Pid, -1, color.Default..trad.NotPts)				
		elseif Comp == "Restoration" and PointCount < Count and State == "Add" then
			tes3mp.MessageBox(Pid, -1, color.Default..trad.NoPt..color.Green.. PointCount ..color.Default..trad.Req..color.Yellow..Count..".")								
		end
	
		if Comp == "Unarmored" and PointCount >= Count and State == "Add" then
			local skillId = tes3mp.GetSkillId("Unarmored")
			local valueC = Players[Pid].data.skills.Unarmored.base + Count
			tes3mp.SetSkillBase(Pid, skillId, valueC)			
			Players[Pid].data.customVariables.TfnLeveling.pointSoul = Players[Pid].data.customVariables.TfnLeveling.pointSoul - Count
			Players[Pid].data.customVariables.TfnLeveling.unarmoredCount = Players[Pid].data.customVariables.TfnLeveling.unarmoredCount + Count
		elseif Comp == "Unarmored" and UnarmoredCount >= Count and State == "Remove" then
			local skillId = tes3mp.GetSkillId("Unarmored")
			local valueC = Players[Pid].data.skills.Unarmored.base - Count
			tes3mp.SetSkillBase(Pid, skillId, valueC)			
			Players[Pid].data.customVariables.TfnLeveling.pointSoul = Players[Pid].data.customVariables.TfnLeveling.pointSoul + Count
			Players[Pid].data.customVariables.TfnLeveling.unarmoredCount = Players[Pid].data.customVariables.TfnLeveling.unarmoredCount - Count
		elseif Comp == "Unarmored" and UnarmoredCount < Count and State == "Remove" then
			tes3mp.MessageBox(Pid, -1, color.Default..trad.NotPts)				
		elseif Comp == "Unarmored" and PointCount < Count and State == "Add" then
			tes3mp.MessageBox(Pid, -1, color.Default..trad.NoPt..color.Green.. PointCount ..color.Default..trad.Req..color.Yellow..Count..".")								
		end

		Players[Pid]:SaveAttributes()	
		Players[Pid]:SaveSkills()			
		tes3mp.SendAttributes(Pid)
		tes3mp.SendSkills(Pid)
	end
end	

TFN_LevelingPlayer.MainMenu = function(Pid)
    if Players[Pid]~= nil and Players[Pid]:IsLoggedIn() then
		if not tes3mp.IsWerewolf(Pid) then
			Players[Pid].currentCustomMenu = "menu leveling"
			menuHelper.DisplayMenu(Pid, Players[Pid].currentCustomMenu)
		else
			tes3mp.MessageBox(Pid, -1, trad.WereWolf)
		end
	end
end

TFN_LevelingPlayer.LevelPlayer = function(eventStatus, pid)	
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then		
		local player = Players[pid]		
		if player.data.stats.level >= config.levelMax then
			player.data.stats.level = config.levelMax
			player.data.stats.levelProgress = 0
			player:LoadLevel()
			return customEventHooks.makeEventStatus(false,false)				
		end	
		TFN_LevelingPlayer.GetlevelSoul(pid)		
		player:QuicksaveToDrive()
	end
end

TFN_LevelingPlayer.NewLevelPlayer = function(pid)	
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then		
		local player = Players[pid]
		if player.data.stats.level < config.levelMax then
			player.data.stats.level = player.data.stats.level + 1
			player.data.stats.levelProgress = 0 
			player:LoadLevel()
		end
		player:QuicksaveToDrive()
	end
end

TFN_LevelingPlayer.OnPlayerAddCustom = function(eventStatus, pid) 
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		local player = Players[pid]	
		if not Players[pid].data.customVariables.TfnLeveling.pointSoul then
			Players[pid].data.customVariables.TfnLeveling.pointSoul = 0	
			player:QuicksaveToDrive()			
		end
	end
end

customCommandHooks.registerCommand("level", TFN_LevelingPlayer.MainMenu)
customEventHooks.registerValidator("OnPlayerLevel", TFN_LevelingPlayer.LevelPlayer)
customEventHooks.registerHandler("OnPlayerAuthentified", TFN_LevelingPlayer.OnPlayerAddCustom)
customEventHooks.registerHandler("OnGUIAction", function(eventStatus, pid, idGui, data)
	if TFN_LevelingPlayer.OnGUIAction(pid, idGui, data) then return end
end)

return TFN_LevelingPlayer
