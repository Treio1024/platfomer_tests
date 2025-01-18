love.graphics.setDefaultFilter("nearest", "nearest")
    
require'player'
require'gui'
map = require'map'

wf = require'libraries/windfield'
anim8 = require'libraries/anim8'
gamera = require'libraries.gamera'

function love.load()
    --print'main_'
    background = love.graphics.newImage'images/background.png'
    
    map:load()
    player:load()
    gui:load()
    cam = gamera.new(0, 0, 3840, 1546)
    cam:setWindow(0, 0, 1280, 768)
end

function love.update(dt)
    world:update(dt)
    player:update(dt)
    Coin.updateA(dt)
    gui:update(dt)
    cam:setPosition(player.x, player.y)
end

function love.draw()

    cam:draw(function()
        local camx, camy = cam:getPosition()

        --map.levels[map.current_level]:draw(camx, camy, 2, 2)

        love.graphics.draw(map.levels[map.current_level].image, 0, 0, 0, 2)
    
        if gui.detailsOn then
            world:draw(0xff)
        end

        love.graphics.push()
        love.graphics.scale(2, 2)
            player:draw()
            Coin.drawA()
        love.graphics.pop()

    end)

    gui:draw()
end

function love.keypressed(key)
    player:jump(key)
    gui:enableDetails(key)

    if key == 'g' then
        map:next(true)
    end
end

function beginContact(a, b, collision)
    if Coin.beginContact(a, b, collision) then return end
    player:beginContact(a, b, collision)
end

function endContact(a, b, collision)
   player:endContact(a, b, collision)
end