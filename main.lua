push = require 'push'

WINDOW_WIDTH, WINDOW_HEIGHT = love.window.getDesktopDimensions();

WINDOW_WIDTH = WINDOW_WIDTH*0.8
WINDOW_HEIGHT = WINDOW_HEIGHT*0.8

VIRTUAL_WIDTH = WINDOW_WIDTH
VIRTUAL_HEIGHT = WINDOW_HEIGHT

start = love.timer.getTime()

SHIP_DIMENSIONS = {width=20, height=10}

LAZER_SPEED = 100
LAUNCH_LAZER = false
LAZER_RADIUS = 4
LAZER_INTERVAL = 0.2
lastLazerSpawnTime = love.timer.getTime()

ROCK_SPEED = 100
ROCK_SPAWN_INTERVAL = 5
ROCK_MIN_RADIUS = 2
ROCK_MAX_RADIUS = 3

SCALE = 5

rockSpeed = ROCK_SPEED
rockSpawnInterval = ROCK_SPAWN_INTERVAL 
ROCK_LIMIT = 100
rocksSpawned = 0

lazers = {}
rocks = {}

gameState = "new"
score = 0

debugSwitch = false

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

function love.load()
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH,WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = true,
        vsync = -1
    })
    mesh = CreateShip()
end

function love.resize(w, h)
    WINDOW_WIDTH = w
    WINDOW_HEIGHT = h
    push:resize(w, h)
end

function love.update(dt)

    if gameState ~= "start" then
        return
    end

    levelUp()
    
    updateRocksAndLazers(dt)
    
    launchRocksAndLazers(dt)

end

function love.draw()
    push:apply('start')
    
    printScore()

    printMessages()

    drawShip()

    drawRocksAndLazers()


    push:apply('end')
end

function launchRocksAndLazers(dt)
    local mx, my = love.mouse.getPosition()
    mx = mx*VIRTUAL_WIDTH/WINDOW_WIDTH
    my = my*VIRTUAL_HEIGHT/WINDOW_HEIGHT

    if LAUNCH_LAZER and love.timer.getTime() - lastLazerSpawnTime > LAZER_INTERVAL then
        lastLazerSpawnTime = love.timer.getTime()
        lazerTime = love.timer.getTime()
        table.insert(lazers, {x=mx, y=my-8*5})
    end

    if love.timer.getTime() - start > ROCK_SPAWN_INTERVAL and rocksSpawned < ROCK_LIMIT then
        start = love.timer.getTime()
        local radius = love.math.random(ROCK_MIN_RADIUS,ROCK_MAX_RADIUS)
        table.insert(rocks, {val=CreateRock(radius),x=love.math.random(VIRTUAL_WIDTH)+1,y=1,angle=math.pi*love.math.random(), radius=radius})
        rocksSpawned = rocksSpawned + 1;
    end

end

function updateRocksAndLazers(dt)

    detectHit()

    for k,v in pairs(rocks) do
        if collisionWithShip(v) then
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

function collisionWithShip(v)
    local mx, my = love.mouse.getPosition()
    mx = mx*VIRTUAL_WIDTH/WINDOW_WIDTH
    my = my*VIRTUAL_HEIGHT/WINDOW_HEIGHT - SHIP_DIMENSIONS.height/2
    diffSquare = (v.radius+SHIP_DIMENSIONS.width/2)^2 + (v.radius+SHIP_DIMENSIONS.height/2)^2

    if ((v.x-mx)^2 + (v.y-my)^2) < diffSquare*SCALE*SCALE then
        return true
    else
        return false
    end
end

function detectHit()
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

function levelUp()
    if score%10 == 0 then
        rockSpeed = ROCK_SPEED + 5*score/10
    end
    if score%100 == 0 and score < 900 then
        rockSpawnInterval = ROCK_SPAWN_INTERVAL - 0.5*score/100
    end
end

function printScore()
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

function printMessages()
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
        
        local mx, my = love.mouse.getPosition()
        mx = mx*VIRTUAL_WIDTH/WINDOW_WIDTH
        my = my*VIRTUAL_HEIGHT/WINDOW_HEIGHT - SHIP_DIMENSIONS.height/2
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

function drawRocksAndLazers()
    for k,v in pairs(lazers) do
        love.graphics.circle("fill", v.x, v.y, 2, SCALE, SCALE)
    end
    
    for k,v in pairs(rocks) do
        love.graphics.draw(v.val, v.x, v.y, 0, SCALE, SCALE)
    end
end

function drawShip()
    if gameState == "over" then
        return
    end
    local mx, my = love.mouse.getPosition()
    mx = mx*VIRTUAL_WIDTH/WINDOW_WIDTH
    my = my*VIRTUAL_HEIGHT/WINDOW_HEIGHT
    love.graphics.draw(mesh, mx, my, 0, SCALE, SCALE)
end

function CreateShip()
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


function CreateRock(radius)
    vertices = {{0,0,0.2,0.2,love.math.random(),love.math.random(),love.math.random()}}
    segment = 40*(ROCK_MAX_RADIUS-ROCK_MIN_RADIUS)/ROCK_MIN_RADIUS
    for i = 1, 40 do
        local angle = math.pi*i/40
        local multiplier = love.math.random(0.8,1)*radius
        table.insert(vertices, {0+math.cos(i)*multiplier,0+math.sin(i)*multiplier})
        table.insert(vertices, {0-math.cos(i)*multiplier,0-math.sin(i)*multiplier})
    end
    
    return love.graphics.newMesh(vertices, "fan")
end