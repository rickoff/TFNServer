Menus["resurrect player"] = {
    text = color.Gold .. "Do you want to\n" .. color.LightGreen ..
    "resurrect\n" .. color.Gold .. "this player ?\n" ..
        color.White .. "...",
    buttons = {						
        { caption = "yes",
            destinations = {menuHelper.destinations.setDefault(nil,
            { 
				menuHelper.effects.runGlobalFunction("GameplayAdvance", "ResurrectPlayer", 
					{menuHelper.variables.currentPlayerDataVariable("targetPid")})
                })
            }
        },			
        { caption = "no", destinations = nil }
    }
}

Menus["resurrectvamp"] = {
    text = color.Gold .. "You are dead !!!\n" .. color.LightGreen ..
    "you have to\n" .. color.Gold .. "wait for a player\n" ..
        color.White .. "...",
    buttons = {						
       { caption = "resurrect",
            destinations = {menuHelper.destinations.setDefault(nil,
            { 
				menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/resurrectvamp"})
                })
            }
        },			
        { caption = "wait", destinations = nil }
    }
}

Menus["resurrect"] = {
    text = color.Gold .. "You are dead !!!\n" .. color.LightGreen ..
    "you have to\n" .. color.Gold .. "wait for a player\n" ..
        color.White .. "...",
    buttons = {						
        { caption = "resurrect",
            destinations = {menuHelper.destinations.setDefault(nil,
            { 
				menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/resurrect"})
                })
            }
        },			
        { caption = "wait", destinations = nil }
    }
}
