local BaseState = require "states/BaseState"
local ChaseState = setmetatable({}, {__index = BaseState})
ChaseState.__index = ChaseState
function ChaseState.new(enemy)
    local self = setmetatable(BaseState.new(), ChaseState)
    self.enemy = enemy
    return self
end
function ChaseState:enter()
    self.enemy.anim = self.enemy.animations.forward
end
function ChaseState:update(dt)
    local e = self.enemy
    local p = e.player
    local dx = p.x - e.x
    local dy = p.y - e.y
    local dist = math.sqrt(dx*dx + dy*dy)
    if dist > 300 then
        e.stateMachine:change("patrol")
        return
    end
    if math.abs(dx) < 40 and math.abs(dy) < 40 then
        e.stateMachine:change("attack")
        return
    end
    local dirX = dx / dist
    local dirY = dy / dist
    e.directionX = dirX
    local nextX = e.x + dirX * e.speed * dt
    local nextY = e.y + dirY * e.speed * dt
    if isWalkable(nextX + e.width/2, nextY + e.height/2) then
        e.x = nextX
        e.y = nextY
    end
end
function ChaseState:render()
    local e = self.enemy
    e.anim.animation:draw(e.anim.sprite, e.x, e.y, 0, 2, 2)
end
return ChaseState
