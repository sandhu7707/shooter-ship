interface = {}

function interface:printScore()
    if gameState == "over" then
        return
    end

    local font = love.graphics.newFont(20, "mono", 2)
    love.graphics.printf(
        ("Score: %d"):format(score),
        font,
        0,
        30,
        VIRTUAL_WIDTH,
        'center')
end

function interface:printMessages()
    if gameState == "new" then
        local font = love.graphics.newFont( 40, "mono", 2)
        love.graphics.printf(
            ("PRESS \"ENTER\" TO START"),
            font,
            0,
            VIRTUAL_HEIGHT/2,
            VIRTUAL_WIDTH,
            'center')
    elseif gameState == "start" then
        local font = love.graphics.newFont( 20, "mono", 2)
        love.graphics.printf(
            ("PRESS \"SPACEBAR\" TO PAUSE"),
            font,
            0,
            VIRTUAL_HEIGHT - 30,
            VIRTUAL_WIDTH,
            'center')
    elseif gameState == "paused" then
        local font = love.graphics.newFont( 40, "mono", 2)
        love.graphics.printf(
            ("PRESS \"ENTER\" TO CONTINUE"),
            font,
            0,
            VIRTUAL_HEIGHT/2,
            VIRTUAL_WIDTH,
            'center')
    elseif gameState == "over" then
        local font = love.graphics.newFont( 40, "mono", 2)
        love.graphics.printf(
            ("GAME OVER, FINAL SCORE: %d"):format(score),
            font,
            0,
            VIRTUAL_HEIGHT/2,
            VIRTUAL_WIDTH,
            'center')
    end

    if debugSwitch == true then
        local fontSize = 10
        local font = love.graphics.newFont( fontSize, "mono", 2)
        local printMessageY = 20
        for k,v in pairs(rocks) do
            love.graphics.printf(
                ("ROCK KEY: %d, POSITION X:%d Y:%d"):format(k, v.x, v.y),
                font,
                0,
                printMessageY,
                VIRTUAL_WIDTH,
                'left')
            printMessageY = printMessageY + fontSize    
        end
        
        local mx, my = ship:getPosition()
        love.graphics.printf(
            ("SHIP POSITION X:%d Y:%d"):format(mx, my),
            font,
            0,
            printMessageY,
            VIRTUAL_WIDTH,
            'left')
        printMessageY = printMessageY + fontSize

        for k,v in pairs(lazers) do
            love.graphics.printf(
                ("LAZER KEY: %d, POSITION X:%d Y:%d"):format(k, v.x, v.y),
                font,
                0,
                printMessageY,
                VIRTUAL_WIDTH,
                'left')
            printMessageY = printMessageY + fontSize
        end
    end
end

return interface