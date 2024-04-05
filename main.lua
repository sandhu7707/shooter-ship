push = require 'push'
ship = require 'ship'
interface = require 'interface'
controls = require "controls"
gameplay = require "gameplay"

WINDOW_WIDTH, WINDOW_HEIGHT = love.window.getDesktopDimensions();

WINDOW_WIDTH = WINDOW_WIDTH*0.8
WINDOW_HEIGHT = WINDOW_HEIGHT*0.8

VIRTUAL_WIDTH = WINDOW_WIDTH
VIRTUAL_HEIGHT = WINDOW_HEIGHT

SCALE = 5

gameState = "new"
score = 0

debugSwitch = false

function love.load()
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH,WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = true,
        vsync = -1
    })
    mesh = ship:CreateShip()
end

function love.resize(w, h)
    WINDOW_WIDTH = w
    WINDOW_HEIGHT = h
    push:resize(w, h)
end

function love.update(dt)

    if gameState ~= "start" then
        return
    end

    gameplay:execute(dt)

end

function love.draw()
    push:apply('start')
    
    interface:printScore()

    interface:printMessages()

    ship:drawShip(mesh)

    drawRocksAndLazers()


    push:apply('end')
end


function drawRocksAndLazers()
    for k,v in pairs(lazers) do
        love.graphics.circle("fill", v.x, v.y, 2, SCALE, SCALE)
    end
    
    for k,v in pairs(rocks) do
        love.graphics.draw(v.val, v.x, v.y, 0, SCALE, SCALE)
    end
end