local path = ...

local polygon = require(path .. "/polygon")
local circle = require(path .. "/circle")

return {
    polygon = polygon,
    circle = circle
}