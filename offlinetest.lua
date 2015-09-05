--preprocessor test in vanilla Lua
dofile 'buffer.lua'
dofile 'prep.lua'

src = [[
#print ( arg )
]]

print ( getPreProcessed ( src, "asd" ) )
--[[
for line in src:lines () do
  print ( line )
end
--]]