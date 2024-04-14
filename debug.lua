debug = {}

function debug:printMessages()

    if debugSwitch == true then
        local fontSize = 10
        local font = love.graphics.newFont( fontSize, "mono", 2)
        local printMessageY = 20

        printMessageY = printDebugMessage(("FPS: %d"):format(love.timer.getFPS()), font, printMessageY, fontSize) 

        for k,v in pairs(rocks) do
            printMessageY = printDebugMessage(("ROCK KEY: %d, POSITION X:%d Y:%d"):format(k, v.x, v.y), font, printMessageY, fontSize)
        end
        
        local mx, my = ship:getPosition()
        printMessageY = printDebugMessage(("SHIP POSITION X:%d Y:%d"):format(mx, my), font, printMessageY, fontSize)


        for k,v in pairs(lazers) do
            printMessageY = printDebugMessage(("LAZER KEY: %d, POSITION X:%d Y:%d"):format(k, v.x, v.y), font, printMessageY, fontSize)
        end
    end
end

function printDebugMessage(message, font, printMessageY)
    love.graphics.printf(
        message,
        font,
        0,
        printMessageY,
        WINDOW_WIDTH,
        'left')
    
    return printMessageY + fontSize
end

return debug