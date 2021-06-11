--[[
TFN_Mannequin by Rickoff
tes3mp 0.7.0
---------------------------
DESCRIPTION :
class system limiting the use of weapons, armor, various items and sort according to the corresponding talent.
---------------------------
INSTALLATION:
Save the file as TFN_Mannequin.lua inside your server/scripts/custom folder.

Edits to customScripts.lua :
TFN_Mannequin = require("custom.TFN_Mannequin")
---------------------------
]]
local TFN_Mannequin = {}

local trad = {
	ManNotOwner = "Mannequins cannot be placed outside your homes.",
	ManNotExterior = "Mannequins cannot be placed outside.",
	ManCapCount = "You can only place one at a time.",
	ManOpenOwner = "This dummy can now only be activated by you.",
	ManOpenAll = "This dummy can now be activated by anyone.",
	ManBuyOwner = "You have purchased ",
	ManBuyFor = " for ",
	ManBuyGolds = " gold coins.",
	ManDontBuy = "You can't pay",
	ManShopExit = "* Quit *\n",
	ManMainMenu = "Shop Mannequin:\n",
	ManYouHave = "You have ",
	ManMainGold = " gold coins",
	ManGuiMenu = (color.Orange.. "Mannequin Menu:\n\n"
		..color.Yellow.."Display my equipment\n"
		..color.White.."Give this dummy all the items you have equipped.\n\n"
		..color.Yellow.."Delete the equipment\n"
		..color.White.."Will return all equipment to your inventory.\n\n"
		..color.Yellow.."Equip this outfit.\n"
		..color.White.."will retrieve and equip this mannequin display equipment.\n\n"
		..color.Yellow.. "Pick up\n"
		..color.White.."Will return any equipment as well as this mannequin itself to your inventory.\n\n"
	),
	ManLocked = color.Red.."[Closed]\n"..color.White.. "This mannequin is currently only accessible by you",
	ManLockChoice = color.Red.."[Closed]",
	ManUnlocked = color.Green.."[Open]\n"..color.White.. "This mannequin is currently accessible to everyone.\n",
	ManUnlockChoice = color.Green.."[Open]",
	ManLockAccess = color.Red.."[Locked]\n"..color.White.. "This dummy is currently only accessible by ",
	ManOptAccess = "Show my equipment;Delete the equipment;Equip this outfit;Pick up;",
	ManExit = ";Quit",
	ManLockedBy = "This mannequin has been locked by ",
	ManViewNow = " now displayed on this mannequin.",
	ManSingle = " item are",
	ManPlural = " item is",
	ManTheyMan = " these dummies ",
	ManView = " display ",
	ManAddInv = " been added to your inventory.",
	ManEquip = "You have equipped ",
	ManSend = "You have received "	
}
local config = {
	MenuTextColor = "#AB8C53",
	LockByDefault = true,
	StaffRankToBypassLock = 2 ,
	DefaultMannequinPrice = 2500,
	mannequinDisplayEquipmentOptions = 03302030,
	menuMannequinShop = 03302031,
	mannequinRefIDs = {
		"mannequin_script_dunmer_male",
		"mannequin_script_dunmer_female",
		"mannequin_script_breton_male",
		"mannequin_script_breton_female",
		"mannequin_script_altmer_male",
		"mannequin_script_altmer_female",
		"mannequin_script_imperial_male",
		"mannequin_script_imperial_female",
		"mannequin_script_nord_male",
		"mannequin_script_nord_female",
		"mannequin_script_orc_male",
		"mannequin_script_orc_female",
		"mannequin_script_redguard_male",
		"mannequin_script_redguard_female",
		"mannequin_script_bosmer_male",
		"mannequin_script_bosmer_female"
	},
	droppableItemsInHome = {
		"mannequin_script_item_dunmer_male",
		"mannequin_script_item_dunmer_female",
		"mannequin_script_item_breton_male",
		"mannequin_script_item_breton_female",
		"mannequin_script_item_altmer_male",
		"mannequin_script_item_altmer_female",
		"mannequin_script_item_imperial_male",
		"mannequin_script_item_imperial_female",
		"mannequin_script_item_nord_male",
		"mannequin_script_item_nord_female",
		"mannequin_script_item_orc_male",
		"mannequin_script_item_orc_female",
		"mannequin_script_item_redguard_male",
		"mannequin_script_item_redguard_female",
		"mannequin_script_item_bosmer_male",
		"mannequin_script_item_bosmer_female"
	},
	mannequinItemToNPC = {
		["mannequin_script_item_dunmer_male"] = "mannequin_script_dunmer_male", 
		["mannequin_script_item_dunmer_female"] = "mannequin_script_dunmer_female",
		["mannequin_script_item_breton_male"] = "mannequin_script_breton_male",
		["mannequin_script_item_breton_female"] = "mannequin_script_breton_female",
		["mannequin_script_item_altmer_male"] = "mannequin_script_altmer_male",
		["mannequin_script_item_altmer_female"] = "mannequin_script_altmer_female",
		["mannequin_script_item_imperial_male"] = "mannequin_script_imperial_male",
		["mannequin_script_item_imperial_female"] = "mannequin_script_imperial_female",
		["mannequin_script_item_nord_male"] = "mannequin_script_nord_male",
		["mannequin_script_item_nord_female"] = "mannequin_script_nord_female",
		["mannequin_script_item_orc_male"] = "mannequin_script_orc_male",
		["mannequin_script_item_orc_female"] = "mannequin_script_orc_female",
		["mannequin_script_item_redguard_male"] = "mannequin_script_redguard_male",
		["mannequin_script_item_redguard_female"] = "mannequin_script_redguard_female",
		["mannequin_script_item_bosmer_male"] = "mannequin_script_bosmer_male",
		["mannequin_script_item_bosmer_female"] = "mannequin_script_bosmer_female"
	}	
}

