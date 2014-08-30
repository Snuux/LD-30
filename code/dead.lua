local Dead = {}

local psDead = Dead.ps
local a, lose, count, timer

function Dead:init()
  psDead = Particles:new(require('code.particles.dead'), image.plus)
  psDead:stop()
  a = false
  lose = false
  count = 5.0
end

function Dead:update(dt)
  if player.isDead and not a or count <= 0 then
    a = true
    psDead:start()
    Timer.add(2, function() 
        psDead:stop() 
        Timer.clear()
        local bodies = {}
        if world ~= nil then
          bodies = world:getBodyList()
        end
        
        if stone ~= nil then
        if not stone.isDestroy then
          stone.isDestroy = true
          stone:destroy()
        end end
        
        if lavaBig ~= nil then
        if not lavaBig.isDestroy then
          lavaBig.isDestroy = true
          lavaBig:destroy()
        end end
        
        if single ~= nil then
        if not single.isDestroy then
          single.isDestroy = true
          single:destroy()
        end end
        
        if multi ~= nil then
        if not multi.isDestroy then
          multi.isDestroy = true
          multi:destroy()
        end end
        
        for i,v in ipairs(bodies) do
          --local a = v:getFixtureList()
          --if not a[1]:getUserData().name == 'edge' then
          --  v:destroy()
          --end
        end
        
        
        Tutorial.time = 1
        world = nil
        count = 5.0
        State.switch(ResultState, player.score) 
        end)
  end
  
  if lose then
    gui.group{grow = "down", pos = {windowW/2, windowH/2-150}, function()
        if count >= 0 and count < 6 then
          gui.Label{text = "Until lose: " .. count, align = "center", size = {1, 25}}
        end
    end}
    
    if player.x > 0 - 30 and player.x < windowW and player.y > 0 and player.y < windowH - 30 then
      lose = false
      Timer.cancel(timer)
      count = 5.0
    end
  end
  
  if not lose then
    if player.x < 0 - 30 or player.x > windowW or player.y < 0 or player.y > windowH - 30 then
      lose = true
      count = 5.0
      timer = Timer.addPeriodic(0.1, function() count = count - 0.1 if count < 0 then count = 0 end end)
    end
  end
  
  psDead:update(dt)
  psDead:moveTo(player.x, player.y)
end

function Dead:draw()
  love.graphics.draw(psDead, 0, 0)
end

return Dead