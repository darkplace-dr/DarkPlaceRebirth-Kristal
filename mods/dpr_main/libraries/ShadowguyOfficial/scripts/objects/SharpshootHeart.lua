local SharpshootHeart, super = Class(Object)

function SharpshootHeart:init(x, y, cursor)
    super.init(self, x, y)
	
	self.layer = BATTLE_LAYERS["top"]
	self:setOrigin(0.5, 0.5)
	self.heart = Sprite("player/sharpshoot_heart", 0, 0)
	self.heart:setScale(0.5, 0.5)
	self:addChild(self.heart)
	
	self.heart_afterimages = {}
	
	for i = 0, 8 do
		self.heart_afterimages[i+1] = Sprite("player/sharpshoot_heart", 0, 0)
		self.heart_afterimages[i+1]:setScale(0.5, 0.5)
		self.heart_afterimages[i+1].layer = self.layer - i-9
		self:addChild(self.heart_afterimages[i+1])
	end
	
	self:setHitbox(0, 0, 10, 10)

	self.cursor = cursor or nil
	
	local angle = Utils.angle(self.x, self.y, cursor.x, cursor.y)
	self.physics.direction = angle
	self.physics.speed = 50
	self.remove_offscreen = true
	
	self.con = 0
	self.savey = 0
	self.timer = 0
	self.prevx = self.x
	self.prevy = self.y
	self.prevprevx = self.prevx
	self.prevprevy = self.prevy
end

function SharpshootHeart:update()
	super.update(self)
	
    if self.x < -80 or self.y < -80 or self.x > SCREEN_WIDTH + 80 or self.y > SCREEN_HEIGHT + 80 then
        self:remove()
    end
	
	if self.con == 1 then
		if self.y > self.savey then
			self.con = 2
			self:fadeOutAndRemove(5/30)
		end
	end
	for _,target in ipairs(Game.stage:getObjects(SharpshootTarget)) do
		if self:collidesWith(target) then
			if self.con == 0 and target.hittable and not target.enemy.spare_after_sharpshoot then
				self.con = 1
				self.savey = target.enemy.y + 70 + love.math.random(0, 35)
				self:hitSomething()
				target.shake = 6
				target.enemy.sharpshootmercy = target.enemy.sharpshootmercy + 10
				target.sparehp = target.sparehp - 1
				if (target.spare == false and target.enemy.mercy + target.enemy.sharpshootmercy >= 100) or (target.spare == true and target.sparehp <= 0) then
					if target.already_spared then
						target.enemy:sharpshootSpare()
						target:reset()
					else
						target:doSpare()
					end
				end
				Assets.stopAndPlaySound("bump")
			end
		end
	end
	for i = 0, 8 do
		self.heart_afterimages[i+1].x = Utils.lerp((self.prevprevx-self.x)*(FPS/30), 0, i / 8)
		self.heart_afterimages[i+1].y = Utils.lerp((self.prevprevy-self.y)*(FPS/30), 0, i / 8)
		self.heart_afterimages[i+1].alpha = (0.1 + (i / 16)) * self.alpha
	end
	if self.timer >= 1 then
		self.prevprevx = self.prevx
		self.prevprevy = self.prevy
	end
	self.prevx = self.x
	self.prevy = self.y
	self.timer = self.timer + DTMULT
end

function SharpshootHeart:hitSomething()
	local effect = Sprite("effects/attack/slap_n")
	effect:setOrigin(0.5, 0.5)
	effect:setPosition(self.x, self.y)
	effect.layer = BATTLE_LAYERS["top"]
	effect:play(1/30, false, function(s) s:remove() end)
	Game.battle:addChild(effect)
	self.physics.speed_x = Utils.pick({2, -1, -2, 1})
	self.physics.speed_y = -10 - Utils.random(3)
	self.physics.gravity = 2
	self.savey = self.y + 20
end

return SharpshootHeart