RegisterCommand(Config.commandname, function(source, args, raw)
    TriggerClientEvent("xc:globalentity", source)
end, true)

lib.callback.register("xc_entity:getFirstOwner", function(source, netId)
    local entity = NetworkGetEntityFromNetworkId(netId)
    local firstOwner = NetworkGetFirstEntityOwner(entity)
    return firstOwner
end)