local mannequinShopInventory = {
	{name = "Mannequin: Altmer Homme", refId = "mannequin_script_item_altmer_male", price = config.DefaultMannequinPrice, qty = 1},
	{name = "Mannequin: Altmer Femme", refId = "mannequin_script_item_altmer_female", price = config.DefaultMannequinPrice, qty = 1},
	{name = "Mannequin: Bosmer Homme", refId = "mannequin_script_item_bosmer_male", price = config.DefaultMannequinPrice, qty = 1},
	{name = "Mannequin: Bosmer Femme", refId = "mannequin_script_item_bosmer_female", price = config.DefaultMannequinPrice, qty = 1},
	{name = "Mannequin: Breton Homme", refId = "mannequin_script_item_breton_male", price = config.DefaultMannequinPrice, qty = 1},
	{name = "Mannequin: Breton Femme", refId = "mannequin_script_item_breton_female", price = config.DefaultMannequinPrice, qty = 1},
	{name = "Mannequin: Dunmer Homme", refId = "mannequin_script_item_dunmer_male", price = config.DefaultMannequinPrice, qty = 1},
	{name = "Mannequin: Dunmer Femme", refId = "mannequin_script_item_dunmer_female", price = config.DefaultMannequinPrice, qty = 1},
	{name = "Mannequin: Imperial Homme", refId = "mannequin_script_item_imperial_male", price = config.DefaultMannequinPrice, qty = 1},
	{name = "Mannequin: Imperial Femme", refId = "mannequin_script_item_imperial_female", price = config.DefaultMannequinPrice, qty = 1},
	{name = "Mannequin: Nord Homme", refId = "mannequin_script_item_nord_male", price = config.DefaultMannequinPrice, qty = 1},
	{name = "Mannequin: Nord Femme", refId = "mannequin_script_item_nord_female", price = config.DefaultMannequinPrice, qty = 1},
	{name = "Mannequin: Orc Homme", refId = "mannequin_script_item_orc_male", price = config.DefaultMannequinPrice, qty = 1},
	{name = "Mannequin: Orc Femme", refId = "mannequin_script_item_orc_female", price = config.DefaultMannequinPrice, qty = 1},
	{name = "Mannequin: Rougegarde Homme", refId = "mannequin_script_item_redguard_male", price = config.DefaultMannequinPrice, qty = 1},
	{name = "Mannequin: Rougegarde Femme", refId = "mannequin_script_item_redguard_female", price = config.DefaultMannequinPrice, qty = 1}
}

local targetMannequin = {}
local mannequinShop = {}

