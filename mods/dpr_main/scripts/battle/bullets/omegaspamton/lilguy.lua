local LilGuy, super = Class(Bullet)

function LilGuy:init(x, y)
    super.init(self, x, y)
	
    self:setSprite("battle/bullets/omegaspamton/lilguy", 0, false)
    self:setScale(1, 1)
	
    self:setHitbox(10, 14, 20, 22)
	self.collider.collidable = false

    self.blue_siner = 0
    self.red_siner = 0
	
    self.loop = false
    self.loopy_1 = 90
    self.loopy_2 = 240
	
    self.false_speed_y = 0
    self.big_hitbox = 0
    self.big_head = 0
	
    self.alt_direction = 0
    self.alt_speed = 0
    self.alt_friction = 0
    self.alt_gravity = 0
	
    self.angle_speed = 0
    self.angle_adjust = 0
	
    self.change_direction = false
	
    self.bullet_speed = 8

    self.is_cutscene = false

    self.tp = 2
	
    self.timer = Timer()
    self:addChild(self.timer)
end

function LilGuy:update()
    super.update(self)
	
    if self.is_cutscene == false then
        if self.x >= Game.battle.camera.x/2 + 1000 or self.x <= Game.battle.camera.x/2 - 200 or self.y >= Game.battle.camera.y/2 + 600 or self.y <= Game.battle.camera.y/2 - 200 then
            self:remove()
        end
    end

    self.physics.direction = self.physics.direction + self.angle_speed * DTMULT
	
    if self.angle_adjust == 1 then
        self.sprite.angle = self.physics.direction
    end

    if self.loop == true then
        if self.y < self.loopy_1 then
            self.y = self.loopy_2 - (self.loopy_1 - self.y) * DTMULT
		end
        if self.y > self.loopy_2 then
            self.y = self.loopy_1 + (self.y - self.loopy_2) * DTMULT
        end
    end

    self.y = self.y + self.false_speed_y * DTMULT
end

function LilGuy:switchToAlternatePhysics()
    if self.change_direction then
	    self.physics.direction = self.alt_direction
        self.physics.gravity = self.alt_gravity
	    self.physics.friction = self.alt_friction
	    self.physics.speed_x = self.alt_speed
    end
end

function LilGuy:fire()
    if self.collider.collidable == true then
        local bullet = self.wave:spawnBullet("omegaspamton/lilguy_bullet", self.x, self.y + 12)
        bullet.physics.speed = self.bullet_speed
        bullet.physics.direction = Utils.angle(self.x, self.y, Game.battle.soul.x, Game.battle.soul.y)
        bullet.layer = self.layer - 1
    end
end

function LilGuy:resetAnimationIndex()
    if self.collider.collidable == true then
        self:setSprite("battle/bullets/omegaspamton/lilguy", 0.1, false)
    end
end

function LilGuy:onCollide(soul)
    super.onCollide(self, soul)

    self.collider.collidable = false
end

return LilGuy