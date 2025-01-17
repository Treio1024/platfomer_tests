Coin = {}; Coin.__index = Coin
aCoins = {}

function Coin.new(x, y) --principal functions
    local i = setmetatable(
        {x = x, y = y, image = love.graphics.newImage'images/gold_coin.png'}, Coin)
    i.width, i.height = i.image:getDimensions()
    i.scaleX = 0
    i.spinRandom = love.math.random(1.2754910, 2.120194)
    i.remove = false

    i.collider = world:newRectangleCollider(i.x, i.y, i.width * 2, i.height * 2)
    i.collider:setType('static')
    i.collider:setSensor(true)

    table.insert(aCoins, i)

    return i
end

function Coin:update(dt)
    self:spin(dt)
    self:check()
end

function Coin:draw()
    love.graphics.draw(self.image, self.x / 2 + self.width / 2, self.y / 2 + self.height / 2, 0, self.scaleX, 1, self.width / 2, self.height / 2)
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
    self.scaleX = math.sin(love.timer.getTime() * self.spinRandom)
end

function Coin:removeCoin()
    for i, v in ipairs(aCoins) do
        if v == self then
            player.coinsAmount = player.coinsAmount + 1
            self.collider.body:destroy()
            table.remove(aCoins, i)
        end
    end
end

function Coin:removeALL()
    for i, v in ipairs(aCoins) do
        v.collider:destroy()
        aCoins[i] = nil
    end
end

function Coin:check()
    if self.remove then
        self:removeCoin()
    end
end

function Coin.beginContact(a, b, contact)
    for _, v in ipairs(aCoins) do
        if (a == v.collider.fixture or b == v.collider.fixture) and (a == player.collider.fixture or b == player.collider.fixture) then   
            v.remove = true
            return true
        end
    end
end