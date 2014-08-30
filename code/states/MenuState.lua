local MenuState = {}
local name, line, ps, block
local m = {y = 0}
local options = {all = false, sfx = false, graphic = false, music = false}
local slider   = {value = 1.0}
local aa

function MenuState:enter()
  love.graphics.setBackgroundColor(17,17,40)
  m = {y = 0}
  name = {
      x = windowW/2, y = windowH/2, text = "Drop of Light", sx = 0.4, sy = 0.4, a = 0
    }
  line = {
      x1 = windowW-6, y1 = 300, x2 = windowW-5, y2 = 300
    }
  block = {x = windowW-183}
    
  ps = Particles:new(require('code.particles.menu'), image.smallSquare)
  ps:stop()
  
  yMenu = -20
  
  aa = true
  
  textHint = {
    "Tip #1: Use [Left-Click] for boost",
    "Tip #2: Use [Right-Click] for go in Connected World",
    "Tip #3: Collect bonuses with yourself",
    "Tip #4: Don't lose your drop",
    "Tip #5: Thanks to YOU - player!",
  }
  textHintStart = 0
  
  --Timer:add(10, function(func) 
  --      textHintStart = textHintStart + 1
  --      if textHintStart > #textHint then
  --        textHintStart = 1
  --      end
  --      Timer.add(2, func)
  --    end)
  
  --local aa = true
  --Parallax:init()
end

local function fn2()
  ps:stop()
end

local function fn()
  if aa then
    ps:start()
    aa = false
  end
  flux.to(m, 2, {y = 180}):after(block, 2, {x = windowW-350}):oncomplete(fn2)
end

function MenuState:update(dt)
  flux.update(dt)
  --Timer.update(dt)
  --Parallax:update(dt, dt)
  gui.group.push{grow = "down", pos = {windowW-150, windowH-m.y}}
      if gui.Button{text = "Start", size = {100}} then
        State.switch(TutorialState)
      end
      
      --gui.group.push{grow = "left"}
      --if gui.Button{text = "Options", size = {100}} then
      --  options.all = not options.all
      --end
      --
      --if options.all then
      --  gui.group.push{grow = "down"}
      --  love.graphics.setFont(fonts[12])
      --    if gui.Button{text = "SFX", size = {100}} then
      --      options.sfx = not options.sfx
      --    end
      --    
      --    if options.sfx then
      --      gui.Slider{info = slider, size = {100}}
      --      gui.Label{text = slider.value * 100, size = {100}, align = "center"}--("Value: %.2f"):format(slider.value)
      --    end
      --  gui.group.pop{}
      --    if gui.Button{text = "Music", size = {100}} then
      --      options.music = not options.music
      --    end
      --    if gui.Button{text = "Graphics", size = {100}} then
      --      options.graphic = not options.graphic
      --    end
      --  love.graphics.setFont(fonts[20])
      --end
      --gui.group.pop{}
      
      if gui.Button{text = "Exit", size = {100}} then
        love.event.quit()
      end
  gui.group.pop{}
  
  flux.to(name, 2, { x = 200, y = 300, a = 255 }):after(name, 2, { sx = 1, sy = 1 }):after(line, 2, { x1 = 200, y1 = 300 }):oncomplete(fn)
  ps:update(dt)
  ps:moveTo(line.x1, line.y1)
  
end



function MenuState:draw()
  --Parallax:draw()
  gui.core.draw()
  
  local c = {love.graphics.getColor()}
  love.graphics.setColor(50, 100, 255, name.a)
  love.graphics.setFont(fonts[85])
  love.graphics.print(name.text, name.x, name.y, 0, name.sx, name.sy)
  love.graphics.line(line.x1, line.y1, line.x2, line.y2)
  love.graphics.setFont(fonts[20])
  --love.graphics.setColor(c)
  
  love.graphics.setBlendMode("additive")
  love.graphics.draw(ps, 0, 0)--, 200, 300)
  love.graphics.setBlendMode("alpha")
  
  if textHintStart > 0 then
    love.graphics.print(textHint[textHintStart], 290, windowW-200)
  end
  
  love.graphics.setFont(fonts[16])
  love.graphics.print("Ludum Dare #30", windowW-183, 20)
  love.graphics.print("by Snuux", windowW-123, 50)
  love.graphics.setFont(fonts[20])
  
  local c = {love.graphics.getColor()}
  love.graphics.setColor(17,17,40)
  love.graphics.rectangle("fill", block.x, 0, 150, 150)
  love.graphics.setColor(c)
end

function MenuState:mousepressed(x, y, button)
end

function MenuState:mousereleased(x, y, button)
end

return MenuState