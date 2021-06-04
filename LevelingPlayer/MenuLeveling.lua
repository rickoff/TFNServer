Menus["menu leveling"] = {
	text = {color.Orange .. "SKILLS MENU\n",
		color.Yellow .. "\nskill points : " .. color.White,
		menuHelper.variables.currentPlayerDataVariable("customVariables.pointSoul"),
		"\n",
	},
    buttons = {
        { caption = "Statistics",
			destinations = {menuHelper.destinations.setDefault("menu cmp cmb")
			}
        },
        { caption = "Skills",
			destinations = {menuHelper.destinations.setDefault("menu cmp mag")
			}
        },			
        { caption = "Exit", destinations = nil }
    }
}

Menus["menu cmp cmb"] = {
	text = {color.Orange .. "INCREASE STATISTICS\n",	
		color.Yellow .. "\nskill points : " .. color.White,
		menuHelper.variables.currentPlayerDataVariable("customVariables.pointSoul"),
		"\n\n",
		color.White .. "\nSelect a characteristic from the list" .. color.Yellow,
		"\nincreases the characteristic of :" .. color.Green,
		" + 1" .. color.White,
		" point.\n" .. color.Yellow,
		color.Yellow .. "\nCost : ",
		color.White .. "1 skill point.\n"		
	},
    buttons = {						
        { caption = {"Strength : ", color.Gold, menuHelper.variables.currentPlayerDataVariable("customVariables.forceCount")},
            destinations = {menuHelper.destinations.setDefault(nil,
            { 
				menuHelper.effects.runGlobalFunction("TFN_LevelingPlayer", "InputDialog", 
					{menuHelper.variables.currentPid(), "Strength", "Add"})
                })
            }
		},
        { caption = {"Endurance : ", color.Gold, menuHelper.variables.currentPlayerDataVariable("customVariables.enduranceCount")},
            destinations = {menuHelper.destinations.setDefault(nil,
            { 
				menuHelper.effects.runGlobalFunction("TFN_LevelingPlayer", "InputDialog", 
					{menuHelper.variables.currentPid(), "Endurance", "Add"})
                })
            }
		},		
        { caption = {"Speed : ", color.Gold, menuHelper.variables.currentPlayerDataVariable("customVariables.rapiditeCount")},
            destinations = {menuHelper.destinations.setDefault(nil,
            { 
				menuHelper.effects.runGlobalFunction("TFN_LevelingPlayer", "InputDialog", 
					{menuHelper.variables.currentPid(), "Speed", "Add"})
                })
            }	
		},
        { caption = {"Agility : ", color.Gold, menuHelper.variables.currentPlayerDataVariable("customVariables.agiliteCount")},
            destinations = {menuHelper.destinations.setDefault(nil,
            { 
				menuHelper.effects.runGlobalFunction("TFN_LevelingPlayer", "InputDialog", 
					{menuHelper.variables.currentPid(), "Agility", "Add"})
                })
            }	
		},		
        { caption = {"Intelligence : ", color.Gold, menuHelper.variables.currentPlayerDataVariable("customVariables.intelligenceCount")},
            destinations = {menuHelper.destinations.setDefault(nil,
            { 
				menuHelper.effects.runGlobalFunction("TFN_LevelingPlayer", "InputDialog", 
					{menuHelper.variables.currentPid(), "Intelligence", "Add"})
                })
            }
        },
        { caption = {"Willpower : ", color.Gold, menuHelper.variables.currentPlayerDataVariable("customVariables.volonteCount")},
            destinations = {menuHelper.destinations.setDefault(nil,
            { 
				menuHelper.effects.runGlobalFunction("TFN_LevelingPlayer", "InputDialog", 
					{menuHelper.variables.currentPid(), "Willpower", "Add"})
                })
            }
        },		
        { caption = {"Luck : ", color.Gold, menuHelper.variables.currentPlayerDataVariable("customVariables.chanceCount")},
            destinations = {menuHelper.destinations.setDefault(nil,
            { 
				menuHelper.effects.runGlobalFunction("TFN_LevelingPlayer", "InputDialog", 
					{menuHelper.variables.currentPid(), "Luck", "Add"})
                })
            }
        },
        { caption = {"Personality : ", color.Gold, menuHelper.variables.currentPlayerDataVariable("customVariables.personnaliteCount")},
            destinations = {menuHelper.destinations.setDefault(nil,
            { 
				menuHelper.effects.runGlobalFunction("TFN_LevelingPlayer", "InputDialog", 
					{menuHelper.variables.currentPid(), "Personality", "Add"})
                })
            }
        },
        { caption = "Discrease",
            destinations = {menuHelper.destinations.setDefault("menu cmp cmb 2")
            }
        },						
        { caption = "Exit", destinations = nil }
    }
}

