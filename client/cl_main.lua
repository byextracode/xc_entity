local DoesEntityExist = DoesEntityExist
local GetEntityType = GetEntityType
local DrawLaser = DrawLaser
local GetEntityModel = GetEntityModel
local GetModelDimensions = GetModelDimensions
local GetOffsetFromEntityInWorldCoords = GetOffsetFromEntityInWorldCoords
local IsEntityOnScreen = IsEntityOnScreen
local drawPolys = drawPolys
local drawLines = drawLines

local active = false
local target_object = nil
local current_focused_object = 0
local current_entity_outline = 0
local object_hash = 0
local dim_min, dim_max = vector3(0.0, 0.0, 0.0), vector3(0.0, 0.0, 0.0)
local draw_box = {}
local number_handle = 0
local textUI = false

RegisterNetEvent("xc:globalentity", function()
    active = not active
    if active then
        return
    end
    if textUI then
        textUI = false
        lib.hideTextUI()
    end
    if current_entity_outline ~= 0 then
        drawOutline(current_entity_outline, false)
        current_entity_outline = 0
    end
    draw_box = {}
end)

RegisterNetEvent("xc:globalwipe", function()
    local invoking = GetInvokingResource()
    if invoking and invoking ~= GetCurrentResourceName() then
        return
    end
    local input = lib.inputDialog('Global Wipes', {
        {
            type = "number",
            label = "Entity Owner",
            description = "Leave blank to wipe all entity",
            placeholder = "Player ID",
            icon = "passport"
        },
        {
            type = "checkbox",
            label = "Object",
            icon = "object-ungroup"
        },
        {
            type = "checkbox",
            label = "Ped",
            icon = "person"
        },
        {
            type = "checkbox",
            label = "Vehicle",
            icon = "car"
        },
        {
            type = "input",
            label = "Entity model/hash",
            description = "Leave blank to wipe all model/hash",
            icon = "hashtag"
        },
    })

    if not input then
        return
    end

    local pId = input[1] or -1
    local object = input[2]
    local ped = input[3]
    local vehicle = input[4]
    local model = input[5]
    local entity = object or ped or vehicle
    if pId == 0 then
        return lib.notify({
            title = 'Entity Owner is not valid',
            description = 'Make sure entity owner input',
            position = 'top',
            style = {
                backgroundColor = '#141517',
                color = '#909296'
            },
            icon = 'ban',
            iconColor = '#C53030'
        })
    end
    if model and type(model) ~= "number" then
        model = tonumber(model) or joaat(model)
    end
    if not entity then
        return lib.notify({
            title = 'Can not proceed',
            description = 'At least one entity type must be checked',
            position = 'top',
            style = {
                backgroundColor = '#141517',
                color = '#909296'
            },
            icon = 'ban',
            iconColor = '#C53030'
        })
    end

    local data = {
        pId = pId,
        object = object,
        ped = ped,
        vehicle = vehicle,
        model = model
    }

    TriggerServerEvent("xc:entityWipe", data)
end)

RegisterNetEvent("xc:request:EntityFreeze", function(netId)
    if not NetworkDoesEntityExistWithNetworkId(netId) then return end
    freezeEntity(NetworkGetEntityFromNetworkId(netId))
end)

