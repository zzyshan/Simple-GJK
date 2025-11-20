local path = ...

local gjk = require(path .. "/GJK")
local shapes = require(path .. "/shapes")

local mt = { __index = shapes.create }

return setmetatable(gjk, mt)