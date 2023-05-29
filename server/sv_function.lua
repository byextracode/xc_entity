function fetchEntities(data)
    local entities = {}
    if data.object then
        local objects = GetAllObjects()
        for i = 1, #objects do
            local entity = objects[i]
            local netId = NetworkGetNetworkIdFromEntity(entity)
            local firstOwner = Entities[netId] or NetworkGetFirstEntityOwner(entity)
            if data.pId ~= -1 and firstOwner ~= data.pId then
                goto nextobject
            end
            if data.model ~= 0 and GetEntityModel(entity) ~= data.model then
                goto nextobject
            end
            entities[#entities+1] = entity
            ::nextobject::
        end
    end
    if data.ped then
        local peds = GetAllPeds()
        for i = 1, #peds do
            local entity = peds[i]
            local netId = NetworkGetNetworkIdFromEntity(entity)
            local firstOwner = Entities[netId] or NetworkGetFirstEntityOwner(entity)
            if data.pId ~= -1 and firstOwner ~= data.pId then
                goto nextped
            end
            if data.model ~= 0 and GetEntityModel(entity) ~= data.model then
                goto nextped
            end
            entities[#entities+1] = entity
            ::nextped::
        end
    end
    if data.vehicle then
        local vehicles = GetAllVehicles()
        for i = 1, #vehicles do
            local entity = vehicles[i]
            local netId = NetworkGetNetworkIdFromEntity(entity)
            local firstOwner = Entities[netId] or NetworkGetFirstEntityOwner(entity)
            if data.pId ~= -1 and firstOwner ~= data.pId then
                goto nextvehicle
            end
            if data.model ~= 0 and GetEntityModel(entity) ~= data.model then
                goto nextvehicle
            end
            entities[#entities+1] = entity
            ::nextvehicle::
        end
    end
    return entities
end