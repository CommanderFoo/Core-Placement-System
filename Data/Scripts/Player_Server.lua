local PLAYER_API = require(script:GetCustomProperty("Player_API"))

local function on_player_joined(player)
	PLAYER_API.set_visibility(player, false)	
	PLAYER_API.activate_flying(player, true)
end


Game.playerJoinedEvent:Connect(on_player_joined)