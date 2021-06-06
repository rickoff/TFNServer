Menus ["menu housing"] = {
text = {color.Orange.."HOUSING MENU \n",
color.Yellow .. "\n\n[Catalog]",
color.White .. "\nallows you to buy or use your goods",
color.Yellow .. "\n\n [Store]",
color.White .. "\nbuy decorative items",
color.Yellow .. "\n\n [Models]",
color.White .. "\nbuy mannequins",
color.Yellow .. "\n\n [Decoration]",
color.White .. "\ndecorate your space \n"

},
    buttons = {
        {caption = "Catalog",
destinations = {menuHelper.destinations.setDefault (nil,
{
menuHelper.effects.runGlobalFunction (nil, "OnPlayerSendMessage",
{menuHelper.variables.currentPid (), "/catalog"})
})
}
        },
        {caption = "My House",
destinations = {menuHelper.destinations.setDefault (nil,
{
menuHelper.effects.runGlobalFunction (nil, "OnPlayerSendMessage",
{menuHelper.variables.currentPid (), "/myhouse"})
})
}
        },
        {caption = "House Roomate",
destinations = {menuHelper.destinations.setDefault (nil,
{
menuHelper.effects.runGlobalFunction (nil, "OnPlayerSendMessage",
{menuHelper.variables.currentPid (), "/roomate"})
})
}
        },
        {caption = "Store",
destinations = {menuHelper.destinations.setDefault (nil,
{
menuHelper.effects.runGlobalFunction (nil, "OnPlayerSendMessage",
{menuHelper.variables.currentPid (), "/mag"})
})
}
        },
        {caption = "Models",
destinations = {menuHelper.destinations.setDefault (nil,
{
menuHelper.effects.runGlobalFunction (nil, "OnPlayerSendMessage",
{menuHelper.variables.currentPid (), "/mannequins"})
})
}
        },
        {caption = "Decoration",
destinations = {menuHelper.destinations.setDefault (nil,
{
menuHelper.effects.runGlobalFunction (nil, "OnPlayerSendMessage",
{menuHelper.variables.currentPid (), "/dh"})
})
}
        },
        {caption = "Exit", destinations = nil}
    }
}

Menus ["menu prison house"] = {
	text = {
color.Red .. "WARNING !!!",
color.White .. "\n\nYou have just committed a crime against the server.",
color.Red .. "\n\n\nTENTATIVE BY CHEAT !!!",
color.Yellow .. "\n\nA message to was recorded in the server logs to warn moderation",
color.White .. "\n\nBe careful next time",
color.Yellow .. "\n\nObject to was disabled only for you during this game session",
color.White .. "\n\nTo make it reappear you can disconnect and reconnect",
color.Cyan .. "\n\nGood game, fair play and role play.",
color.Red .. "\n\n\nBy continuing you agree not to reproduce this action?"
},
    buttons = {
        {caption = "yes",
            destinations = {
                menuHelper.destinations.setDefault (nil,
                {
                    menuHelper.effects.runGlobalFunction ("TFN_HousingShop", "PunishPrison",
                    {
                        menuHelper.variables.currentPid (), menuHelper.variables.currentPid ()
                    })
                })
            }
        },
        {caption = "no",
            destinations = {
                menuHelper.destinations.setDefault (nil,
                {
                    menuHelper.effects.runGlobalFunction ("TFN_HousingShop", "PunishKick",
                    {
                        menuHelper.variables.currentPid (),
                    })
                })
            }
        }
    }
} 	
