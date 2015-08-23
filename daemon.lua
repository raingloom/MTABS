--auto preprocessor daemon
USE_DAEMON = 1
if USE_DAEMON then
	addEventHandler ( 'onResourcePreStart', root,
		function (...)
			local name = getResourceName ( source )
			local buildfile = ':' .. name .. '/build.xml'
			local errmissing = "building %s failed at child #%d: missing `%s` attribute"
			if not File.exists ( buildfile ) then
			cancelEvent ()
			buildfile = XML ( buildfile )
			for i, node in ipairs ( buildfile.children  ) do
				if node.name == 'bssrc' then
					local attr = node.attributes
					local src = attr.src or error ( errmissing:format ( name, i, 'src' ) )
					local target = attr.target or error ( errmissing:format ( name, i, 'target' ) )
					if attr.prep == '1' then
						local srcf = File ( src ) or error ( (''):format ( name, i,  ) )
					end
				end
			end
		end
	)
end