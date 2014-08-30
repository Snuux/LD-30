local TutorialState = {}

local x

function TutorialState:enter()
  x = {x1 = 1000, x2 = -1000, x3 = 1000, x4 = -1000, x5 = 1000, x6 = -1000}
end

function TutorialState:update(dt)
  flux.update(dt)
  flux.to(x, 1, {x1 = 0}):after(x, 1, {x2 = 0}):after(x, 1, {x3 = 0}):after(x, 1, {x4 = 0}):after(x, 1, {x5 = 0}):after(x, 1, {x6 = 0})
  gui.group{grow = "down", pos = {windowW/2, windowH/2-100}, function()
    gui.Label{text = "You must protect 'Drop of Light'", align = "center", pos = {x.x1}, size = {1, 25}}
    gui.Label{text = "Collect bonuses, for gain yellow shield", align = "center", pos = {x.x2}, size = {1, 25}}
    gui.Label{text = "Collect bonuses, for gain score", align = "center", pos = {x.x3}, size = {1, 25}}
    gui.Label{text = "You - +1 score. 'Drop of Light' - +10 score", align = "center", pos = {x.x4}, size = {1, 25}}
    gui.Label{text = "And don't lose 'Drop of Light'", align = "center", pos = {x.x5}, size = {1, 25}}
    gui.Label{text = "Now your are ready", align = "center", pos = {x.x6}, size = {1, 25}}
    if gui.Button{text = "Play", pos = {-60}, size = {120}} then
      State.switch(GameState)
    end
  end}
end

function TutorialState:draw()
  
  gui.core.draw()
  love.graphics.rectangle("fill",1,1,1,1)
end

function TutorialState:mousepressed(x, y, button)
end

function TutorialState:mousereleased(x, y, button)
end

return TutorialState