---------------------
-- Longo Development 
---------------------

local reviveTimer = 90 -- This is uses for both Revive and Respawn, You may change the time to your needs (Time is in seconds)

isDead = false
timerCount1 = reviveTimer

AddEventHandler('onClientMapStart', function()
	exports.spawnmanager:spawnPlayer() -- Ensure player spawns into server.
	Citizen.Wait(2500)
	exports.spawnmanager:setAutoSpawn(false)
end)

function text(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(false, false)
end


function revivePed()
    isDead = false
    timerCount1 = reviveTimer
    
    local playerCoords = GetEntityCoords(PlayerPedId())
    NetworkResurrectLocalPlayer(playerCoords.x, playerCoords.y, playerCoords.z, GetEntityHeading(PlayerPedId()), true, false)
end

function respawnPed()
    local rCoords = vector3(1828.44, 3692.32, 34.22)
    isDead = false
    timerCount1 = reviveTimer
    SetEntityCoordsNoOffset(PlayerPedId(), rCoords.x, rCoords.y, rCoords.z, true, false, false)
    NetworkResurrectLocalPlayer(rCoords.x, rCoords.y, rCoords.z, GetEntityHeading(PlayerPedId()), true, false)
    ClearPedBloodDamage(PlayerPedId())

end

Citizen.CreateThread(function ()
   
    while true do
        Wait(10)

        if GetEntityHealth(PlayerPedId()) <= 2 then
            isDead = true
        else
            isDead = false
        end



        if isDead == true then
            text("~r~REVIVE SYSTEM~w~: Press [E] to Revive or [R] to Respawn")

            if (IsControlJustPressed(0, 45)) then
                if timerCount1 == 0 then
                    --exports.spawnmanager:spawnPlayer()
                    respawnPed()
                    TriggerEvent("chat:clear")
                    TriggerEvent("chatMessage", "[~r~REVIVE SYSTEM~w~] Chat Cleared of Cooldown Timer! ~g~Revived ~w~Sucessfully!")
                else 
                    if timerCount1 ~= 0 then
                        TriggerEvent("chatMessage", "[~r~REVIVE SYSTEM~w~] You need to wait " .. timerCount1 .. " seconds before Respawning!")
                    end
                end
            else 
                if (IsControlJustReleased(0, 38)) then
                    if timerCount1 == 0 then
                        revivePed()
                        TriggerEvent("chat:clear")
                        TriggerEvent("chatMessage", "[~r~REVIVE SYSTEM~w~] Chat Cleared of Cooldown Timer! ~g~Respawned! ~w~Sucessfully!")
                    else 
                        if timerCount1 ~= 0 then
                            TriggerEvent("chatMessage", "[~r~REVIVE SYSTEM~w~] You need to wait " .. timerCount1 .. " seconds before Reviving!")
                        end
                    end
                end
            end
         else if isDead == false then
            Citizen.Wait(sleep)
            end
        end
        Citizen.Wait(sleep)
    end
end)

Citizen.CreateThread(function ()
    while true do
        if isDead then
            if timerCount1 ~= 0 then
                timerCount1 = timerCount1 - 1
                --print(timerCount1)
            end
        end
        Wait(1000)
    end
end)

RegisterCommand('revive', function ()
    if isDead then
        if timerCount1 == 0 then
        revivePed()
        elseif timerCount1 ~= 0 then
            TriggerEvent("chatMessage", "[~r~REVIVE SYSTEM~w~] You need to wait " .. timerCount1 .. " before Reviving")
        end
    else 
        if not isDead then
            TriggerEvent("chatMessage", "[~r~REVIVE SYSTEM~w~] You can not Revive or Respawn if you are not dead!")
        end
    end
end)
