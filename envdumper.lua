--circumvent __pairs metamethod
local function fpairs ( x )
	local mt = getmetatable ( x )
	local iter = pairs ( x )
	return function ()
		local k, v = iter ()
		if k ~= nil then
			return k, v
		else
			setmetatable ( x, mt )
		end
	end
end


--enforce vanilla tostring
local function ftostring ( x )
	local mt = getmetatable ( x )
	local ret = tostring ( x )
	setmetatable ( x, mt )
	return ret
end


local function dump ( env, data, iterator, guard )
	env = env or _G or _ENV
	guard = guard or {}
	data = data or { metatables = {}, buffer = {} }
	iterator = iterator or fpairs
	for k, v in iterator ( env ) do
	end
end