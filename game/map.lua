local sti = require'libraries/sti'

require'coin'

local map = {}

function map:load()
    self.current_level = 1

    world = wf.newWorld(0, 0, false)
    world.box2d_world:setCallbacks(beginContact, endContact)

    self:init()
    
end

function map:init()
    self.level = sti('images/map'.. self.current_level ..'.lua', {'box2d'})
    self.level.layers.solids.visible = false

    self.statics = {}
    for i, obj in pairs(self.level.layers["solids"].objects) do
        local static = world:newRectangleCollider(obj.x * 2, obj.y * 2, obj.width * 2, obj.height * 2)
        static:setType('static')
        table.insert(self.statics, static)
    end
end

function map:next()
    self:clean()
    if self.current_level + 1 < 3 then
        self.current_level = self.current_level + 1
    else
        self.current_level = 1
    end
        self:init()
end

function map:clean()
    Coin:removeALL()

    for i, v in ipairs(self.statics) do
        v:destroy()
        self.statics[i] = nil
    end
end

return map