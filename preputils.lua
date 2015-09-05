preputils = {}


local function include ( path )
	local f = File ( path )
	if f then
		return f:read ( f:getLength () )
	else
		error ( 'Failed to open file: ' .. tostring ( path ) )
	end
end
preputils.include = include


local function load ( path )
	return 'function()' .. include ( path ) .. 'end'
end
preputils.load = includeScript


local function require ( path )
	return '(' .. load ( path ) .. ')();'
end
preputils.require = require