# Simply GJK

[![中文文档](https://img.shields.io/badge/Docs-中文-blue)](README.md) [![English Documentation](https://img.shields.io/badge/Docs-English-green)](README-en.md)

A simple 2D GJK collision detection library using **[Lua](https://www.lua.org/)**.<br>
You can use it for collision detection in **[LÖVE](https://love2d.org/)**.

## Introduction to GJK

- **GJK (Gilbert-Johnson-Keerthi)** is an efficient convex set collision detection algorithm
- It cleverly uses Minkowski difference to quickly compute collisions
- The algorithm is elegant and typically produces results within 3-5 iterations

## Supported Shapes

Currently supports **convex polygons and circles**.<br>
**Support for concave polygons, ellipses, and other shapes will be added later.**

## Quick Start

```lua
-- Demonstration using LÖVE
local lg = love.graphics

gjk = require("SimplyGJK")

-- Create various shapes
local Rectangle1 = gjk.Rectangle({100, 100}, 20, 90)
local Rectangle2 = gjk.Rectangle({150, 100}, 20, 60)
local Polygon = gjk.Polygon({250, 100, 240, 130, 250, 180, 300, 70})
local circle = gjk.Circle({400, 100}, 60)

-- Set rotation angle
Rectangle1:setAngle(30)

function love.update(dt)
    -- Update object positions and rotations
    Rectangle1:MoveTo(love.mouse.getPosition())
    Rectangle2:rotate(1)
    
    -- Collision detection
    local collision1 = gjk.collisions(Rectangle1, Rectangle2)  -- Rectangle vs Rectangle
    local collision2 = gjk.collisions(Rectangle1, Polygon)     -- Rectangle vs Polygon
    local collision3 = gjk.collisions(Rectangle1, circle)      -- Rectangle vs Circle
end

function love.draw()
    -- Render all shapes
    love.graphics.circle("fill", circle.x, circle.y, circle.radius)
    love.graphics.polygon("fill", Polygon:unpack())
    -- ... more rendering code
end
```

## Performance

- Currently, as it's in the early stages, I haven't optimized it extensively
- Planning to use techniques like **spatial partitioning** to improve performance in the future

## Contributing

I welcome all forms of contributions! If you'd like to:

- Report bugs
- Suggest new features
- Submit code improvements

Please contact me through the following methods:

## Community Support

- **QQ Group**: 3647793002
- **Other Platforms**: Not yet available (suggestions welcome!)

## License

This project is licensed under the Mozilla Public License Version 2.0 - see the [LICENSE](LICENSE) file for details.<br>
**If you use this library, please remember to open source it when distributing (keep the open source license published)**