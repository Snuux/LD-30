State = require 'libs.hump.gamestate'
Timer = require 'libs.hump.timer'
Class = require 'libs.middleclass'
Save = require 'libs.slib'
Physics = require 'libs.ophysics'
Camera = require 'libs.gamera'
Particles = require 'libs.particles'
gui = require 'libs.Quickie'

Tutorial = require 'code.tutorial'
MenuState = require 'code.states.MenuState'
GameState = require 'code.states.GameState'
Player = require 'code.player'
Edges = require 'code.edges'
Rockets = require 'code.rockets'
Parallax = require 'code.parallax'
Lasers = require 'code.lasers'
Stones = require 'code.stones'

windowW, windowH = love.window.getMode()

function love.load()
  State.registerEvents()
  love.graphics.setBackgroundColor(100, 50, 200)
  
  love.math.setRandomSeed(os.time())
  
  image = {
    square =        love.graphics.newImage('res/images/square.png'),
    smallSquare =   love.graphics.newImage('res/images/smallSquare.png'),
    circle =        love.graphics.newImage('res/images/circle.png'),
    plus =          love.graphics.newImage('res/images/plus.png'),
  }
  
  State.switch(MenuState)
end

function love.update(dt)
  windowW, windowH = love.window.getMode()
  scaleW, scaleH = windowW*0.6/800, windowH*0.6/415
end