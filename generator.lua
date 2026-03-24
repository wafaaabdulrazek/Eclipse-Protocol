generator = {}
function generator.load()
    generator.x = 100
    generator.y = 500
    generator.sprite = love.graphics.newImage('sprites/NuclearGenerator.png')
    generator.energySprite = love.graphics.newImage('sprites/Nuclear Energy.png')
    generator.sound = love.audio.newSource('sound/nuclear.mp3', 'static')
    local w = generator.sprite:getWidth()
    local h = generator.sprite:getHeight()
    generator.width = w
    generator.height = h
    generator.scale = 0.1
    generator.state = "idle"
    generator.progress = 0
    generator.targetTime = 10
    if player then
        generator.lastPlayerHealth = player.health
    else
        generator.lastPlayerHealth = 100
    end
end
function generator.update(dt)
    if generator.state == "completed" then return end
    local pX = player.x + player.width / 2
    local pY = player.y + player.height / 2
    local gX = generator.x + (generator.width * generator.scale) / 2
    local gY = generator.y + (generator.height * generator.scale) / 2
    local dx = pX - gX
    local dy = pY - gY
    local dist = math.sqrt(dx*dx + dy*dy)
    local inRange = dist < 250
    local gotHit = player.health < generator.lastPlayerHealth
    generator.lastPlayerHealth = player.health
    if inRange and love.keyboard.isDown('e') and energy and energy.allCollected() then
        if gotHit then
            generator.state = "idle"
            generator.progress = 0
        else
            generator.state = "activating"
            generator.progress = generator.progress + dt
            if generator.progress >= generator.targetTime then
                generator.state = "completed"
                generator.progress = generator.targetTime
                generator.sound:play()
            end
        end
    else
        generator.state = "idle"
        generator.progress = 0
    end
end
function generator.draw()
    love.graphics.draw(generator.sprite, generator.x, generator.y, 0, generator.scale, generator.scale)
    if generator.state == "completed" then
        local greenScale = 0.1
        local ew = generator.energySprite:getWidth() * greenScale
        local eh = generator.energySprite:getHeight() * greenScale
        local gw = generator.width * generator.scale
        local ex = generator.x + (gw / 2) - (ew / 2)
        local ey = generator.y - (eh / 2)
        love.graphics.draw(generator.energySprite, ex, ey, 0, greenScale, greenScale)
    elseif generator.state == "activating" then
        local barWidth = generator.width * generator.scale
        local barX = generator.x
        local barY = generator.y - 30
        love.graphics.setColor(1, 0, 0)
        love.graphics.rectangle("fill", barX, barY, barWidth, 15)
        love.graphics.setColor(0, 1, 0)
        love.graphics.rectangle("fill", barX, barY, barWidth * (generator.progress / generator.targetTime), 15)
        love.graphics.setColor(1, 1, 1)
    end
end
