--a few useful functions for preprcessing scripts
function include ( path )
	local f = File ( path )
	if f then
		return f:read(f:getSize())
	else
		error "failed to open file: " .. tostring ( path )
	end
end