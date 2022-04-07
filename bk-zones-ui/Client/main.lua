local zone = nil
local isIn = false
local disable = false
local areas = {}

sendNotification = function (str)
    SetNotificationTextEntry('STRING')
    AddTextComponentString(str)
    DrawNotification(0,1)
end

Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(20)
        for k in pairs(Config.locations) do 
            local dist = nil
            local radius = Config.locations[k].blip.radius / (3.14 * 2) / 1.25
            local coords = GetEntityCoords(GetPlayerPed(-1), false)
            dist = GetDistanceBetweenCoords(coords.x, coords.y, coords.z, Config.locations[k].blip.pos, false)
            if dist <= radius then
                if not isIn and disable == false then
                    table.insert(areas, Config.locations[k].name)
                    TriggerEvent("zones:enter", Config.locations[k].name, Config.locations[k].desc)
                    -- print("[Zones] " .. Config.locations[k].name .. " showing")
                    Citizen.Wait(Config.Wait)
                    -- print("[Zones] " .. Config.locations[k].name .. " hidden")
                    TriggerEvent("zones:exit", Config.locations[k].name)
                else 
                    -- print("[Zones] " .. Config.locations[k].name .. " disabled")
                end

                isIn = true

            elseif areas[1] == Config.locations[k].name then
                isIn = false
                for k in pairs(areas) do
                    areas[k] = nil
                end    
            end
        end
        Citizen.Wait(500)
    end
end)
RegisterCommand("zones", function(source, args, raw)
    if args[1] == "off" then
        sendNotification("Zones disabled")
        TriggerEvent("zones:disable")
    elseif args[1] == "on" then
        TriggerEvent("zones:enable")
        sendNotification("Zones enabled")
    end
end)

RegisterNetEvent("zones:disable")
AddEventHandler("zones:disable", function()
    disable = true
    SendNUIMessage({
        type = "disable"
    })
end)
RegisterNetEvent("zones:enable")
AddEventHandler("zones:enable", function()
    disable = false
end)
RegisterNetEvent("zones:enter")
AddEventHandler("zones:enter", function(data, desc)
    SendNUIMessage({
        type = "enter",
        zone = data,
        description = desc
    })
end)
RegisterNetEvent("zones:exit")
AddEventHandler("zones:exit", function(data)
    SendNUIMessage({
        type = "exit",
        zone = data,
    })
end)