CreateThread(function()
    while true do
        local wait = 1000
        if active then
            wait = 0
            local hit, coords, entity = DrawLaser({r = 200, g = 21, b = 181, a = 200})
            if hit and DoesEntityExist(entity) and GetEntityType(entity) ~= 0 then
                target_object = entity
                if target_object ~= current_focused_object then
                    object_hash = GetEntityModel(target_object)
                    dim_min, dim_max = GetModelDimensions(object_hash)
                    number_handle = target_object
                    draw_box = {
                        entity = target_object,
                        hash = object_hash,
                        dim_min = dim_min,
                        dim_max = dim_max,
                        b_r_l = GetOffsetFromEntityInWorldCoords(number_handle, dim_min),
                        b_r_r = GetOffsetFromEntityInWorldCoords(number_handle, dim_max.x, dim_min.yz),
                        b_f_l = GetOffsetFromEntityInWorldCoords(number_handle, dim_min.x, dim_max.y, dim_min.z),
                        b_f_r = GetOffsetFromEntityInWorldCoords(number_handle, dim_max.xy, dim_min.z),
                        t_r_l = GetOffsetFromEntityInWorldCoords(number_handle, dim_min.xy, dim_max.z),
                        t_r_r = GetOffsetFromEntityInWorldCoords(number_handle, dim_max.x, dim_min.y, dim_max.z),
                        t_f_l = GetOffsetFromEntityInWorldCoords(number_handle, dim_min.x, dim_max.yz),
                        t_f_r = GetOffsetFromEntityInWorldCoords(number_handle, dim_max),
                        r = 211,
                        g = 21,
                        b = 212,
                        a = 21,
                        a2 = 255
                    }
                    local isNetworked = NetworkGetEntityIsNetworked(entity)
                    local netId = isNetworked and GetPlayerServerId(NetworkGetEntityOwner(entity)) or "local"
                    local firstOwner = netId
                    if isNetworked then
                        firstOwner = lib.callback.await("xc_entity:getFirstOwner", false, NetworkGetNetworkIdFromEntity(entity))
                    end
                    if firstOwner == -1 then
                        firstOwner = ("%s (server)"):format(firstOwner)
                    end
                    if target_object ~= current_focused_object then
                        textUI = true
                        lib.showTextUI(("Owner ID: %s  \nHash: %s  \nFirst Owner ID : %s  \n.  \n[E] Copy Hash  \n[F] Freeze Entity  \n[G] Delete Entity"):format(netId, object_hash, firstOwner), {
                            position = "top-center"
                        })
                    end
                    current_focused_object = target_object
                end
            else
                draw_box = {}
                current_focused_object = 0
                if textUI then
                    textUI = false
                    lib.hideTextUI()
                end
            end
        end
        Wait(wait)
    end
end)

CreateThread(function()
    while true do
        local wait = 1000
        if next(draw_box) then
            if IsEntityOnScreen(draw_box.entity) then
                wait = 0
                local number_handle = draw_box.entity
                draw_box.b_r_l = GetOffsetFromEntityInWorldCoords(number_handle, draw_box.dim_min)
                draw_box.b_r_r = GetOffsetFromEntityInWorldCoords(number_handle, draw_box.dim_max.x, draw_box.dim_min.yz)
                draw_box.b_f_l = GetOffsetFromEntityInWorldCoords(number_handle, draw_box.dim_min.x, draw_box.dim_max.y, draw_box.dim_min.z)
                draw_box.b_f_r = GetOffsetFromEntityInWorldCoords(number_handle, draw_box.dim_max.xy, draw_box.dim_min.z)
                draw_box.t_r_l = GetOffsetFromEntityInWorldCoords(number_handle, draw_box.dim_min.xy, draw_box.dim_max.z)
                draw_box.t_r_r = GetOffsetFromEntityInWorldCoords(number_handle, draw_box.dim_max.x, draw_box.dim_min.y, draw_box.dim_max.z)
                draw_box.t_f_l = GetOffsetFromEntityInWorldCoords(number_handle, draw_box.dim_min.x, draw_box.dim_max.yz)
                draw_box.t_f_r = GetOffsetFromEntityInWorldCoords(number_handle, draw_box.dim_max)
                drawPolys(draw_box)
                drawLines(draw_box)
                if number_handle ~= current_entity_outline then
                    if GetEntityType(number_handle) >= 2 then
                        drawOutline(number_handle, true)
                    end
                    if current_entity_outline ~= 0 then
                        drawOutline(current_entity_outline, false)
                    end
                    current_entity_outline = number_handle
                end
                if IsControlJustPressed(0, Config.copybutton) then
                    lib.setClipboard(object_hash)
                    lib.notify({
                        title = 'Copied',
                        description = 'Model hash has been copied to clipboard',
                        type = 'success'
                    })
                end
                if IsControlJustPressed(0, Config.deletebutton) then
                    if NetworkHasControlOfEntity(number_handle) then
                        requestDeleteEntity(number_handle)
                    else
                        TriggerServerEvent("xc:EntityDelete", NetworkGetNetworkIdFromEntity(number_handle))
                    end
                end
                if IsControlJustPressed(0, Config.freezebutton) then
                    if NetworkHasControlOfEntity(number_handle) then
                        freezeEntity(number_handle)
                    else
                        TriggerServerEvent("xc:request:EntityFreeze", NetworkGetNetworkIdFromEntity(number_handle))
                    end
                end
            else
                if current_entity_outline ~= 0 then
                    drawOutline(current_entity_outline, false)
                    current_entity_outline = 0
                end
            end
        else
            if current_entity_outline ~= 0 then
                drawOutline(current_entity_outline, false)
                current_entity_outline = 0
            end
        end
        Wait(wait)
    end
end)