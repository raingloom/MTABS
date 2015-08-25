function validateSetting ( key, value )
	--TODO: create setting validator
end

function processResource ( resourceName )
	local metaxml = XML.load ( ':' .. resourceName .. '/meta.xml' ) or error "failed loading meta.xml"
	local defaults = {
		luac = '',
		prep = '1',
		prepa = '',
		prepcache = '0',
		luaccache = '0',
		suffix = '.bso',
		extension = '.bsrc',
		naming = 'est',--order is important, e=strip extension, s=add suffix, t=replace with target if target exists
		tgt = '',
	}
	for l1i, l1node in ipairs ( metaxml.children ) do
		outputDebugString ( l1i .. ":" .. l1node.name )
		if l1node.name == 'build' then
			for l2i, l2node in ipairs ( l1node.children ) do
				outputDebugString ( l2node.name )
				if l2node.name == 'setting' then--update build settings
					local k, v = l2node:getAttribute 'key', l2node:getAttribute 'value'
					defaults [ k ] = v
				elseif l2node.name == 'obj' then--build directives for a file
					local src = l2node:getAttribute 'src' or error 'no src attribute'
					local tgt = l2node:getAttribute 'tgt' or defaults.tgt
					local luac = l2node:getAttribute 'luac' or defaults.luac
					local prep = l2node:getAttribute 'prep' or defaults.prep
					local prepa = l2node:getAttribute 'prepa' or defaults.prepa
					local luaccache = l2node:getAttribute 'luaccache' or defaults.luaccache
					local prepcache = l2node:getAttribute 'prepcache' or defaults.prepcache
					local naming = l2node:getAttribute 'naming' or defaults.naming
					local extension = l2node:getAttribute 'extension' or defaults.extension
					local suffix = l2node:getAttribute 'suffix' or defaults.suffix
					
					local out = src
					local srcf = File ( ':' .. resourceName .. '/' .. src, true )
					local buffer = srcf:read ( srcf:getSize () )
					buffer = prep == '1' and getPreProcessed (
							buffer,
							loadstring ( 'return ' .. prepa ) ()
						) or buffer
					for directive in naming:gmatch '.' do
						if directive == 'e' then
							--extension is escaped and anchored to the string's end first
							out = out:gsub ( extension:gsub ( '%W', '%%%1' ) .. '$', '' )--remove extension
							outputDebugString ( 'e out: ' .. tostring ( out ) )
						elseif directive == 's' then
							out = out .. suffix--adds suffix
							outputDebugString ( 's out: ' .. tostring ( out ) )
						elseif directive == 't' then
							out = #tgt > 0 and tgt or out--replace with target
							outputDebugString ( 't out: ' .. tostring ( out ) )
						else
							outputDebugString ( "invalid naming directive: " .. directive, 2 )
						end
					end
					outputDebugString ( 'out: ' .. tostring ( out ) )
					assert ( out ~= src, "Output file is same as input, build aborted to prevent information loss" )
					--TODO: send to compiler
					---[[
					out = ':' .. resourceName .. '/' .. out
					File.delete ( out )--remove previous output
					local outf = File.new ( out )
					outf:write ( buffer )
					outf:close ()
					--]]
					outputDebugString ( "processed " .. src .. " to " .. out .. "data:" .. buffer )
				end
			end
		end
	end
	return true
end

local startSet = {}

addEventHandler ( 'onResourcePreStart', root,
	function ( resource )
		if startSet [ resource ] then
			startSet [ resource ] = nil
		else
			cancelEvent ()
			processResource ( resource.name )
			startSet [ resource ] = true
			startResource ( resource )
		end
	end
)
