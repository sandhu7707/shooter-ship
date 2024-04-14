gameplay = require "gameplay"
ship = require "../ship"

local pauseState = {}

function pauseState:update(dt)
end

function pauseState:draw()
    pauseState:printMessage()
    ship:draw()
    gameplay:drawRocksAndLazers()
end

function pauseState:printMessage()
    local font = love.graphics.newFont( "assets/Nicolast.ttf", 60)
    love.graphics.printf(
        ("PRESS \"ENTER\" TO CONTINUE"),
        font,
        0,
        WINDOW_HEIGHT/2,
        WINDOW_WIDTH,
        'center')
end

return pauseState