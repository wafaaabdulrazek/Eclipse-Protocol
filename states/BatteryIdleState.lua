local BaseState = require "states/BaseState"
local IdleState = setmetatable({}, {__index = BaseState})
IdleState.__index = IdleState
function IdleState.new(battery)
    local self = setmetatable(BaseState.new() or {}, IdleState)
    self.battery = battery
    return self
end
function IdleState:enter()
    self.battery.anim = self.battery.animations.idle
end
function IdleState:update(dt)
    if CheckCollision(self.battery, player) then
        self.battery.stateMachine:change("collected")
    end
end
function IdleState:render()
end
return IdleState
