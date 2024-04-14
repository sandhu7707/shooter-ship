ship = require "../ship"

local titleState = {}

function titleState:update(dt)
    ship:update(dt)
end

function titleState:draw()

    titleState:printMessage()
    ship:draw()
end

function titleState:printMessage()
    
    local font = love.graphics.newFont( "assets/Nicolast.ttf", 60)
    love.graphics.printf(
        ("PRESS \'ENTER\' TO START"),
        font,
        0,
        WINDOW_HEIGHT/2,
        WINDOW_WIDTH,
        'center')
end

return titleState