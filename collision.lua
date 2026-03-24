collision={}
function CheckCollision(a, b)
    if not a or not b then return false end
    return a.x < b.x + b.width  and
           b.x < a.x + a.width  and
           a.y < b.y + b.height and
           b.y < a.y + a.height
end


function isWalkable(px,py)
    local width = 40
    local height = 40
    local halfW = width / 2
    local halfH = height / 2
    local left = px - halfW
    local right = px + halfW
    local top = py - halfH
    local bottom = py + halfH
    local function intersects(x1, y1, w1, h1, x2, y2, w2, h2)
        return x1 < x2 + w2 and x2 < x1 + w1 and y1 < y2 + h2 and y2 < y1 + h1
    end

    local onOpenDoor = false
    if door and door.x and door.isOpen then
        local dx = door.x
        local dy = door.y
        local dw = door.width * door.scale
        local dh = door.height * door.scale
        if intersects(left, top, width, height, dx, dy, dw, dh) then
            onOpenDoor = true
        end
    end

    local tileSize = gameMap.tilewidth
    local corners = {
        {math.floor(left / tileSize) + 1, math.floor(top / tileSize) + 1},
        {math.floor(right / tileSize) + 1, math.floor(top / tileSize) + 1},
        {math.floor(left / tileSize) + 1, math.floor(bottom / tileSize) + 1},
        {math.floor(right / tileSize) + 1, math.floor(bottom / tileSize) + 1}
    }
    local wallLayer = gameMap.layers["wall"]
    for _, corner in ipairs(corners) do
        local col, row = corner[1], corner[2]
        if row < 1 or row > gameMap.height or col < 1 or col > gameMap.width then
            if not onOpenDoor then return false end
        end
        if wallLayer.data[row][col] ~= nil then
            if not onOpenDoor then return false end
        end
    end




    if generator and generator.x then
        local gw = generator.width * generator.scale
        local gh = generator.height * generator.scale
        local gx = generator.x + (gw * 0.2)
        local gy = generator.y + (gh * 0.2)
        gw = gw * 0.6
        gh = gh * 0.6
        if intersects(left, top, width, height, gx, gy, gw, gh) then
            return false
        end
    end


    
    if door and door.x and not door.isOpen then
        local dx = door.x
        local dy = door.y
        local dw = door.width * door.scale
        local dh = door.height * door.scale
        if intersects(left, top, width, height, dx, dy, dw, dh) then
            return false
        end
    end
    if room_gen and room_gen.walls then
        for _, w in ipairs(room_gen.walls) do
            if intersects(left, top, width, height, w.x, w.y, w.width, w.height) then
                return false
            end
        end
    end
    return true
end
