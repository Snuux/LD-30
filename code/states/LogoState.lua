local LogoState = {}

local logo = {}

function LogoState:enter()
  logo.a = 255
end

function LogoState:update(dt)
  flux.update(dt)
  flux.to(logo, 2, { a = 0 }):oncomplete(funn)
  --ps:update(dt)
end

function funn()
  State.switch(MenuState)
end

function LogoState:draw()
  local c = {love.graphics.getColor()}
  love.graphics.setColor(255, 255, 255, logo.a)
  love.graphics.print(".", -10, -10)
  love.graphics.draw(image.logo, windowW/2-128, windowH/2-128)
  love.graphics.setColor(c)
end

function LogoState:mousepressed(x, y, button)
end

function LogoState:mousereleased(x, y, button)
end

return LogoState