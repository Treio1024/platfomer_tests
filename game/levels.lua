local sti = require'libraries/sti'

local levels = {}

levels.lobby = sti('assets/map1.lua', {'box2d'})
levels.lobby.image = love.graphics.newImage'assets/map1.png'

function levels.lobby:load()
    cam:setWorld(0, 0, self.image:getWidth() * 2, self.image:getHeight() * 2)
    
    for i, obj in pairs(self.layers.solids.objects) do
        local static = world:newRectangleCollider(obj.x * 2, obj.y * 2, obj.width * 2, obj.height * 2)
        static:setType('static')
        table.insert(map.statics, static)
    end

    for i, obj in pairs(self.layers.coins.objects) do
        Coin.new(obj.x * 2, obj.y * 2)
    end

    for i, obj in pairs(self.layers.spikes.objects) do
        spikes.new(obj.x, obj.y, obj.width * 2, obj.height * 2)
    end
end

function levels.lobby:fGreen1() --foward to green1
    if player.x > self.properties.endX and (player.y <= self.properties.endY or player.y >= self.properties.endY - 112) then
        map:clean()
        map.current_level = levels.green1
        levels.green1:load()

        player.collider:setPosition(map.current_level.properties.startX, map.current_level.properties.startY)
    end
end

function levels.lobby:update()
    self:fGreen1()
end

----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------

levels.green1 = sti('assets/map2.lua', {'box2d'})
levels.green1.image = love.graphics.newImage'assets/map2.png'

function levels.green1:load()
    cam:setWorld(0, 0, self.image:getWidth() * 2, self.image:getHeight() * 2)

    for i, obj in pairs(self.layers.solids.objects) do
        local static = world:newRectangleCollider(obj.x * 2, obj.y * 2, obj.width * 2, obj.height * 2)
        static:setType('static')
        table.insert(map.statics, static)

        for i, obj in pairs(self.layers.spikes.objects) do
            spikes.new(obj.x, obj.y, obj.width * 2, obj.height * 2)
        end
    end
end

function levels.green1:bLobby() --back to lobby
    if player.x < 0 and (player.y < self.properties.startY) then
        map:clean()
        map.current_level = levels.lobby
        levels.lobby:load()

        player.collider:setPosition(map.current_level.properties.endX, map.current_level.properties.endY)
    end
end

function levels.green1:fPurple1()
    if player.x > self.properties.endX and (player.y <= self.properties.endY or player.y >= self.properties.endY - 112) then
        map:clean()
        map.current_level = levels.purple1
        levels.purple1:load()

        player.collider:setPosition(map.current_level.properties.startX, map.current_level.properties.startY)
    end
end

function levels.green1:update()
    self:bLobby()
    self:fPurple1()
end

----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------

levels.purple1 = sti('assets/map3.lua', {'box2d'})
levels.purple1.image = love.graphics.newImage'assets/map3.png'

function levels.purple1:load()
    cam:setWorld(0, 0, self.image:getWidth() * 2, self.image:getHeight() * 2)

    for i, obj in pairs(self.layers.solids.objects) do
        local static = world:newRectangleCollider(obj.x * 2, obj.y * 2, obj.width * 2, obj.height * 2)
        static:setType('static')
        table.insert(map.statics, static)
    end
end

function levels.purple1:bGreen1()
    if player.x < 0 and (player.y < self.properties.startY) then
        map:clean()
        map.current_level = levels.green1
        levels.green1:load()

        player.collider:setPosition(map.current_level.properties.endX, map.current_level.properties.endY)
    end
end

function levels.purple1:update()
    self:bGreen1()
end

----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------

return levels