local function createRecord()
	local recordStore = RecordStores["spell"]
	recordStore.data.permanentRecords["npc_buffing_mannequin_buff"] = {
		name = "Mannequin Buff",
		subtype = 1, -- subtype = 4,
		cost = 0,
		flags = 0,
		effects = {
			{
				attribute = -1,
				area = 0,
				duration = 10,
				id = 45, -- Paralyze
				rangeType = 0,
				skill = -1,
				magnitudeMin = 1000,
				magnitudeMax = 1000
			},
			{
				attribute = -1,
				area = 0,
				duration = 10,
				id = 49, -- Calm Humanoid
				rangeType = 0,
				skill = -1,
				magnitudeMin = 1000,
				magnitudeMax = 1000
			},
			{
				attribute = -1,
				area = 0,
				duration = 10,
				id = 68, -- Reflect
				rangeType = 0,
				skill = -1,
				magnitudeMin = 10000,
				magnitudeMax = 10000
			},
			{
				attribute = -1,
				area = 0,
				duration = 10,
				id = 90, -- Resist Fire
				rangeType = 0,
				skill = -1,
				magnitudeMin = 10000,
				magnitudeMax = 10000
			},
			{
				attribute = -1,
				area = 0,
				duration = 10,
				id = 91, -- Resist Frost
				rangeType = 0,
				skill = -1,
				magnitudeMin = 10000,
				magnitudeMax = 10000
			},
			{
				attribute = -1,
				area = 0,
				duration = 10,
				id = 92, -- Resist Shock
				rangeType = 0,
				skill = -1,
				magnitudeMin = 10000,
				magnitudeMax = 10000
			},
			{
				attribute = -1,
				area = 0,
				duration = 10,
				id = 93, -- Resist Magicka
				rangeType = 0,
				skill = -1,
				magnitudeMin = 10000,
				magnitudeMax = 10000
			},
			{
				attribute = -1,
				area = 0,
				duration = 10,
				id = 94, -- Resist Common Disease
				rangeType = 0,
				skill = -1,
				magnitudeMin = 10000,
				magnitudeMax = 10000
			},
			{
				attribute = -1,
				area = 0,
				duration = 10,
				id = 95, -- Resist Blight Disease
				rangeType = 0,
				skill = -1,
				magnitudeMin = 10000,
				magnitudeMax = 10000
			},
			{
				attribute = -1,
				area = 0,
				duration = 10,
				id = 96, -- Resist Corprus Disease
				rangeType = 0,
				skill = -1,
				magnitudeMin = 10000,
				magnitudeMax = 10000
			},
			{
				attribute = -1,
				area = 0,
				duration = 10,
				id = 97, -- Resist Poison
				rangeType = 0,
				skill = -1,
				magnitudeMin = 10000,
				magnitudeMax = 10000
			},
			{
				attribute = -1,
				area = 0,
				duration = 10,
				id = 98, -- Resist Normal Weapons
				rangeType = 0,
				skill = -1,
				magnitudeMin = 10000,
				magnitudeMax = 10000
			},
			{
				attribute = -1,
				area = 0,
				duration = 10,
				id = 77, -- Restore Fatigue
				rangeType = 0,
				skill = -1,
				magnitudeMin = 20000,
				magnitudeMax = 20000
			},
			{
				attribute = -1,
				area = 0,
				duration = 10,
				id = 67, -- Spell Absorption
				rangeType = 0,
				skill = -1,
				magnitudeMin = 10000,
				magnitudeMax = 10000
			},
			{
				attribute = -1,
				area = 0,
				duration = 10,
				id = 75, -- Restore Health
				rangeType = 0,
				skill = -1,
				magnitudeMin = 200000,
				magnitudeMax = 200000
			}
		}
	}	
	recordStore = RecordStores["npc"]	
	recordStore.data.permanentRecords["mannequin_script_dunmer_male"] = {
		name = "Mannequin: Dunmer Homme",
		--gender = 1,
		baseId = "belvis sedri",
		health = 999999999,
		fatigue = 999999999,
		level = 9999,
		items = {},
		race = "dark elf",
		head = "b_n_dark elf_m_head_06",
		hair = "b_n_dark elf_m_hair_22",
		script = ""
	}
	recordStore:Save()
	
	recordStore.data.permanentRecords["mannequin_script_dunmer_female"] = {
		name = "Mannequin: Dunmer Femme",
		gender = 0,
		baseId = "belvis sedri",
		health = 999999999,
		fatigue = 999999999,
		level = 9999,
		items = {},
		race = "dark elf",
		head = "b_n_dark elf_f_head_02",
		hair = "b_n_dark elf_f_hair_01",
		script = ""
	}
	recordStore:Save()
	
	recordStore.data.permanentRecords["mannequin_script_breton_male"] = {
		name = "Mannequin: Breton Homme",
		baseId = "belvis sedri",
		health = 999999999,
		fatigue = 999999999,
		level = 9999,
		items = {},
		race = "breton",
		head = "b_n_breton_m_head_05",
		hair = "b_n_breton_m_hair_02",
		script = ""
	}
	recordStore:Save()
	
	recordStore.data.permanentRecords["mannequin_script_breton_female"] = {
		name = "Mannequin: Breton Femme",
		gender = 0,
		baseId = "belvis sedri",
		health = 999999999,
		fatigue = 999999999,
		level = 9999,
		items = {},
		race = "breton",
		head = "b_n_breton_f_head_02",
		hair = "b_n_breton_f_hair_02",
		script = ""
	}
	recordStore:Save()
	
	recordStore.data.permanentRecords["mannequin_script_altmer_male"] = {
		name = "Mannequin: Altmer Homme",
		baseId = "belvis sedri",
		health = 999999999,
		fatigue = 999999999,
		level = 9999,
		items = {},
		race = "high elf",
		head = "b_n_high elf_m_head_03",
		hair = "b_n_high elf_m_hair_04",
		script = ""
	}
	recordStore:Save()
	
	recordStore.data.permanentRecords["mannequin_script_altmer_female"] = {
		name = "Mannequin: Altmer Femme",
		gender = 0,
		baseId = "belvis sedri",
		health = 999999999,
		fatigue = 999999999,
		level = 9999,
		items = {},
		race = "high elf",
		head = "b_n_high elf_f_head_03",
		hair = "b_n_high elf_f_hair_02",
		script = ""
	}
	recordStore:Save()
	
	recordStore.data.permanentRecords["mannequin_script_imperial_male"] = {
		name = "Mannequin: Imperial Homme",
		baseId = "belvis sedri",
		health = 999999999,
		fatigue = 999999999,
		level = 9999,
		items = {},
		race = "imperial",
		head = "B_N_Imperial_M_Head_07",
		hair = "b_n_imperial_m_hair_05",
		script = ""
	}
	recordStore:Save()
	
	recordStore.data.permanentRecords["mannequin_script_imperial_female"] = {
		name = "Mannequin: Imperial Femme",
		gender = 0,
		baseId = "belvis sedri",
		health = 999999999,
		fatigue = 999999999,
		level = 9999,
		items = {},
		race = "imperial",
		head = "b_n_Imperial_f_head_03",
		hair = "b_n_imperial_f_hair_01",
		script = ""
	}
	recordStore:Save()
	
	recordStore.data.permanentRecords["mannequin_script_nord_male"] = {
		name = "Mannequin: Nord Homme",
		baseId = "belvis sedri",
		health = 999999999,
		fatigue = 999999999,
		level = 9999,
		items = {},
		race = "nord",
		head = "b_n_nord_m_head_05",
		hair = "b_n_nord_m_hair01",
		script = ""
	}
	recordStore:Save()
	
	recordStore.data.permanentRecords["mannequin_script_nord_female"] = {
		name = "Mannequin: Nord Femme",
		gender = 0,
		baseId = "belvis sedri",
		health = 999999999,
		fatigue = 999999999,
		level = 9999,
		items = {},
		race = "nord",
		head = "b_n_nord_f_head_03",
		hair = "b_n_nord_f_hair_03",
		script = ""
	}
	recordStore:Save()
	
	recordStore.data.permanentRecords["mannequin_script_orc_male"] = {
		name = "Mannequin: Orc Homme",
		baseId = "belvis sedri",
		health = 999999999,
		fatigue = 999999999,
		level = 9999,
		items = {},
		race = "orc",
		head = "b_n_orc_m_head_01",
		hair = "b_n_orc_m_hair_05",
		script = ""
	}
	recordStore:Save()
	
	recordStore.data.permanentRecords["mannequin_script_orc_female"] = {
		name = "Mannequin: Orc Femme",
		gender = 0,
		baseId = "belvis sedri",
		health = 999999999,
		fatigue = 999999999,
		level = 9999,
		items = {},
		race = "orc",
		head = "b_n_orc_f_head_02",
		hair = "b_n_orc_f_hair05",
		script = ""
	}
	recordStore:Save()
	
	recordStore.data.permanentRecords["mannequin_script_redguard_male"] = {
		name = "Mannequin: Rougegarde Homme",
		baseId = "belvis sedri",
		health = 999999999,
		fatigue = 999999999,
		level = 9999,
		items = {},
		race = "redguard",
		head = "b_n_redguard_m_head_04",
		hair = "b_n_redguard_m_hair_03",
		script = ""
	}
	recordStore:Save()
	
	recordStore.data.permanentRecords["mannequin_script_redguard_female"] = {
		name = "Mannequin: Rougegarde Femme",
		gender = 0,
		baseId = "belvis sedri",
		health = 999999999,
		fatigue = 999999999,
		level = 9999,
		items = {},
		race = "redguard",
		head = "b_n_redguard_f_head_03",
		hair = "b_n_redguard_f_hair_01",
		script = ""
	}
	recordStore:Save()
	
	recordStore.data.permanentRecords["mannequin_script_bosmer_male"] = {
		name = "Mannequin: Bosmer Homme",
		baseId = "belvis sedri",
		health = 999999999,
		fatigue = 999999999,
		level = 9999,
		items = {},
		race = "wood elf",
		head = "b_n_wood elf_m_head_04",
		hair = "b_n_wood elf_m_hair_06",
		script = ""
	}
	recordStore:Save()
	
	recordStore.data.permanentRecords["mannequin_script_bosmer_female"] = {
		name = "Mannequin: Bosmer Femme",
		gender = 0,
		baseId = "belvis sedri",
		health = 999999999,
		fatigue = 999999999,
		level = 9999,
		items = {},
		race = "wood elf",
		head = "b_n_wood elf_f_head_03",
		hair = "b_n_wood elf_f_hair_03",
		script = ""
	}
	recordStore:Save()
	
	
