local currentWeather = "CLEAR"
local currentHour = 12
local currentMinute = 0
local specialWeather = nil
local specialPersistent = false

local SYNC_INTERVAL = 60000

local function applyWeather()
    ClearWeatherTypePersist()
    SetWeatherTypeOvertimePersist(currentWeather, 1.0)
    if specialWeather then
        SetWeatherTypePersist(specialWeather)
        if specialPersistent then
            SetWeatherTypeNowPersist(specialWeather)
        else
            SetWeatherTypeNow(specialWeather)
        end
    end
end

local function applyTime()
    NetworkOverrideClockTime(currentHour, currentMinute, 0)
end

RegisterNetEvent("weather:update")
AddEventHandler("weather:update", function(weather, special, persistent)
    currentWeather = weather
    specialWeather = special
    specialPersistent = persistent
    applyWeather()
end)

RegisterNetEvent("time:update")
AddEventHandler("time:update", function(hour, minute)
    currentHour = hour
    currentMinute = minute
    applyTime()
end)

RegisterCommand("syncWeather", function()
    TriggerServerEvent("weather:requestUpdate")
end, false)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(SYNC_INTERVAL)
        TriggerServerEvent("weather:requestUpdate")
    end
end)

TriggerServerEvent("weather:requestUpdate")