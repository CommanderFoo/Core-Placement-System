local INVENTORY_ASSETS = require(script:GetCustomProperty("InventoryAssets"))
local CONTAINER = script:GetCustomProperty("Container"):WaitForObject()
local PREVIEW_MATERIAL = script:GetCustomProperty("PreviewMaterial")

local PLAYER = Environment.IsClient() and Game.GetLocalPlayer() or nil

local API = {

	spawned_objects = {},
	has_invalid_material = false,
	has_valid_material = true,
	last_rotation = Rotation.New()

}

function API.find_row_by_asset(item)
	for index, row in ipairs(INVENTORY_ASSETS) do
		if(string.find(row.asset, item.itemAssetId)) then
			row.index = index
			return row
		end
	end
end

function API:get_position_as_string(obj)
	local position = obj:GetWorldPosition()

	return string.format("%.2f,%.2f,%.2f", position.x, position.y, position.z)
end

function API:get_rotation_as_string(obj)
	local rotation = obj:GetWorldRotation()

	return string.format("%.2f,%.2f,%.2f", rotation.x, rotation.y, rotation.z)
end

function API.on_item_picked(item)
	local row = API.find_row_by_asset(item)

	if(row ~= nil) then
		API.current_row = row
	end
end

function API.clear_current_item()
	if(Object.IsValid(API.current_item)) then
		API.current_item:Destroy()
	end

	API.current_row = nil
	API.current_item = nil
end

function API.on_item_dropped()
	API.clear_current_item()
end

function API.on_action_pressed(player, action)
	if(action == "Shoot") then
		if(Object.IsValid(API.current_item)) then
			Events.BroadcastToServer("placement.placed", API.current_item:GetWorldPosition(), API.current_item:GetWorldRotation(), API.current_row.index)
			API.clear_current_item()
			Events.Broadcast("inventory.removeitem")
		elseif(API.current_row ~= nil) then
			local hit = UI.GetHitResult(Input.GetPointerPosition())

			if(hit ~= nil) then
				API.current_item = World.SpawnAsset(API.current_row.template, {

					networkContext = NetworkContextType.CLIENT_CONTEXT,
					position = hit:GetImpactPosition(),
					rotation = API.last_rotation

				})

				local static_meshes = nil
				
				if(API.current_item.type == "StaticMesh") then
					static_meshes = { API.current_item }
				else
					static_meshes = API.current_item:FindDescendantsByType("StaticMesh")
				end

				for index, mesh in ipairs(static_meshes) do
					local slots = mesh:GetMaterialSlots()

					for s, slot in ipairs(slots) do
						mesh:SetMaterialForSlot(PREVIEW_MATERIAL, slot.slotName)
					end
				end

				Events.Broadcast("proxy.hide")
			end
		end
	elseif(action == "Rotate Object") then
		if(Object.IsValid(API.current_item)) then
			local rot = API.current_item:GetWorldRotation()

			rot.z = rot.z + 90
			API.last_rotation = rot
			API.current_item:SetWorldRotation(rot)
		end
	end
end

function API.on_inventory_opened()

end

function API.on_inventory_closed()
	API.clear_current_item()
end

function API.place_static_object(position, rotation, row_index)
	local row = INVENTORY_ASSETS[row_index]

	if(row) then
		table.insert(API.spawned_objects, CONTAINER:SpawnSharedAsset(row.template, {

			position = position,
			rotation = rotation

		}))
	end
end

function API.invalid_position()
	local static_meshes = nil
				
	if(API.current_item.type == "StaticMesh") then
		static_meshes = { API.current_item }
	else
		static_meshes = API.current_item:FindDescendantsByType("StaticMesh")
	end

	for index, mesh in ipairs(static_meshes) do
		local slots = mesh:GetMaterialSlots()

		for s, slot in ipairs(slots) do
			slot:SetColor(Color.RED)
		end
	end

	API.has_invalid_material = true
	API.has_valid_material = false
end

function API.valid_position()
	local static_meshes = nil
				
	if(API.current_item.type == "StaticMesh") then
		static_meshes = { API.current_item }
	else
		static_meshes = API.current_item:FindDescendantsByType("StaticMesh")
	end

	for index, mesh in ipairs(static_meshes) do
		local slots = mesh:GetMaterialSlots()

		for s, slot in ipairs(slots) do
			slot:ResetColor()
		end
	end

	API.has_invalid_material = false
	API.has_valid_material = true
end

function API.tick(dt)
	if(API.current_item ~= nil) then
		local hit = UI.GetHitResult(Input.GetPointerPosition())

		if(hit ~= nil) then
			local position = hit:GetImpactPosition()
			local scale = API.current_item:GetWorldScale()

			if(not Input.IsActionHeld(PLAYER, "Free Movement")) then
				position.x = CoreMath.Round(position.x / 100) * 100
				position.y = CoreMath.Round(position.y / 100) * 100
			end

			local objects = World.FindObjectsOverlappingBox(position + (Vector3.UP * ((scale * 100) / 2)), API.current_item:GetWorldScale() * 96, {

				ignoreObjects = API.current_item,
				ignorePlayers = true

			})

			if(#objects > 0) then
				if(not API.has_invalid_material) then
					API.invalid_position()
				end
			elseif(not API.has_valid_material) then
				API.valid_position()
			end

			API.current_item:SetWorldPosition(position)
		end
	end
end

if(Environment.IsClient()) then
	Input.actionPressedEvent:Connect(API.on_action_pressed)
end

return API