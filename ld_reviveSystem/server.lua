RegisterNetEvent("getId")
AddEventHandler("getId", function ()
    local src = source

    if src ~= nil then
        GetPlayerServerId(source)
    end
end)