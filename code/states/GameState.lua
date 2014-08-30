local GameState = {}

function dist(x1,y1,x2,y2) return math.sqrt((x2-x1)^2 + (y2-y1)^2) end

function GameState:enter()
  love.graphics.setBackgroundColor(17,17,40)
  world = love.physics.newWorld(0, 50)
  world:setCallbacks(beginContact, endContact, preSolve, postSolve)
  --world:setCallbacks(collisionBeginContact, function() collectgarbage() end)
  Physics.initPhysics(world)
  love.mouse.setVisible(false)
  local p = require('code.particles.playerIdle')
  p['colors'][1] = 0
  cursorPS = Particles:new(p, image.smallSquare)

  Tutorial:init()
  Dead:init()
  
  wallPS = {
    r = Particles:new(require('code.particles.wallH'), image.smallSquare), --right
    l = Particles:new(require('code.particles.wallH'), image.smallSquare), --left
    u = Particles:new(require('code.particles.wallW'), image.smallSquare), --up
    d = Particles:new(require('code.particles.wallW'), image.smallSquare), --down
  }
  wallPS.r:stop()
  wallPS.l:stop()
  wallPS.u:stop()
  wallPS.d:stop()
  
  walls = Physics.create.chain(true, {20, 20, 20, windowH-20, windowW-20, windowH-20, windowW-20, 20}, 'kinematic')
  walls.f:setUserData({name = 'walls'})
  walls.f:setFriction(0.5)
  walls.f:setRestitution(0.5)
  walls.f:setFilterData(1, 1, -1)
  walls.f:setSensor( true )
  
  init = { true, true, true, true }
  
  plusOne = {amount = 1, status = false, a = 255, toY = 0, x = 0, y = 0, logic = false}
end

function GameState:update(dt)
  if Tutorial.s == 0 and init[1] then
    Parallax:init()
    init[1] = not init[1]
  elseif Tutorial.s == 1 and init[2] then
    Edges:init()
    init[2] = not init[2]
  elseif Tutorial.s == 2 and init[3] then
    player = Player:new(400, 200)
    init[3] = not init[3]
  elseif Tutorial.s == 3 and init[4] then
    Dead:init()
    Rockets:init()
    Lasers:init()
    Stones:init()
    Lava:init()
    Bonus:init()
    init[4] = not init[4]
  end
  
  world:update(dt)
  
  if Tutorial.s == 0 then
    Parallax:update(dt, dt)
  elseif Tutorial.s == 1 then
    Parallax:update(dt, dt)
    Edges:update(dt)
  elseif Tutorial.s == 2 then
    Edges:update(dt)
    if player ~= nil then player:update(dt) end
    Parallax:update(dt, player.y)
  elseif Tutorial.s == 3 then
    Edges:update(dt)
    player:update(dt)
    Parallax:update(dt, player.y)
    Rockets:update(dt)
    Lasers:update(dt)
    Stones:update(dt)
    Dead:update(dt)
    Lava:update(dt)
    Bonus:update(dt)
    flux.update(dt)
    if plusOne.status then
      local aa = plusOne.toY
      flux.to(plusOne, 2, {y = aa, a = 0})--:oncomplete(fff)
    end
    gui.group{grow = "down", pos = {100, 20}, function()
      gui.Label{text = "Your score is: " .. player.score, align = "center", size = {1, 25}}
    end}
  end
  Timer.update(dt)
  Tutorial:update(dt)
  
  
  
  
  wallPS.r:update(dt)
  wallPS.l:update(dt)
  wallPS.u:update(dt)
  wallPS.d:update(dt)
  wallPS.r:setPosition(20, windowH/2)
  wallPS.l:setPosition(windowW-20, windowH/2)
  wallPS.u:setPosition(windowW/2, 20)
  wallPS.d:setPosition(windowW/2, windowH-20)
  
  cursorPS:update(dt)
  cursorPS:moveTo(love.mouse.getPosition())
  
  
end

function fff()
  plusOne.logic = false
end

function GameState:draw()
  --love.graphics.print('FPS: ' .. love.timer.getFPS(), 10, 10)
  love.graphics.rectangle("fill", 1, 1, 1, 1)
  
  if Tutorial.s == 0 then
    Parallax:draw()
  elseif Tutorial.s == 1 then
    Parallax:draw()
    Edges:draw()
  elseif Tutorial.s == 2 then
    Parallax:draw()
    Edges:draw()
    if player ~= nil then player:draw() end
  elseif Tutorial.s == 3 then
    Parallax:draw()
    Edges:draw()
    player:draw()
    Rockets:draw()
    Lasers:draw()
    Lava:draw()
    Stones:draw()
    Dead:draw()
    Bonus:draw()
  end
  
  love.graphics.draw(wallPS.r)
  love.graphics.draw(wallPS.l)
  love.graphics.draw(wallPS.u)
  love.graphics.draw(wallPS.d)
  
  Tutorial:draw()
  
  --love.graphics.setBlendMode("additive")
    love.graphics.draw(cursorPS)
  --love.graphics.setBlendMode("alpha")
  
  if plusOne.status then
    local c = {love.graphics.getColor()}
    love.graphics.setColor(0, 255, 255, plusOne.a)
    love.graphics.print('+' .. plusOne.amount, plusOne.x, plusOne.y)
    love.graphics.setColor(c)
  end
  gui.core.draw()
  --Physics.debugDraw()
