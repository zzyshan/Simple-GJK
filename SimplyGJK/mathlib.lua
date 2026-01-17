local mathlib = {}

-- 点积
function mathlib.dot(point, direction)
    return point.x * direction.x + point.y * direction.y
end

-- 三重积
function mathlib.triple_product(a, b, c)
    local ac = a.x * c.x + a.y * c.y  -- a·c
    local bc = b.x * c.x + b.y * c.y  -- b·c
    return {
        x = b.x * ac - a.x * bc,
        y = b.y * ac - a.y * bc
    }
end

-- 叉乘
function mathlib.cross(u, v)
    return u.x * v.y - u.y * v.x
end

-- 计算三角形面积
function mathlib.triangle_area(A, B, C)
    return math.abs(
        (A.x*(B.y-C.y) + B.x*(C.y-A.y) + C.x*(A.y-B.y)) / 2
    )
end

-- 三角形质心
function mathlib.triangle_centroid(A, B, C)
    return {
        x = (A.x + B.x + C.x) / 3,
        y = (A.y + B.y + C.y) / 3
    }
end

return mathlib