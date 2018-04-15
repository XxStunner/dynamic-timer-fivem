-- Desenvolvido por XxStunner.
-- Se quiser um site, forum, aplicativo ou programas desktop só me mandar email por: www.spaceshipws.com :)
-- Developed by XxStunner
-- If you need a website, forum, mobile app or a desktop app contact me: www.spaceshipws.com :)
CurrentWeather = 'EXTRASUNNY'
local lastWeather = CurrentWeather
-- Declara o horario / Set everything to 0 to prevent bugs
Time = {}
Time.h = 0
Time.m = 0
Time.s = 0
Time.y = 0
Time.me = 0
Time.d = 0
-- Eventos / Events
RegisterNetEvent('JNS:updateWeather')
AddEventHandler('JNS:updateWeather', function(NewWeather)
    CurrentWeather = NewWeather
end)
RegisterNetEvent('JNS:updateTime')
AddEventHandler('JNS:updateTime', function(hours, minutes, seconds, year, month, day)
    Time.h = hours
    Time.m = minutes
    Time.s = seconds
    Time.y = year
    Time.me = month
    Time.d = day
end)
AddEventHandler('playerSpawned', function()
    TriggerServerEvent('JNS:requestSync')
end)
-- Threads / Sicroniza os horários / Sync the timer.
Citizen.CreateThread(function()
    while true do
      Citizen.Wait(1000) -- Sicroniza o horario do game com o servidor (1s)
      TriggerServerEvent('JNS:requestSync')
      NetworkOverrideClockTime(Time.h, Time.m, Time.s)
    end
end)
Citizen.CreateThread(function()
    while true do
        if lastWeather ~= CurrentWeather then
            lastWeather = CurrentWeather
            SetWeatherTypeOverTime(CurrentWeather, 15.0)
            Citizen.Wait(60000)
        end
        Citizen.Wait(1000) -- (1s)
        ClearOverrideWeather()
        ClearWeatherTypePersist()
        SetWeatherTypePersist(lastWeather)
        SetWeatherTypeNow(lastWeather)
        SetWeatherTypeNowPersist(lastWeather)
    end
end)