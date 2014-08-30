State       = require 'libs.hump.gamestate'
Timer       = require 'libs.hump.timer'
Class       = require 'libs.middleclass'
Slib        = require 'libs.slib'
Physics     = require 'libs.ophysics'
Particles   = require 'libs.particles'
gui         = require 'libs.Quickie'
flux        = require "libs.flux"
  
Tutorial    = require 'code.tutorial'
LogoState   = require 'code.states.LogoState'
MenuState   = require 'code.states.MenuState'
GameState   = require 'code.states.GameState'
ResultState = require 'code.states.ResultState'
TutorialState = require 'code.states.TutorialState'
Player      = require 'code.player'
Edges       = require 'code.edges'
Rockets     = require 'code.rockets'
Parallax    = require 'code.parallax'
Lasers      = require 'code.lasers'
Stones      = require 'code.stones'
Dead        = require 'code.dead'
Lava        = require 'code.lava'
Bonus       = require 'code.bonus'

windowW, windowH = love.window.getMode()

function love.load()
  State.registerEvents()
  love.graphics.setBackgroundColor(17,17,40)
  
  love.math.setRandomSeed(os.time())
  
  image = {
    square =        love.graphics.newImage('res/images/square.png'),
    smallSquare =   love.graphics.newImage('res/images/smallSquare.png'),
    circle =        love.graphics.newImage('res/images/circle.png'),
    plus =          love.graphics.newImage('res/images/plus.png'),
    logo =          love.graphics.newImage('res/images/lovelogo.png')
  }
  
  music = { 
    love.audio.newSource('res/music/1.mp3', 'stream'),
  }
  currentMusic = 1
  love.audio.play(music[currentMusic])
  music[1]:setVolume( 1 )
  
  sound = {
    laser       = love.audio.newSource('res/sound/laser.wav'       , 'static'),
    lava        = love.audio.newSource('res/sound/lava.wav'        , 'static'),
    playerDead  = love.audio.newSource('res/sound/playerDead.wav'  , 'static'),
    playerEdge  = love.audio.newSource('res/sound/player-edge.wav' , 'static'),
    rocket      = love.audio.newSource('res/sound/rocket.wav'      , 'static'),
    stones      = love.audio.newSource('res/sound/stones.wav'      , 'static'),
    bonus      = love.audio.newSource('res/sound/bonus.wav'      , 'static'),
    bonusEnd      = love.audio.newSource('res/sound/bonusEnd.wav'      , 'static'),
  }
  
  for i,v in ipairs(sound) do 
    v:setVolume( 0.6 )
  end
  sound['playerEdge']:setVolume( 0.1 )
  
  fonts = {
        [12] = love.graphics.newFont(12),
        [16] = love.graphics.newFont(16),
        [20] = love.graphics.newFont(20),
        [85] = love.graphics.newFont(85)
    }
    love.graphics.setFont(fonts[20])
    
  Slib.init('Slib')
  --State.switch(GameState)
  
  State.switch(LogoState)
end

function love.update(dt)
  if music[currentMusic]:isStopped() then
    currentMusic = currentMusic + 1
    if currentMusic > #music then
      currentMusic = 1
    end
    love.audio.play(music[currentMusic])
  end
  
  windowW, windowH = love.window.getMode()
  scaleW, scaleH = windowW*0.6/800, windowH*0.6/415
end