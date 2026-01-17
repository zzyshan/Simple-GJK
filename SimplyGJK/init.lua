local path = ... .. "/"

package.loaded["SimplyGJK/_info"] = {
    path = path,
    search = function(module)
        return package.loaded[path .. module]
    end
}

local mathlib = require(path .. "mathlib")
local gjk = require(path .. "GJK")
local shapes_func = require(path .. "shapes_func")
local shapes = require(path .. "shapes")

return setmetatable(gjk, { __index = shapes })