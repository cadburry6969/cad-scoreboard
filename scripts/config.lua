Config = {}

Config.Debug = false -- true - enable debug mode | false - disable debug mode
Config.Core = "qb-core" -- name of the core object
Config.OpenKey = 'U' -- Open playerlist key https://docs.fivem.net/docs/game-references/input-mapper-parameter-ids/keyboard/
Config.CloseInstantly = false -- If this is false the scoreboard stays open only when you hold the OpenKey button, if this is true the scoreboard will be openned and closed with the OpenKey button
Config.MaxPlayers = GetConvarInt('sv_maxclients', 48) -- It returns 48 if it cant find the Convar Int
Config.SteamCompulsory = false -- Steam is Compulsory for scoreboard? [if false then citizenid will be main identifier]
Config.EnableIDAboveHead = true -- Display id above head