Menus["menu cmp cmb 2"] = {
	text = {color.Orange .. "DECREASE STATISTICS\n",
		color.Yellow .. "\nskill points : " .. color.White,
		menuHelper.variables.currentPlayerDataVariable("customVariables.pointSoul"),
		"\n\n",
		color.White .. "\nSelect a characteristic from the list" .. color.Yellow,
		"\ndecreases the characteristic of :" .. color.Green,
		" - 1" .. color.White,
		" point.\n" .. color.Yellow,
		color.Yellow .. "\nGain : ",
		color.White .. "1 skill point.\n"	
	},
    buttons = {						
        { caption = {"Strength : ", color.Gold, menuHelper.variables.currentPlayerDataVariable("customVariables.forceCount")},
            destinations = {menuHelper.destinations.setDefault(nil,
            { 
				menuHelper.effects.runGlobalFunction("TFN_LevelingPlayer", "InputDialog", 
					{menuHelper.variables.currentPid(), "Strength", "Remove"})
                })
            }
		},
        { caption = {"Endurance : ", color.Gold, menuHelper.variables.currentPlayerDataVariable("customVariables.enduranceCount")},
            destinations = {menuHelper.destinations.setDefault(nil,
            { 
				menuHelper.effects.runGlobalFunction("TFN_LevelingPlayer", "InputDialog", 
					{menuHelper.variables.currentPid(), "Endurance", "Remove"})
                })
            }
		},		
        { caption = {"Speed : ", color.Gold, menuHelper.variables.currentPlayerDataVariable("customVariables.rapiditeCount")},
            destinations = {menuHelper.destinations.setDefault(nil,
            { 
				menuHelper.effects.runGlobalFunction("TFN_LevelingPlayer", "InputDialog", 
					{menuHelper.variables.currentPid(), "Speed", "Remove"})
                })
            }	
		},
        { caption = {"Agility : ", color.Gold, menuHelper.variables.currentPlayerDataVariable("customVariables.agiliteCount")},
            destinations = {menuHelper.destinations.setDefault(nil,
            { 
				menuHelper.effects.runGlobalFunction("TFN_LevelingPlayer", "InputDialog", 
					{menuHelper.variables.currentPid(), "Agility", "Remove"})
                })
            }	
		},		
        { caption = {"Intelligence : ", color.Gold, menuHelper.variables.currentPlayerDataVariable("customVariables.intelligenceCount")},
            destinations = {menuHelper.destinations.setDefault(nil,
            { 
				menuHelper.effects.runGlobalFunction("TFN_LevelingPlayer", "InputDialog", 
					{menuHelper.variables.currentPid(), "Intelligence", "Remove"})
                })
            }
        },
        { caption = {"Willpower : ", color.Gold, menuHelper.variables.currentPlayerDataVariable("customVariables.volonteCount")},
            destinations = {menuHelper.destinations.setDefault(nil,
            { 
				menuHelper.effects.runGlobalFunction("TFN_LevelingPlayer", "InputDialog", 
					{menuHelper.variables.currentPid(), "Willpower", "Remove"})
                })
            }
        },		
        { caption = {"Luck : ", color.Gold, menuHelper.variables.currentPlayerDataVariable("customVariables.chanceCount")},
            destinations = {menuHelper.destinations.setDefault(nil,
            { 
				menuHelper.effects.runGlobalFunction("TFN_LevelingPlayer", "InputDialog", 
					{menuHelper.variables.currentPid(), "Luck", "Remove"})
                })
            }
        },
        { caption = {"Personality : ", color.Gold, menuHelper.variables.currentPlayerDataVariable("customVariables.personnaliteCount")},
            destinations = {menuHelper.destinations.setDefault(nil,
            { 
				menuHelper.effects.runGlobalFunction("TFN_LevelingPlayer", "InputDialog", 
					{menuHelper.variables.currentPid(), "Personality", "Remove"})
                })
            }
        },
        { caption = "Increase",
            destinations = {menuHelper.destinations.setDefault("menu cmp cmb")
            }
        },					
        { caption = "Exit", destinations = nil }
    }
}