--==----==----==----==----==----==----==----==----==----==----==----==----==--
	
	recordStore = RecordStores["miscellaneous"]
	recordStore.data.permanentRecords["mannequin_script_item_dunmer_male"] = {
		name = "Mannequin: Dunmer Male",
		icon = "m\\Tx_vivec_ashmask_01.tga",
		model = "m\\Misc_vivec_ashmask_01.NIF",
		weight = 0.5,
		value = 0,
		script = ""
	}
	recordStore:Save()
	
	recordStore.data.permanentRecords["mannequin_script_item_dunmer_female"] = {
		name = "Mannequin: Dunmer Female",
		icon = "m\\Tx_vivec_ashmask_01.tga",
		model = "m\\Misc_vivec_ashmask_01.NIF",
		weight = 0.5,
		value = 0,
		script = ""
	}
	recordStore:Save()
	
	recordStore.data.permanentRecords["mannequin_script_item_breton_male"] = {
		name = "Mannequin: Breton Male",
		icon = "m\\Tx_vivec_ashmask_01.tga",
		model = "m\\Misc_vivec_ashmask_01.NIF",
		weight = 0.5,
		value = 0,
		script = ""
	}
	recordStore:Save()
	
	recordStore.data.permanentRecords["mannequin_script_item_breton_female"] = {
		name = "Mannequin: Breton Female",
		icon = "m\\Tx_vivec_ashmask_01.tga",
		model = "m\\Misc_vivec_ashmask_01.NIF",
		weight = 0.5,
		value = 0,
		script = ""
	}
	recordStore:Save()
	
	recordStore.data.permanentRecords["mannequin_script_item_altmer_male"] = {
		name = "Mannequin: Altmer Male",
		icon = "m\\Tx_vivec_ashmask_01.tga",
		model = "m\\Misc_vivec_ashmask_01.NIF",
		weight = 0.5,
		value = 0,
		script = ""
	}
	recordStore:Save()
	
	recordStore.data.permanentRecords["mannequin_script_item_altmer_female"] = {
		name = "Mannequin: Altmer Female",
		icon = "m\\Tx_vivec_ashmask_01.tga",
		model = "m\\Misc_vivec_ashmask_01.NIF",
		weight = 0.5,
		value = 0,
		script = ""
	}
	recordStore:Save()
	
	recordStore.data.permanentRecords["mannequin_script_item_imperial_male"] = {
		name = "Mannequin: Imperial Male",
		icon = "m\\Tx_vivec_ashmask_01.tga",
		model = "m\\Misc_vivec_ashmask_01.NIF",
		weight = 0.5,
		value = 0,
		script = ""
	}
	recordStore:Save()
	
	recordStore.data.permanentRecords["mannequin_script_item_imperial_female"] = {
		name = "Mannequin: Imperial Female",
		icon = "m\\Tx_vivec_ashmask_01.tga",
		model = "m\\Misc_vivec_ashmask_01.NIF",
		weight = 0.5,
		value = 0,
		script = ""
	}
	recordStore:Save()
	
	recordStore.data.permanentRecords["mannequin_script_item_nord_male"] = {
		name = "Mannequin: Nord Male",
		icon = "m\\Tx_vivec_ashmask_01.tga",
		model = "m\\Misc_vivec_ashmask_01.NIF",
		weight = 0.5,
		value = 0,
		script = ""
	}
	recordStore:Save()
	
	recordStore.data.permanentRecords["mannequin_script_item_nord_female"] = {
		name = "Mannequin: Nord Female",
		icon = "m\\Tx_vivec_ashmask_01.tga",
		model = "m\\Misc_vivec_ashmask_01.NIF",
		weight = 0.5,
		value = 0,
		script = ""
	}
	recordStore:Save()
	
	recordStore.data.permanentRecords["mannequin_script_item_orc_male"] = {
		name = "Mannequin: Orsimer Male",
		icon = "m\\Tx_vivec_ashmask_01.tga",
		model = "m\\Misc_vivec_ashmask_01.NIF",
		weight = 0.5,
		value = 0,
		script = ""
	}
	recordStore:Save()
	
	recordStore.data.permanentRecords["mannequin_script_item_orc_female"] = {
		name = "Mannequin: Orsimer Female",
		icon = "m\\Tx_vivec_ashmask_01.tga",
		model = "m\\Misc_vivec_ashmask_01.NIF",
		weight = 0.5,
		value = 0,
		script = ""
	}
	recordStore:Save()
	
	recordStore.data.permanentRecords["mannequin_script_item_redguard_male"] = {
		name = "Mannequin: Redguard Male",
		icon = "m\\Tx_vivec_ashmask_01.tga",
		model = "m\\Misc_vivec_ashmask_01.NIF",
		weight = 0.5,
		value = 0,
		script = ""
	}
	recordStore:Save()
	
	recordStore.data.permanentRecords["mannequin_script_item_redguard_female"] = {
		name = "Mannequin: Redguard Female",
		icon = "m\\Tx_vivec_ashmask_01.tga",
		model = "m\\Misc_vivec_ashmask_01.NIF",
		weight = 0.5,
		value = 0,
		script = ""
	}
	recordStore:Save()
	
	recordStore.data.permanentRecords["mannequin_script_item_bosmer_male"] = {
		name = "Mannequin: Bosmer Male",
		icon = "m\\Tx_vivec_ashmask_01.tga",
		model = "m\\Misc_vivec_ashmask_01.NIF",
		weight = 0.5,
		value = 0,
		script = ""
	}
	recordStore:Save()
	
	recordStore.data.permanentRecords["mannequin_script_item_bosmer_female"] = {
		name = "Mannequin: Bosmer Female",
		icon = "m\\Tx_vivec_ashmask_01.tga",
		model = "m\\Misc_vivec_ashmask_01.NIF",
		weight = 0.5,
		value = 0,
		script = ""
	}
	recordStore:Save()
	
