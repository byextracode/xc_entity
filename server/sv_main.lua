RegisterCommand(Config.commandlaser, function(source, args, raw)
    TriggerClientEvent("xc:globalentity", source)
end, true)

RegisterCommand(Config.commandwipe, function(source, args, raw)
    TriggerClientEvent("xc:globalwipe", source)
end, true)

lib.callback.register("xc_entity:getFirstOwner", function(source, netId)
    local entity = NetworkGetEntityFromNetworkId(netId)
    local firstOwner = NetworkGetFirstEntityOwner(entity)
    return firstOwner
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