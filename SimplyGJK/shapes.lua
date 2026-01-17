local shapes = {}

local func = package.loaded["SimplyGJK/_info"].search("shapes_func")
local polygon_func = { __index = func.polygon }
local circle_func = { __index = func.circle }

function shapes.rectangle(position, w, h, a)
    local self = setmetatable({}, polygon_func)
    self.x, self.y = unpack(position)
    self.width, self.height = w, h
    self.angle = a or 0
    self.vertexs = {}
    self:get_rectangle_vertexs()
    
    return self
end

function shapes.triangle(points, a)
    if #points ~= 6 then print("Warning: Not a triangle") return end
    
    local vertexs = {}
    for i = 1, #points, 2 do
        if points[i] and points[i+1] then
            table.insert(vertexs, {x = points[i], y = points[i+1]})
        end
    end
    
    local self = setmetatable({}, polygon_func)
    self.vertexs = vertexs
    self.x, self.y = self:get_centroid(points)
    self.angle = a or 0
    
    return self
end

function shapes.polygon(points, a)
    local vertexs = {}
    for i = 1, #points, 2 do
        if points[i] and points[i+1] then
            table.insert(vertexs, {x = points[i], y = points[i+1]})
        end
    end
    
    local self = setmetatable({}, polygon_func)
    self.vertexs = vertexs
    self.x, self.y = self:get_centroid(points)
    self.angle = a or 0
    
    if not self:is_convex(vertexs) then
        local triangles = love.math.triangulate(points)
        local converted_triangles = {}
        
        for i, tri in ipairs(triangles) do
            table.insert(converted_triangles, shapes.triangle(tri))
        end
        
        self.colliders = converted_triangles
    end    
    
    return self
end

function shapes.circle(position, radius)
    local self = setmetatable({}, circle_func)
    self.x, self.y = unpack(position)
    self.radius = radius
    
    return self
end

return shapes