--preprocessor test in vanilla Lua
dofile 'buffer.lua'
dofile 'prep.lua'

src = [[
print 'loading Fibonacci numbers'
fibonacci = {
  #local a, b = 0, 1
    $(a),
  #for i = 2, 10 do
  #a, b = b, a + b
    $(a),
  #end
}]]

print ( getPreProcessed ( src ) )
--[[
for line in src:lines () do
  print ( line )
end
--]]