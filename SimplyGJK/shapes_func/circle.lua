local circle = {
    type = "circle"
}

function circle:support(direction)
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
end

function circle:move(xspeed, yspeed)
    self.x = self.x + xspeed
    self.y = self.y + yspeed
end
function circle:move_to(x, y)
    self.x = x
    self.y = y
end

function circle:draw(color)
    local color = color or {1, 1, 1, 1}
    love.graphics.setColor(unpack(color))
    love.graphics.circle("line", self.x, self.y, self.radius)
    love.graphics.setColor(1, 1, 1, 1)
end

function circle:remove()
    self = nil
end

return circle