spikes = {}; spikes.__index = spikes
aSpikes = {}

function spikes.new(x, y, width, height)
    local i = setmetatable({}, spikes)

    i.image = love.graphics.newImage'assets/spikes.png'
    i.width, i.height = width, height
    i.x, i.y = x, y

    i.collider = world:newRectangleCollider(i.x * 2, i.y * 2, width, height)
    i.collider:setType('static')
    i.collider:setSensor(true)
    table.insert(aSpikes, i)

    return i
end

function spikes.draw()
    for i, obj in pairs(aSpikes) do
        for i=0, obj.width / 64 - 1 do
            love.graphics.draw(obj.image, obj.x + (i * 32), obj.y)
        end
    end
end

----------------------------------------------------------------------------------------------------

function spikes.remove()
    for i, v in pairs(aSpikes) do
        v.collider:destroy()
        aSpikes[i] = nil
    end
end

----------------------------------------------------------------------------------------------------

function spikes.beginContact(a, b, contact)
    for _, v in ipairs(aSpikes) do
        if (a == v.collider.fixture or b == v.collider.fixture) and (a == player.collider.fixture or b == player.collider.fixture) then
            player:die()
            return true
        end
    end
end