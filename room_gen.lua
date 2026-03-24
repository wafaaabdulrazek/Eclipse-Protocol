room_gen = {}


function room_gen.load()
    room_gen.walls = {}
    local numWalls = love.math.random(3, 8)
    for i = 1, numWalls do
        table.insert(room_gen.walls, {
            x = love.math.random(100, 700),
            y = love.math.random(150, 700),
            width = love.math.random(50, 150),
            height = love.math.random(30, 80)
        })
    end
end
function room_gen.update(dt)
end
function room_gen.draw()
    love.graphics.setColor(0.3, 0.3, 0.4)
    for _, w in ipairs(room_gen.walls) do
        love.graphics.rectangle("fill", w.x, w.y, w.width, w.height)
        love.graphics.setColor(0.5, 0.5, 0.6)
        love.graphics.rectangle("line", w.x, w.y, w.width, w.height)
        love.graphics.setColor(0.3, 0.3, 0.4)
    end
    love.graphics.setColor(1, 1, 1)
end
