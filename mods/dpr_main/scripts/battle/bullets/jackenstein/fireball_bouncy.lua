local FireballBouncy, super = Class(Bullet)

function FireballBouncy:init(x, y, sprite)
    -- Last argument = sprite path
    super.init(self, x, y)

	self.tp = 0
	self:setOrigin(0.5,0.5)
    self:setSprite(sprite or "battle/bullets/jackenstein/bullet/pumpkin_spin", 0, false)
	self.basex = self.x
	self.basey = self.y
	self.frame = 0
	self.iris_tex = Assets.getFrames("battle/bullets/jackenstein/bullet/iris")
	self.iris = false
	self.iris_dir = math.rad(-1)
	self.bounce_collider = CircleCollider(self, 0, 0, 16)
end

function FireballBouncy:getDamage()
	local dmg = super.getDamage(self)
	if Game.battle.encounter.scaredy_cat then
		return MathUtils.round(dmg * 1.5)
	else
		return dmg
	end
end

function FireballBouncy:update()
    super.update(self)
	if self.sprite.texture_path == "battle/bullets/jackenstein/bullet/pumpkin_horizontal" then
		self.frame = MathUtils.approach(self.frame, 2 - (2 * MathUtils.sign(self.physics.speed_x)), 0.2 * DTMULT)
		self:setFrame(math.floor(self.frame+1))
	elseif self.sprite.texture_path == "battle/bullets/jackenstein/bullet/pumpkin_verticaal" then
		self.frame = MathUtils.approach(self.frame, 2 - (2 * MathUtils.sign(self.physics.speed_y)), 0.2 * DTMULT)
		self:setFrame(math.floor(self.frame+1))
	end
	if self.iris then
		self.iris_dir = self.iris_dir + (MathUtils.angleDiff(self.physics.direction, self.iris_dir) / 5) * DTMULT
	end
end

function FireballBouncy:draw()
    super.draw(self)
	if self.iris then
		local big = 0
		if self.width > 12 then
			big = 1
		end
		Draw.draw(self.iris_tex[big+1], -math.cos(self.iris_dir) * 4, -math.sin(self.iris_dir) * 4, self.iris_dir, 1, 1, 2, 3)
	end 
	if DEBUG_RENDER and self.bounce_collider then
        self.bounce_collider:draw(0, 0, 1)
    end
end

return FireballBouncy