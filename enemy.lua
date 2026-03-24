enemy = {}

function enemy.load()
    anim8=require'library/anim8'
    local StateMachine = require("EnemyStateMachine")
    local PatrolState = require("states/EnemyPatrolState")
    local ChaseState = require("states/EnemyChaseState")
    local AttackState = require("states/EnemyAttackState")

    enemy.sprite = {}
    enemy.sprite.idlee = love.graphics.newImage('sprites/Golem_1_idle.png')
    enemy.sprite.Forward=love.graphics.newImage('sprites/Golem_1_walk.png')
    enemy.sprite.Fireright=love.graphics.newImage('sprites/Golem_1_attack.png')
    enemy.sprite.Back = love.graphics.newImage('sprites/Golem_1_walk.png')


   
    enemy.grid_idle    = anim8.newGrid(90, 64, enemy.sprite.idlee:getWidth(), enemy.sprite.idlee:getHeight())
    enemy.grid_walk    = anim8.newGrid(90, 64, enemy.sprite.Forward:getWidth(), enemy.sprite.Forward:getHeight())
    enemy.grid_attack  = anim8.newGrid(90, 64, enemy.sprite.Fireright:getWidth(), enemy.sprite.Fireright:getHeight())
    enemy.base_animations = {}
    enemy.base_animations.idle_enemy = { animation = anim8.newAnimation(enemy.grid_idle('1-8', 1), 0.1), sprite = enemy.sprite.idlee }
    enemy.base_animations.forward = { animation = anim8.newAnimation(enemy.grid_walk('1-10', 1), 0.1), sprite = enemy.sprite.Forward }
    enemy.base_animations.back = { animation = anim8.newAnimation(enemy.grid_walk('1-10', 1), 0.1), sprite = enemy.sprite.Back }
    enemy.base_animations.fire = { animation = anim8.newAnimation(enemy.grid_attack('1-11', 1), 0.1), sprite = enemy.sprite.Fireright }
    
    enemy.list = {}

    local numEnemies = love.math.random(2, 5)
    for i = 1, numEnemies do
        local e = {}
        e.x = love.math.random(100, 700)
        e.y = love.math.random(100, 700)
        e.width = 100
        e.height = 150
        e.speed = love.math.random(150, 220)
        e.health = 100
        e.player = player
        e.map = gameMap
        e.directionX = 1
        e.directionY = 1
        e.animations = {
            idle_enemy = { animation = enemy.base_animations.idle_enemy.animation:clone(), sprite = enemy.base_animations.idle_enemy.sprite },
            forward = { animation = enemy.base_animations.forward.animation:clone(), sprite = enemy.base_animations.forward.sprite },
            back = { animation = enemy.base_animations.back.animation:clone(), sprite = enemy.base_animations.back.sprite },
            fire = { animation = enemy.base_animations.fire.animation:clone(), sprite = enemy.base_animations.fire.sprite },
            
        }
        e.anim = e.animations.idle_enemy
        e.stateMachine = StateMachine.new({
            patrol = function() return PatrolState.new(e) end,
            chase  = function() return ChaseState.new(e) end,
            attack = function() return AttackState.new(e) end
        })
        e.stateMachine:change("patrol")
        table.insert(enemy.list, e)
    end
end

function enemy.update(dt)
    for _, e in ipairs(enemy.list) do
        e.anim.animation:update(dt)
        e.stateMachine:update(dt)
    end
end

function enemy.draw()
    for _, e in ipairs(enemy.list) do
        local scaleX = 2
        local offsetX = 0
        if e.directionX and e.directionX < 0 then
            scaleX = -2
            offsetX = 90
        end
        e.anim.animation:draw(
            e.anim.sprite,
            e.x,
            e.y,
            0,
            scaleX,
            2,
            offsetX,
            0
        )
    end
end
