function getPreprocessorIterator ( buffer )
	local code, i = { 'return coroutine.wrap ( function ()' }, 2
	local format = string.format
	for line in buffer:lines () do
		if line:find '%s*#' then
			code [ i ], i = line, i + 1
		else
			local lastPos = 0
			for textBefore, prepScript, endPos in line:gmatch '.*$%((.*)%)()' do
				code [ i ], code [ i + 1 ], i = format ( 'coroutine.yield ( %q );', textBefore ), prepScript, i + 2
				lastPos = endPos
			end
			if lastPos < #line then
				code [ i ], i = format ( 'coroutine.yield ( %q );', line:sub ( lastPos ) ), i + 1
			end
		end
	end
	code [ i + 1 ] = 'end'
	return table.concat ( code, '\n' )
end