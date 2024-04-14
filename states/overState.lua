gameplay = require "gameplay"
ship = require "../ship"

local overState = {}

function overState:update(dt)
end

function overState:draw()
    overState:printMessage()
    ship:draw()
    gameplay:drawRocksAndLazers()
end

function overState:printMessage()
    local font = love.graphics.newFont( "assets/Nicolast.ttf", 60)
    love.graphics.printf(
        ("GAME OVER, FINAL SCORE: %d"):format(love.score),
        font,
        0,
        WINDOW_HEIGHT/2,
        WINDOW_WIDTH,
        'center')
end

return overState