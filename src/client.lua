---@diagnostic disable-next-line: deprecated
Tunnel = module("vrp","lib/Tunnel")
---@diagnostic disable-next-line: deprecated
Proxy = module("vrp", "lib/Proxy")
---@diagnostic disable-next-line: undefined-field
vRP = Proxy.getInterface("vRP")

src = {}
---@diagnostic disable-next-line: undefined-field
Tunnel.bindInterface(GetCurrentResourceName(), src)
---@diagnostic disable-next-line: undefined-field
vSERVER = Tunnel.getInterface(GetCurrentResourceName())

local objectsSpawners = {}
local objectsCooldowns = {}

function src:spawnObjects()
    for _, location in ipairs(Config.objectsCoords) do
        local hashObject = GetHashKey('prop_veg_crop_03_pump')

        RequestModel(hashObject)

        while not HasModelLoaded(hashObject) do
            Wait(0)
        end

        local object = CreateObject(hashObject, location[1], location[2], location[3] -1 , true, true, true)

        FreezeEntityPosition(object, true)

        table.insert(objectsSpawners, object)
        objectsCooldowns[object] = 0
    end
end

RegisterCommand("limpar", function()
    for _, prop in ipairs(objectsSpawners) do
        DeleteEntity(prop)
        print(prop)
    end
end, false)

function src:text3D(x,y,z,text)
    local onScreen,_x,_y = GetScreenCoordFromWorldCoord(x,y,z)

    if onScreen then
        BeginTextCommandDisplayText("STRING")
        AddTextComponentSubstringKeyboardDisplay(text)
        SetTextColour(255,255,255,150)
        SetTextScale(0.35,0.35)
        SetTextFont(4)
        SetTextCentre(1)
        EndTextCommandDisplayText(_x,_y)

        local width = (string.len(text) + 4) / 170 * 0.45
        DrawRect(_x,_y + 0.0125,width,0.03,38,42,56,200)
    end
end

function src:playAnim()
    
    local ped = PlayerPedId()
    local animDict = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@'
    RequestAnimDict(animDict)

    while not HasAnimDictLoaded(animDict) do
        Wait(0)
    end

    local anim = TaskPlayAnim(ped, animDict, 'machinic_loop_mechandplayer', 8.0, 5.0, 5000, 1, 1.0, false, false, false)
end

Citizen.CreateThread(function()
    src:spawnObjects()
    while true do
        src:checkCooldown()
        Wait(1000)
    end
end)

Citizen.CreateThread(function()
    while true do
        local sleep = 1000
        local ped = PlayerPedId()
        local pedCoords = GetEntityCoords(ped)
        for _, object in ipairs(objectsSpawners) do
            local objectsCoords = GetEntityCoords(object)
            local distance = #(pedCoords - objectsCoords)
            if distance < 3 then
                sleep = 0
                if objectsCooldowns[object] <= 0 then
                    src:text3D(objectsCoords.x, objectsCoords.y, objectsCoords.z, "Pressione [E] para interagir")
                    if IsControlJustPressed(0, 38) then
                        src:playAnim()
                        Wait(5000)
                        vSERVER.giveItem()
                        objectsCooldowns[object] = Config.objectsTime * 60000
                    end
                else
                     objectsCooldowns[object] = objectsCooldowns[object] - 1
                end
            end
        end

        Citizen.Wait(sleep)
    end
end)