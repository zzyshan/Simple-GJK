local polygon = {
    type = "polygon"
}

local mathlib = package.loaded["SimplyGJK/_info"].search("mathlib")

-- 寻找支持点
function polygon:support(direction)
    local target = self.vertexs
    local best_point = target[1]
    local best_dot = mathlib.dot(best_point, direction)
    
    -- 遍历所有顶点,找点积最大的
    for i = 2, #target do
        local point = target[i]
        local current_dot = mathlib.dot(point, direction)
        
        if current_dot > best_dot then
            best_dot = current_dot
            best_point = point
        end
    end
    
    return best_point
end

-- 定点转化
function polygon:handle_rotation(vertexs, angle)
    local shape = shape or {}
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
end

function polygon:rotate(a)
    self.angle = self.angle + a
    self:handle_rotation(nil, a)
    
    if self:is_concave() then
        for _, collider in ipairs(self.colliders) do
            self:handle_rotation(collider.vertexs, a)
        end
    end
end

function polygon:set_angle(a)
    self:rotate(a - self.angle)
end

-- 矩形获得顶点
function polygon:get_rectangle_vertexs()
    if not self:is_rectangle() then return end
    
    local width, height = self.width * 0.5, self.height * 0.5
    local vertexs = {
        {x = self.x - width, y = self.y - height},
        {x = self.x + width, y = self.y - height},
        {x = self.x - width, y = self.y + height},
        {x = self.x + width, y = self.y + height},
    }
    
    self:handle_rotation(vertexs)
    
    self.vertexs = vertexs
    return vertexs
end

function polygon:get_centroid(polygon)
    if self:is_rectangle() then return end
    local polygon = polygon or self:unpack()
    local triangles = love.math.triangulate(polygon)
    local total_area = 0
    local weighted_x, weighted_y = 0, 0
    
    for _, triangle in ipairs(triangles) do
        local a = {x = triangle[1], y = triangle[2]}
        local b = {x = triangle[3], y = triangle[4]}
        local c = {x = triangle[5], y = triangle[6]}
        
        local area = mathlib.triangle_area(a, b, c)
        local centroid = mathlib.triangle_centroid(a, b, c)
        
        total_area = total_area + area
        weighted_x = weighted_x + centroid.x * area
        weighted_y = weighted_y + centroid.y * area
    end
    
    return weighted_x / total_area, weighted_y / total_area, total_area
end

-- {{x,y},{x2,y2},...} → x,y,x2,y2,...
function polygon:unpack()
    local data = {}
    for _, v in ipairs(self.vertexs) do
        table.insert(data, v.x)
        table.insert(data, v.y)
    end
    
    return data
end

function polygon:is_convex(vertexs)
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
        local currentCross = mathlib.cross(vec1, vec2)
        
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

function polygon:is_concave()
    return self.colliders ~= nil
end

function polygon:is_rectangle()
    return (self.width ~= nil and self.height ~= nil)
end

function polygon:is_triangle()
    return #self.vertexs == 3
end

function polygon:move(xspeed, yspeed)
    for _, v in ipairs(self.vertexs) do
        v.x = v.x + xspeed
        v.y = v.y + yspeed
    end
    self.x = self.x + xspeed
    self.y = self.y + yspeed
end

function polygon:move_to(x, y)
    local xoffset, yoffset = x - self.x, y - self.y
    for _, v in ipairs(self.vertexs) do
        v.x = v.x + xoffset
        v.y = v.y + yoffset
    end
    self.x = x
    self.y = y
end

function polygon:draw(color)
    local color = color or {1, 1, 1, 1}
    love.graphics.setColor(unpack(color))
    if self:is_concave() then
        for _, tr in ipairs(self.colliders) do
            love.graphics.polygon("line", tr:unpack())
        end
    elseif self:is_rectangle() then
        love.graphics.push()
    	love.graphics.translate(self.x, self.y)
    	love.graphics.rotate(math.rad(self.angle))
    	love.graphics.rectangle("line", -self.width*0.5, -self.height*0.5, self.width, self.height)
    	love.graphics.pop()
    else
        love.graphics.polygon("line", self:unpack())
    end
    
    love.graphics.setColor(1, 1, 1, 1)
end

function polygon:remove()
    self = nil
end

return polygon