battery = {}
function battery.load()
    anim8=require'library/anim8'
    local StateMachine = require("BatteryStateMachine")
    local IdleState = require("states/BatteryIdleState")
    local CollectedState = require("states/BatteryCollectedState")
    battery.sprite = {}
    battery.sprite.idle = love.graphics.newImage('sprites/battery.png')
    battery.width = 32
    battery.height = 32
    battery.grid = anim8.newGrid(32, 32,
        battery.sprite.idle:getWidth(),
        battery.sprite.idle:getHeight()
    )


    battery.animations = {}
    battery.animations.idle = {
        animation = anim8.newAnimation(battery.grid('1-4', 1, '1-4', 2), 0.12),
        sprite = battery.sprite.idle
    }



    battery.anim = battery.animations.idle
    battery.x = 400
    battery.y = 400
    battery.isVisible = true
    battery.stateMachine = StateMachine.new({
        idle = function() return IdleState.new(battery) end,
        collected  = function() return CollectedState.new(battery) end
    })




    battery.stateMachine:change("idle")
end





function battery.update(dt)
    if battery.isVisible then
        battery.anim.animation:update(dt)
    end
    battery.stateMachine:update(dt)
end





function battery.draw()
    if battery.isVisible then
        battery.anim.animation:draw(
            battery.anim.sprite,
            battery.x,
            battery.y,
            0,
            1,
            1
        )
    end
end
