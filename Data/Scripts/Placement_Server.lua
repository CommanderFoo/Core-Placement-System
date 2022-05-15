local PLACEMENT_API = require(script:GetCustomProperty("Placement_API"))

Events.Connect("placement.placed", PLACEMENT_API.place_static_object)