local Settings = {}


function Settings.new ( opt )
	local ret = {}
	opt = opt or {}
	for k in "names values validators":gmatch"%W+" do
		local t={}
		if opt[k] then
			for _,k in ipairs(table.copy(opt[k])) do
				t[k]=true
			end
		end
		ret['_'..k]=t
	end
	return setmetatable ( ret, Settings )
end


function Settings:__newindex ( k, v )
	if self._names[k] then
		local fv=self._validators[k]
		local rsp={fv(v,k,self)}
		if not rsp[1] then return unpack(rsp) end
		self._values[k]=v
		return true
	else
		error ( "invalid name:"..tostring(k) )
	end
end


function Settings:__index ( k )
	if self._names[k] then
		return self._values[k]
	else
		error ( "invalid name:"..tostring(k) )
	end
end


return Settings
