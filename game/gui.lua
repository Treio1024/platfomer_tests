gui = {}

local lLove = love
local lString = string

function gui:load()
    self.coin = {}

    self:loadCoin()
end

function gui:update(dt)
    self:changeCoinPos()
end

function gui:draw()
    player:showDetails()
    self:drawCoin()
end

function gui:loadCoin()
    self.coin.image = lLove.graphics.newImage'images/gold_coin.png'
    self.coin.width, self.coin.height = self.coin.image:getDimensions()
    self.coin.x, self.coin.y = 10, 10
end

function gui:drawCoin()
    lLove.graphics.draw(self.coin.image, self.coin.x, self.coin.y, 0, 2)
    lLove.graphics.print(tostring(player.coinsAmount), self.coin.x + self.coin.width * 2.5, self.coin.y + 2, 0, 2)
end

function gui:changeCoinPos()
    if player.detailsOn then
        self.coin.x, self.coin.y = 150, 10
    else
        self.coin.x, self.coin.y = 10, 10
    end
end