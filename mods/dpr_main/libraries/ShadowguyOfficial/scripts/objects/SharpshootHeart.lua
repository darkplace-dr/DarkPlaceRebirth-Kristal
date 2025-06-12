local SharpshootHeart, super = Class(Object)

function SharpshootHeart:init(x, y, cursor)
    super.init(self, x, y)
	
	self:setOrigin(0.5, 0.5)
	self.heart = Sprite("player/sharpshoot_heart", 0, 0)
	self.heart:setScale(0.5, 0.5)
	self:addChild(self.heart)
	
	self:setHitbox(0, 0, 10, 10)

	self.cursor = cursor or nil
	
	local angle = Utils.angle(self.x, self.y, cursor.x, cursor.y)
	self.physics.direction = angle
	self.physics.speed = 50
	self.remove_offscreen = true
	
	self.con = 0
	self.savey = 0
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