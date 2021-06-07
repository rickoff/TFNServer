Menus["resurrect player"] = {
    text = color.White .. "Do you want to" .. color.Gold ..
    "help\n" .. color.White .. "this person?",
    buttons = {						
        { caption = "Patch them up.",
            destinations = {menuHelper.destinations.setDefault(nil,
            { 
				menuHelper.effects.runGlobalFunction("GameplayAdvance", "ResurrectPlayer", 
					{menuHelper.variables.currentPlayerDataVariable("targetPid")})
                })
            }
        },			
        { caption = "Leave them there.", destinations = nil }
    }
}

Menus["resurrectvamp"] = {
    text = color.Red .. "You are unconcious.\n" .. color.White .. "You can wait for another player\n"
    "or respawn at the nearest temple.",
    buttons = {						
       { caption = "Respawn",
            destinations = {menuHelper.destinations.setDefault(nil,
            { 
				menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/resurrectvamp"})
                })
            }
        },			
        { caption = "Wait", destinations = nil }
    }
}

Menus["resurrect"] = {
    text = color.Red .. "You are unconcious.\n" .. color.White .. "You can wait for another player\n"
    "or respawn at the nearest temple.",
    buttons = {						
        { caption = "Respawn",
            destinations = {menuHelper.destinations.setDefault(nil,
            { 
				menuHelper.effects.runGlobalFunction(nil, "OnPlayerSendMessage",
					{menuHelper.variables.currentPid(), "/resurrect"})
                })
            }
        },			
        { caption = "Wait", destinations = nil }
    }
}