end

local function OnServerPostInit(eventStatus)
	createRecord()
end

customEventHooks.registerHandler("OnServerPostInit", OnServerPostInit)

local pName = function(pid)
	return tostring(Players[pid].accountName)
end

local checkForMannequinRefIds = function(pid, cellDescription)
	if LoadedCells[cellDescription] ~= nil then
		for _index,objIndex in pairs(LoadedCells[cellDescription].data.packets.actorList) do
			if cellDescription ~= nil and LoadedCells[cellDescription] ~= nil and LoadedCells[cellDescription].data.objectData[objIndex] ~= nil then 
				local targetRefId = LoadedCells[cellDescription].data.objectData[objIndex].refId				
				if tableHelper.containsValue(config.mannequinRefIDs, targetRefId) then
					local consoleCommand = "addspell npc_buffing_mannequin_buff"
					logicHandler.RunConsoleCommandOnObject(pid, consoleCommand, cellDescription, objIndex, true)
					LoadedCells[cellDescription]:LoadActorEquipment(pid, LoadedCells[cellDescription].data.objectData, {objIndex})
				end
				
			end
		end
	end
end

TFN_Mannequin.pushMannequinParalysis = function(pid)
	local cellDescription = tes3mp.GetCell(pid)
	if cellDescription ~= nil and LoadedCells[cellDescription] ~= nil then
		checkForMannequinRefIds(pid, cellDescription)
	end
end

customEventHooks.registerHandler("OnPlayerCellChange", function(eventStatus, pid)
	TFN_Mannequin.pushMannequinParalysis(pid)
end)

customEventHooks.registerHandler("OnActorList", function(eventStatus, pid)
	TFN_Mannequin.pushMannequinParalysis(pid)
end)

TFN_Mannequin.spawnPlacedMannequin = function(pid, refId)	
	local cellId = tes3mp.GetCell(pid)
	local location = {posX = tes3mp.GetPosX(pid), posY = tes3mp.GetPosY(pid), posZ = tes3mp.GetPosZ(pid), rotX = tes3mp.GetRotX(pid), rotY = 0, rotZ = tes3mp.GetRotZ(pid)}
	local targetRefId = config.mannequinItemToNPC[refId]
	local targetUniqueIndex = logicHandler.CreateObjectAtLocation(cellId, location, targetRefId, "spawn")	
	if cellId ~= nil and targetUniqueIndex ~= nil then
		if LoadedCells[cellId] ~= nil then
			LoadedCells[cellId].data.objectData[targetUniqueIndex].equipment = {}
			LoadedCells[cellId].data.objectData[targetUniqueIndex].inventory = {}
			if config.LockByDefault then
				LoadedCells[cellId].data.objectData[targetUniqueIndex].mannequinOwner = pName(pid)
			end
			for tPid, player in pairs(Players) do
				if LoadedCells[cellId] ~= nil then
					local uniqueIndexArray = {targetUniqueIndex}
					LoadedCells[cellId]:LoadActorEquipment(tPid, LoadedCells[cellId].data.objectData, uniqueIndexArray)
				end
			end
		end
	end
	
end

TFN_Mannequin.deletePlacedMannequin = function(pid)	
	if targetMannequin[pid] ~= nil then	
		local cellDescription = targetMannequin[pid].cell
		local tRefId = targetMannequin[pid].refId
		local tUniqueIndex = targetMannequin[pid].uniqueIndex	
		if cellDescription == nil or tUniqueIndex == nil or tRefId == nil then return end		
		TFN_Mannequin.takeMannequinEquipment(pid)		
		for itemRefId,npcRefId in pairs(config.mannequinItemToNPC) do
			if npcRefId == tRefId then
				TFN_Mannequin.add(pid, itemRefId, 1)
				logicHandler.RunConsoleCommandOnPlayer(pid, "PlaySound \"Item Misc Up\"")
			end
		end
		if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
			if LoadedCells[cellDescription] ~= nil then
				if LoadedCells[cellDescription].data.objectData[tUniqueIndex] then
					tableHelper.removeValue(LoadedCells[cellDescription].data.packets, tUniqueIndex)
					LoadedCells[cellDescription].data.objectData[tUniqueIndex] = nil		
					tableHelper.cleanNils(LoadedCells[cellDescription].data.objectData)							
				end						
				logicHandler.DeleteObjectForEveryone(cellDescription, tUniqueIndex)						
			end
		end		
	end	
end	

