# Simply GJK

[![中文文档](https://img.shields.io/badge/文档-中文-blue)](README.md) [![English Documentation](https://img.shields.io/badge/Docs-English-green)](README-en.md)

A simple **2D GJK collision detection library** written in **[Lua](https://www.lua.org/)**. <br>
You can use it for collision detection in **[LÖVE](https://love2d.org/)**.

## Introduction to GJK

- **GJK (Gilbert-Johnson-Keerthi)** is an efficient algorithm for collision detection between convex sets.
- It cleverly uses the **Minkowski Difference** to compute collisions quickly.
- The algorithm is elegant and usually gives a result within **3 to 5 iterations**.

## Supported Shapes

Currently supports **polygons and circles** (including concave polygons). <br>
**Support for other shapes may be added in the future?**

## Quick Start

```lua
-- Demonstration using Love2d
local lg = love.graphics

gjk = require("SimplyGJK")

-- Create various shapes
local rectangle1 = gjk.rectangle({100, 100}, 20, 90)
local rectangle2 = gjk.rectangle({150, 100}, 20, 60)
local polygon = gjk.polygon({250, 100, 240, 130, 250, 180, 300, 70})
local circle = gjk.circle({400, 100}, 60)

-- Set rotation angle
rectangle1:set_angle(30)

function love.update(dt)
    -- Update object positions and rotations
    rectangle1:move_to(love.mouse.getPosition())
    rectangle2:rotate(1)
    
    -- Collision detection
    local collision1 = gjk.check(rectangle1, rectangle2)  -- rectangle vs rectangle
    local collision2 = gjk.check(rectangle1, polygon)     -- rectangle vs polygon
    local collision3 = gjk.check(rectangle1, circle)      -- rectangle vs circle
end

function love.draw()
    -- Render all shapes
    circle:draw()
    polygon:draw()
    -- ... more rendering code
end
```

## Performance

- Currently, in the early stages, I have not performed extensive optimizations.
- Techniques like **spatial partitioning** may be considered in the future to enhance performance.

## Contributing

Contributions of all forms are welcome! If you would like to:

- Report a bug
- Suggest a new feature
- Submit code improvements

Please get in touch via:

## Community Support

- **QQ Group**: 3647793002
- **Other Platforms**: Not yet available (suggestions welcome!)

## License

This project is licensed under the Mozilla Public License Version 2.0 - see the [LICENSE](LICENSE) file for details.<br>
**Therefore, if you use or modify this library, remember to make its source code public when distributing (only this library is required).**