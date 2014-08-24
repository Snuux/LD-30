local Rockets = {}

local single, multi

function Rockets:init()
  Timer.addPeriodic(4, function() 
      local x, y = windowW+50, love.math.random(30, windowH)
      single = SingleRocket:new(x, y)
      Timer.add(3.5, function() 
            single.isDestroy = true
            single:destroy()
          end)
      end)
    
  Timer.addPeriodic(10, function() 
      local x, y, n = windowW+50, love.math.random(-200, windowH), love.math.random(3, 10)
      multi = MultiRocket:new(x, y, n)
      Timer.add(7, function() 
            multi.isDestroy = true
            multi:destroy()
          end)
      end)
end

function Rockets:update(dt)
  if single ~= nil then
    if not single.isDestroy then
      single:update(dt)
    end
  end
  if multi ~= nil then
    if not multi.isDestroy then
      multi:update(dt)
    end
  end
end

function Rockets:draw()
  if single ~= nil then
    if not single.isDestroy then
      single:draw()
    end
  end
  if multi ~= nil then
    if not multi.isDestroy then
      multi:draw()
    end
  end
end

----------SINGLE ROCKET--------
SingleRocket = Class('SingleRocket', Rocket)

function SingleRocket:initialize(x, y)
  self.x = x
  self.y = y
  self.w = 40
  self.h = 10
  self.isDestroy = false
  self.o = Physics.create.rectangle(x, y, self.w, self.h, "dynamic")
  self.o.b:setMass(1)
  self.o.b:applyLinearImpulse(-800, love.math.random(-10, 10))
  self.o.f:setUserData({name = 'rocket'})
  self.ps = Particles:new(require('code.particles.rockets'), image.smallSquare)
end

function SingleRocket:update(dt)
  if not self.isDestroy then
    self.ps:update(dt)
    self.ps:moveTo(self.o.b:getPosition())
  end
end

function SingleRocket:draw()
  --local bx,by = self.o.b:getPosition()
  --local bodyAngle = self.o.b:getAngle()
  --
  --love.graphics.push()
  --love.graphics.translate(bx,by)
  --love.graphics.rotate(bodyAngle)  
  --  love.graphics.polygon("fill", self.o.s:getPoints())
  --love.graphics.pop()
  Physics.draw(self.o, {210, 0, 0})
  
  --local bx,by =  self.o.b:getPosition()
  --local bodyAngle = self.o.b:getAngle()
  --love.graphics.push()
  --love.graphics.translate(bx,by)
  --love.graphics.rotate(bodyAngle)  
    love.graphics.draw(self.ps, 0, 0)--bx, by)
  --love.graphics.pop()
end

function SingleRocket:destroy()
  self.o.b:destroy()
  self.ps:stop()
  self.ps = nil
end

--------MULTI ROCKET--------
MultiRocket = Class('MultiRocket')

function MultiRocket:initialize(x, y, n)
  self.x = x
  self.y = y
  self.w = 40
  self.h = 10
  self.isDestroy = false
  self.o = {}
  for i=1,n do
    local o = Physics.create.rectangle(x, y+20*i, self.w, self.h, "dynamic")
    o.b:setMass(1)
    o.b:applyLinearImpulse(math.random(-600, -900), 0)
    o.f:setUserData({name = 'rocket'})
    o.ps = Particles:new(require('code.particles.rockets'), image.smallSquare)
    table.insert(self.o, o)
  end
end

function MultiRocket:update(dt)
  if not self.isDestroy then
    for i,v in ipairs(self.o) do
      v.ps:update(dt)
      v.ps:moveTo(v.b:getPosition())
    end
  end
end

function MultiRocket:draw()
  for i,v in ipairs(self.o) do
    Physics.draw(v, {210, 0, 0})
    love.graphics.draw(v.ps, 0, 0)--bx, by)
    --love.graphics.polygon("fill", v.s:getPoints())
  end
end

function MultiRocket:destroy()
  for i,v in ipairs(self.o) do
    v.b:destroy()
  end
end

return Rockets