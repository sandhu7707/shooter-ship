local ship = {

    SHIP_DIMENSIONS = {width=20, height=10}
}

function ship:drawShip(mesh)
    if gameState == "over" then
        return
    end

    local mx, my = love.mouse.getPosition()
    mx = mx*VIRTUAL_WIDTH/WINDOW_WIDTH
    my = my*VIRTUAL_HEIGHT/WINDOW_HEIGHT

    love.graphics.draw(mesh, mx, my, 0, SCALE, SCALE)
end

function ship:CreateShip()
    SHIP_DIMENSIONS = ship.SHIP_DIMENSIONS

    local vertices = {
        {-SHIP_DIMENSIONS.width/2,0,1,1},
        {-SHIP_DIMENSIONS.width/3,-SHIP_DIMENSIONS.height*3/4,1,1},
        {0,-SHIP_DIMENSIONS.height*3/8,1,1},
        {0,-SHIP_DIMENSIONS.height,1,1},
        {0,-SHIP_DIMENSIONS.height*3/8,1,1},
        {SHIP_DIMENSIONS.width/3,-SHIP_DIMENSIONS.height*3/4,1,1},
        {SHIP_DIMENSIONS.width/2,0,1,1}
    }

    local mesh = love.graphics.newMesh(vertices, "strip")
    return mesh;
end

function ship:getPosition()
    local mx, my = love.mouse.getPosition()
    mx = mx*VIRTUAL_WIDTH/WINDOW_WIDTH
    my = my*VIRTUAL_HEIGHT/WINDOW_HEIGHT - ship.SHIP_DIMENSIONS.height/2
    return mx, my
end

function ship:detectCollision(v, radius)
    local mx, my = self:getPosition()
    diffSquare = (radius+ship.SHIP_DIMENSIONS.width/2)^2 + (radius+ship.SHIP_DIMENSIONS.height/2)^2

    if ((v.x-mx)^2 + (v.y-my)^2) < diffSquare*SCALE*SCALE then
        return true
    else
        return false
    end
end

return ship