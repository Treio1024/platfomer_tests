require'coin'

local map = {}

function map:load()
    self.levels = require'levels'

    self.current_level = self.levels.lobby

    world = wf.newWorld(0, 0, false)
    world.box2d_world:setCallbacks(beginContact, endContact)

    self.statics = {}
    self.current_level:load()
end

function map:update(dt)
    self.current_level:update()
end

----------------------------------------------------------------------------------------------------

function map:clean()
    Coin.remove()
    spikes.remove()

    for i, v in ipairs(self.statics) do
        v:destroy()
        self.statics[i] = nil
    end
end

return map