local GameState = {}

function dist(x1,y1,x2,y2) return math.sqrt((x2-x1)^2 + (y2-y1)^2) end

function GameState:enter()
  world = love.physics.newWorld(0, 50)
  world:setCallbacks(beginContact, endContact, preSolve, postSolve)
  world:setCallbacks(collisionBeginContact, function() collectgarbage() end)
  Physics.initPhysics(world)
  love.mouse.setVisible(false)
  local p = require('code.particles.playerIdle')
  p['colors'][1] = 0
  cursorPS = Particles:new(p, image.smallSquare)

  Tutorial:init()
  
  init = { true, true, true, true }
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
    Rockets:init()
    Lasers:init()
    Stones:init()
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
  end
  Timer.update(dt)
  Tutorial:update(dt)
  
  cursorPS:update(dt)
  cursorPS:moveTo(love.mouse.getPosition())
end

function GameState:draw()
  love.graphics.print('FPS: ' .. love.timer.getFPS(), 10, 10)
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
    Stones:draw()
  end
  
  Tutorial:draw()
  
  love.graphics.draw(cursorPS)
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
  end
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