local QBCore = exports[Config.Core]:GetCoreObject()
local IsPlayerListOpen = false
local PlayerList = {}

-- \ Debug
if Config.Debug then
    for i=1 , 25, 1 do
        PlayerList[i] = {src = i, identifier = tostring(QBCore.Shared.RandomStr(3)..QBCore.Shared.RandomInt(5)):upper()}
    end
end

local function Debug(a, b)
    if Config.Debug then
        print("["..a.."] "..b)
    end
end

-- \ Functions
local function TextDraw(data)
    local onScreen, screenX, screenY = World3dToScreen2d(data.coords.x, data.coords.y, data.coords.z)
    if onScreen then
        local camCoords = GetGameplayCamCoords()
        local distance = #(data.coords - camCoords)
        local fov = (1 / GetGameplayCamFov()) * 75
        local scale = (1 / distance) * (4) * fov * (data.fontsize)     
        local r, g, b = data.r, data.b, data.b
        SetTextScale(0.0, scale)
        SetTextFont(data.fontstyle)
        SetTextProportional(true)
        SetTextColour(255, 255, 255, 255)
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(true)
        AddTextComponentString(data.text)
        DrawText(screenX, screenY)
    end
end

local function GetPlayers()
    local players = {}
    local activePlayers = GetActivePlayers()
    for i = 1, #activePlayers do
        local player = activePlayers[i]
        local ped = GetPlayerPed(player)
        if DoesEntityExist(ped) then
            players[#players+1] = player
        end
    end
    return players
end

local function GetPlayersFromCoords(coords, distance)
    local players = GetPlayers()
    local closePlayers = {}

	coords = coords or GetEntityCoords(PlayerPedId())
    distance = distance or  5.0

    for i = 1, #players do
        local player = players[i]
		local target = GetPlayerPed(player)
		local targetCoords = GetEntityCoords(target)
		local targetdistance = #(targetCoords - vector3(coords.x, coords.y, coords.z))
		if targetdistance <= distance then
            closePlayers[#closePlayers+1] = player
		end
    end

    return closePlayers
end

local function ShowID()
    if Config.EnableIDAboveHead then
        local show = true
        while show do
            local sleep = 100
            if IsPlayerListOpen then
                for _, player in pairs(GetPlayersFromCoords(GetEntityCoords(PlayerPedId()), 10.0)) do
                    sleep = 0
                    local playerId = GetPlayerServerId(player)
                    local playerPed = GetPlayerPed(player)
                    local playerCoords = GetEntityCoords(playerPed)                
                    TextDraw({coords = vector3(playerCoords.x, playerCoords.y, playerCoords.z+1.0), fontsize = 0.5, fontstyle = 2, r = 255, g = 255, b = 255, text = playerId})
                end
            else
                show = false
            end
            Wait(sleep)
        end
    end
end

local function InitializeList()
    Wait(1000)
    local list = {}
    for k, v in pairs(PlayerList) do
        list[k] = v.identifier
    end    
    Debug("Single", json.encode(list))
    SendNUIMessage({
        action = "setup",
        items = list
    })
end

-- \ Events
RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()        
    TriggerServerEvent("scoreboard:AddPlayer")
    InitializeList()    
    Debug("Single", "Loaded Playerlist Data")
end)

RegisterNetEvent("scoreboard:RemovePlayer", function(data)
    PlayerList[data.src] = nil
    Debug("Single", "Removed ["..data.src.."] from Playerlist")
end)

RegisterNetEvent("scoreboard:AddPlayer", function(data)
    PlayerList[data.src] = data
    Debug("Single", "Added ["..data.src.."] to Playerlist")
end)

RegisterNetEvent("scoreboard:AddAllPlayers", function(data)    
    PlayerList[data.src] = data 
    Debug("Multiple", "Added ["..data.src.."] to Playerlist")
end)

-- \ Nui callbacks
RegisterNUICallback('closelist', function(_, cb)
    if not IsPlayerListOpen then return end
    SetNuiFocus(false, false)
    SetNuiFocusKeepInput(false)
    SendNUIMessage({
        action = "close",
    })    
    IsPlayerListOpen = false
    Debug("Single", "Closed Playerlist")
    cb('ok')
end)

CreateThread(function()        
	while true do
		Wait(1)
		if NetworkIsSessionStarted() then
            TriggerServerEvent("scoreboard:AddPlayer")            
            InitializeList()
            Debug("Single", "Loaded Playerlist Data")
			return
		end
	end
end)

-- \ Command
RegisterCommand('+scoreboard', function()
    if IsPlayerListOpen then return end
    QBCore.Functions.TriggerCallback('scoreboard:GetTotalPlayers', function(players, playerList)
        SetNuiFocus(true, true)
        SetNuiFocusKeepInput(true)
        SendNUIMessage({
            action = "open",
            players = players,
            maxPlayers = Config.MaxPlayers,
        })

        IsPlayerListOpen = true
        ShowID()
        Debug("Single", "Opened Playerlist")
    end)
end, false)

if Config.CloseInstantly then
    RegisterCommand('-scoreboard', function()
        if not IsPlayerListOpen then return end
        SetNuiFocus(false, false)
        SetNuiFocusKeepInput(false)
        SendNUIMessage({
            action = "close",
        })    
        IsPlayerListOpen = false
        Debug("Single", "Closed Playerlist")
    end, false)
end

RegisterKeyMapping('+scoreboard', 'Open Scoreboard', 'keyboard', Config.OpenKey)