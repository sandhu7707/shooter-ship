local ship = {

    SHIP_DIMENSIONS = {width=20, height=10},
    positionX = 0,
    positionY = 0
}

function ship:CreateShip()
    local SHIP_DIMENSIONS = ship.SHIP_DIMENSIONS

    local vertices = {
        {-SHIP_DIMENSIONS.width/2,0,1,1},
        {-SHIP_DIMENSIONS.width/3,-SHIP_DIMENSIONS.height*3/4,1,1},
        {0,-SHIP_DIMENSIONS.height*3/8,1,1},
        {0,-SHIP_DIMENSIONS.height,1,1},
        {0,-SHIP_DIMENSIONS.height*3/8,1,1},
        {SHIP_DIMENSIONS.width/3,-SHIP_DIMENSIONS.height*3/4,1,1},
        {SHIP_DIMENSIONS.width/2,0,1,1}
    }

    return love.graphics.newMesh(vertices, "strip")
end

local mesh = ship:CreateShip()

function ship:draw()
    if gameState == "over" then
        return
    end

    love.graphics.draw(mesh, ship.positionX, ship.positionY, 0, SCALE, SCALE)
end

function ship:update(dt)
    local mx, my = love.mouse.getPosition()
    ship.positionX = mx
    ship.positionY = my - ship.SHIP_DIMENSIONS.height/2
end

function ship:getPosition()
    return ship.positionX, ship.positionY
end

function ship:detectCollision(v, radius)
    local mx, my = self:getPosition()
    local diffSquare = (radius+ship.SHIP_DIMENSIONS.width/2)^2 + (radius+ship.SHIP_DIMENSIONS.height/2)^2

    if ((v.x-mx)^2 + (v.y-my)^2) < diffSquare*SCALE*SCALE then
        return true
    else
        return false
    end
end

return ship