local BaseState = require("states/BaseState")
local PlayerDeadState = setmetatable({}, {__index = BaseState})
PlayerDeadState.__index = PlayerDeadState
function PlayerDeadState.new(player)
    local self = setmetatable(BaseState.new(), PlayerDeadState)
    self.player = player
    return self
end
function PlayerDeadState:enter()
    local p = self.player
    if p.direction == "left" then
        p.anim = p.animations.death_left
    else
        p.anim = p.animations.death_right
    end
end
function PlayerDeadState:update(dt)
    local p = self.player
    p.anim.animation:update(dt)
end
function PlayerDeadState:render()
    local p = self.player
    p.anim.animation:draw(p.anim.sprite, p.x, p.y, 0, 3, 3)
end
return PlayerDeadState
