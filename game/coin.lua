Coin = {}; Coin.__index = Coin
Coin.sound = love.audio.newSource('assets/audio/coinSound.wav', 'static')
aCoins = {}

function Coin.new(x, y)
    local i = setmetatable({}, Coin)

    i.image = love.graphics.newImage'assets/gold_coin.png'

    i.x = x; i.y = y
    i.width, i.height = i.image:getDimensions()
    
    i.scaleX = 0
    i.spinRandom = love.math.random(1.2754910, 2.120194)
    
    i.remove = false

    ----------------------------------------------------------------------------------------------------

    i.collider = world:newRectangleCollider(i.x, i.y, i.width * 4, i.height * 4)
    i.collider:setType('static')
    i.collider:setSensor(true)
    table.insert(aCoins, i)

    return i
end

function Coin.update(dt)
    for i, v in ipairs(aCoins) do
        v.scaleX = math.sin(love.timer.getTime() * v.spinRandom)

        if v.remove then
            player.coinsAmount = player.coinsAmount + 1
            v.collider.body:destroy()
            table.remove(aCoins, i)

            Coin.sound:stop()
            Coin.sound:play()
        end
    end
end

function Coin.draw()
    for _, v in ipairs(aCoins) do
        love.graphics.draw(v.image, v.x / 2 + v.width, v.y / 2 + v.height, 0, v.scaleX, 1, v.width / 2, v.height / 2)
    end
end

----------------------------------------------------------------------------------------------------

function Coin.remove()
    for i, v in ipairs(aCoins) do
        v.collider:destroy()
        aCoins[i] = nil
    end
end

----------------------------------------------------------------------------------------------------

function Coin.beginContact(a, b, contact)
    for _, v in ipairs(aCoins) do
        if (a == v.collider.fixture or b == v.collider.fixture) and (a == player.collider.fixture or b == player.collider.fixture) then   
            v.remove = true
            return true
        end
    end
end