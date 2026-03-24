local BaseState = require "states/BaseState"
local CollectedState = setmetatable({}, {__index = BaseState})

CollectedState.__index = CollectedState
function CollectedState.new(battery)
    local self = setmetatable(BaseState.new() or {}, CollectedState)
    self.battery = battery
    return self
end


function CollectedState:enter()
    self.battery.isVisible = false
    batteryCount = (batteryCount or 0) + 1
end

function CollectedState:update(dt)
end

function CollectedState:render()
end

return CollectedState
