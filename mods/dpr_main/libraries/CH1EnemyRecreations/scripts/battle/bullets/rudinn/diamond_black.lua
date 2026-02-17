local DiamondBlack, super = Class(Bullet)

function DiamondBlack:init(x, y)
    super.init(self, x, y, "battle/bullets/diamond_form")

	self.alpha = 0
	self:fadeToSpeed(1, 0.1)
    self.rotation = Utils.angle(self.x, self.y, Game.battle.soul.x, Game.battle.soul.y)
    self.physics.speed = 0
	self.physics.match_rotation = true
    self.grazed = false
    self.collider = PolygonCollider(self, {{11, 16}, {16, 14}, {21, 16}, {16, 18}, {11, 16}})
    self.collidable = false
    self.activetimer = 0
    self.difficulty = 1
    self.times = 0
    self.dont = 0
end

function DiamondBlack:update()
	super.update(self)

	if (self.scale_x <= 1) or (self.scale_y <= 1) then
		self.graphics.grow = 0
	else
		self.graphics.grow = -0.1
	end

    if self.collidable == false then
        self.rotation = Utils.angle(self.x, self.y, Game.battle.soul.x, Game.battle.soul.y)

        if self.alpha < 1 then
        else
            self.physics.direction = Utils.angle(self.x, self.y, Game.battle.soul.x, Game.battle.soul.y)
            self.rotation = self.physics.direction
            self.collidable = true
            self.physics.speed = 0
        end
    end
	
    if self.collidable == true then
        self.activetimer = self.activetimer + DTMULT

        if self.activetimer >= 5 and self.times < self.difficulty then
            local bul = self.wave:spawnBullet("rudinn/diamond_white", self.x, self.y, self.rotation)
            bul.tp = self.tp
            bul.physics.direction = self.rotation

            self.times = self.times + 1
            self.activetimer = 0
        end

        if self.activetimer >= 5 and self.times >= self.difficulty then
            self:fadeToSpeed(0, 0.2)

            if self.alpha <= 0 then
                self:remove()
            end
        end
    end

	if self.y < 40 then
	    self.y = 40
	end
end

return DiamondBlack