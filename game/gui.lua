gui = {}

function gui:load()
    self.coin = {}

    self.detailsOn = false

    self.coin.image = love.graphics.newImage'assets/gold_coin.png'
    self.coin.width, self.coin.height = self.coin.image:getDimensions()
    self.coin.x, self.coin.y = 10, 75

    self.hearts = {}
    self.hearts.array = love.graphics.newArrayImage({'assets/heart.png', 'assets/heart.png', 'assets/heart.png'})
    self.hearts.array2 = love.graphics.newArrayImage({'assets/deadheart.png', 'assets/deadheart.png', 'assets/deadheart.png'})
    self.hearts.x, self.hearts.y = 10, 10
    self.hearts.x2 = 0
end

function gui:update(dt)
    self:changeGuiPos()
end

function gui:draw()
    self:drawHearts()

    self:drawCoin()
    self:showDetails()
end

----------------------------------------------------------------------------------------------------

function gui:showDetails()
    if gui.detailsOn then
        love.graphics.print(string.format(
        "love_version_%.1f\nfps_%d\nx_vel_%.2f\ny_vel_%.2f\nx_%.2f\ny_%.2f\ndebugX_%.2f\ndebugY_%.2f\non_ground_%s\nhealth_%d\ncoin_amout_%d",
        love.getVersion(), love.timer.getFPS(), player.xvel, player.yvel, player.x, player.y, player.x - player.width / 2, player.y - player.height / 2, player.onGround, player.health, player.coinsAmount), 0, 0, 0)
    end
end

function gui:showDetailsOnCamera()
    if gui.detailsOn then
        world:draw(0xff)
            
        love.graphics.circle('fill', player.x, player.y, 5)
        love.graphics.circle('fill', player.x - player.width / 2, player.y - player.height / 2, 5)
    end
end

function gui:enableDetails(key)
    if key == "f3" then
        self.detailsOn = not self.detailsOn
    end
end

----------------------------------------------------------------------------------------------------

function gui:drawCoin()
    love.graphics.draw(self.coin.image, self.coin.x, self.coin.y, 0, 2)
    love.graphics.print(tostring(player.coinsAmount), self.coin.x + self.coin.width * 2.5, self.coin.y + 2, 0, 2)
end

function gui:drawHearts()
    for i=1, 3 do
        love.graphics.drawLayer(self.hearts.array2, i, self.hearts.x, self.hearts.y, 0, 3)
        self.hearts.x = self.hearts.x + 64
    end
    self.hearts.x = self.hearts.x2

    for i=1, player.health do
        love.graphics.drawLayer(self.hearts.array, i, self.hearts.x, self.hearts.y, 0, 3)
        self.hearts.x = self.hearts.x + 64
    end
    self.hearts.x = self.hearts.x2
end

function gui:changeGuiPos()
    if self.detailsOn then
        self.coin.x = 150
        self.hearts.x2 = 150
    else
        self.coin.x = 10
        self.hearts.x2 = 10
    end
end