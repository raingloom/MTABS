--[[template from luac.mtasa.com/api:
local FROM="example.lua"
local TO="compiled.lua"
fetchRemote( "http://luac.mtasa.com/?compile=1&debug=0&obfuscate=0", function(data) fileSave(TO,data) end, fileLoad(FROM), true )
]]

function compileString ( source, callback, compile, debug, obfuscate, attempts )
	fetchRemote (
		( 'http://luac.mtasa.com/?compile=%d&debug=%d&obfuscate=%d' ):format (
			compile and 1 or 0,
			debug and 1 or 0,
			obfuscate and 1 or 0
		),
		--attempts,
		function ( response, errcode )
			if response:match ( '^ERROR' ) then
				error ( ( "compilation failed with errorcode=%d and response=%s" ):format ( errcode, response ) )
			else
				outputDebugString "compiled"
				callback ( response )
			end
		end,
		source,
		false
	)
	outputDebugString ( "compiling: " .. source	)
end