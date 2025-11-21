local function dot(point, direction)
    return point.x * direction.x + point.y * direction.y
end

-- 叉乘
local function cross(u, v)
    return u.x * v.y - u.y * v.x
end

-- 计算三角形面积
local function triangleArea(A, B, C)
    return math.abs(
        (A.x*(B.y-C.y) + B.x*(C.y-A.y) + C.x*(A.y-B.y)) / 2
    )
end

-- 三角形质心
local function triangleCentroid(A, B, C)
    return {
        x = (A.x + B.x + C.x) / 3,
        y = (A.y + B.y + C.y) / 3
    }
end

local shapes = {
    Polygon = {
        support = function(self, direction)
            local bestPoint = self.vertexs[1]
            local bestDot = dot(bestPoint, direction)
            
            -- 遍历所有顶点,找点积最大的
            for i = 2, #self.vertexs do
                local point = self.vertexs[i]
                local currentDot = dot(point, direction)
                
                if currentDot > bestDot then
                    bestDot = currentDot
                    bestPoint = point
                end
            end
            
            return bestPoint
        end,
        HandleRotation = function(self, vertexs, angle)
            local vertexs = vertexs or self.vertexs
            local angle = math.rad(angle or 0)
            local cos = math.cos(angle)
            local sin = math.sin(angle)
            
            -- 旋转顶点
            for _, vertex in ipairs(vertexs) do
                local dx = vertex.x - self.x
                local dy = vertex.y - self.y
                vertex.x = self.x + dx * cos - dy * sin
                vertex.y = self.y + dx * sin + dy * cos
            end
        end,
        -- {{x,y},{x2,y2},...} → x,y,x2,y2,...
        unpack = function(self)
            local data = {}
            for _, v in ipairs(self.vertexs) do
                table.insert(data, v.x)
                table.insert(data, v.y)
            end
            
            return data
        end,
        rotate = function(self, a)
            self.angle = self.angle + a
            self:HandleRotation(nil, a)
        end,
        setAngle = function(self, a)
            self:rotate(a - self.angle)
        end,
        Move = function(self, xspeed, yspeed)
            for _, v in ipairs(self.vertexs) do
                v.x = v.x + xspeed
                v.y = v.y + yspeed
            end
            self.x = self.x + xspeed
            self.y = self.y + yspeed
        end,
        MoveTo = function(self, x, y)
            local xoffset, yoffset = x - self.x, y - self.y
            for _, v in ipairs(self.vertexs) do
                v.x = v.x + xoffset
                v.y = v.y + yoffset
            end
            self.x = x
            self.y = y
        end,
        Remove = function(self)
            self = nil
        end
    },
    circle = {
        support = function(self, direction)
            local dx, dy = direction.x, direction.y
            local length = math.sqrt(dx * dx + dy * dy)
            
            if length > 0 then
                dx = dx / length
                dy = dy / length
            else
                return {x = self.x + self.radius, y = self.y}
            end
            
            return {
                x = self.x + self.radius * dx,
                y = self.y + self.radius * dy
            }
        end,
        Move = function(self, xspeed, yspeed)
            self.x = self.x + xspeed
            self.y = self.y + yspeed
        end,
        MoveTo = function(self, x, y)
            self.x = x
            self.y = y
        end,
        Remove = function(self)
            self = nil
        end
    },
    create = {}
}
local create = shapes.create

local mt = { __index = shapes.Polygon }
local mt2 = { __index = shapes.circle }

function create.Rectangle(position, w, h, a)
    local rectangle = setmetatable({}, mt)
    rectangle.x, rectangle.y = unpack(position)
    rectangle.width, rectangle.height = w, h
    rectangle.angle = a or 0
    rectangle.type = "rectangle"
    rectangle.vertexs = {}
    rectangle:getRectangleVertexs()
    
    return rectangle
end

function shapes.Polygon:getRectangleVertexs()
    if self.type ~= "rectangle" then return end
    
    local width, height = self.width * 0.5, self.height * 0.5
    local vertexs = {
        {x = self.x - width, y = self.y - height},
        {x = self.x + width, y = self.y - height},
        {x = self.x - width, y = self.y + height},
        {x = self.x + width, y = self.y + height},
    }
    
    self:HandleRotation(vertexs)
    
    self.vertexs = vertexs
    return vertexs
end

function create.Polygon(points, a)
    local vertexs = {}
    for i = 1, #points, 2 do
        if points[i] and points[i+1] then
            table.insert(vertexs, {x = points[i], y = points[i+1]})
        end
    end
    
    local Polygon = setmetatable({}, mt)
    
    local isConvex = Polygon:isConvex(vertexs)
    
    if not isConvex then print("Error:Not convex") Polygon = nil return false end
    
    Polygon.vertexs = vertexs
    Polygon.x, Polygon.y = Polygon:getCentroid(points)
    Polygon.angle = a or 0
    Polygon.type = "polygon"
    
    return Polygon
end

function shapes.Polygon:isConvex(vertexs)
    local vertexs = vertexs or self.vertexs
    local n = #vertexs
    if n < 3 then return false end
    
    local prevcross  -- 记录上一个叉乘方向
    
    for i = 1, n do
        -- 以一个顺序来顺序获取顶点
        local v1 = vertexs[i]
        local v2 = vertexs[(i % n) + 1]
        local v3 = vertexs[((i + 1) % n) + 1]
        
        -- 计算3点连接两线的向量,并求出叉乘
        local vec1 = {x = v2.x - v1.x, y = v2.y - v1.y}
        local vec2 = {x = v3.x - v2.x, y = v3.y - v2.y}
        local currentCross = cross(vec1, vec2)
        
        if not prevcross then
            if currentCross ~= 0 then
                prevcross = currentCross -- 确认方向
            end
        else
            if currentCross ~= 0 and currentCross * prevcross < 0 then
                return false -- 如果方向不同,这是凹边形
            end
        end
    end
    
    return true
end

function shapes.Polygon:getCentroid(polygon)
    if self.type == "rectangle" then return end
    local polygon = polygon or self:unpack()
    local triangles = love.math.triangulate(polygon)
    local total_area = 0
    local weighted_x, weighted_y = 0, 0
    
    for _, triangle in ipairs(triangles) do
        local a = {x = triangle[1], y = triangle[2]}
        local b = {x = triangle[3], y = triangle[4]}
        local c = {x = triangle[5], y = triangle[6]}
        
        local area = triangleArea(a, b, c)
        local centroid = triangleCentroid(a, b, c)
        
        total_area = total_area + area
        weighted_x = weighted_x + centroid.x * area
        weighted_y = weighted_y + centroid.y * area
    end
    
    return weighted_x / total_area, weighted_y / total_area, total_area
end

function create.Circle(position, radius)
    local circle = setmetatable({}, mt2)
    circle.x, circle.y = unpack(position)
    circle.radius = radius
    circle.type = "circle"
    
    return circle
end

return shapes