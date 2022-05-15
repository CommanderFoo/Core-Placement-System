local PLACEMENT_API = require(script:GetCustomProperty("Placement_API"))

function Tick(dt)
	PLACEMENT_API.tick(dt)
end

Events.Connect("inventory.item.picked", PLACEMENT_API.on_item_picked)
Events.Connect("inventory.item.dropped", PLACEMENT_API.on_item_dropped)

Events.Connect("inventory.opened", PLACEMENT_API.on_inventory_opened)
Events.Connect("inventory.closed", PLACEMENT_API.on_inventory_closed)