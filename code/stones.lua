local Stones = {}

local stone

function Stones:init()
  Timer.add(15, function(func) 
      local n = love.math.random(5, 10)
      stone = Stone:new(n)
      Timer.add(9, function() 
            stone.isDestroy = true
            stone:destroy()
          end)
      Timer.add(math.random(11, 20), func)
      end)
end

function Stones:update(dt)
  if stone ~= nil then
    if not stone.isDestroy then
      stone:update(dt)
    end
  end
end

function Stones:draw()
  if stone ~= nil then
    if not stone.isDestroy then
      stone:draw()
    end
  end
end

Stone = Class('Stone')

function Stone:initialize(n)
  local sizes = { 15, 20, 30 }
  self.isDestroy = false
  self.o = {}
  local speedAngles = { -50, -20, 10, 30, 60 }
  for i=1,n do
    local o = Physics.create.circle(love.math.random(0, windowW), 0-30, sizes[love.math.random(#sizes)], "dynamic")
    o.b:setMass(math.random(40, 60))
    o.b:applyLinearImpulse(speedAngles[love.math.random(#speedAngles)], love.math.random(600, 1000))
    o.segments = love.math.random(5, 7)
    o.f:setUserData({name = 'stone'})
    table.insert(self.o, o)
  end
end

function Stone:update(dt)
  
end

function Stone:draw()
  for i,o in ipairs(self.o) do
    --local o = v.o
    local bx,by =  o.b:getPosition()
    local bodyAngle = o.b:getAngle()
    local shapeType = o.s:getType()
    
    love.graphics.setColor(40, 10, 180)
    love.graphics.push()
      love.graphics.translate(bx,by)
      love.graphics.rotate(bodyAngle)  
      love.graphics.circle("fill", 0, 0, o.s:getRadius(), o.segments)
    love.graphics.pop()
    love.graphics.setColor(255, 255, 255)
    --love.graphics.polygon("fill", v.s:getPoints())
  end
end

function Stone:destroy()
  for i,v in ipairs(self.o) do
    v.b:destroy()
  end
end

return Stones