local API = {}

function API.enable_cursor()
	UI.SetCanCursorInteractWithUI(true)
	UI.SetCursorVisible(true)
end

function API.disable_cursor()
	UI.SetCanCursorInteractWithUI(true)
	UI.SetCursorVisible(true)
end

return API