local camera = {}
camera.x = 0
camera.y = 0
camera.scaleX = 1
camera.scaleY = 1
camera.rotation = 0

function camera:set()
  love.graphics.push()
  love.graphics.rotate(-self.rotation)
  love.graphics.scale(1 / self.scaleX, 1 / self.scaleY)
  love.graphics.translate(-self.x, -self.y)
end

function camera:unset()
  love.graphics.pop()
end

function camera:move(dx, dy)
  self.x = self.x + (dx or 0)
  self.y = self.y + (dy or 0)
end

function camera:rotate(dr)
  self.rotation = self.rotation + dr
end

function camera:scale(sx, sy)
  sx = sx or 1
  self.scaleX = self.scaleX * sx
  self.scaleY = self.scaleY * (sy or sx)
end

function camera:setPosition(x, y)
  self.x = x or self.x
  self.y = y or self.y
end

function camera:setScale(sx, sy)
  self.scaleX = sx or self.scaleX
  self.scaleY = sy or self.scaleY
end

camera.layers = {}

function camera:newLayer(scale, func)
  table.insert(self.layers, { draw = func, scale = scale })
  table.sort(self.layers, function(a, b) return a.scale < b.scale end)
end

function camera:draw()
  local bx, by = self.x, self.y
  
  for _, v in ipairs(self.layers) do
    self.x = bx * v.scale
    self.y = by * v.scale
    camera:set()
    v.draw()
    camera:unset()
  end
end

local Parallax = {}

function Parallax:init()
  camera.layer = {}
  
  for i = .5, 3, .5 do
    local rectangles = {}
    local random = love.math.random
    for j = 1, math.random(2, 300) do
      local wh = random(3, 7)
      table.insert(rectangles, {
        random(0, 15600),
        random(0, 1500),
        wh,
        wh,
        color = { random(0, 255), random(0, 255), random(0, 255) }
      })
    end
    
    camera:newLayer(i, function()
      for _, v in ipairs(rectangles) do
        love.graphics.setColor(v.color)
        
        love.graphics.rectangle('fill', unpack(v))
        love.graphics.setColor(255, 255, 255)
      end
    end)
  end
  
  Parallax.spdX = 0
end

function Parallax:update(dt, py)
  Parallax.spdX = Parallax.spdX + 20*dt
  camera:setPosition(Parallax.spdX * 2, py * 2)
end

function Parallax:draw()
  camera:draw()
end

return Parallax