local QBCore = exports[Config.Core]:GetCoreObject()

function Debug(a, b)
    if Config.Debug then
        print("["..a.."] "..b)
    end
end

function AddAllPlayers(self)
    local xPlayers = QBCore.Functions.GetPlayers()
    for i=1, #xPlayers, 1 do       
        if xPlayers[i] then
            local pidentifier = QBCore.Functions.GetIdentifier(xPlayers[i], "steam")     
            local Player = QBCore.Functions.GetPlayer(xPlayers[i])
            local pCid = Player.PlayerData.citizenid                      
            if pidentifier == nil then pidentifier = pCid end
            local data = { src = xPlayers[i], identifier = pidentifier}            
            TriggerClientEvent("scoreboard:AddAllPlayers", source, data, recentData)
            Debug("Multiple", "Player ["..GetPlayerName(xPlayers[i]).."] "..pidentifier.." added to playerlist")
        end
    end
end

RegisterNetEvent('scoreboard:AddPlayer', function()
    local pidentifier = QBCore.Functions.GetIdentifier(source, "steam")     
    local Player = QBCore.Functions.GetPlayer(source)
    if Player then
        local pCid = Player.PlayerData.citizenid        
        if pidentifier == nil then pidentifier = pCid end            
        local data = { src = source, identifier = pidentifier}        
        TriggerClientEvent("scoreboard:AddPlayer", -1, data)
        Debug("Single", "Player ["..GetPlayerName(source).."] "..pidentifier.." added to playerlist")
        AddAllPlayers()
    end
end)

AddEventHandler("playerDropped", function()
    local pidentifier = QBCore.Functions.GetIdentifier(source, "steam")       
    local Player = QBCore.Functions.GetPlayer(source)
    if Player then
        local pCid = Player.PlayerData.citizenid                      
        if pidentifier == nil then pidentifier = pCid end
        local data = { src = source, identifier = pidentifier}        
        TriggerClientEvent("scoreboard:RemovePlayer", -1, data)
        Debug("Single", "Player ["..GetPlayerName(source).."] "..pidentifier.." disconnected")
    end
end)

QBCore.Functions.CreateCallback('scoreboard:GetTotalPlayers', function(_, cb)
    local total = 0
    for _, v in pairs(QBCore.Functions.GetQBPlayers()) do
        if v then
            total += 1
        end
    end
    cb(total)
end)

if Config.SteamCompulsory then    

local function OnPlayerConnecting(name, setKickReason, deferrals)
    local player = source
    local steamIdentifier
    local identifiers = GetPlayerIdentifiers(player)
    deferrals.defer()
    Wait(0)
    deferrals.update(string.format("Validating Steam [%s]", name))
    for _, v in pairs(identifiers) do
        if string.find(v, "steam") then
            steamIdentifier = v
            break
        end
    end
    Wait(0)
    if not steamIdentifier then
        Debug("Single", "Player ["..GetPlayerName(source).."] "..steamIdentifier.." could not connect as steam identifier was not found")
        deferrals.done("You are not connected to Steam.")
    else
        Debug("Single", "Player ["..GetPlayerName(source).."] "..steamIdentifier.." connected")
        deferrals.done()
    end
end

AddEventHandler("playerConnecting", OnPlayerConnecting)

end