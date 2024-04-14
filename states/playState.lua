gameplay = require "gameplay"
ship = require "../ship"

local playState = {}

function playState:update(dt) 
    gameplay:execute(dt)
    ship:update(dt)
end

function playState:draw()

    gameplay:drawRocksAndLazers()

    playState:printScore()
    playState:printMessage()
    
    ship:draw()
end

function playState:printScore()

    local font = love.graphics.newFont( "assets/Nicolast.ttf", 30)
    love.graphics.printf(
        ("Score: %d"):format(love.score),
        font,
        0,
        30,
        WINDOW_WIDTH,
        'center')
end

function playState:printMessage()
    local font = love.graphics.newFont( "assets/Nicolast.ttf", 30)
    love.graphics.printf(
        ("PRESS \"SPACEBAR\" TO PAUSE"),
        font,
        0,
        WINDOW_HEIGHT - 30,
        WINDOW_WIDTH,
        'center')
end

return playState