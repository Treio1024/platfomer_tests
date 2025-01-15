love.graphics.setDefaultFilter("nearest", "nearest")
    
require'player'
--require'coin'
--require'gui'
local sti = require'libraries/sti'
local wf = require'libraries.windfield'

function love.load()
    --print'main_'

    world = wf.newWorld(0, 0, false)

    map = sti('images/map.lua', {'box2d'})
    map.layers.solids.visible = false

    world.box2d_world:setCallbacks(beginContact, endContact)
    background = love.graphics.newImage'images/background.png'
    
    player:load()
    --gui:load()

    --[[for i=1, 100 do
        Coin.new(lLove.math.random(1, 500), lLove.math.random(1, 500))
    end]]--
    statics = {}
    for i, obj in pairs(map.layers["solids"].objects) do
        local wall = world:newRectangleCollider(obj.x * 2, obj.y * 2, obj.width * 2, obj.height * 2)
        wall:setType('static')
        table.insert(statics, wall)
    end
end

function love.update(dt)
    world:update(dt)
    player:update(dt)
    --Coin.updateA(dt)
    --gui:update(dt)
end

function love.draw()
    love.graphics.draw(background)
    world:draw(0xff)
    map:draw(0, 0, 2, 2)
    love.graphics.push()
    love.graphics.scale(2, 2)
    
    --player:draw()
    --Coin.drawA()

    love.graphics.pop()

    player:showDetails()
    --gui:draw() 
end

function love.keypressed(key)
    player:jump(key)
    --player:enableDetails(key)
end

function beginContact(a, b, collision)
    --if Coin.beginContact(a, b, collision) then return end
    player:beginContact(a, b, collision)
end

function endContact(a, b, collision)
    player:endContact(a, b, collision)
end