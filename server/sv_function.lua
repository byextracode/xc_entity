function fetchEntities(data)
    local entities = {}
    if data.object then
        local objects = GetAllObjects()
        for i = 1, #objects do
            if data.pId ~= -1 and NetworkGetFirstEntityOwner(objects[i]) ~= data.pId then
                goto nextobject
            end
            if data.model ~= 0 and GetEntityModel(objects[i]) ~= data.model then
                goto nextobject
            end
            entities[#entities+1] = objects[i]
            ::nextobject::
        end
    end
    if data.ped then
        local peds = GetAllPeds()
        for i = 1, #peds do
            if data.pId ~= -1 and NetworkGetFirstEntityOwner(peds[i]) ~= data.pId then
                goto nextped
            end
            if data.model ~= 0 and GetEntityModel(peds[i]) ~= data.model then
                goto nextped
            end
            entities[#entities+1] = peds[i]
            ::nextped::
        end
    end
    if data.vehicle then
        local vehicles = GetAllVehicles()
        for i = 1, #vehicles do
            if data.pId ~= -1 and NetworkGetFirstEntityOwner(vehicles[i]) ~= data.pId then
                goto nextvehicle
            end
            if data.model ~= 0 and GetEntityModel(vehicles[i]) ~= data.model then
                goto nextvehicle
            end
            entities[#entities+1] = vehicles[i]
            ::nextvehicle::
        end
    end
    return entities
end