TFN_Mannequin.equipMannequinsEquipment = function(pid)
	if targetMannequin[pid] ~= nil then
		local cell = targetMannequin[pid].cell
		local tRefId = targetMannequin[pid].refId
		local tUniqueIndex = targetMannequin[pid].uniqueIndex		
		if cell ~= nil and tUniqueIndex ~= nil then
			if LoadedCells[cell] ~= nil then					
				if LoadedCells[cell].data.objectData[tUniqueIndex].inventory ~= nil and not tableHelper.isEmpty(LoadedCells[cell].data.objectData[tUniqueIndex].inventory) then
					local inventoryItems = 0
					for iSlot,iData in pairs(LoadedCells[cell].data.objectData[tUniqueIndex].inventory) do
						local iRefId = iData.refId
						local iCount = iData.count
						local iECharge = iData.enchantmentCharge
						local iCharge = iData.charge
						local iSoul = iData.soul
						TFN_Mannequin.add(pid, iRefId, iCount, iSoul, iCharge, iECharge)
						inventoryItems = inventoryItems + 1
					end					
					if inventoryItems > 0 then
						local plural = "items."
						if inventoryItems == 1 then
							plural = "item."
						end							
						tes3mp.MessageBox(pid, -1, config.MenuTextColor..trad.ManSend..color.White..inventoryItems..config.MenuTextColor..trad.ManView..plural)
						logicHandler.RunConsoleCommandOnPlayer(pid, "PlaySound \"Item Misc Up\"")						
						TFN_Mannequin.reloadNPCEquipment(pid)
					end										
				end				
				if LoadedCells[cell].data.objectData[tUniqueIndex].equipment ~= nil and not tableHelper.isEmpty(LoadedCells[cell].data.objectData[tUniqueIndex].equipment) then
					local equippedItemCount = 0
					for iSlot,iData in pairs(LoadedCells[cell].data.objectData[tUniqueIndex].equipment) do
						equippedItemCount = equippedItemCount + 1
					end					
					if equippedItemCount > 0 then
						local plural = "items."
						if equippedItemCount == 1 then
							plural = "item."
						end						
						tes3mp.MessageBox(pid, -1, config.MenuTextColor..trad.ManEquip..color.White..equippedItemCount..config.MenuTextColor..trad.ManView..plural)
						local equipmentTransfer = LoadedCells[cell].data.objectData[tUniqueIndex].equipment
						logicHandler.RunConsoleCommandOnPlayer(pid, "PlaySound \"Item Misc Up\"")					
						Players[pid].data.equipment = equipmentTransfer
						Players[pid]:LoadEquipment()
						LoadedCells[cell].data.objectData[tUniqueIndex].inventory = {}
						LoadedCells[cell].data.objectData[tUniqueIndex].equipment = {}			
						TFN_Mannequin.reloadNPCEquipment(pid)
					end									
				end
			end
			
		end
		
	end
end

TFN_Mannequin.takeMannequinEquipment = function(pid)
	if targetMannequin[pid] ~= nil then
		local cell = targetMannequin[pid].cell
		local tRefId = targetMannequin[pid].refId
		local tUniqueIndex = targetMannequin[pid].uniqueIndex		
		if cell ~= nil and tUniqueIndex ~= nil then
			if LoadedCells[cell] ~= nil then
				if LoadedCells[cell].data.objectData[tUniqueIndex].inventory ~= nil and not tableHelper.isEmpty(LoadedCells[cell].data.objectData[tUniqueIndex].inventory) then
					local inventoryCounter = 0
					for iSlot,iData in pairs(LoadedCells[cell].data.objectData[tUniqueIndex].inventory) do
						local iRefId = iData.refId
						local iCount = iData.count
						local iECharge = iData.enchantmentCharge
						local iCharge = iData.charge
						local iSoul = iData.soul
						TFN_Mannequin.add(pid, iRefId, iCount, iSoul, iCharge, iECharge)
						inventoryCounter = inventoryCounter + 1
					end
					local plural = trad.ManSingle
					if equippedItemCount == 1 then
						plural = trad.ManPlural
					end	
						
					tes3mp.MessageBox(pid, -1, trad.ManTheyMan..inventoryCounter..trad.ManView..plural..trad.ManAddInv)
					logicHandler.RunConsoleCommandOnPlayer(pid, "PlaySound \"Item Misc Up\"")
					
				end
				LoadedCells[cell].data.objectData[tUniqueIndex].inventory = {}
				LoadedCells[cell].data.objectData[tUniqueIndex].equipment = {}
				TFN_Mannequin.reloadNPCEquipment(pid)
			end			
		end		
	end
end

TFN_Mannequin.addMannequinEquipment = function(pid)
	if targetMannequin[pid] ~= nil then
		local cell = targetMannequin[pid].cell
		local tRefId = targetMannequin[pid].refId
		local tUniqueIndex = targetMannequin[pid].uniqueIndex		
		if cell ~= nil and tUniqueIndex ~= nil then
			TFN_Mannequin.takeMannequinEquipment(pid)
			if Players[pid].data.equipment ~= nil and not tableHelper.isEmpty(Players[pid].data.equipment) then
				local equipmentTransfer = Players[pid].data.equipment
				local displayCount = 0				
				for eSlot,eData in pairs(Players[pid].data.equipment) do
					displayCount = displayCount + 1
					
					local eRefId = eData.refId
					local eCount = eData.count
					local eSoul = eData.soul or ""
					local eCharge = eData.charge
					local eECharge = eData.enchantmentCharge
					
					TFN_Mannequin.remove(pid, eRefId, eCount, eSoul, eCharge, eECharge)
					local addInventoryItem = {refId = eRefId, enchantmentCharge = eECharge, count = eCount, charge = eCharge, soul = eSoul}
					if LoadedCells[cell].data.objectData[tUniqueIndex].inventory == nil then 
						LoadedCells[cell].data.objectData[tUniqueIndex].inventory = {}
					end
					table.insert(LoadedCells[cell].data.objectData[tUniqueIndex].inventory, addInventoryItem)
				end
				LoadedCells[cell].data.objectData[tUniqueIndex].equipment = equipmentTransfer				
				local plural = trad.ManSingle
				if displayCount == 1 then
					plural = trad.ManPlural
				end				
				tes3mp.MessageBox(pid, -1, color.White..displayCount.." "..config.MenuTextColor..plural..trad.ManViewNow)
				TFN_Mannequin.reloadNPCEquipment(pid)
			end			
		end		
	end
end

