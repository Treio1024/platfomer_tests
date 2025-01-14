local lLove = love

lLove.graphics.setDefaultFilter("nearest", "nearest")

require'player'
require'coin'
require'gui'
sti = require'libraries/sti'

function love.load()
    --print'main_'

    map = sti('images/map.lua', {'box2d'})
    world = lLove.physics.newWorld(0, 0)
    world:setCallbacks(beginContact, endContact)
    map:box2d_init(world)
    map.layers.solids.visible = false
    background = lLove.graphics.newImage'images/background.png'
    
    player:load()
    gui:load()

    for i=1, 100 do
        Coin.new(lLove.math.random(1, 500), lLove.math.random(1, 500))
    end
end

function lLove.update(dt)
    world:update(dt)
    player:update(dt)
    Coin.updateA(dt)
    gui:update(dt)
end

function lLove.draw()
    love.graphics.draw(background)
    map:draw(0, 0, 2, 2)
    love.graphics.push()
    love.graphics.scale(2, 2)
    
    player:draw()
    Coin.drawA()

    love.graphics.pop()

    gui:draw() 
end

function lLove.keypressed(key)
    player:jump(key)
    player:enableDetails(key)
end

function beginContact(a, b, collision)
    if Coin.beginContact(a, b, collision) then return end
    player:beginContact(a, b, collision)
end

function endContact(a, b, collision)
    player:endContact(a, b, collision)
end