end

function GameState:mousepressed(x, y, button)
  if Tutorial.s > 0 then
    Edges:mousepressed(x, y, button)
  end
  Tutorial:mousepressed(x, y, button)
  if Tutorial.s > 1 then
    if player ~= nil then player:mousepressed(x, y, button) end
  end
end

function GameState:mousereleased(x, y, button)
  if Tutorial.s > 1 then
    if player ~= nil then player:mousereleased(x, y, button) end
  end
end

function GameState:keypressed(key, isrepeat)
  if key == 'escape' then
    Timer.clear()
    local bodies = world:getBodyList()
    for i,v in ipairs(bodies) do
      local a = v:getFixtureList()
      if not a[1]:getUserData().name == 'edge' then
        v:destroy()
      end
    end
    Tutorial.time = 1
    world = nil
    love.mouse.setVisible(true)
    State.switch(MenuState)
  end
end

function beginContact(a, b, coll)
  local x, y = coll:getNormal()
  local aB = a:getBody()
  local bB = b:getBody()
  local aN = a:getUserData().name
  local bN = b:getUserData().name
  
  if aN == 'edge' and bN == 'player' or aN == 'player' and bN == 'edge' then
    
  end
  
  if aN == 'rocket' and bN == 'player' or aN == 'player' and bN == 'rocket' then
    local a, b
    if aN == 'rocket' and bN == 'player' then
      a, b = aB, bB
    else
      b, a = aB, bB
    end
    
    local xx, yy = a:getLinearVelocity()
    b:applyLinearImpulse(xx*15, yy*15)
  end
  
  if aN == 'laser' and bN == 'player' or aN == 'player' and bN == 'laser' then
    local af, bf
    if aN == 'laser' and bN == 'player' then
      af, bf = a, b
    else
      bf, af = a, b
    end
    bf:setUserData({status = 'dead'})
    love.audio.play(sound.playerDead)
  end
  
  if aN == 'lava' and bN == 'player' or aN == 'player' and bN == 'lava' then
    local af, bf
    if aN == 'lava' and bN == 'player' then
      af, bf = a, b
    else
      bf, af = a, b
    end
    bf:setUserData({status = 'dead'})
    love.audio.play(sound.playerDead)
  end
  
  if aN == 'player' or bN == 'player' then
    love.audio.play(sound.playerEdge)
  end
  
  if aN == 'edge' and bN == 'bonus' or aN == 'bonus' and bN == 'edge' then
    local af, bf
    if aN == 'edge' and bN == 'bonus' then
      af, bf = a, b
    else
      bf, af = a, b
    end
    bf:setUserData({status = 'dead'})
    
    player.score = player.score + 1
    createWall()
    plusOne.status = true
    plusOne.x, plusOne.y = bB:getPosition()
    plusOne.amount = 1
    plusOne.toY = plusOne.y - 20
    Timer.add(3, deleteWall)
    
    love.audio.play(sound.bonus)
  end
  
  if aN == 'player' and bN == 'bonus' or aN == 'bonus' and bN == 'player' then
    local af, bf
    if aN == 'player' and bN == 'bonus' then
      af, bf = a, b
    else
      bf, af = a, b
    end
    bf:setUserData({status = 'dead'})
    
    plusOne.status = true
    plusOne.x, plusOne.y = bB:getPosition()
    plusOne.amount = 10
    player.score = player.score + 10
    plusOne.toY = plusOne.y - 20

    createWall()
    Timer.add(3, deleteWall)
    
    love.audio.play(sound.bonus)
  end
end

function createWall()
  walls.f:setSensor(false)
  wallPS.r:start()
  wallPS.l:start()
  wallPS.u:start()
  wallPS.d:start()
end

function deleteWall()
  walls.f:setSensor(true)
  wallPS.r:stop()
  wallPS.l:stop()
  wallPS.u:stop()
  wallPS.d:stop()
  plusOne.status = false
  love.audio.play(sound.bonusEnd)
end

function endContact(a, b, coll)
end

function preSolve(a, b, coll)
end

function postSolve(a, b, coll, normalimpulse1, tangentimpulse1, normalimpulse2, tangentimpulse2)
end

--function GameState.keypressed(key, isrepeat)
--  if key == ' ' then
--    love.load()
--  elseif key == 'escape' then
--    love.event.push('q')
--  end
--end

return GameState