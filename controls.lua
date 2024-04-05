controls={}

function love.mousepressed(x, y, button, istouch, presses)
    LAUNCH_LAZER = true;
end

function love.mousereleased(x, y, button, istouch, presses)
    LAUNCH_LAZER = false
end

function love.keypressed(key)
    if key=="enter" or key=="return" then
        gameState = "start"
    elseif key =="space" or key=="spacebar" then
        gameState = "paused"
    elseif key =="D" or key=="d" then
        debugSwitch = true
    end
end

return controls