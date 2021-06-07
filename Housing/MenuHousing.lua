Menus ["menu housing"] = {
text = {color.Orange.."HOUSING MENU",
color.Yellow .. "\n\n[Homes/Shops]",
color.White .. "\nAllows you to see a list of homes/shops\navailable for purchase.",
color.Yellow .. "\n\n[My Homes]",
color.White .. "\nOpens your house menu.",
color.Yellow .. "\n\n[Shared Homes]",
color.White .. "\nOpens the shared homes menu, for houses\nyou may not own, but live together in.",
color.Yellow .. "\n\n [Furniture Store]",
color.White .. "\nOpens the furniture store menu.",
color.Yellow .. "\n\n [Decorate Mode]",
color.White .. "\nOpens the furniture and decoration editor.",
color.Yellow .. "\n\n [Mannequins]",
color.White .. "\nAllows you to purchase mannequins to\ndisplay your items.\n"
},
    buttons = {
        {caption = "Homes/Shops",
destinations = {menuHelper.destinations.setDefault (nil,
{
menuHelper.effects.runGlobalFunction (nil, "OnPlayerSendMessage",
{menuHelper.variables.currentPid (), "/catalog"})
})
}
        },
        {caption = "My Homes",
destinations = {menuHelper.destinations.setDefault (nil,
{
menuHelper.effects.runGlobalFunction (nil, "OnPlayerSendMessage",
{menuHelper.variables.currentPid (), "/myhouse"})
})
}
        },
        {caption = "Shared Homes",
destinations = {menuHelper.destinations.setDefault (nil,
{
menuHelper.effects.runGlobalFunction (nil, "OnPlayerSendMessage",
{menuHelper.variables.currentPid (), "/roomate"})
})
}
        },
        {caption = "Furniture Store",
destinations = {menuHelper.destinations.setDefault (nil,
{
menuHelper.effects.runGlobalFunction (nil, "OnPlayerSendMessage",
{menuHelper.variables.currentPid (), "/mag"})
})
}
        },
        {caption = "Decorate Mode",
destinations = {menuHelper.destinations.setDefault (nil,
{
menuHelper.effects.runGlobalFunction (nil, "OnPlayerSendMessage",
{menuHelper.variables.currentPid (), "/dh"})
})
}
        },
        {caption = "Mannequins",
destinations = {menuHelper.destinations.setDefault (nil,
{
menuHelper.effects.runGlobalFunction (nil, "OnPlayerSendMessage",
{menuHelper.variables.currentPid (), "/mannequins"})
})
}
        },
        {caption = "Exit", destinations = nil}
    }
}

Menus ["menu prison house"] = {
	text = {
color.Red .. "WARNING!",
color.White .. "\nYou have attempted to bypass the anti-steal measures\nto steal from another player's home.",
color.White .. "\n\nThe object has been disabled for the remainder of your session.",
color.Red .. "\nTo make it re-appear, please reconnect.",
color.Yellow .. "\n\nIf you are attempting to help decorate,\nmake sure the owner adds you as a 'roommate'.",
color.Red .. "\n\nIf you attempt to bypass the measures again, moderators will be notified.",
color.White .. "\nDo you agree to" .. color.Red .. "NOT" .. color.White .. "reproduce this action?"
},
    buttons = {
        {caption = "Agree.",
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
        {caption = "No.",
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