Menus["menu cmp mag"] = {
	text = {color.Orange .. "INCREASE TALENT page 1\n",
		color.Yellow .. "\nskill points : " .. color.White,
		menuHelper.variables.currentPlayerDataVariable("customVariables.pointSoul"),
		"\n\n",
		color.White .. "\nSelect a talent from the list" .. color.Yellow,
		"\naugmente le talent de :" .. color.Green,
		" + 1" .. color.White,
		" point.\n" .. color.Yellow,
		color.Yellow .. "\nCost : ",
		color.White .. "1 skill point.\n"
	},
    buttons = {	
        { caption = {"Handtohand : ", color.Gold, menuHelper.variables.currentPlayerDataVariable("customVariables.handtohandCount")}, 
            destinations = {menuHelper.destinations.setDefault(nil,
            { 
				menuHelper.effects.runGlobalFunction("TFN_LevelingPlayer", "InputDialog", 
					{menuHelper.variables.currentPid(), "Handtohand", "Add"})
                })
            }
        },	
        { caption = {"Shortblade : ", color.Gold, menuHelper.variables.currentPlayerDataVariable("customVariables.shortbladeCount")},
            destinations = {menuHelper.destinations.setDefault(nil,
            { 
				menuHelper.effects.runGlobalFunction("TFN_LevelingPlayer", "InputDialog", 
					{menuHelper.variables.currentPid(), "Shortblade", "Add"})
                })
            }	
		},	
        { caption = {"Longblade : ", color.Gold, menuHelper.variables.currentPlayerDataVariable("customVariables.longbladeCount")},
            destinations = {menuHelper.destinations.setDefault(nil,
            { 
				menuHelper.effects.runGlobalFunction("TFN_LevelingPlayer", "InputDialog", 
					{menuHelper.variables.currentPid(), "Longblade", "Add"})
                })
            }
        },
        { caption = {"Axe : ", color.Gold, menuHelper.variables.currentPlayerDataVariable("customVariables.axeCount")},
            destinations = {menuHelper.destinations.setDefault(nil,
            { 
				menuHelper.effects.runGlobalFunction("TFN_LevelingPlayer", "InputDialog", 
					{menuHelper.variables.currentPid(), "Axe", "Add"})
                })
            }
        },	
        { caption = {"Bluntweapon : ", color.Gold, menuHelper.variables.currentPlayerDataVariable("customVariables.bluntweaponCount")},
            destinations = {menuHelper.destinations.setDefault(nil,
            { 
				menuHelper.effects.runGlobalFunction("TFN_LevelingPlayer", "InputDialog", 
					{menuHelper.variables.currentPid(), "Bluntweapon", "Add"})
                })
            }
        },		
        { caption = {"Spear : ", color.Gold, menuHelper.variables.currentPlayerDataVariable("customVariables.spearCount")},
            destinations = {menuHelper.destinations.setDefault(nil,
            { 
				menuHelper.effects.runGlobalFunction("TFN_LevelingPlayer", "InputDialog", 
					{menuHelper.variables.currentPid(), "Spear", "Add"})
                })
            }
        },		
        { caption = {"Security : ", color.Gold, menuHelper.variables.currentPlayerDataVariable("customVariables.securityCount")},
            destinations = {menuHelper.destinations.setDefault(nil,
            { 
				menuHelper.effects.runGlobalFunction("TFN_LevelingPlayer", "InputDialog", 
					{menuHelper.variables.currentPid(), "Security", "Add"})
                })
            }
		},		
        { caption = {"Athletics : ", color.Gold, menuHelper.variables.currentPlayerDataVariable("customVariables.athleticsCount")},
            destinations = {menuHelper.destinations.setDefault(nil,
            { 
				menuHelper.effects.runGlobalFunction("TFN_LevelingPlayer", "InputDialog", 
					{menuHelper.variables.currentPid(), "Athletics", "Add"})
                })
            }
        },		
        { caption = {"Marksman : ", color.Gold, menuHelper.variables.currentPlayerDataVariable("customVariables.marksmanCount")},
            destinations = {menuHelper.destinations.setDefault(nil,
            { 
				menuHelper.effects.runGlobalFunction("TFN_LevelingPlayer", "InputDialog", 
					{menuHelper.variables.currentPid(), "Marksman", "Add"})
                })
            }
		},
        { caption = {"Acrobatics : ", color.Gold, menuHelper.variables.currentPlayerDataVariable("customVariables.acrobaticsCount")},
            destinations = {menuHelper.destinations.setDefault(nil,
            { 
				menuHelper.effects.runGlobalFunction("TFN_LevelingPlayer", "InputDialog", 
					{menuHelper.variables.currentPid(), "Acrobatics", "Add"})
                })
            }	
		},
        { caption = {"Sneak : ", color.Gold, menuHelper.variables.currentPlayerDataVariable("customVariables.sneakCount")},
            destinations = {menuHelper.destinations.setDefault(nil,
            { 
				menuHelper.effects.runGlobalFunction("TFN_LevelingPlayer", "InputDialog", 
					{menuHelper.variables.currentPid(), "Sneak", "Add"})
                })
            }
        },	
        { caption = {"Mercantile : ", color.Gold, menuHelper.variables.currentPlayerDataVariable("customVariables.mercantileCount")},
            destinations = {menuHelper.destinations.setDefault(nil,
            { 
				menuHelper.effects.runGlobalFunction("TFN_LevelingPlayer", "InputDialog", 
					{menuHelper.variables.currentPid(), "Mercantile", "Add"})
                })
            }
		},		
        { caption = {"Unarmored : ", color.Gold, menuHelper.variables.currentPlayerDataVariable("customVariables.unarmoredCount")},
            destinations = {menuHelper.destinations.setDefault(nil,
            { 
				menuHelper.effects.runGlobalFunction("TFN_LevelingPlayer", "InputDialog", 
					{menuHelper.variables.currentPid(), "Unarmored", "Add"})
                })
            }
        },
        { caption = "Decreases",
            destinations = {menuHelper.destinations.setDefault("menu cmp mag3")
            }
        },			
        { caption = "Page 2",
            destinations = {menuHelper.destinations.setDefault("menu cmp mag2")
            }
        },						
        { caption = "Exit", destinations = nil }
    }
}

