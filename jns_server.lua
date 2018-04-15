-- Desenvolvido por XxStunner.
-- Se quiser um site, forum, aplicativo ou programas desktop só me mandar email por: www.spaceshipws.com :)
-- Developed by XxStunner
-- If you need a website, forum, mobile app or a desktop app contact me: www.spaceshipws.com :)
-- Ativa o clima dinamico / Activate the dynamic climate
local DynamicWeather = true
-- Tipos de clima / Types of climate
local AvailableWeatherTypes = {
    'EXTRASUNNY',
    'CLEAR',
    'NEUTRAL',
    'SMOG',
    'FOGGY',
    'OVERCAST',
    'CLOUDS',
    'CLEARING',
    'RAIN',
    'THUNDER',
    'SNOW',
    'BLIZZARD',
    'SNOWLIGHT',
    'XMAS',
    'HALLOWEEN',
}
-- Hoje / Today 
local CurrentWeather = "EXTRASUNNY"
local Time = {}
-- Timezone (Se você mudar a Timezone aqui lembre-se de alterar o arquivo .js) / Timezone (If you change this don't forget to change in the javascript too.)
local timezone = -3
-- Defina o intervalo em minutos que o clima irá mudar (120m = 2hrs) / Define a interval in minutes to change the climate of the server (thx vSync).
local newWeatherTimer = 120
-- Funções / Functions
function atualizarHora()
  -- Puxa o horário do servidor (Maior perfomance assim e precisão no horário, já que não usa um relógio interno mais)
  -- Get the time of the server (Better for perfomance and precision)
  Time.h = tonumber(os.date("%H", os.time() + timezone * 60 * 60))
  Time.m = tonumber(os.date("%M"))
  Time.s = tonumber(os.date("%S"))
  Time.y = tonumber(os.date("%Y"))
  Time.me = tonumber(os.date("%m"))
  Time.d = tonumber(os.date("%d"))
  -- Use esse if aqui para chamar um payday / Use this to trigger a payday from time to time.
  if Time.s == 0 and Time.m == 0 then
   -- TriggerEvent("vRP:BPAPayday")
  end
end
-- Eventos / Events
RegisterServerEvent('JNS:requestSync')
AddEventHandler('JNS:requestSync', function()
    TriggerClientEvent('JNS:updateWeather', -1, CurrentWeather)
    TriggerClientEvent('JNS:updateTime', -1, Time.h, Time.m, Time.s, Time.y, Time.me, Time.d)
end)
-- Atualiza a data a cada segundo (Assim ele muda o mês e ano certinho) / Verifiy the date on every second so he can change the month later.
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(100)
        atualizarHora()
    end
end)
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(100)
        TriggerClientEvent('JNS:updateTime', -1, Time.h, Time.m, Time.s, Time.y, Time.me, Time.d)
    end
end)
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(60000)
        TriggerClientEvent('JNS:updateWeather', -1, CurrentWeather)
    end
end)
Citizen.CreateThread(function()
    tempTimer = newWeatherTimer
    while true do
        tempTimer = tempTimer - 1
        Citizen.Wait(60000)
        if tempTimer == 0 then
            if DynamicWeather then
                NextWeatherStage()
            end
            tempTimer = newWeatherTimer
        end
    end
end)
-- Função ajustada do vSnc para mudar de climas dinamicamente / Function based on the vSync so it can change the climate.
function NextWeatherStage()
    if CurrentWeather == "CLEAR" or CurrentWeather == "CLOUDS" or CurrentWeather == "EXTRASUNNY"  then
        local new = math.random(1,2)
        if new == 1 then
            CurrentWeather = "CLEARING"
        else
            CurrentWeather = "OVERCAST"
        end
    elseif CurrentWeather == "CLEARING" or CurrentWeather == "OVERCAST" then
        local new = math.random(1,6)
        if new == 1 then
            if CurrentWeather == "CLEARING" then CurrentWeather = "FOGGY" else CurrentWeather = "RAIN" end
        elseif new == 2 then
            CurrentWeather = "CLOUDS"
        elseif new == 3 then
            CurrentWeather = "CLEAR"
        elseif new == 4 then
            CurrentWeather = "EXTRASUNNY"
        elseif new == 5 then
            CurrentWeather = "SMOG"
        else
            CurrentWeather = "FOGGY"
        end
    elseif CurrentWeather == "THUNDER" or CurrentWeather == "RAIN" then
        CurrentWeather = "CLEARING"
    elseif CurrentWeather == "SMOG" or CurrentWeather == "FOGGY" then
        CurrentWeather = "CLEAR"
    end
    TriggerEvent("JNS:requestSync")
end
