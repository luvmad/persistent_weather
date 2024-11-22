local currentWeather = "CLEAR"
local json = require "json"
local currentHour = 12
local currentMinute = 0
local specialWeather = nil
local specialPersistent = false

local SYNC_INTERVAL = 60000
local translations = {}
local lang = "en"

local function loadTranslations()
    local translationsFile = "translations.json"
    local file = LoadResourceFile(GetCurrentResourceName(), translationsFile)
    if file then
        translations = json.decode(file)
        if translations then
            print("Translations loaded successfully.")
        else
            print("Failed to decode translations.")
        end
    else
        print("Failed to open translations file.")
    end
end

local function translate(lang, key)
    return translations[lang] and translations[lang][key] or key
end

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
    loadTranslations()
    while true do
        Citizen.Wait(SYNC_INTERVAL)
        TriggerServerEvent("weather:requestUpdate")
    end
end)

TriggerServerEvent("weather:requestUpdate")