Menus["menu cmp mag3"] = {
	text = {color.Orange .. "DECREASE TALENT page 1\n",
		color.Yellow .. "\nskill points : " .. color.White,
		menuHelper.variables.currentPlayerDataVariable("customVariables.pointSoul"),
		"\n\n",
		color.White .. "\nSelect a talent from the list" .. color.Yellow,
		"\ndecreases the talent of :" .. color.Green,
		" - 1" .. color.White,
		" point.\n" .. color.Yellow,
		color.Yellow .. "\nGain : ",
		color.White .. "1 skill point.\n",
		color.Yellow .. "\nCost : "
	},
    buttons = {	
        { caption = {"Handtohand : ", color.Gold, menuHelper.variables.currentPlayerDataVariable("customVariables.handtohandCount")}, 
            destinations = {menuHelper.destinations.setDefault(nil,
            { 
				menuHelper.effects.runGlobalFunction("TFN_LevelingPlayer", "InputDialog", 
					{menuHelper.variables.currentPid(), "Handtohand", "Remove"})
                })
            }
        },	
        { caption = {"Shortblade : ", color.Gold, menuHelper.variables.currentPlayerDataVariable("customVariables.shortbladeCount")},
            destinations = {menuHelper.destinations.setDefault(nil,
            { 
				menuHelper.effects.runGlobalFunction("TFN_LevelingPlayer", "InputDialog", 
					{menuHelper.variables.currentPid(), "Shortblade", "Remove"})
                })
            }	
		},	
        { caption = {"Longblade : ", color.Gold, menuHelper.variables.currentPlayerDataVariable("customVariables.longbladeCount")},
            destinations = {menuHelper.destinations.setDefault(nil,
            { 
				menuHelper.effects.runGlobalFunction("TFN_LevelingPlayer", "InputDialog", 
					{menuHelper.variables.currentPid(), "Longblade", "Remove"})
                })
            }
        },
        { caption = {"Axe : ", color.Gold, menuHelper.variables.currentPlayerDataVariable("customVariables.axeCount")},
            destinations = {menuHelper.destinations.setDefault(nil,
            { 
				menuHelper.effects.runGlobalFunction("TFN_LevelingPlayer", "InputDialog", 
					{menuHelper.variables.currentPid(), "Axe", "Remove"})
                })
            }
        },	
        { caption = {"Bluntweapon : ", color.Gold, menuHelper.variables.currentPlayerDataVariable("customVariables.bluntweaponCount")},
            destinations = {menuHelper.destinations.setDefault(nil,
            { 
				menuHelper.effects.runGlobalFunction("TFN_LevelingPlayer", "InputDialog", 
					{menuHelper.variables.currentPid(), "Bluntweapon", "Remove"})
                })
            }
        },		
        { caption = {"Spear : ", color.Gold, menuHelper.variables.currentPlayerDataVariable("customVariables.spearCount")},
            destinations = {menuHelper.destinations.setDefault(nil,
            { 
				menuHelper.effects.runGlobalFunction("TFN_LevelingPlayer", "InputDialog", 
					{menuHelper.variables.currentPid(), "Spear", "Remove"})
                })
            }
        },		
        { caption = {"Security : ", color.Gold, menuHelper.variables.currentPlayerDataVariable("customVariables.securityCount")},
            destinations = {menuHelper.destinations.setDefault(nil,
            { 
				menuHelper.effects.runGlobalFunction("TFN_LevelingPlayer", "InputDialog", 
					{menuHelper.variables.currentPid(), "Security", "Remove"})
                })
            }
		},		
        { caption = {"Athletics : ", color.Gold, menuHelper.variables.currentPlayerDataVariable("customVariables.athleticsCount")},
            destinations = {menuHelper.destinations.setDefault(nil,
            { 
				menuHelper.effects.runGlobalFunction("TFN_LevelingPlayer", "InputDialog", 
					{menuHelper.variables.currentPid(), "Athletics", "Remove"})
                })
            }
        },		
        { caption = {"Marksman : ", color.Gold, menuHelper.variables.currentPlayerDataVariable("customVariables.marksmanCount")},
            destinations = {menuHelper.destinations.setDefault(nil,
            { 
				menuHelper.effects.runGlobalFunction("TFN_LevelingPlayer", "InputDialog", 
					{menuHelper.variables.currentPid(), "Marksman", "Remove"})
                })
            }
		},
        { caption = {"Acrobatics : ", color.Gold, menuHelper.variables.currentPlayerDataVariable("customVariables.acrobaticsCount")},
            destinations = {menuHelper.destinations.setDefault(nil,
            { 
				menuHelper.effects.runGlobalFunction("TFN_LevelingPlayer", "InputDialog", 
					{menuHelper.variables.currentPid(), "Acrobatics", "Remove"})
                })
            }	
		},
        { caption = {"Sneak : ", color.Gold, menuHelper.variables.currentPlayerDataVariable("customVariables.sneakCount")},
            destinations = {menuHelper.destinations.setDefault(nil,
            { 
				menuHelper.effects.runGlobalFunction("TFN_LevelingPlayer", "InputDialog", 
					{menuHelper.variables.currentPid(), "Sneak", "Remove"})
                })
            }
        },	
        { caption = {"Mercantile : ", color.Gold, menuHelper.variables.currentPlayerDataVariable("customVariables.mercantileCount")},
            destinations = {menuHelper.destinations.setDefault(nil,
            { 
				menuHelper.effects.runGlobalFunction("TFN_LevelingPlayer", "InputDialog", 
					{menuHelper.variables.currentPid(), "Mercantile", "Remove"})
                })
            }
		},		
        { caption = {"Unarmored : ", color.Gold, menuHelper.variables.currentPlayerDataVariable("customVariables.unarmoredCount")},
            destinations = {menuHelper.destinations.setDefault(nil,
            { 
				menuHelper.effects.runGlobalFunction("TFN_LevelingPlayer", "InputDialog", 
					{menuHelper.variables.currentPid(), "Unarmored", "Remove"})
                })
            }
        },
        { caption = "Increase",
            destinations = {menuHelper.destinations.setDefault("menu cmp mag")
            }
        },			
        { caption = "Page 2",
            destinations = {menuHelper.destinations.setDefault("menu cmp mag4")
            }
        },						
        { caption = "Exit", destinations = nil }
    }
}

