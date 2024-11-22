local json = require "json"

local weatherFile = "weather_data.json"
local translationsFile = "translations.json"
local defaultWeather = { weather = "CLEAR", hour = 12, minute = 0, specialWeather = nil, specialPersistent = false }
local currentWeather = {}
local translations = {}

local lang = "en"

local function loadTranslations()
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

local function loadWeather()
    local file = io.open(weatherFile, "r")
    if file then
        local content = file:read("*a")
        local data = json.decode(content)
        if data and data.weather and data.hour and data.minute then
            currentWeather = data
        else
            currentWeather = defaultWeather
        end
        file:close()
    else
        currentWeather = defaultWeather
    end
end

local function saveWeather()
    local file = io.open(weatherFile, "w+")
    if file then
        local dataToSave = {
            weather = currentWeather.weather,
            hour = currentWeather.hour,
            minute = currentWeather.minute,
            specialWeather = currentWeather.specialWeather,
            specialPersistent = currentWeather.specialPersistent
        }
        file:write(json.encode(dataToSave))
        file:close()
    end
end

local function syncWeather()
    TriggerClientEvent("weather:update", -1, currentWeather.weather, currentWeather.specialWeather, currentWeather.specialPersistent)
end

local function syncTime()
    TriggerClientEvent("time:update", -1, currentWeather.hour, currentWeather.minute)
end

local function addCustomNotification(playerId, header, title, subtitle, content, duration, sticky)
    TriggerClientEvent('fb_ui:addNotification', playerId, "", "", title, subtitle, content, duration or 10000, sticky or false)
end

local validWeather = {
    "CLEAR", "EXTRASUNNY", "CLOUDS", "OVERCAST", "RAIN",
    "CLEARING", "THUNDER", "SMOG", "FOGGY", "SNOW",
    "BLIZZARD", "SNOWLIGHT", "XMAS", "HALLOWEEN"
}

local validSpecialWeather = {
    "SNOWLIGHT", "XMAS", "HALLOWEEN", "BLACKOUT"
}

function table.contains(tbl, value)
    for _, v in pairs(tbl) do
        if v == value then
            return true
        end
    end
    return false
end

function math.clamp(val, min, max)
    return math.min(math.max(val, min), max)
end

RegisterCommand("weather", function(source, args)
    if not IsPlayerAceAllowed(source, "command.weather") then
        addCustomNotification(
            source, 
            translate(lang, "accessDenied"), 
            translate(lang, "accessDenied"), 
            "", 
            "", 
            10000
        )
        return
    end

    if #args < 1 then
        addCustomNotification(
            source, 
            translate(lang, "weatherCommandUsage"), 
            translate(lang, "weatherCommandExample") .. table.concat(validWeather, ", "), 
            "", 
            "", 
            12000
        )
        return
    end

    local newWeather = args[1]:upper()

    if not table.contains(validWeather, newWeather) then
        addCustomNotification(
            source, 
            translate(lang, "invalidWeatherType"), 
            translate(lang, "invalidWeatherType") .. table.concat(validWeather, ", "), 
            "", 
            "", 
            12000
        )
        return
    end

    currentWeather.weather = newWeather
    syncWeather()
    saveWeather()

    local playerName = GetPlayerName(source) or "Console"
    addCustomNotification(
        source, 
        translate(lang, "weatherChanged"), 
        translate(lang, "weatherChanged") .. newWeather, 
        "", 
        "", 
        10000
    )
end, false)

RegisterCommand("weatherreset", function(source)
    if not IsPlayerAceAllowed(source, "command.weatherreset") then
        addCustomNotification(
            source, 
            translate(lang, "accessDenied"), 
            translate(lang, "accessDenied"), 
            "", 
            "", 
            10000
        )
        return
    end

    currentWeather = defaultWeather
    syncWeather()
    saveWeather()

    local playerName = GetPlayerName(source) or "Console"
    addCustomNotification(
        source, 
        translate(lang, "weatherReset"), 
        translate(lang, "weatherReset"), 
        "", 
        "", 
        10000
    )
end, false)

