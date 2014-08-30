local Lava = {}

local LavaBig

function Lava:init()
  Timer.add(23, function(func) 
      lavaBig = LavaBig:new()
      Timer.add(15, function() 
            lavaBig.isDestroy = true
            lavaBig:destroy()
          end)
      Timer.add(math.random(18, 25), func)
      end)
end

function Lava:update(dt)
  if lavaBig ~= nil then
    if not lavaBig.isDestroy then
      lavaBig:update(dt)
    end
  end
end

function Lava:draw()
  if lavaBig ~= nil then
    if not lavaBig.isDestroy then
      lavaBig:draw()
    end
  end
end

LavaBig = Class('Lava')

function LavaBig:initialize()
  local sizes = { 90, 60, 80 }
  self.x = 0
  self.y = 0
  self.r = 30
  self.isDestroy = false
  self.o = Physics.create.circle(love.math.random(0, windowW), windowH+60, sizes[love.math.random(#sizes)], "dynamic")
  self.o.b:setMass(10)
  self.o.b:applyLinearImpulse(0, -1700)
  self.o.f:setUserData({name = 'lava'})
  self.o.f:setSensor(true)
  self.o.f:setFilterData(1, 1, -1)
  self.ps = Particles:new(require('code.particles.lava'), image.circle)
  love.audio.play(sound.lava)
end

function LavaBig:update(dt)
  if not self.isDestroy then
    self.ps:update(dt)
    self.ps:moveTo(self.o.b:getPosition())
    self.x, self.y = self.o.b:getPosition()
  end
  
  if player.isDead then
    sound.lava:stop()
  end
end

function LavaBig:draw()
  ------
  --Physics.draw(self.o, {210, 0, 0})
  love.graphics.setBlendMode("additive")
  love.graphics.draw(self.ps, 0, 0)
  love.graphics.setBlendMode("alpha")
end

function LavaBig:destroy()
  self.o.b:destroy()
  self.ps:stop()
  self.ps = nil
end

return Lava