TFN_Mannequin.reloadNPCEquipment = function(pid)
	if targetMannequin[pid] ~= nil then
		local cell = targetMannequin[pid].cell
		local tRefId = targetMannequin[pid].refId
		local tUniqueIndex = targetMannequin[pid].uniqueIndex		
		if cell ~= nil and tUniqueIndex ~= nil then
			for tPid, player in pairs(Players) do
				if LoadedCells[cell] ~= nil then					
					local uniqueIndexArray = {tUniqueIndex}
					LoadedCells[cell]:LoadActorEquipment(tPid, LoadedCells[cell].data.objectData, uniqueIndexArray)
					
				end
			end
		end
		
	end
end

TFN_Mannequin.activateMannequin = function(pid, cellDescription, tRefId, tUniqueIndex)	
	if LoadedCells[cellDescription] ~= nil and tUniqueIndex ~= nil then		
		if Players[pid].data.settings.staffRank < config.StaffRankToBypassLock then
			local mOwner = LoadedCells[cellDescription].data.objectData[tUniqueIndex].mannequinOwner
			if mOwner ~= nil and string.lower(mOwner) ~= string.lower(pName(pid)) then 
				local txt = config.MenuTextColor..trad.ManLockedBy..color.Yellow..mOwner..config.MenuTextColor.."."
				tes3mp.MessageBox(pid, -1, txt)
				return
			end
		end		
		targetMannequin[pid] = {}
		targetMannequin[pid].cell = cellDescription
		targetMannequin[pid].refId = tRefId
		targetMannequin[pid].uniqueIndex = tUniqueIndex		
		TFN_Mannequin.menuActivatedMannequin(pid)
		local uniqueIndexArray = {tUniqueIndex}
		LoadedCells[cellDescription]:LoadActorEquipment(pid, LoadedCells[cellDescription].data.objectData, uniqueIndexArray)
	end	
end

TFN_Mannequin.menuActivatedMannequin = function(pid)	
	if targetMannequin[pid] ~= nil then
		local cellDescription = targetMannequin[pid].cell
		local tUniqueIndex = targetMannequin[pid].uniqueIndex		
		if cellDescription ~= nil and tUniqueIndex ~= nil then
			local msg = trad.ManGuiMenu			
			local lockedTxt = trad.ManLocked
			local lockChoice = trad.ManLockChoice
			local mOwner = LoadedCells[cellDescription].data.objectData[tUniqueIndex].mannequinOwner
			if mOwner == nil then 
				lockedTxt = trad.ManUnlocked
				lockChoice = trad.ManUnlockChoice
			else
				if Players[pid].data.settings.staffRank >= config.StaffRankToBypassLock then
					lockedTxt = trad.ManLockAccess..color.Yellow..mOwner..color.White..".\n"
				end
			end			
			msg = msg..lockedTxt			
			tes3mp.CustomMessageBox(pid, config.mannequinDisplayEquipmentOptions, msg, trad.ManOptAccess..lockChoice..trad.ManExit)	
			
		end
	end
	
end

local pullMannequinShopInventory = function()	
	local items = {}	
	for i = 1, #mannequinShopInventory do
		table.insert(items, mannequinShopInventory[i])
	end	
	return items
end

local getPlayerCurrencyAmount = function(pid)
	if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		if inventoryHelper.containsItem(Players[pid].data.inventory, "gold_001") then
			local goldLoc = inventoryHelper.getItemIndex(Players[pid].data.inventory, "gold_001")
			if goldLoc then
				return Players[pid].data.inventory[goldLoc].count
			end
		end
	end	
	return 0
end

TFN_Mannequin.menuMannequinShop = function(pid)	
	local label = color.Orange..trad.ManMainMenu..config.MenuTextColor..trad.ManYouHave..getPlayerCurrencyAmount(pid)..trad.ManMainGold	
	local options = pullMannequinShopInventory()
	local msg = trad.ManShopExit	
	for i = 1, #options do
		local cashColor = color.Red
		if getPlayerCurrencyAmount(pid) > options[i].price then
			cashColor = color.White
		end
		msg = msg..options[i].name..config.MenuTextColor.."  ("..cashColor..options[i].price..config.MenuTextColor..")\n"
	end
	mannequinShop[tostring(pid)] = options	
	tes3mp.ListBox(pid, config.menuMannequinShop, label, msg)
end

local purchaseMannequinFunction = function(pid, data)	
	local pGold = getPlayerCurrencyAmount(pid)
	local choice = mannequinShop[tostring(pid)][data]
	if choice == nil or choice.price == nil then return TFN_Mannequin.menuMannequinShop(pid) end	
	if pGold < choice.price then
		tes3mp.MessageBox(pid, -1, trad.ManDontBuy..choice.name..".")
		return TFN_Mannequin.menuMannequinShop(pid)
	end	
	local refId = string.lower(choice.refId)
	local cost = choice.price	
	TFN_Mannequin.remove(pid, "gold_001", cost)
	TFN_Mannequin.add(pid, refId, choice.qty)
	logicHandler.RunConsoleCommandOnPlayer(pid, "PlaySound \"Item Gold Down\"")
	logicHandler.RunConsoleCommandOnPlayer(pid, "PlaySound \"Item Misc Up\"")
	tes3mp.MessageBox(pid, -1, trad.ManBuyOwner..choice.qty.." "..choice.name..trad.ManBuyFor..cost..trad.ManBuyGolds)
	return TFN_Mannequin.menuMannequinShop(pid)	
end

