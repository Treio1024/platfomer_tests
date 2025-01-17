love.graphics.setDefaultFilter("nearest", "nearest")
    
require'player'
require'gui'
map = require'map'

wf = require'libraries/windfield'
anim8 = require'libraries/anim8'

function love.load()
    --print'main_'
    background = love.graphics.newImage'images/background.png'
    
    map:load()
    player:load()
    gui:load()

    local counter = 0
    for i=1, 5 do
        Coin.new(325 + counter, 350)
        counter = counter + 50
    end
end

function love.update(dt)
    world:update(dt)
    player:update(dt)
    Coin.updateA(dt)
    gui:update(dt)
end

function love.draw()
    love.graphics.draw(background)
    
    map.level:draw(0, 0, 2, 2)
    
    if gui.detailsOn then
        world:draw(0xff)
    end

    love.graphics.push()
    love.graphics.scale(2, 2)
    
    player:draw()
    Coin.drawA()

    love.graphics.pop()

    gui:draw() 
end

function love.keypressed(key)
    player:jump(key)
    gui:enableDetails(key)

    if key == 'g' then
        map:next()
    end
end

function beginContact(a, b, collision)
    if Coin.beginContact(a, b, collision) then return end
    player:beginContact(a, b, collision)
end

function endContact(a, b, collision)
   player:endContact(a, b, collision)
end