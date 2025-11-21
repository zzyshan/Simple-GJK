# Simply GJK

[![中文文档](https://img.shields.io/badge/文档-中文-blue)](README.md) [![English Documentation](https://img.shields.io/badge/Docs-English-green)](README-en.md)

一个使用 **[Lua](https://www.lua.org/)** 简易且对于2D的GJK碰撞库。<br>
你可以在 **[LÖVE](https://love2d.org/)** 中使用它进行碰撞检测。

## GJK介绍

- **GJK (Gilbert-Johnson-Keerthi)** 是一种高效的凸集碰撞检测算法
- 它巧妙利用闵可夫斯基差集来快速计算碰撞。
- 算法优雅,通常在 3-5 次迭代内即可得出结果。

## 兼容形状

目前兼容 **凸边形与圆形**。<br>
**之后会进行凹边形与椭圆等其他形状的兼容。**

## 快速开始

```lua
-- 使用Love进行演示
local lg = love.graphics

gjk = require("SimplyGJK")

-- 创建各种形状
local Rectangle1 = gjk.Rectangle({100, 100}, 20, 90)
local Rectangle2 = gjk.Rectangle({150, 100}, 20, 60)
local Polygon = gjk.Polygon({250, 100, 240, 130, 250, 180, 300, 70})
local circle = gjk.Circle({400, 100}, 60)

-- 设置旋转角度
Rectangle1:setAngle(30)

function love.update(dt)
    -- 更新对象位置和旋转
    Rectangle1:MoveTo(love.mouse.getPosition())
    Rectangle2:rotate(1)
    
    -- 碰撞检测
    local collision1 = gjk.collisions(Rectangle1, Rectangle2)  -- 矩形vs矩形
    local collision2 = gjk.collisions(Rectangle1, Polygon)     -- 矩形vs多边形
    local collision3 = gjk.collisions(Rectangle1, circle)      -- 矩形vs圆形
end

function love.draw()
    -- 渲染所有形状
    love.graphics.circle("fill", circle.x, circle.y, circle.radius)
    love.graphics.polygon("fill", Polygon:unpack())
    -- ... 更多渲染代码
end
```

## 性能

- 目前,因为在初期阶段,我没有对它进行很好的优化
- 之后会考虑使用 **空间划分** 等技术来提升其的性能

## 参与贡献

我欢迎各种形式的贡献！如果您想：
- 报告 Bug
- 建议新功能
- 提交代码改进

请通过以下方式联系我：

## 社区支持

- **QQ 群**: 3647793002
- **其他平台**: 暂未开通 (欢迎建议!)

## 许可证

本项目采用 Mozilla Public License Version 2.0 许可证 - 详见 [LICENSE](LICENSE) 文件。<br>
**所以如果你使用到此库,分发时应记得将其开源(保留开源协议公布出来)**