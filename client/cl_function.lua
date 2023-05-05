local GetGameplayCamRot = GetGameplayCamRot
local GetGameplayCamCoord = GetGameplayCamCoord
local GetShapeTestResult = GetShapeTestResult
local StartShapeTestRay = StartShapeTestRay
local DrawLine = DrawLine
local DrawPoly = DrawPoly

-- credit to https://github.com/TheExquis
function RotationToDirection(rotation)
	local adjustedRotation =
	{
		x = (math.pi / 180) * rotation.x,
		y = (math.pi / 180) * rotation.y,
		z = (math.pi / 180) * rotation.z
	}
	local direction =
	{
		x = -math.sin(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
		y = math.cos(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
		z = math.sin(adjustedRotation.x)
	}
	return direction
end

function RayCastGamePlayCamera(distance)
    local cameraRotation = GetGameplayCamRot()
	local cameraCoord = GetGameplayCamCoord()
	local direction = RotationToDirection(cameraRotation)
	local destination =
	{
		x = cameraCoord.x + direction.x * distance,
		y = cameraCoord.y + direction.y * distance,
		z = cameraCoord.z + direction.z * distance
	}
	local _, hit, endCoords, _, entity = GetShapeTestResult(StartShapeTestRay(cameraCoord.x, cameraCoord.y, cameraCoord.z, destination.x, destination.y, destination.z, -1, cache.ped, 0))
	return hit, endCoords, entity
end

function DrawLaser(color)
    local hit, coords, entity = RayCastGamePlayCamera(100.0)

    if hit and DoesEntityExist(entity) then
        local position = GetEntityCoords(cache.ped)
        DrawLine(position.x, position.y, position.z, coords.x, coords.y, coords.z, color.r, color.g, color.b, color.a)
    end

    return hit, coords, entity
end

-- credit to https://github.com/Puntherline
-- ####################### Functions #######################
function drawPolys(v)
	-- Starting top left, going counter-clockwise when looking at that side
	-- Top
	DrawPoly(v.t_f_l, v.t_r_l, v.t_r_r, v.r, v.g, v.b, v.a)
	DrawPoly(v.t_r_r, v.t_f_r, v.t_f_l, v.r, v.g, v.b, v.a)
	-- Bottom
	DrawPoly(v.b_f_r, v.b_r_r, v.b_r_l, v.r, v.g, v.b, v.a)
	DrawPoly(v.b_r_l, v.b_f_l, v.b_f_r, v.r, v.g, v.b, v.a)
	-- Front
	DrawPoly(v.t_f_r, v.b_f_r, v.b_f_l, v.r, v.g, v.b, v.a)
	DrawPoly(v.b_f_l, v.t_f_l, v.t_f_r, v.r, v.g, v.b, v.a)
	-- Rear
	DrawPoly(v.t_r_l, v.b_r_l, v.b_r_r, v.r, v.g, v.b, v.a)
	DrawPoly(v.b_r_r, v.t_r_r, v.t_r_l, v.r, v.g, v.b, v.a)
	-- Left
	DrawPoly(v.t_f_l, v.b_f_l, v.b_r_l, v.r, v.g, v.b, v.a)
	DrawPoly(v.b_r_l, v.t_r_l, v.t_f_l, v.r, v.g, v.b, v.a)
	-- Right
	DrawPoly(v.t_r_r, v.b_r_r, v.b_f_r, v.r, v.g, v.b, v.a)
	DrawPoly(v.b_f_r, v.t_f_r, v.t_r_r, v.r, v.g, v.b, v.a)
end

function drawLines(v)
	-- Top
	DrawLine(v.t_f_l, v.t_f_r, 255, 255, 255, v.a2)
	DrawLine(v.t_f_r, v.t_r_r, 255, 255, 255, v.a2)
	DrawLine(v.t_r_r, v.t_r_l, 255, 255, 255, v.a2)
	DrawLine(v.t_r_l, v.t_f_l, 255, 255, 255, v.a2)
	-- Bottom
	DrawLine(v.b_f_l, v.b_f_r, 255, 255, 255, v.a2)
	DrawLine(v.b_f_r, v.b_r_r, 255, 255, 255, v.a2)
	DrawLine(v.b_r_r, v.b_r_l, 255, 255, 255, v.a2)
	DrawLine(v.b_r_l, v.b_f_l, 255, 255, 255, v.a2)
	-- Bottom
	DrawLine(v.t_f_l, v.b_f_l, 255, 255, 255, v.a2)
	DrawLine(v.t_f_r, v.b_f_r, 255, 255, 255, v.a2)
	DrawLine(v.t_r_r, v.b_r_r, 255, 255, 255, v.a2)
	DrawLine(v.t_r_l, v.b_r_l, 255, 255, 255, v.a2)
end