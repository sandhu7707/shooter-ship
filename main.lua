debug = require 'debug'
background = require 'background'
stateMachine = require "stateMachine"

WINDOW_WIDTH, WINDOW_HEIGHT = love.window.getDesktopDimensions();

WINDOW_HEIGHT = WINDOW_HEIGHT*0.8
WINDOW_WIDTH = WINDOW_WIDTH*0.8

SCALE = 5

gameState = "new"
love.score = 0

debugSwitch = false


function love.load()
    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = true,
        vsync = -1
    })
end

function love.resize(w, h)
    WINDOW_WIDTH = w
    WINDOW_HEIGHT = h
end

function love.update(dt)

    background:updateBackground(dt)

    stateMachine:update(dt)
end

function love.draw()
    
    background:drawBackground()

    stateMachine:draw()
end

function love.mousepressed(x, y, button, istouch, presses)
    LAUNCH_LAZER = true;
end

function love.mousereleased(x, y, button, istouch, presses)
    LAUNCH_LAZER = false
end

function love.keypressed(key)
    if key=="enter" or key=="return" then
        stateMachine:changeState(stateMachine.states.play)
    elseif key =="space" or key=="spacebar" then
        stateMachine:changeState(stateMachine.states.pause)
    elseif key =="D" or key=="d" then
        debugSwitch = true
    end
end
