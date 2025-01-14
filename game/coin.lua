Coin = {}; Coin.__index = Coin
aCoins = {}

local lLove = love
local lTable = table
local lMath = math

function Coin.new(x, y) --principal functions
    local i = setmetatable(
        {x = x, y = y, image = love.graphics.newImage'images/gold_coin.png'}, Coin)
    i.width, i.height = i.image:getDimensions()
    i.scaleX = 0
    i.spinRandom = love.math.random(1.0000, 2.0000)
    i.remove = false

    i.physics = {}
    i.physics.body = love.physics.newBody(world, i.x, i.y, "static")
    i.physics.shape= love.physics.newRectangleShape(i.width, i.height)
    i.physics.fixture = love.physics.newFixture(i.physics.body, i.physics.shape)
    i.physics.fixture:setSensor(true)

    lTable.insert(aCoins, i)

    return i
end

function Coin:update(dt)
    self:spin(dt)
    self:check()
end

function Coin:draw()
    lLove.graphics.draw(self.image, self.x, self.y, 0, self.scaleX, 1, self.width / 2, self.height / 2)
end --end

function Coin.updateA(dt)
    for _, v in ipairs(aCoins) do
        v:update(dt)
    end
end

function Coin.drawA()
    for _, v in ipairs(aCoins) do
        v:draw()
    end
end

function Coin:spin(dt)
    self.scaleX = lMath.sin(lLove.timer.getTime() * self.spinRandom)
end

function Coin:removeCoin()
    for i, v in ipairs(aCoins) do
        if v == self then
            player.coinsAmount = player.coinsAmount + 1
            self.physics.body:destroy()
            lTable.remove(aCoins, i)
        end
    end
end

function Coin:check()
    if self.remove then
        self:removeCoin()
    end
end

function Coin.beginContact(a, b, contact)
    for _, v in ipairs(aCoins) do
        if (a == v.physics.fixture or b == v.physics.fixture) and (a == player.physics.fixture or b == player.physics.fixture) then   
            v.remove = true
            return true
        end
    end
end