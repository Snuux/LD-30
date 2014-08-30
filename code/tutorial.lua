local Tutorial = {}

function Tutorial:init()
  Tutorial.s = 0
  
  Tutorial.time = 1
end

function Tutorial:update(dt)
  local t = Tutorial.time
  
  gui.group{grow = "down", pos = {windowW/2, windowH/2}, function()
      if t == 1 then
        gui.Label{text = "[Left-Click] to continue", align = "center", size = {1, 1}}
      elseif t == 2 then
        gui.Label{text = "A long time ago in a galaxy far, far away...", align = "center", size = {1, 1}}
      elseif t == 3 then
        gui.Label{text = "(Oh, pardon, it's not Star Wars...)", align = "center", size = {1, 1}}
      elseif t == 4 then
        gui.Label{text = "[Left-Click] to start create yourself", align = "center", size = {1, 1}}
        Tutorial.s = 1
      elseif t == 5 then
        gui.Label{text = "Move your mouse! (And then press [Left-Click])", align = "center", size = {1, 1}}
      elseif t == 6 then
        gui.Label{text = "Congratulations! You Finish Game! Press [Left-Click] for exit", align = "center", size = {1, 1}}
      elseif t == 7 then
        gui.Label{text = "( it's joke...=) )", align = "center", size = {1, 1}}
      elseif t == 8 then
        gui.Label{text = "And now - your mission - don't lose him! [Left-Click]", align = "center", size = {1, 1}}
        Tutorial.s = 2
      elseif t == 9 then
        gui.Label{text = "Yellow bonuses you must collect! Good luck [Left-Click]", align = "center", size = {1, 1}}
        Tutorial.s = 3
      end
  end}

  if t >= 10 and t < 20 then
    gui.group{grow = "down", pos = {windowW/2, windowH - 100}, function()
          love.graphics.setFont(fonts[16])
          gui.Label{text = "[Left-Click] to boost your 'friend'!", align = "center", size = {1, 25}}
          gui.Label{text = "[Right-Click] to move him in CONNECTED world!", align = "center", size = {1, 25}}
          love.graphics.setFont(fonts[20])
        end}
  end
end

function Tutorial:draw()
  --gui.core.draw()
end

function Tutorial:mousepressed(x, y, button)
  if button == 'l' then
    Tutorial.time = Tutorial.time + 1
  end
end

return Tutorial