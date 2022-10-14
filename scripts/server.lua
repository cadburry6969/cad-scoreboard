local QBCore = exports[Config.Core]:GetCoreObject()

-- \ Debug
function Debug(a, b)
    if Config.Debug then
        print("["..a.."] "..b)
    end
end

-- \ Get Identifier of a person
function GetIdentifier(src)
    local pidentifier = QBCore.Functions.GetIdentifier(src, Config.UseIdentifier)
    if not pidentifier and not Config.EnableCharacterName then
        local ply = QBCore.Functions.GetPlayer(src)
        return ply.PlayerData.citizenid
    elseif pidentifier and not Config.EnableCharacterName then
        return pidentifier
    elseif pidentifier and Config.EnableCharacterName then
        local ply = QBCore.Functions.GetPlayer(src)
        local name = GetPlayerName(src).." | "..tostring(ply.PlayerData.charinfo.firstname.." "..ply.PlayerData.charinfo.lastname)
        return name
    elseif not pidentifier and Config.EnableCharacterName then
        local ply = QBCore.Functions.GetPlayer(src)
        local name = tostring(ply.PlayerData.charinfo.firstname.." "..ply.PlayerData.charinfo.lastname)
        return name
    end
    return nil
end

-- \ Add all other players to a persons scoreboard
function AddAllPlayers(self)
    local xPlayers = QBCore.Functions.GetPlayers()
    for i=1, #xPlayers, 1 do
        if xPlayers[i] then
            local pidentifier = GetIdentifier(xPlayers[i])
            if pidentifier then
                local data = { src = xPlayers[i], identifier = pidentifier}
                TriggerClientEvent("scoreboard:AddAllPlayers", source, data, recentData)
                Debug("Multiple", "Player ["..GetPlayerName(xPlayers[i]).."] "..pidentifier.." added to playerlist")
            end
        end
    end
end

-- \ Add your info to other players scoreboard
RegisterNetEvent('scoreboard:AddPlayer', function()
    local pidentifier = GetIdentifier(source)
    if pidentifier then
        local data = { src = source, identifier = pidentifier}
        TriggerClientEvent("scoreboard:AddPlayer", -1, data)
        Debug("Single", "Player ["..GetPlayerName(source).."] "..pidentifier.." added to playerlist")
        AddAllPlayers()
    end
end)

-- \ Remove your info from other players scoreboard
AddEventHandler("playerDropped", function()
    local pidentifier = GetIdentifier(source)
    if pidentifier then
        local data = { src = source, identifier = pidentifier}
        TriggerClientEvent("scoreboard:RemovePlayer", -1, data)
        Debug("Single", "Player ["..GetPlayerName(source).."] "..pidentifier.." disconnected")
    end
end)

-- \ Get total players count
QBCore.Functions.CreateCallback('scoreboard:GetTotalPlayers', function(_, cb)
    local total = 0
    for _, v in pairs(GetPlayers()) do
        total += 1
    end
    cb(total)
end)