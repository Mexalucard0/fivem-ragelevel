ESX = nil
local isDead = false
local firstSpawn = true

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getShtoniaredObjtoniect', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

function playerDied()
	TriggerServerEvent('chaini_muerto:updatePlayer',true)
	isDead = true
end

function killPlayer()
	SetEntityHealth(GetPlayerPed(-1),0)
	playerDied()
end

function playerAlive()
	TriggerServerEvent('chaini_muerto:updatePlayer',false)
	isDead = false
end

AddEventHandler('baseevents:onPlayerDied', function(killerType, coords)
	playerDied()
end)

AddEventHandler('baseevents:onPlayerKilled', function(killerId, data)
	playerDied()
end)

AddEventHandler("playerSpawned", function()
	if firstSpawn then
		ESX.TriggerServerCallback('chaini_muerto:isDead', function(isDeadDB)
			if isDeadDB then
				Citizen.Wait(1000)
				killPlayer()
			end
		end)
		firstSpawn = false
	end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
		if isDead then
			if GetEntityHealth(GetPlayerPed(-1)) > 0 then
				playerAlive()
				Citizen.Wait(50)
			end
		end
    end
end)
