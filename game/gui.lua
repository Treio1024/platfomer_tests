gui = {}

function gui:load()
    self.coin = {}

    self.detailsOn = false

    self:loadCoin()
end

function gui:update(dt)
    self:changeCoinPos()
end

function gui:draw()
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

function gui:enableDetails(key)
    if key == "f3" then
        self.detailsOn = not self.detailsOn
    end
end

----------------------------------------------------------------------------------------------------

function gui:loadCoin()
    self.coin.image = love.graphics.newImage'assets/gold_coin.png'
    self.coin.width, self.coin.height = self.coin.image:getDimensions()
    self.coin.x, self.coin.y = 10, 10
end

function gui:drawCoin()
    love.graphics.draw(self.coin.image, self.coin.x, self.coin.y, 0, 2)
    love.graphics.print(tostring(player.coinsAmount), self.coin.x + self.coin.width * 2.5, self.coin.y + 2, 0, 2)
end

function gui:changeCoinPos()
    if self.detailsOn then
        self.coin.x, self.coin.y = 150, 10
    else
        self.coin.x, self.coin.y = 10, 10
    end
end