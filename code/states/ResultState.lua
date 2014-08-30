local ResultState = {}

function ResultState:enter(previous, score)
  Parallax:init()
  ResultState.highScore = 0
  ResultState.score = score
  love.mouse.setVisible(true)
  if Slib.isFirst() then
    ResultState.highScore = 0
  else
    ResultState.highScore = Slib.load()[1]
  end
  
  if ResultState.highScore < ResultState.score then
    ResultState.highScore = ResultState.score
  end
  Slib.save({ResultState.highScore})
  
  ResultState.text = {
      "Be careful rockets!",
      "Use mouse Left-Button to boost!",
      "Use mouse Right-Button to go in Connected World!",
    }
  ResultState.currentText = ResultState.text[love.math.random(#ResultState.text)]
end

function ResultState:update(dt)
  Parallax:update(dt, dt)
  gui.group{grow = "down", pos = {windowW/2, windowH/2-100}, function()
    gui.Label{text = "Your score is: " .. ResultState.score .. "!", align = "center", size = {1, 25}}
    gui.Label{text = " ", align = "center", size = {1, 25}}
    gui.Label{text = "Your highscore: " .. ResultState.highScore .. "!", align = "center", size = {1, 25}}
    gui.Label{text = " ", align = "center", size = {1, 25}}
    gui.Label{text = "Don't worry! Try Again!", align = "center", size = {1, 25}}
    gui.Label{text = ResultState.currentText, align = "center", size = {1, 25}}
    if gui.Button{text = "Try Again", pos = {-60}, size = {120}} then
      State.switch(GameState)
    end
  end}
end

function ResultState:draw()
  Parallax:draw()
  
  gui.core.draw()
end

function ResultState:keyreleased(key)
end

function ResultState:mousereleased(x,y, button)
end

return ResultState