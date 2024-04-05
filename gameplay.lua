rock = require 'rock'
ship = require 'ship'

gameplay = {}

start = love.timer.getTime()

LAZER_SPEED = 100
LAUNCH_LAZER = false
LAZER_RADIUS = 4
LAZER_INTERVAL = 0.2
lastLazerSpawnTime = love.timer.getTime()

ROCK_SPEED = 100
ROCK_SPAWN_INTERVAL = 5
ROCK_MIN_RADIUS = 2
ROCK_MAX_RADIUS = 3

rockSpeed = ROCK_SPEED
rockSpawnInterval = ROCK_SPAWN_INTERVAL 
ROCK_LIMIT = 100
rocksSpawned = 0

lazers = {}
rocks = {}

function gameplay:execute(dt)
    self:levelUp()
    
    self:updateRocksAndLazers(dt)
    
    self:launchRocksAndLazers(dt)
end

function gameplay:launchRocksAndLazers(dt)
    local mx, my = ship:getPosition()

    if LAUNCH_LAZER and love.timer.getTime() - lastLazerSpawnTime > LAZER_INTERVAL then
        lastLazerSpawnTime = love.timer.getTime()
        lazerTime = love.timer.getTime()
        table.insert(lazers, {x=mx, y=my-8*5})
    end

    if love.timer.getTime() - start > ROCK_SPAWN_INTERVAL and rocksSpawned < ROCK_LIMIT then
        start = love.timer.getTime()
        local radius = love.math.random(ROCK_MIN_RADIUS,ROCK_MAX_RADIUS)
        table.insert(rocks, {val=rock:CreateRock(radius),x=love.math.random(VIRTUAL_WIDTH)+1,y=1,angle=math.pi*love.math.random(), radius=radius})
        rocksSpawned = rocksSpawned + 1;
    end

end

function gameplay:updateRocksAndLazers(dt)

    self:detectHit()

    for k,v in pairs(rocks) do
        if ship:detectCollision(v, v.radius) then
            gameState = "over"
            lazers = {}
            rocks = {}
            rocksSpawned = 0
            return
        end
        if v.y > VIRTUAL_HEIGHT or v.y < 0 then
            v.angle = 2*math.pi - v.angle
        end
        if v.x > VIRTUAL_WIDTH or v.x < 0 then
            v.angle = math.pi - v.angle
        end
        v.y = v.y + dt*rockSpeed*math.sin(v.angle)    
        v.x = v.x + dt*rockSpeed*math.cos(v.angle)
    end

    for k,v in pairs(lazers) do
        v.y = v.y - dt*LAZER_SPEED
    end

end

function gameplay:detectHit()
    for k,v in pairs(lazers) do
        if v.y < 0 then
            table.remove(lazers, k)
        end
        for k2,v2 in pairs(rocks) do
            if ((v.x-v2.x)^2 + (v.y-v2.y)^2) < (v2.radius*v2.radius)*SCALE*SCALE  then
                score = score + 1;
                table.remove(rocks,k2)
                table.remove(lazers, k)
                rocksSpawned = rocksSpawned - 1;
            end
        end
    end
end

function gameplay:levelUp()
    if score%10 == 0 then
        rockSpeed = ROCK_SPEED + 5*score/10
    end
    if score%100 == 0 and score < 900 then
        rockSpawnInterval = ROCK_SPAWN_INTERVAL - 0.5*score/100
    end
end

return gameplay