 require("player")
 require("enemy")
 require("collision")
 require("battery")
 require("generator")
 require("door")
 require("energy")
 require("room_gen")
 gameState = "menu"



function resetRoom()
  enemy.load()
  player.load()
  battery.load()
  generator.load()
  door.load()
  energy.load()
  room_gen.load()
  batteryCount = 0
  num = 0
end




function love.load()
 love.graphics.setDefaultFilter("nearest", "nearest")
 sti=require'library/sti'
 gameMap=sti('maps/map.lua')
 sound={}
 sound.mainmusic=love.audio.newSource("sound/mainmusic.mp3",'stream')
 sound.footstep=love.audio.newSource("sound/footstep.wav",'static')
 sound.hit=love.audio.newSource("sound/hit.mp3",'static')
 sound.mainmusic:setLooping(true)
 sound.mainmusic:play()
 resetRoom()
 font = love.graphics.newFont(30)
 love.graphics.setFont(font)
end




function love.update(dt)
  if gameState == "menu" or gameState == "gameover" or gameState == "paused" or gameState == "win" then
    return
  end
  if player.health <= 0 then
    gameState = "gameover"
  end
  if door.isOpen then
    local px = player.x
    local py = player.y
    local pw = player.width
    local ph = player.height
    
    local dx = door.x
    local dy = door.y
    local dw = door.width * door.scale
    local dh = door.height * door.scale
    
    if px < dx + dw and dx < px + pw and py < dy + dh and dy < py + ph then
      gameState = "win"
    end
  end
  cam:lookAt(player.x, player.y)
  gameMap:update(dt)
  enemy.update(dt)
  player.update(dt)
  battery.update(dt)
  generator.update(dt)
  door.update(dt)
  energy.update(dt)
  room_gen.update(dt)
end





function love.keypressed(key)
    if key == "escape" then
        if gameState == "playing" then
            gameState = "paused"
        elseif gameState == "paused" then
            gameState = "playing"
        end
    end
    if key == "q" and gameState == "menu" then
        love.event.quit()
    end
end



function love.mousepressed(x, y, button, istouch, presses)
    if button == 1 then
        local scW = love.graphics.getWidth()
        local scH = love.graphics.getHeight()
        local function inBounds(bx, by, bw, bh)
            return x >= bx and x <= bx + bw and y >= by and y <= by + bh
        end
        local bx = scW/2 - 100
        if gameState == "menu" then
            if inBounds(bx, scH/2, 200, 50) then
                resetRoom()
                gameState = "playing"
            elseif inBounds(bx, scH/2 + 80, 200, 50) then
                love.event.quit()
            end
        elseif gameState == "paused" then
            if inBounds(bx, scH/2, 200, 50) then
                gameState = "playing"
            elseif inBounds(bx, scH/2 + 80, 200, 50) then
                love.event.quit()
            end
        elseif gameState == "gameover" or gameState == "win" then
            if inBounds(bx, scH/2, 200, 50) then
                resetRoom()
                gameState = "playing"
            elseif inBounds(bx, scH/2 + 80, 200, 50) then
                love.event.quit()
            end
        end
    end
end



function drawButton(text, x, y, w, h)
    love.graphics.setColor(0.2, 0.2, 0.2)
    love.graphics.rectangle("fill", x, y, w, h)
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("line", x, y, w, h)
    love.graphics.printf(text, x, y + h/2 - 15, w, "center")
end



function love.draw()
  if gameState == "playing" or gameState == "paused" then
    cam:attach()
    gameMap:drawLayer(gameMap.layers["floor"])
    gameMap:drawLayer(gameMap.layers["spacelayer"])
    gameMap:drawLayer(gameMap.layers["wall"])
    room_gen.draw()
    enemy.draw()
    battery.draw()
    generator.draw()
    door.draw()
    energy.draw()
    player.draw()
    cam:detach()
    love.graphics.print("Health state: " .. tostring(math.max(0, player.health)), 20, 15)
    love.graphics.print("Energy: " .. tostring(batteryCount), 20, 50)
  end


  local scW = love.graphics.getWidth()
  local scH = love.graphics.getHeight()

  if gameState == "paused" then
      love.graphics.printf("PAUSED", 0, scH/2 - 100, scW, "center")
      drawButton("Resume", scW/2 - 100, scH/2, 200, 50)
      drawButton("Quit", scW/2 - 100, scH/2 + 80, 200, 50)

  elseif gameState == "menu" then

      love.graphics.printf("ECLIPSE PROTOCOL", 0, scH/2 - 100, scW, "center")
      drawButton("Play", scW/2 - 100, scH/2, 200, 50)
      drawButton("Quit", scW/2 - 100, scH/2 + 80, 200, 50)
  elseif gameState == "gameover" then

      love.graphics.printf("GAME OVER", 0, scH/2 - 100, scW, "center")
      drawButton("Restart", scW/2 - 100, scH/2, 200, 50)
      drawButton("Quit", scW/2 - 100, scH/2 + 80, 200, 50)
  elseif gameState == "win" then
    
      love.graphics.printf("AREA CLEARED!", 0, scH/2 - 100, scW, "center")
      drawButton("Next Area", scW/2 - 100, scH/2, 200, 50)
      drawButton("Quit", scW/2 - 100, scH/2 + 80, 200, 50)
  end
end
