local BaseState = require("states/BaseState")
local EnemyAttackState = setmetatable({}, {__index = BaseState})
EnemyAttackState.__index = EnemyAttackState
function EnemyAttackState.new(enemy)
    local self = setmetatable(BaseState.new(), EnemyAttackState)
    self.enemy = enemy
    self.hasHit = false
    self.timer = 0
    self.duration = 0.8
    return self
end
function EnemyAttackState:enter()
    self.timer = 0
    self.hasHit = false
    self.enemy.anim = self.enemy.animations.fire
    if self.enemy.anim.animation then
        self.enemy.anim.animation:gotoFrame(1)
        self.enemy.anim.animation:resume()
    end
end
function EnemyAttackState:update(dt)
    local e = self.enemy
    local p = e.player
    self.timer = self.timer + dt
    local dx = p.x - e.x
    local dy = p.y - e.y
    local distX = math.abs(dx)
    local distY = math.abs(dy)
    if distX < 60 and distY < 50 then
        if not self.hasHit then
            p.takeDamage(20, e.x)
            self.hasHit = true
        end
    end
    if self.timer >= self.duration then
        e.stateMachine:change("chase")
    end
end
function EnemyAttackState:render()
    local e = self.enemy
    e.anim.animation:draw(e.anim.sprite, e.x, e.y, 0, 2, 2)
end
return EnemyAttackState
