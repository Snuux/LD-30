local Player = Class('Player')

Player.static.alive = false

function Player:initialize(x, y)
  self.x = x
  self.y = y
  self.r = 15
  self.o = Physics.create.circle(x, y, self.r, "dynamic")
  self.o.b:setMass(10)
  self.o.f:setUserData({name = 'player', status = 'alive'})
  Player.static.alive = true
  self.ps = Particles:new(require('code.particles.playerIdle'), image.circle)
  self.fire = Particles:new(require('code.particles.playerFire'), image.square)
  self.fire:stop()
  self.invisible = Particles:new(require('code.particles.playerInvisible'), image.circle)
  self.invisible:stop()
  self.bgtemp = {}
  self.invisibleB = false
  self.fireB = false
  self.score = 0
  self.invisibleC = 5
  self.invisibleF = true --future
  
  Timer.addPeriodic(1, function()
      self.invisibleC = self.invisibleC + 1
      if self.invisibleC > 5 then
        self.invisibleC = 5
        self.invisibleF = true
      end
      end)
  
  self.isDead = false
end

function Player:update(dt)
  local o = self.o
  o.b:applyLinearImpulse( 0.2, 0 )

  --if love.keyboard.isDown('w') then
  --  o.b:applyForce( 0, -1200 )
  --elseif love.keyboard.isDown('d') then
  --  o.b:applyForce( 1200, 0 )
  --end
  
  if love.mouse.isDown('l') then
    o.b:applyForce( 2000, 0 )
    self.fire:start()
    self.fireB = true
  elseif love.mouse.isDown('r') and self.invisibleF then
    self.invisibleC = self.invisibleC - 1
    self.invisibleB = true
    love.graphics.setBackgroundColor(150, 50, 50)
    o.b:setActive(false)
    self.invisible:start()
  end

  if self.invisibleC <= 0 then
    self.invisibleF = false
  end
  
  --print(self.o.f:getUserData().status)
  if self.o.f:getUserData().status == 'dead' then
    self.isDead = true
  end
  
  self.x, self.y = o.b:getPosition()
  
  self.ps:update(dt)
  self.fire:update(dt)
  self.invisible:update(dt)
  self.ps:moveTo(self.x, self.y)
  self.fire:moveTo(self.x, self.y)
  self.invisible:moveTo(self.x, self.y)
end

function Player:draw()
  --love.graphics.push()
  --love.graphics.translate(-self.x, -self.y)
  love.graphics.setBlendMode("additive")
  if self.invisibleB then
    love.graphics.draw(self.invisible, 0, 0)
  else
    love.graphics.draw(self.fire, 0, 0)
    love.graphics.draw(self.ps, 0, 0)--self.o.b:getX(), self.o.b:getY())
    love.graphics.circle("fill", self.o.b:getX(), self.o.b:getY(), self.r, 10)
  end  
 
  love.graphics.setBlendMode("alpha")
  --love.graphics.pop()
end

function Player:mousereleased(x, y, button)
  if button == 'r' then
    self.invisibleB = false
    self.o.b:setActive(true)
    self.invisible:stop()
    love.graphics.setBackgroundColor(self.bgtemp )
  end
  
  if button == 'l' then
    self.fireB = false
    self.fire:stop()
  end
end

function Player:mousepressed(x, y, button)
  self.bgtemp = {love.graphics.getBackgroundColor()}
end

return Player