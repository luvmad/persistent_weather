fx_version 'cerulean'
game 'gta5'

author 'LuvMadison'
description 'Weather and Time Management Script'
version '1.0.0'


server_scripts {
    'server.lua', 
}


client_scripts {
    'client.lua', 
    'version_check.lua'
}


files {
    'weather_data.json', 
}

-- Dépendances
dependencies {
    'fb_ui',
}

exports {
    'addNotification',
    'tmpHideNotification',
}

lua54 'yes'

commands {
    'weather',
    'time',
    'weatherspecial',
    'weatherreset',
    'syncWeather'
}


ace_permissions {
    'command.weather',
    'command.time',
    'command.weatherspecial',
    'command.weatherreset',
    'command.syncWeather'
}

features {
    'persistent_weather',
    'time_sync',
    'special_weather_effects'
}

metadata {
    'author' = 'LuvMadison',
    'description' = 'Weather and Time Management Script',
    'version' = '1.0.0',
    'repository' = 'https://github.com/luvmad/persistent_weather'
}