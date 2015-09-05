local startSet = {}

local function procd ( resource )
	if startSet [ resource ] then
		startSet [ resource ] = nil
	else
		cancelEvent ()
		processResource ( resource.name )
		startSet [ resource ] = true
		setTimer ( function ( resource ) startResource ( resource ) end, 500, 1, resource )
	end
end
addEventHandler ( 'onResourcePreStart', root, procd )