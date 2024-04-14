rock = {}

function rock:CreateRock(radius)
    local vertices = {{0,0,0.2,0.2,love.math.random(),love.math.random(),love.math.random()}}
    local segments = 40*(ROCK_MAX_RADIUS-ROCK_MIN_RADIUS)/ROCK_MIN_RADIUS
    for i = 1, segments do
        local angle = math.pi*i/40
        local multiplier = love.math.random(0.8,1)*radius
        table.insert(vertices, {0+math.cos(i)*multiplier,0+math.sin(i)*multiplier})
        table.insert(vertices, {0-math.cos(i)*multiplier,0-math.sin(i)*multiplier})
    end
    
    return love.graphics.newMesh(vertices, "fan")
end

return rock