local Entities = {}

RegisterCommand(Config.commandlaser, function(source, args, raw)
    TriggerClientEvent("xc:globalentity", source)
end, true)

RegisterCommand(Config.commandwipe, function(source, args, raw)
    TriggerClientEvent("xc:globalwipe", source)
end, true)

lib.callback.register("xc_entity:getFirstOwner", function(source, netId)
    local entity = NetworkGetEntityFromNetworkId(netId)
    return Entities[netId] or NetworkGetFirstEntityOwner(entity)
end)

AddEventHandler('entityCreating', function(entity)
    if IsPedAPlayer(entity) then
        return
    end

    local netId = NetworkGetNetworkIdFromEntity(entity)
    local firstOwner = NetworkGetFirstEntityOwner(entity)
    Entities[netId] = firstOwner
end)

AddEventHandler('entityRemoved', function(entity)
    if IsPedAPlayer(entity) then
        return
    end

    local netId = NetworkGetNetworkIdFromEntity(entity)
    if not Entities[netId] then
        return
    end
    Entities[netId] = nil
end)

RegisterNetEvent("xc:entityWipe", function(data)
    local source = source
    if not IsPlayerAceAllowed(source, ("command.%s"):format(Config.commandwipe)) then
        return
    end

    local entities = fetchEntities(data)
    local totalentities = #entities
    for i = 1, #entities do
        DeleteEntity(entities[i])
    end
    lib.notify(source, {
        title = 'Entities Wiped',
        description = ('Total %s entities'):format(totalentities),
        position = 'top',
        style = {
            backgroundColor = '#141517',
            color = '#909296'
        },
        icon = 'circle-check',
        iconColor = '#00ff00'
    })
end)