Menus["menu cmp mag2"] = {
	text = {color.Orange .. "INCREASE TALENT page 2\n",
		color.Yellow .. "\nskill points : " .. color.White,
		menuHelper.variables.currentPlayerDataVariable("customVariables.pointSoul"),
		"\n\n",
		color.White .. "\nSelect a talent from the list" .. color.Yellow,
		"\nincreases the talent of :" .. color.Green,
		" + 1" .. color.White,
		" point.\n" .. color.Yellow,
		color.Yellow .. "\nCost : ",
		color.White .. "1 skill point.\n"
	},
    buttons = {		
        { caption = {"Lightarmor : ", color.Gold, menuHelper.variables.currentPlayerDataVariable("customVariables.lightarmorCount")},
            destinations = {menuHelper.destinations.setDefault(nil,
            { 
				menuHelper.effects.runGlobalFunction("TFN_LevelingPlayer", "InputDialog", 
					{menuHelper.variables.currentPid(), "Lightarmor", "Add"})
                })
            }	
		},
        { caption = {"Mediumarmor : ", color.Gold, menuHelper.variables.currentPlayerDataVariable("customVariables.mediumarmorCount")},
            destinations = {menuHelper.destinations.setDefault(nil,
            { 
				menuHelper.effects.runGlobalFunction("TFN_LevelingPlayer", "InputDialog", 
					{menuHelper.variables.currentPid(), "Mediumarmor", "Add"})
                })
            }
		},
        { caption = {"Heavyarmor : ", color.Gold, menuHelper.variables.currentPlayerDataVariable("customVariables.heavyarmorCount")},
            destinations = {menuHelper.destinations.setDefault(nil,
            { 
				menuHelper.effects.runGlobalFunction("TFN_LevelingPlayer", "InputDialog", 
					{menuHelper.variables.currentPid(), "Heavyarmor", "Add"})
                })
            }	
		},
        { caption = {"Block : ", color.Gold, menuHelper.variables.currentPlayerDataVariable("customVariables.blockCount")},
            destinations = {menuHelper.destinations.setDefault(nil,
            { 
				menuHelper.effects.runGlobalFunction("TFN_LevelingPlayer", "InputDialog", 
					{menuHelper.variables.currentPid(), "Block", "Add"})
                })
            }
		},		
        { caption = {"Armorer : ", color.Gold, menuHelper.variables.currentPlayerDataVariable("customVariables.armorerCount")},
            destinations = {menuHelper.destinations.setDefault(nil,
            { 
				menuHelper.effects.runGlobalFunction("TFN_LevelingPlayer", "InputDialog", 
					{menuHelper.variables.currentPid(), "Armorer", "Add"})
                })
            }
		},
        { caption = {"Speechcraft : ", color.Gold, menuHelper.variables.currentPlayerDataVariable("customVariables.speechcraftCount")},
            destinations = {menuHelper.destinations.setDefault(nil,
            { 
				menuHelper.effects.runGlobalFunction("TFN_LevelingPlayer", "InputDialog", 
					{menuHelper.variables.currentPid(), "Speechcraft", "Add"})
                })
            }	
		},
        { caption = {"Enchant : ", color.Gold, menuHelper.variables.currentPlayerDataVariable("customVariables.enchantCount")},
            destinations = {menuHelper.destinations.setDefault(nil,
            { 
				menuHelper.effects.runGlobalFunction("TFN_LevelingPlayer", "InputDialog", 
					{menuHelper.variables.currentPid(), "Enchant", "Add"})
                })
            }	
		},
        { caption = {"Destruction : ", color.Gold, menuHelper.variables.currentPlayerDataVariable("customVariables.destructionCount")},
            destinations = {menuHelper.destinations.setDefault(nil,
            { 
				menuHelper.effects.runGlobalFunction("TFN_LevelingPlayer", "InputDialog", 
					{menuHelper.variables.currentPid(), "Destruction", "Add"})
                })
            }
        },
        { caption = {"Conjuration : ", color.Gold, menuHelper.variables.currentPlayerDataVariable("customVariables.conjurationCount")},
            destinations = {menuHelper.destinations.setDefault(nil,
            { 
				menuHelper.effects.runGlobalFunction("TFN_LevelingPlayer", "InputDialog", 
					{menuHelper.variables.currentPid(), "Conjuration", "Add"})
                })
            }
		},		
        { caption = {"Illusion : ", color.Gold, menuHelper.variables.currentPlayerDataVariable("customVariables.illusionCount")},
            destinations = {menuHelper.destinations.setDefault(nil,
            { 
				menuHelper.effects.runGlobalFunction("TFN_LevelingPlayer", "InputDialog", 
					{menuHelper.variables.currentPid(), "Illusion", "Add"})
                })
            }
		},
        { caption = {"Alteration : ", color.Gold, menuHelper.variables.currentPlayerDataVariable("customVariables.alterationCount")},
            destinations = {menuHelper.destinations.setDefault(nil,
            { 
				menuHelper.effects.runGlobalFunction("TFN_LevelingPlayer", "InputDialog", 
					{menuHelper.variables.currentPid(), "Alteration", "Add"})
                })
            }
        },		
        { caption = {"Mysticism : ", color.Gold, menuHelper.variables.currentPlayerDataVariable("customVariables.mysticismCount")},
            destinations = {menuHelper.destinations.setDefault(nil,
            { 
				menuHelper.effects.runGlobalFunction("TFN_LevelingPlayer", "InputDialog", 
					{menuHelper.variables.currentPid(), "Mysticism", "Add"})
                })
            }	
		},
        { caption = {"Restoration : ", color.Gold, menuHelper.variables.currentPlayerDataVariable("customVariables.restorationCount")},
            destinations = {menuHelper.destinations.setDefault(nil,
            { 
				menuHelper.effects.runGlobalFunction("TFN_LevelingPlayer", "InputDialog", 
					{menuHelper.variables.currentPid(), "Restoration", "Add"})
                })
            }	
		},
        { caption = {"Alchemy : ", color.Gold, menuHelper.variables.currentPlayerDataVariable("customVariables.alchemyCount")},
            destinations = {menuHelper.destinations.setDefault(nil,
            { 
				menuHelper.effects.runGlobalFunction("TFN_LevelingPlayer", "InputDialog", 
					{menuHelper.variables.currentPid(), "Alchemy", "Add"})
                })
            }	
		},
        { caption = "Discrease",
            destinations = {menuHelper.destinations.setDefault("menu cmp mag4")
            }
        },		
        { caption = "Page 1",
            destinations = {menuHelper.destinations.setDefault("menu cmp mag")
            }
        },					
        { caption = "Exit", destinations = nil }
    }
}

