door = {}
function door.load()
    door.x = 400
    door.y = 0
    door.spriteClosed = love.graphics.newImage('sprites/Doorc.png')
    door.spriteOpen = love.graphics.newImage('sprites/Dooro.png')
    door.sound = love.audio.newSource('sound/door.mp3', 'static')
    door.width = door.spriteClosed:getWidth()
    door.height = door.spriteClosed:getHeight()
    door.scale = 0.15
    door.isOpen = false
end
function door.update(dt)
    if generator and generator.state == "completed" and not door.isOpen then
        door.isOpen = true
        door.sound:play()
    end
end
function door.draw()
    if door.isOpen then
        love.graphics.draw(door.spriteOpen, door.x, door.y, 0, door.scale, door.scale)
    else
        love.graphics.draw(door.spriteClosed, door.x, door.y, 0, door.scale, door.scale)
    end
end
