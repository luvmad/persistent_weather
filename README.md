# Weather and Time Management Script

This script allows you to manage weather and time in your FiveM server.

## Features
- Change weather
- Reset weather
- Change time
- Sync weather and time
- Set special weather conditions

## Commands
- `/weather [WEATHER_TYPE]`: Change the weather.
- `/weatherreset`: Reset the weather to default.
- `/time [HOUR] [MINUTE]`: Change the time.
- `/syncWeather`: Sync weather and time with all players.
- `/weatherspecial [SPECIAL_WEATHER_TYPE] [PERSISTENT]`: Set special weather conditions.

## Permissions
- `command.weather`: Permission to change the weather.
- `command.weatherreset`: Permission to reset the weather.
- `command.time`: Permission to change the time.
- `command.syncWeather`: Permission to sync weather and time.
- `command.weatherspecial`: Permission to set special weather conditions.

## Dependencies
- `fb_ui`: Required for notifications.

## Installation
1. Ensure you have the `fb_ui` resource installed.
2. Add this resource to your `server.cfg`:

cfg
ensure persistent_weather

# Ace Permissions

add_ace group.admin command.weather allow
add_ace group.admin command.weatherreset allow
add_ace group.admin command.time allow
add_ace group.admin command.weatherspecial allow
add_ace group.admin command.syncWeather allow

add_ace group.superadmin command.weather allow
add_ace group.superadmin command.weatherreset allow
add_ace group.superadmin command.time allow
add_ace group.superadmin command.weatherspecial allow
add_ace group.superadmin command.syncWeather allow

add_ace group.owner command.weather allow
add_ace group.owner command.weatherreset allow
add_ace group.owner command.time allow
add_ace group.owner command.weatherspecial allow
add_ace group.owner command.syncWeather allow

# Staff Groups Permissions

add_principal identifier.steam:110000112345678 group.admin
add_principal identifier.steam:110000112345679 group.mod
