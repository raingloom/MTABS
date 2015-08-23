--strings as files and MTA files as Lua files

if createElement then--are we running in MTA?
	assert ( isOOPEnabled (), 'OOP must be on' )

	local FileMT = getmetatable ( File )
	function FileMT:__len ()
		return self:getSize ()
	end

	function File:lines ()
		return function ()
			if self.isEOF then return end
			local buffer, i, byte = {}, 1
			while byte ~= '\n' or not self.isEOF do
				byte = self:read ( 1 )
				buffer [ i ], i = byte, i + 1
			end
			return table.concat ( buffer )
		end
	end
end

function string:lines ()
	local iter = self:gmatch '([^\n]*)\n()'
	local last = 0
	local done
	return function ()
	  if done then return end
		local line, endpos = iter ()
		last = endpos or last
		if line then
			return line
		elseif last - 1< #self then
      done = true
			return self:sub ( last )
		end
	end
end