RegisterCommand("time", function(source, args)
    if not IsPlayerAceAllowed(source, "command.time") then
        addCustomNotification(
            source, 
            translate(lang, "accessDenied"), 
            translate(lang, "accessDenied"), 
            "", 
            "", 
            10000
        )
        return
    end

    if #args < 2 then
        addCustomNotification(
            source, 
            translate(lang, "timeCommandUsage"), 
            translate(lang, "timeCommandExample"), 
            "", 
            "", 
            12000
        )
        return
    end

    local hour = tonumber(args[1])
    local minute = tonumber(args[2])

    if hour and minute then
        currentWeather.hour = math.clamp(hour, 0, 23)
        currentWeather.minute = math.clamp(minute, 0, 59)
        syncTime()
        saveWeather()

        local playerName = GetPlayerName(source) or "Console"
        addCustomNotification(
            source, 
            translate(lang, "timeChanged"), 
            translate(lang, "timeChanged") .. hour .. "h" .. string.format("%02d", minute), 
            "", 
            "", 
            10000
        )
    else
        addCustomNotification(
            source, 
            translate(lang, "invalidTimeValues"), 
            translate(lang, "invalidTimeValues"), 
            "", 
            "", 
            10000
        )
    end
end, false)

RegisterCommand("syncWeather", function(source)
    if not IsPlayerAceAllowed(source, "command.syncWeather") then
        addCustomNotification(
            source, 
            translate(lang, "accessDenied"), 
            translate(lang, "accessDenied"), 
            "", 
            "", 
            10000
        )
        return
    end

    syncWeather()
    syncTime()

    addCustomNotification(
        source, 
        translate(lang, "syncSuccess"), 
        translate(lang, "syncSuccess"), 
        "", 
        "", 
        10000
    )
end, false)

RegisterCommand("weatherspecial", function(source, args)
    if not IsPlayerAceAllowed(source, "command.weatherspecial") then
        addCustomNotification(
            source, 
            translate(lang, "accessDenied"), 
            translate(lang, "accessDenied"), 
            "", 
            "", 
            10000
        )
        return
    end

    if #args < 2 then
        addCustomNotification(
            source, 
            translate(lang, "specialWeatherCommandUsage"), 
            translate(lang, "specialWeatherCommandExample") .. table.concat(validSpecialWeather, ", "), 
            "", 
            "", 
            12000
        )
        return
    end

    local specialWeather = args[1]:upper()
    local persistent = args[2]:lower() == "true"

    if not table.contains(validSpecialWeather, specialWeather) then
        addCustomNotification(
            source, 
            translate(lang, "invalidSpecialWeatherType"), 
            translate(lang, "invalidSpecialWeatherType") .. table.concat(validSpecialWeather, ", "), 
            "", 
            "", 
            12000
        )
        return
    end

    currentWeather.specialWeather = specialWeather
    currentWeather.specialPersistent = persistent
    syncWeather()
    saveWeather()

    local playerName = GetPlayerName(source) or "Console"
    addCustomNotification(
        source, 
        translate(lang, "specialWeatherChanged"), 
        translate(lang, "specialWeatherChanged") .. specialWeather .. " (Persistent: " .. tostring(persistent) .. ")", 
        "", 
        "", 
        10000
    )
end, false)

AddEventHandler("onResourceStart", function(resourceName)
    if resourceName == GetCurrentResourceName() then
        loadTranslations()
        loadWeather()
        syncWeather()
        syncTime()
        addCustomNotification(
            -1, 
            translate(lang, "weatherLoading"), 
            translate(lang, "weatherLoaded") .. currentWeather.weather .. " at " .. currentWeather.hour .. "h" .. string.format("%02d", currentWeather.minute), 
            "", 
            "", 
            10000
        )
    end
end)

AddEventHandler("onResourceStop", function(resourceName)
    if resourceName == GetCurrentResourceName() then
        saveWeather()
    end
end)

AddEventHandler("txAdmin:events:scheduledRestart", function()
    saveWeather()
end)

AddEventHandler("txAdmin:events:serverShuttingDown", function()
    saveWeather()
end)
