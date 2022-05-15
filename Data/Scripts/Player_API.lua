local API = {}

function API.set_visibility(player, value)
	player.isVisible = value
end

function API.activate_flying(player, wait)
	if(wait) then
		Task.Wait()
	end
	
	player:ActivateFlying()
end

function API.activate_walking(player)
	player:ActivateWalking()
end

return API