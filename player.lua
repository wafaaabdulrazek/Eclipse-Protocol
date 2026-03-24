player = {}
function player.load()
    local camera=require'library.camera'
    cam=camera()
    anim8=require'library/anim8'
    player.health = 100
    player.maxHealth = 100
    player.isProtected = false
    player.protectTimer = 0
    player.sprite = {}
    player.sprite.idle = love.graphics.newImage('sprites/idle.png')
    player.sprite.walk = love.graphics.newImage('sprites/walk.png')
    player.sprite.deathLeft = love.graphics.newImage('sprites/death_Left_Down.png')
    player.sprite.deathRight = love.graphics.newImage('sprites/death_Right_Up.png')
    player.sprite.deathup = love.graphics.newImage('sprites/death_Up.png')
    player.sprite.deathdown = love.graphics.newImage('sprites/death_Down.png')
    player.animations = {}
    player.width = 100
    player.height = 150
    player.speed = 200



    local screenWidth = love.graphics.getWidth()
    player.x = (screenWidth / 2) - (player.width / 2)
    player.y = 825
    player.idlegrid = anim8.newGrid(48,64,
        player.sprite.idle:getWidth(),
        player.sprite.idle:getHeight()
    )
    player.walkgrid = anim8.newGrid(48,64,
        player.sprite.walk:getWidth(),
        player.sprite.walk:getHeight()
    )
    player.deathGrid = anim8.newGrid(48,48,
        player.sprite.deathLeft:getWidth(),
        player.sprite.deathLeft:getHeight()
    )
    player.animations.idle_down = {
        animation = anim8.newAnimation(player.idlegrid('1-4', 1), 0.2),
        sprite = player.sprite.idle
    }
    player.animations.idle_left = {
        animation = anim8.newAnimation(player.idlegrid('1-4', 3), 0.2),
        sprite = player.sprite.idle
    }
    player.animations.idle_up = {
        animation = anim8.newAnimation(player.idlegrid('1-4', 4), 0.2),
        sprite = player.sprite.idle
    }
    player.animations.idle_right = {
        animation = anim8.newAnimation(player.idlegrid('1-4', 5), 0.2),
        sprite = player.sprite.idle
    }
    player.animations.down = {
        animation = anim8.newAnimation(player.walkgrid('1-8', 1), 0.12),
        sprite = player.sprite.walk
    }
    player.animations.left = {
        animation = anim8.newAnimation(player.walkgrid('1-8', 3), 0.12),
        sprite = player.sprite.walk
    }
    player.animations.up = {
        animation = anim8.newAnimation(player.walkgrid('1-8', 4), 0.12),
        sprite = player.sprite.walk
    }
    player.animations.right = {
        animation = anim8.newAnimation(player.walkgrid('1-8', 5), 0.12),
        sprite = player.sprite.walk
    }
    player.animations.death_left = {
        animation = anim8.newAnimation(player.deathGrid('1-8', 1), 0.1, 'pauseAtEnd'),
        sprite = player.sprite.deathLeft
    }
    player.animations.death_right = {
        animation = anim8.newAnimation(player.deathGrid('1-8', 1), 0.1, 'pauseAtEnd'),
        sprite = player.sprite.deathRight
    }
player.animations.deathup = {
        animation = anim8.newAnimation(player.deathGrid('1-8', 1), 0.1, 'pauseAtEnd'),
        sprite = player.sprite.deathup
    }
    player.animations.deathdown = {
        animation = anim8.newAnimation(player.deathGrid('1-8', 1), 0.1, 'pauseAtEnd'),
        sprite = player.sprite.deathdown
    }
    player.anim = player.animations.idle_down
    player.direction = "down"
    local PlayerStateMachine = require("PlayerStateMachine")
    local PlayerDeadState = require("states/PlayerDeadState")
    player.stateMachine = PlayerStateMachine.new({
        dead = function() return PlayerDeadState.new(player) end
    })
end



function player.update(dt)
if player.isProtected then
    player.protectTimer = player.protectTimer - dt
    if player.protectTimer <= 0 then
        player.isProtected = false
    end
end



    if player.stateMachine.currentName == "dead" then
        player.stateMachine:update(dt)
        return
    end



    player.anim.animation:update(dt)



    if love.keyboard.isDown('right') then
        sound.footstep:play()

        local nextX = player.x + player.speed * dt
        local centerX = nextX + player.width / 2
        local centerY = player.y + player.height / 2
        if isWalkable(centerX, centerY) then player.x = nextX end

        player.anim = player.animations.right
        player.direction = "right"
    
    
    elseif love.keyboard.isDown('left') then
        sound.footstep:play()
        local nextX = player.x - player.speed * dt
        local centerX = nextX + player.width / 2
        local centerY = player.y + player.height / 2
        if isWalkable(centerX, centerY) then player.x = nextX end
        player.anim = player.animations.left
        player.direction = "left"
   
   
    elseif love.keyboard.isDown('up') then
        sound.footstep:play()
        local nextY = player.y - player.speed * dt
        local centerX = player.x + player.width / 2
        local centerY = nextY + player.height / 2
        if isWalkable(centerX, centerY) then player.y = nextY end
        player.anim = player.animations.up
        player.direction = "up"
   
   
    elseif love.keyboard.isDown('down') then
        sound.footstep:play()
        local nextY = player.y + player.speed * dt
        local centerX = player.x + player.width / 2
        local centerY = nextY + player.height / 2
        if isWalkable(centerX, centerY) then player.y = nextY end
        player.anim = player.animations.down
        player.direction = "down"
        
    else
        if player.direction == "right" then player.anim = player.animations.idle_right
        elseif player.direction == "left" then player.anim = player.animations.idle_left
        elseif player.direction == "up" then player.anim = player.animations.idle_up
        elseif player.direction == "down" then player.anim = player.animations.idle_down
        end
    end
    player.stateMachine:update(dt)
end


function player.draw()
    player.anim.animation:draw(player.anim.sprite, player.x, player.y, 0, 3, 3)
end


function player.takeDamage(amount, sourceX)
    if player.isProtected then return end
    player.health = player.health - amount

    if sound.hit then sound.hit:play() end
    player.isProtected = true
    player.protectTimer = 1.0
    if player.health <= 0 then

        player.stateMachine:change("dead")
    end
end
