local Bonus = {}

local screenBonus

function Bonus:init()
  screenBonus = {}
  Timer.add(1, function(func)
      local sl = ScreenBonus:new()
      table.insert(screenBonus, sl)
      Timer.add(math.random(5, 8), func)
    end)  
end

function Bonus:update(dt)
  
  for i,v in ipairs(screenBonus) do
    if v ~= nil then
      if not v.isDestroy then
        v:update(dt)
      end
    end
  end
  
end

function Bonus:draw()
  
  if screenBonus ~= nil then
  for i,v in ipairs(screenBonus) do
    if v ~= nil then
      if not v.isDestroy then
        v:draw()
      end
    end
  end
  end
  
end


-----Small LASER----

ScreenBonus = Class('Stone')

function ScreenBonus:initialize()
  self.x = windowW + 100
  self.y = math.random(0, windowH)
  self.r = 15
  self.o = Physics.create.circle(self.x, self.y, self.r, 'dynamic')
  self.o.f:setSensor(true)
  self.isDestroy = false
  self.timer = Timer.add(love.math.random(20, 25), function() 
      if self.isDestroy == false then
        self.isDestroy = true
        self.o.b:destroy()
      end
    end)
  local t = require('code.particles.playerFire')
  t.colors[1] = 255
  t.colors[2] = 255
  t.colors[3] = 0
  t.colors[5] = 255
  t.colors[6] = 255
  t.colors[7] = 0
  t.colors[9] = 255
  t.colors[10] = 255
  t.colors[11] = 0
  self.ps = Particles:new(t, image.circle)
  
  self.o.f:setUserData({name = 'bonus', status = 'alive'})
  
  --love.audio.play(sound.laser)
end

function ScreenBonus:update(dt)
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
  
  if self.o.f:getUserData().status == 'dead' then
    self.isDestroy = true
    self.o.b:destroy()
  end
end

function ScreenBonus:draw()
  if not self.isDestroy then
    local bx,by =  self.o.b:getPosition()
    local bodyAngle = self.o.b:getAngle()

    --Physics.draw(self.o)

    love.graphics.push()
    love.graphics.translate(bx,by)
    love.graphics.rotate(bodyAngle)  
      love.graphics.setBlendMode("additive")
      love.graphics.draw(self.ps, 0, 0)--bx, by)
      love.graphics.setBlendMode("alpha")
    love.graphics.pop()
  end
end

function ScreenBonus:destroy()
  self.o.b:destroy()
end

return Bonus