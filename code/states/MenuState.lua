local MenuState = {}

function MenuState:enter()
  love.graphics.setBackgroundColor(17,17,50)
--  love.graphics.setFont(fonts[12])
end

function MenuState:update(dt)
  gui.group{grow = "down", pos = {windowW-150, windowH-100}, function()
                if gui.Button{text = "Start", size = {100}} then
                  State.switch(GameState)
                end
                if gui.Button{text = "Exit", size = {100}} then
                  love.event.quit()
                end
            end}
end

function MenuState:draw()
  gui.core.draw()
end

function MenuState:mousepressed(x, y, button)
end

function MenuState:mousereleased(x, y, button)
end

return MenuState