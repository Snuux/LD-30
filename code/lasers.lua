local Lasers = {}

local smallLasers

function Lasers:init()
  smallLasers = {}
  Timer.add(20, function(func)
      local sl = SmallLaser:new()
      table.insert(smallLasers, sl)
      Timer.add(math.random(10, 25), func)
    end)  
end

function Lasers:update(dt)
  
  for i,v in ipairs(smallLasers) do
    if v ~= nil then
      if not v.isDestroy then
        v:update(dt)
      end
    end
  end
  
end

function Lasers:draw()
  
  if smallLasers ~= nil then
  for i,v in ipairs(smallLasers) do
    if v ~= nil then
      if not v.isDestroy then
        v:draw()
      end
    end
  end
  end
  
end


-----Small LASER----

SmallLaser = Class('Stone')

function SmallLaser:initialize()
  self.x = windowW + 100
  self.y = math.random(0, windowH)
  self.w = 15
  self.h = love.math.random(50, 200)
  self.o = Physics.create.rectangle(self.x, self.y, self.w, self.h, 'dynamic')
  self.o.f:setSensor(true)
  self.type = love.math.random(0, 2) -- 0, 1 - Fixed, 2 - Rotated
  self.speed = love.math.random(0, math.pi*2)
  self.isDestroy = false
  self.timer = Timer.add(love.math.random(20, 25), function() 
        self.isDestroy = true
        self.o.b:destroy()
      end)
  local t = require('code.particles.laser')
  t['area_spread_dy'] = self.h/2
  self.ps = Particles:new(t, image.smallSquare)
  
  if self.type == 0 or self.type == 1 then
    self.o.b:setAngle(self.speed)
  end
  self.o.f:setUserData({name = 'laser'})
end

function SmallLaser:update(dt)
  local body = self.o.b
  if self.type == 2 then
    body:setAngularVelocity(self.speed)
  end
  
  body:setLinearVelocity( -100, 0 )
  
  if not self.isDestroy then
    self.ps:update(dt)
  else
    self.ps:stop()
    self.ps = nil
  end
  --self.ps:setPosition(self.x, self.y)
end

function SmallLaser:draw()
  if not self.isDestroy then
    local bx,by =  self.o.b:getPosition()
    local bodyAngle = self.o.b:getAngle()

    --Physics.draw(self.o)

    love.graphics.push()
    love.graphics.translate(bx,by)
    love.graphics.rotate(bodyAngle)  
      love.graphics.draw(self.ps, 0, 0)--bx, by)
    love.graphics.pop()
  end
end

function SmallLaser:destroy()
  self.o.b:destroy()
end


-----BIG LASER----

local BigLaser = Class('BigLaser')

function BigLaser:initialize()
  self.x = math.random(3,3)
end

return Lasers