customEventHooks.registerHandler("OnGUIAction", function(eventStatus, pid, idGui, data)	
	if idGui == config.mannequinDisplayEquipmentOptions then -- 
		if tonumber(data) == 0 then -- Afficher mon équipement
			TFN_Mannequin.addMannequinEquipment(pid)
			return
		elseif tonumber(data) == 1 then -- Remove Display Equipment
			TFN_Mannequin.takeMannequinEquipment(pid)
			return
		elseif tonumber(data) == 2 then -- Equip This Outfit
			TFN_Mannequin.equipMannequinsEquipment(pid)
			return
		elseif tonumber(data) == 3 then -- Pick Up Mannequin
			TFN_Mannequin.deletePlacedMannequin(pid)
			return
		elseif tonumber(data) == 4 then -- Lock/Unlock
			if targetMannequin[pid] ~= nil then
				local cellDescription = targetMannequin[pid].cell
				local tRefId = targetMannequin[pid].refId
				local tUniqueIndex = targetMannequin[pid].uniqueIndex
			
				if LoadedCells[cellDescription].data.objectData[tUniqueIndex].mannequinOwner == nil then
					LoadedCells[cellDescription].data.objectData[tUniqueIndex].mannequinOwner = pName(pid)
					tes3mp.MessageBox(pid, -1, trad.ManOpenOwner)
				else
					LoadedCells[cellDescription].data.objectData[tUniqueIndex].mannequinOwner = nil
					tes3mp.MessageBox(pid, -1, trad.ManOpenAll)
				end
				return TFN_Mannequin.menuActivatedMannequin(pid)
			end
		else 
			return
		end	
	elseif idGui == config.menuMannequinShop then
		if tonumber(data) == 0 or tonumber(data) > 1000 then --Close/Nothing Selected
			Players[pid].currentCustomMenu = "menu immobilier"--main menu
			menuHelper.DisplayMenu(pid, Players[pid].currentCustomMenu)
			return
		else
			return purchaseMannequinFunction(pid, tonumber(data))
		end
		
	end	
end)

function TFN_Mannequin.OnObjectActivateValidator(eventStatus, pid, cellDescription, objects, players)
    for _, object in pairs(objects) do
		if tableHelper.containsValue(config.mannequinRefIDs, object.refId) then
				
			if not Players[pid].data.shapeshift.isWerewolf then	
				local cellDescription = tes3mp.GetCell(pid)
				local tRefId = object.refId
				local tUniqueIndex = object.uniqueIndex
				TFN_Mannequin.activateMannequin(pid, cellDescription, tRefId, tUniqueIndex)
			end
			
			return customEventHooks.makeEventStatus(false, false)
		end
    end
end

customEventHooks.registerValidator("OnObjectActivate", TFN_Mannequin.OnObjectActivateValidator)

TFN_Mannequin.add = function(pid, refId, count, soul, charge, enchantmentCharge)
	if refId == nil then return end
	if count == nil then count = 1 end
	if soul == nil then soul = "" end
	if charge == nil then charge = -1 end
	if enchantmentCharge == nil then enchantmentCharge = -1 end
	
	tes3mp.ClearInventoryChanges(pid)
	tes3mp.SetInventoryChangesAction(pid, enumerations.inventory.ADD)
	tes3mp.AddItemChange(pid, refId, count, charge, enchantmentCharge, soul)
	tes3mp.SendInventoryChanges(pid)
	Players[pid]:SaveInventory()
end

TFN_Mannequin.remove = function(pid, refId, count, soul, charge, enchantmentCharge)
	if refId == nil then return end
	if count == nil then count = 1 end
	if soul == nil then soul = "" end
	if charge == nil then charge = -1 end
	if enchantmentCharge == nil then enchantmentCharge = -1 end
	
	tes3mp.ClearInventoryChanges(pid)
	tes3mp.SetInventoryChangesAction(pid, enumerations.inventory.REMOVE)
	tes3mp.AddItemChange(pid, refId, count, charge, enchantmentCharge, soul)
	tes3mp.SendInventoryChanges(pid)
	Players[pid]:SaveInventory()
end

local split = function(s, delimiter)
    result = {};
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match);
    end
    return result;
end

function TFN_Mannequin.OnObjectPlaceValidator(eventStatus, pid, cellDescription, objects)	
	for i, object in pairs(objects) do
		local temp = split(object.uniqueIndex, "-")
        local RefNum = temp[1]
		local MpNum = temp[2]
		local refId = object.refId		
		local itemSoul = tes3mp.GetObjectSoul(i-1)
		local count = tes3mp.GetObjectCount(i-1)
		local itemCharge = tes3mp.GetObjectCharge(i-1)
        local itemEnchantmentCharge = tes3mp.GetObjectEnchantmentCharge(i-1)		
		if tableHelper.containsValue(config.droppableItemsInHome, refId) then
			local CellData = TFN_HousingShop.GetCellData(cellDescription)
			if CellData and CellData.house then
				if TFN_HousingShop.IsOwner(string.lower(Players[pid].accountName), CellData.house) or
					TFN_HousingShop.IsCoOwner(string.lower(Players[pid].accountName), CellData.house) then 
					TFN_Mannequin.spawnPlacedMannequin(pid, refId)
					TFN_Mannequin.pushMannequinParalysis(pid)					
				else
					tes3mp.MessageBox(pid, -1, trad.ManNotOwner)
					logicHandler.RunConsoleCommandOnPlayer(pid, "PlaySound \"Item Misc Up\"")
					TFN_Mannequin.add(pid, refId, count)
				end	
			else
				if LoadedCells[cellDescription].isExterior then
					tes3mp.MessageBox(pid, -1, trad.ManNotExterior)
					logicHandler.RunConsoleCommandOnPlayer(pid, "PlaySound \"Item Misc Up\"")
					TFN_Mannequin.add(pid, refId, count)
				else		
					if count > 1 then
						tes3mp.MessageBox(pid, -1, trad.ManCapCount)
						logicHandler.RunConsoleCommandOnPlayer(pid, "PlaySound \"Item Misc Up\"")
						local dropCount = count - 1
						TFN_Mannequin.add(pid, refId, dropCount)
					end
					tes3mp.MessageBox(pid, -1, trad.ManNotOwner)
					logicHandler.RunConsoleCommandOnPlayer(pid, "PlaySound \"Item Misc Up\"")
					local dropCount = count
					TFN_Mannequin.add(pid, refId, count)					
				end
			end			
			return customEventHooks.makeEventStatus(false, false)
		end
	end	
end

customEventHooks.registerValidator("OnObjectPlace", TFN_Mannequin.OnObjectPlaceValidator)

customCommandHooks.registerCommand("mannequins", function(pid, cmd)
	TFN_Mannequin.menuMannequinShop(pid)
end)

return TFN_Mannequin
