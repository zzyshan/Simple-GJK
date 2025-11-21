local GJK = {}

-- 点积
local function dot(point, direction)
    return point.x * direction.x + point.y * direction.y
end

-- 三重积
local function tripleProduct(a, b, c)
    local ac = a.x * c.x + a.y * c.y  -- a·c
    local bc = b.x * c.x + b.y * c.y  -- b·c
    return {
        x = b.x * ac - a.x * bc,
        y = b.y * ac - a.y * bc
    }
end

function GJK.support(shape1, shape2, direction)
    local point1 = shape1:support(direction)
    local point2 = shape2:support({x = -direction.x, y = -direction.y})
    
    return {
        x = point1.x - point2.x,
        y = point1.y - point2.y
    }
end

function GJK.collisions(shape1, shape2)
    local direction = {
        x = shape2.x - shape1.x,
        y = shape2.y - shape1.y
    } -- 初始方向
    
    if direction.x == 0 and direction.y == 0 then
        -- 如果为重合,则使用默认方向
        direction.x = 1
    end
    
    local simplex = { GJK.support(shape1, shape2, direction) }
    direction = {x = -simplex[1].x, y = -simplex[1].y} -- 支撑点指向原点的方向
    
    while true do
        local point = GJK.support(shape1, shape2, direction)
        
        if dot(point, direction) < 0 then
            return false -- 如果没有更远的点,无法碰撞
        end
        
        -- 添加点
        table.insert(simplex, point)
        
        if GJK.handleSimplex(simplex, direction) then
            return true
        end
    end
end

-- 处理单纯型
function GJK.handleSimplex(simplex, direction)
    local a = simplex[#simplex]  -- 最新点
    local b = simplex[#simplex-1] or a
    local ao = {x = -a.x, y = -a.y} -- a点指向原点的方向

    if #simplex == 2 then
        -- 处理线情况
        local ab = {x = b.x - a.x, y = b.y - a.y}
        -- 使用三重积确定下个方向
        local abPerp = tripleProduct(ab, ao, ab)
        
        direction.x, direction.y = abPerp.x, abPerp.y
        return false
    else
        -- 处理单纯型情况
        local c = simplex[1]
        
        local ab = {x = b.x - a.x, y = b.y - a.y}
        local ac = {x = c.x - a.x, y = c.y - a.y}
        
        local abPerp = tripleProduct(ac, ab, ab)
        local acPerp = tripleProduct(ab, ac, ac)
        
        if dot(abPerp, ao) > 0 then
            table.remove(simplex, 1) --删除c点
            direction.x, direction.y = abPerp.x, abPerp.y
            return false
        elseif dot(acPerp, ao) > 0 then
            table.remove(simplex, 2) --删除b点
            direction.x, direction.y = acPerp.x, acPerp.y
            return false
        else
            return true
        end
    end
end

return GJK