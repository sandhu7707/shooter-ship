local background = {}

local backgroundPositionX = 0
local backgroundPositionY = 0
local BACKGROUND_LOOP_POINT = 1024
local BACKGROUND_SPEED = 40
local spawnCelestialObjectTimer = 2
local celestialObjects = {}

local BACKGROUND_IMAGE = love.graphics.newImage("assets/background.png")
local CELESTIAL_OBJECTS = {
    [0]=love.graphics.newImage("assets/objectA.png"),
    [1]=love.graphics.newImage("assets/objectB.png"), 
    [2]=love.graphics.newImage("assets/objectD.png"),
    [3]=love.graphics.newImage("assets/objectE.png"),
    [4]=love.graphics.newImage("assets/objectF.png"),
    [5]=love.graphics.newImage("assets/objectG.png"),
    [6]=love.graphics.newImage("assets/objectH.png")
}

function background:updateBackground(dt)
    backgroundPositionY = -1024 + (backgroundPositionY + BACKGROUND_SPEED*dt)%BACKGROUND_LOOP_POINT

    spawnCelestialObjectTimer = spawnCelestialObjectTimer - dt

    if spawnCelestialObjectTimer <= 0 then
        local celestialObj = CELESTIAL_OBJECTS[os.time()%7]
        table.insert(celestialObjects, {val = celestialObj, x = math.random(0,WINDOW_WIDTH), y = -celestialObj:getHeight(), speed = math.random(20,80)})
        spawnCelestialObjectTimer = 1
    end

    for k, celestialObject in pairs(celestialObjects) do
        if celestialObject.y > WINDOW_HEIGHT then
            table.remove(celestialObjects, k)
        else
            celestialObject.y = celestialObject.y + celestialObject.speed*dt
        end
    end
end

function background:drawBackground()
    love.graphics.draw(BACKGROUND_IMAGE, backgroundPositionX, backgroundPositionY)

    for k, celestialObject in pairs(celestialObjects) do
        love.graphics.draw(celestialObject.val, celestialObject.x, celestialObject.y)
    end
end

return background