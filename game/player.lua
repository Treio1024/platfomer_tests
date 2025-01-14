player = {}

function player:load() --principal functions
    self.x = 100; self.y = 100
    self.width = 48 * 2; self.height = 80 * 2
    self.xvel = 0; self.yvel = 0
    self.MAX_SPEED = 500
    self.ACCELERATION = 3500
    self.FRICTION = 6000
    self.GRAVITY = 1250
    self.onGround = false
    self.jumpCounter = 0
    self.graceTime = 0
    self.direction = ""; self.state = "idle"; self.onTheWall = false
    self.coinsAmount = 0
    --print'attributes_loaded'
    --print'assets_loaded'
    self.collider = world:newRectangleCollider(self.x, self.y, self.width, self.height)
    self.collider:setType('dynamic')
    self.collider:setFixedRotation(true)
    --print'physics_loaded'

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
    --self:setState()
    --self:animate(dt)
    --self:decreaseGraceTime(dt)
    self:syncPhysics()
    self:move(dt)
    self:applyGravity(dt)
    self.animations.actual:update(dt)
end

function player:draw() 
    --[[local X
    if self.direction == 'right' then X = 1
    else  X = -1 end]]--
    
    --love.graphics.draw(love.graphics.newImage'images/sprites/idle1.png', self.x / 2, self.y / 2, 0, 1, 1, self.width / 4, self.height / 4)
    self.animations.actual:draw(self.spritesheet, (self.x / 2) - 24, (self.y / 2) - 40)
end --end

--[[function player:loadAssets() --animation functions
    self.animation = {timer = 0, rate = 0.25}
    
    self.animation.walk = {total = 4, current = 1, image = {lLove.graphics.newImage'images/sprites/walking1.png', lLove.graphics.newImage'images/sprites/walking2.png',
    lLove.graphics.newImage'images/sprites/walking3.png', lLove.graphics.newImage'images/sprites/walking2.png'}}
    
    self.animation.jump = {total = 1, current = 1, image = {lLove.graphics.newImage'images/sprites/jumping1.png'}}
    self.animation.idle = {total = 1, current = 1, image = {lLove.graphics.newImage'images/sprites/idle1.png'}}
    
    self.animation.draw = self.animation.idle.image[1]
    
    self.width, self.height = self.animation.draw:getDimensions()    
end

function player:animate(dt)
    self.animation.timer = self.animation.timer + dt
    
    if self.animation.timer > self.animation.rate then
        self.animation.timer = 0
        self:setNewFrame()
        
    end
end

function player:setNewFrame()
    if self.animation[self.state].current < self.animation[self.state].total then
        self.animation[self.state].current = self.animation[self.state].current + 1
    else
        self.animation[self.state].current = 1
    end
    self.animation.draw = self.animation[self.state].image[self.animation[self.state].current]
    self.width, self.height = self.animation[self.state].image[self.animation[self.state].current]:getDimensions()
end]]--

--[[function player:setState()
    if not self.onGround then
        self.state = "jump"
    elseif (self.xVel > 0 or self.xVel < 0) and (not self.onTheWall) then
        self.state = "walk"
    else
        self.state = "idle"
    end
end --end]]--

function player:move(dt)
    if love.keyboard.isDown'right' then
        
        self.xvel = math.min(self.xvel + self.ACCELERATION * dt, self.MAX_SPEED)
    elseif love.keyboard.isDown'left' then
        
        self.xvel = math.max(self.xvel - self.ACCELERATION * dt, -self.MAX_SPEED)
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
    self.jumpCounter = 2
    self.graceTime = 0.9
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

            if ny == 1 then
                self:land(collision)
            elseif ny == 1 then                
                self.yvel = 0
            end

        end
    end
end

function player:endContact(a, b, collision)
    --print'contact_ended'
    local nx, ny = collision:getNormal()
    if a == player.collider.fixture or b == player.collider.fixture then
        if self.currentGroundCollision == collision then
            self.onGround = false
        end
    end 
end --end


function player:syncPhysics()
    self.x, self.y = self.collider:getPosition()
    self.collider:setLinearVelocity(self.xvel, self.yvel)
end