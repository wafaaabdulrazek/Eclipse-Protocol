local BaseState = require "states/BaseState"
local PatrolState = setmetatable({}, {__index = BaseState})
PatrolState.__index = PatrolState
function PatrolState.new(enemy)
    local self = setmetatable(BaseState.new(), PatrolState)
    self.enemy = enemy
    self.enemy.directionY = love.math.random() > 0.5 and 1 or -1
    return self
end
function PatrolState:enter()
    self.enemy.anim = self.enemy.animations.forward
end
function PatrolState:update(dt)
    local e = self.enemy
    local nextY = e.y + e.speed * dt * e.directionY
    if not isWalkable(e.x + e.width/2, nextY + e.height/2) then
        e.directionY = -e.directionY
        nextY = e.y + e.speed * dt * e.directionY
    end
    e.y = nextY
    if e.directionY > 0 then
        e.anim = e.animations.forward
    else
        e.anim = e.animations.back
    end
    local dx = e.player.x - e.x
    local dy = e.player.y - e.y
    local isOnSameYAxis = math.abs(dx) < 120
    local isFacingPlayer = (e.directionY > 0 and dy > 0) or (e.directionY < 0 and dy < 0)
    if isOnSameYAxis and isFacingPlayer and math.abs(dy) < 300 then
        e.stateMachine:change("chase")
    end
end
function PatrolState:render()
end
return PatrolState
