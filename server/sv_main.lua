RegisterCommand(Config.commandname, function(source, args, raw)
    TriggerClientEvent("xc:globalentity", source)
end, true)