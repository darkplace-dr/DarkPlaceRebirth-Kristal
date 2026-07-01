local TriangleBlack, super = Class(Bullet)

function TriangleBlack:init(x, y)
    super.init(self, x, y, "battle/bullets/floradinn/triangle_form")

	self.alpha = 0
	self:fadeToSpeed(1, 0.1)
	self:setScale(2, 1)
    self.rotation = MathUtils.angle(self.x, self.y, Game.battle.soul.x, Game.battle.soul.y)
    self.physics.speed = 0
	self.physics.match_rotation = true
    self.grazed = false
    self.collider = Hitbox(self, 3, 7, 11, 4)
    self.collidable = false
    self.activetimer = 0
    self.difficulty = 1
    self.times = 0
    self.dont = 0
	self.attackers = nil
end

function TriangleBlack:update()
	super.update(self)

    if self.collidable == false then
        self.rotation = MathUtils.angle(self.x, self.y, Game.battle.soul.x, Game.battle.soul.y)

        if self.alpha < 1 then
        else
            self.physics.direction = MathUtils.angle(self.x, self.y, Game.battle.soul.x, Game.battle.soul.y)
            self.rotation = self.physics.direction
            self.collidable = true
            self.physics.speed = 0
        end
    end
	
    if self.collidable == true then
        self.activetimer = self.activetimer + DTMULT

        if self.activetimer >= 5 and self.times < self.difficulty then
            local bul = self.wave:spawnBullet("floradinn/spike_bullet", self.x, self.y, self.rotation)
            bul.tp = 1.6
            bul.physics.direction = self.rotation
			bul.scale_x = 2
			bul.physics.speed = 0
			bul.tween_timer = Game.battle.timer:tween(15/30, bul.physics, {speed = 15}, "in-back")
            for _,wave in ipairs(Game.battle.waves) do
				if wave.id == "floradinn/mane_thorn" then
					bul.physics.speed = 6
					if bul.tween_timer then
						Game.battle.timer:cancel(bul.tween_timer)
					end
					break
				end
			end

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

function TriangleBlack:draw()
	if self.dont == 0 then
		if self.collidable == false then
			local futuredir = MathUtils.angle(self.x, self.y, Game.battle.soul.x, Game.battle.soul.y)
			Draw.setColor(1,1,1,1 - self.alpha)
			love.graphics.push()
			love.graphics.origin()
			Draw.draw(self.sprite.texture, self.x, self.y, futuredir, 4 - (self.alpha * 2), 3 - (self.alpha * 2), 10, 9)
			love.graphics.pop()
		end
	end
	Draw.setColor(1,1,1,self.alpha)
	self.scale_x = 3 - self.alpha
	self.scale_y = 2 - self.alpha
	super.draw(self)
end

return TriangleBlack