Menus["menu cmp mag4"] = {
	text = {color.Orange .. "DECREASE TALENT page 2\n",	
		color.Yellow .. "\nskill points : " .. color.White,
		menuHelper.variables.currentPlayerDataVariable("customVariables.pointSoul"),
		"\n\n",
		color.White .. "\nSelect a talent from the list" .. color.Yellow,
		"\ndecreases the talent of :" .. color.Green,
		" - 1" .. color.White,
		" points.\n" .. color.Yellow,
		color.Yellow .. "\nGain : ",
		color.White .. "1 skill point.\n"
	},
    buttons = {		
        { caption = {"Lightarmor : ", color.Gold, menuHelper.variables.currentPlayerDataVariable("customVariables.lightarmorCount")},
            destinations = {menuHelper.destinations.setDefault(nil,
            { 
				menuHelper.effects.runGlobalFunction("TFN_LevelingPlayer", "InputDialog", 
					{menuHelper.variables.currentPid(), "Lightarmor", "Remove"})
                })
            }	
		},
        { caption = {"Mediumarmor : ", color.Gold, menuHelper.variables.currentPlayerDataVariable("customVariables.mediumarmorCount")},
            destinations = {menuHelper.destinations.setDefault(nil,
            { 
				menuHelper.effects.runGlobalFunction("TFN_LevelingPlayer", "InputDialog", 
					{menuHelper.variables.currentPid(), "Mediumarmor", "Remove"})
                })
            }
		},
        { caption = {"Heavyarmor : ", color.Gold, menuHelper.variables.currentPlayerDataVariable("customVariables.heavyarmorCount")},
            destinations = {menuHelper.destinations.setDefault(nil,
            { 
				menuHelper.effects.runGlobalFunction("TFN_LevelingPlayer", "InputDialog", 
					{menuHelper.variables.currentPid(), "Heavyarmor", "Remove"})
                })
            }	
		},
        { caption = {"Block : ", color.Gold, menuHelper.variables.currentPlayerDataVariable("customVariables.blockCount")},
            destinations = {menuHelper.destinations.setDefault(nil,
            { 
				menuHelper.effects.runGlobalFunction("TFN_LevelingPlayer", "InputDialog", 
					{menuHelper.variables.currentPid(), "Block", "Remove"})
                })
            }
		},		
        { caption = {"Armorer : ", color.Gold, menuHelper.variables.currentPlayerDataVariable("customVariables.armorerCount")},
            destinations = {menuHelper.destinations.setDefault(nil,
            { 
				menuHelper.effects.runGlobalFunction("TFN_LevelingPlayer", "InputDialog", 
					{menuHelper.variables.currentPid(), "Armorer", "Remove"})
                })
            }
		},
        { caption = {"Speechcraft : ", color.Gold, menuHelper.variables.currentPlayerDataVariable("customVariables.speechcraftCount")},
            destinations = {menuHelper.destinations.setDefault(nil,
            { 
				menuHelper.effects.runGlobalFunction("TFN_LevelingPlayer", "InputDialog", 
					{menuHelper.variables.currentPid(), "Speechcraft", "Remove"})
                })
            }	
		},
        { caption = {"Enchant : ", color.Gold, menuHelper.variables.currentPlayerDataVariable("customVariables.enchantCount")},
            destinations = {menuHelper.destinations.setDefault(nil,
            { 
				menuHelper.effects.runGlobalFunction("TFN_LevelingPlayer", "InputDialog", 
					{menuHelper.variables.currentPid(), "Enchant", "Remove"})
                })
            }	
		},
        { caption = {"Destruction : ", color.Gold, menuHelper.variables.currentPlayerDataVariable("customVariables.destructionCount")},
            destinations = {menuHelper.destinations.setDefault(nil,
            { 
				menuHelper.effects.runGlobalFunction("TFN_LevelingPlayer", "InputDialog", 
					{menuHelper.variables.currentPid(), "Destruction", "Remove"})
                })
            }
        },
        { caption = {"Conjuration : ", color.Gold, menuHelper.variables.currentPlayerDataVariable("customVariables.conjurationCount")},
            destinations = {menuHelper.destinations.setDefault(nil,
            { 
				menuHelper.effects.runGlobalFunction("TFN_LevelingPlayer", "InputDialog", 
					{menuHelper.variables.currentPid(), "Conjuration", "Remove"})
                })
            }
		},		
        { caption = {"Illusion : ", color.Gold, menuHelper.variables.currentPlayerDataVariable("customVariables.illusionCount")},
            destinations = {menuHelper.destinations.setDefault(nil,
            { 
				menuHelper.effects.runGlobalFunction("TFN_LevelingPlayer", "InputDialog", 
					{menuHelper.variables.currentPid(), "Illusion", "Remove"})
                })
            }
		},
        { caption = {"Alteration : ", color.Gold, menuHelper.variables.currentPlayerDataVariable("customVariables.alterationCount")},
            destinations = {menuHelper.destinations.setDefault(nil,
            { 
				menuHelper.effects.runGlobalFunction("TFN_LevelingPlayer", "InputDialog", 
					{menuHelper.variables.currentPid(), "Alteration", "Remove"})
                })
            }
        },		
        { caption = {"Mysticism : ", color.Gold, menuHelper.variables.currentPlayerDataVariable("customVariables.mysticismCount")},
            destinations = {menuHelper.destinations.setDefault(nil,
            { 
				menuHelper.effects.runGlobalFunction("TFN_LevelingPlayer", "InputDialog", 
					{menuHelper.variables.currentPid(), "Mysticism", "Remove"})
                })
            }	
		},
        { caption = {"Restoration : ", color.Gold, menuHelper.variables.currentPlayerDataVariable("customVariables.restorationCount")},
            destinations = {menuHelper.destinations.setDefault(nil,
            { 
				menuHelper.effects.runGlobalFunction("TFN_LevelingPlayer", "InputDialog", 
					{menuHelper.variables.currentPid(), "Restoration", "Remove"})
                })
            }	
		},
        { caption = {"Alchemy : ", color.Gold, menuHelper.variables.currentPlayerDataVariable("customVariables.alchemyCount")},
            destinations = {menuHelper.destinations.setDefault(nil,
            { 
				menuHelper.effects.runGlobalFunction("TFN_LevelingPlayer", "InputDialog", 
					{menuHelper.variables.currentPid(), "Alchemy", "Remove"})
                })
            }	
		},
        { caption = "Increase",
            destinations = {menuHelper.destinations.setDefault("menu cmp mag2")
            }
        },		
        { caption = "Page 1",
            destinations = {menuHelper.destinations.setDefault("menu cmp mag3")
            }
        },					
        { caption = "Exit", destinations = nil }
    }
}
