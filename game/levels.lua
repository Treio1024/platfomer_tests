local sti = require'libraries/sti'

levels = {}

levels[1] = sti('images/map1.lua', {'box2d'})
levels[1].image = love.graphics.newImage'images/map1.png'

levels[2] = sti('images/map2.lua', {'box2d'})
levels[2].image = love.graphics.newImage'images/map2.png'

return levels