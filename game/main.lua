love.graphics.setDefaultFilter("nearest", "nearest")
    
require'coin'
require'player'
require'gui'
require'spikes'
require'map'

wf = require'libraries/windfield'
anim8 = require'libraries/anim8'
gamera = require'libraries.gamera'

cam = gamera.new(0, 0, 3840, 1546)

----------------------------------------------------------------------------------------------------

function love.load()
    map:load()
    player:load()
    gui:load()

    cam:setWindow(0, 0, 1280, 768)
end

function love.update(dt)
    map:update(dt)
    world:update(dt)

    player:update(dt)

    Coin.update(dt)
    
    gui:update(dt)

    cam:setPosition(player.x, player.y)
end

function love.draw()

    cam:draw(function()
        love.graphics.draw(map.current_level.image, 0, 0, 0, 2)
        
        love.graphics.push()
        love.graphics.scale(2, 2)
        player:draw()
        Coin.draw()
        spikes.draw()
        love.graphics.pop()
        
        gui:showDetailsOnCamera()
    end)
    
    gui:draw()
end

----------------------------------------------------------------------------------------------------

function love.keypressed(key)
    player:jump(key)
    gui:enableDetails(key)

    if key == 'escape' then
        love.window.close()
    end

    if key == 'g' then
        player.collider = world:newRectangleCollider(player.x, player.y, 24, 40)
        player.collider:setType('dynamic')
        player.collider:setFixedRotation(true)

        player.onGround = false
    end
end

----------------------------------------------------------------------------------------------------

function beginContact(a, b, collision)
    if Coin.beginContact(a, b, collision) then return end
    if spikes.beginContact(a, b, collision) then return end
    player:beginContact(a, b, collision)
end

function endContact(a, b, collision)
   player:endContact(a, b, collision)
end