local currentVersion = "1.0.0" -- Version actuelle du script
local releasesURL = "https://api.github.com/repos/luvmad/persistent_weather/releases/latest" -- URL de l'API GitHub pour la dernière release
local latestReleaseURL = "https://github.com/luvmad/persistent_weather/releases/latest" -- URL de la dernière version sur GitHub

local function checkVersion()
    PerformHttpRequest(releasesURL, function(statusCode, response, headers)
        if statusCode == 200 then
            local data = json.decode(response)
            local latestVersion = data.tag_name:gsub("%s+", "") -- Supprimer les espaces blancs
            if latestVersion == currentVersion then
                print("Script version: " .. currentVersion .. " - Up to date.")
            else
                print("Script version: " .. currentVersion .. " - Outdated. Latest version: " .. latestVersion)
                print("Download the latest version here: " .. latestReleaseURL)
            end
        else
            print("Failed to check the latest version. Status code: " .. statusCode)
        end
    end, "GET", "", {["Content-Type"] = "application/json"})
end

AddEventHandler("onClientResourceStart", function(resourceName)
    if GetCurrentResourceName() == resourceName then
        checkVersion()
    end
end)
