energy = {}
function energy.load()
    anim8 = require 'library/anim8'
    energy.cells = {}
    energy.totalCells = love.math.random(1, 10)
    energy.collectedCells = 0
    energy.sprite = love.graphics.newImage('sprites/Battery.png')
    energy.grid = anim8.newGrid(32, 32, energy.sprite:getWidth(), energy.sprite:getHeight())
    energy.animation = anim8.newAnimation(energy.grid('1-4', 1, '1-4', 2), 0.12)
    energy.sound = love.audio.newSource('sound/energy.ogg', 'static')
    local w = 32
    local h = 32
    local scale = 1
    for i = 1, energy.totalCells do
        table.insert(energy.cells, {
            x = love.math.random(50, 750),
            y = love.math.random(50, 850),
            collected = false,
            width = w * scale,
            height = h * scale,
            scale = scale
        })
    end
end
function energy.update(dt)
    energy.animation:update(dt)
    for _, cell in ipairs(energy.cells) do
        if not cell.collected then
            local pX = player.x + (player.width / 2)
            local pY = player.y + (player.height / 2)
            local cX = cell.x + (cell.width / 2)
            local cY = cell.y + (cell.height / 2)
            local dx = pX - cX
            local dy = pY - cY
            local dist = math.sqrt(dx*dx + dy*dy)
            if dist < 60 then
                cell.collected = true
                energy.collectedCells = energy.collectedCells + 1
                if batteryCount then
                    batteryCount = batteryCount + 1
                end
                energy.sound:stop()
                energy.sound:play()
            end
        end
    end
end
function energy.draw()
    for _, cell in ipairs(energy.cells) do
        if not cell.collected then
            energy.animation:draw(energy.sprite, cell.x, cell.y, 0, cell.scale, cell.scale)
        end
    end
end
function energy.allCollected()
    return energy.collectedCells >= energy.totalCells
end
