player = {}

function player:load() --principal functions
    self.x = 64; self.y = 1312
    self.startx = self.x; self.starty = self.y
    self.endx = 1235
    self.width = 48 * 2; self.height = 80 * 2
    self.xvel = 0; self.yvel = 0
    self.MAX_SPEED = 750
    self.ACCELERATION = 3500
    self.FRICTION = 6000
    self.GRAVITY = 1250
    self.onGround = false
    self.jumpCounter = 0
    self.graceTime = 0
    self.direction = ""; self.onTheWall = false
    self.coinsAmount = 0

    self.collider = world:newRectangleCollider(self.x, self.y, self.width, self.height)
    self.collider:setType('dynamic')
    self.collider:setFixedRotation(true)

    self.spritesheet = love.graphics.newImage'images/spritesheet.png'
    self.grid = anim8.newGrid(48, 80, 288, 160)
    
    self.animations = {}
    self.animations.walk_right = anim8.newAnimation(self.grid('1-4', 1), 0.2)
    self.animations.walk_left = anim8.newAnimation(self.grid('1-4', 2), 0.2)

    self.animations.jump_right = anim8.newAnimation(self.grid('5-5', 1), 1)
    self.animations.jump_left = anim8.newAnimation(self.grid('5-5', 2), 1)

    self.animations.idle_right = anim8.newAnimation(self.grid('6-6', 1), 1)
    self.animations.idle_left = anim8.newAnimation(self.grid('6-6', 2), 1)

    self.animations.actual = self.animations.idle_right
end

function player:update(dt)
    self:backToStart()
    self:syncPhysics()
    --self:decreaseGraceTime(dt)
    self:move(dt)
    self:setState()
    self.animations.actual:update(dt)
    self:applyGravity(dt)
end

function player:draw() 
    self.animations.actual:draw(self.spritesheet, (self.x / 2) - 24, (self.y / 2) - 40)
end --end

function player:setState()
    if not self.onGround then
        if self.direction == "right" then
            self.animations.actual = self.animations.jump_right
        else
            self.animations.actual = self.animations.jump_left
        end
    elseif self.xvel == 0 or self.onTheWall then
        if self.direction == "right" then
            self.animations.actual = self.animations.idle_right
        else
            self.animations.actual = self.animations.idle_left
        end
    end
end

function player:move(dt)
    if love.keyboard.isDown'right' then
        
        self.xvel = math.min(self.xvel + self.ACCELERATION * dt, self.MAX_SPEED)
        self.direction = "right"
        self.animations.actual = self.animations.walk_right
    elseif love.keyboard.isDown'left' then
        
        self.xvel = math.max(self.xvel - self.ACCELERATION * dt, -self.MAX_SPEED)
        self.direction = "left"
        self.animations.actual = self.animations.walk_left
    else
        self:friction(dt)
    end
end

function player:friction(dt)
    if self.xvel > 0 then

        self.xvel = math.max(self.xvel - self.FRICTION * dt, 0)
    elseif self.xvel < 0 then
        
        self.xvel = math.min(self.xvel + self.FRICTION * dt, 0)
    end
end

function player:applyGravity(dt)
    if not self.onGround and self.yvel < 800 then
        self.yvel = self.yvel + self.GRAVITY * dt
    end
end

function player:jump(key)
    if key == 'space' or key == 'up' then
        --print(self.onGround)
        if self.onGround then
            self.yvel = -750
            --print'jumped'
        elseif self.jumpCounter > 0 and self.graceTime > 0 then -- double jump
            self.yvel = -750 * 0.8
            self.jumpCounter = self.jumpCounter - 1
            --print'double_jumped'
        end
    end
end

function player:decreaseGraceTime(dt)
    if not self.onGround then
        self.graceTime = self.graceTime - dt
    end
end

function player:land(collision) 
    self.currentGroundCollision = collision
    self.yvel = 0
    self.onGround = true
    self.jumpCounter = 90
    self.graceTime = 0.9
end

function player:backToStart()
    if self.x > map.levels[map.current_level].properties.endX and (self.y >= map.levels[map.current_level].properties.endY2 or self.y <= map.levels[map.current_level].properties.endY1) then
    
        map:next(true)
        self.collider:setPosition(map.levels[map.current_level].properties.startX, map.levels[map.current_level].properties.startY)
    elseif self.x < 0 and (self.y >= map.levels[map.current_level].properties.startY or self.y <= map.levels[map.current_level].properties.startY) then
        
        map:next(false)
        self.collider:setPosition(map.levels[map.current_level].properties.endX - 32, map.levels[map.current_level].properties.endY1)
    end
end --end

function player:beginContact(a, b, collision) --collision callbacks
    --print'contact_started'
    local nx, ny = collision:getNormal()
    
    if not self.onGround then
        if a == player.collider.fixture then

            if ny == 1 then
                self:land(collision)
            elseif ny == -1 then
                self.yvel = 0
            end
            
        elseif b == player.collider.fixture then

            if ny == -1 then
                self:land(collision)
            elseif ny == 1 then                
                self.yvel = 0
            end

        end
    end

    if nx == 1 or nx == -1 then
        self.onTheWall = true
        self.currentWallCollision = collision
    end
end

function player:endContact(a, b, collision)
    --print'contact_ended'
    local nx, ny = collision:getNormal()

    if a == player.collider.fixture or b == player.collider.fixture then
        if self.currentGroundCollision == collision then
            self.onGround = false
        end

        if self.currentWallCollision == collision then
            self.onTheWall = false
        end
    end 
end --end

function player:syncPhysics()
    self.x, self.y = self.collider:getPosition()
    self.collider:setLinearVelocity(self.xvel, self.yvel)
end