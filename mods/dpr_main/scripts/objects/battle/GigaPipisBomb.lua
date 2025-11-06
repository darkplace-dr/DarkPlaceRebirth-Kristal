local GigaPipisBomb, super = Class(Object)

function GigaPipisBomb:init(x, y, time)
    super.init(self, x, y)
	
    self.sprite = Sprite("battle/bullets/omegaspamton/pipis/gigapipis_bomb")
	self.sprite:setScale(2,2)
	self:addChild(self.sprite)
	self:setOrigin(0.5, 1)
	self.countdown = false
	self.timer = time or 30
	self.frametimer = 0
	self.con = 0
	self.conb = 0
	self.shaker = 0
    self.text = Text(string.format("%02d", self.timer), 71*2, 85*2, 52, 20, {font = "bignumbers"})
	self.text.color = COLORS["red"]
    self:addChild(self.text)
end

function GigaPipisBomb:update()
    super.update(self)
	if self.countdown then
		if self.con == 0 then
			if self.frametimer >= 30 then
				self.timer = self.timer - 1
				if self.timer <= 0 then
					self.con = 1
				end
				self.text:setText(string.format("%02d", self.timer))
				Assets.playSound("pipisbomb_tick")
				self.frametimer = 0
			end
		elseif self.con == 1 then
			if self.frametimer >= 15 and self.conb == 0 then
				self:addFX(ColorMaskFX({1,1,1}, 0), "mask")
				self.graphics.shake_friction = 0
				self.shaketween = Game.battle.timer:tween(0.5, self, {shaker = 8})
				Game.battle.timer:tween(0.5, self:getFX("mask"), {amount = 1})
				self.conb = 1
			end
			if self.frametimer >= 30 then
				if self.wave.has_text then
					local encounter_text = Game.battle.battle_ui.encounter_text
					encounter_text:setSkippable(false)
					encounter_text:setAdvance(false)
					encounter_text:setText("[instant]* Defuse failed...")
				end
				for _,switch in ipairs(Game.stage:getObjects(GigaPipisSwitch)) do
					switch.switch_pressed = false
					switch:setSwitchActive(false)
				end
				Assets.playSound("explosion", 1, 0.8)
				Assets.playSound("minigames/punch_out/explosion_8bit", 1.2, 0.8)
				local shard = self.wave:spawnSprite("battle/bullets/omegaspamton/pipis/gigapipis_shards_1", self.x+self.sprite.width, self.y+self.sprite.height, self.layer+1)
				shard:addFX(ColorMaskFX())
				shard:setScale(2)
				shard.physics.direction = math.rad(-180)
				shard.physics.speed = 13
				shard.physics.gravity = 2
				shard.physics.friction = 0.05
				shard.graphics.spin = math.rad(Utils.pick({-1, 1}))
				shard = self.wave:spawnSprite("battle/bullets/omegaspamton/pipis/gigapipis_shards_2", self.x+self.sprite.width, self.y+self.sprite.height, self.layer+1)
				shard:addFX(ColorMaskFX())
				shard:setScale(2)
				shard.physics.direction = math.rad(-120)
				shard.physics.speed = 13
				shard.physics.gravity = 2
				shard.physics.friction = 0.05
				shard.graphics.spin = math.rad(Utils.pick({-1, 1}))
				shard = self.wave:spawnSprite("battle/bullets/omegaspamton/pipis/gigapipis_shards_3", self.x+self.sprite.width, self.y+self.sprite.height, self.layer+1)
				shard:addFX(ColorMaskFX())
				shard:setScale(2)
				shard.physics.direction = math.rad(-76)
				shard.physics.speed = 13
				shard.physics.gravity = 2
				shard.physics.friction = 0.05
				shard.graphics.spin = math.rad(Utils.pick({-1, 1}))
				shard = self.wave:spawnSprite("battle/bullets/omegaspamton/pipis/gigapipis_shards_4", self.x+self.sprite.width, self.y+self.sprite.height, self.layer+1)
				shard:addFX(ColorMaskFX())
				shard:setScale(2)
				shard.physics.direction = math.rad(-0)
				shard.physics.speed = 13
				shard.physics.gravity = 2
				shard.physics.friction = 0.05
				shard.graphics.spin = math.rad(Utils.pick({-1, 1}))
				shard = self.wave:spawnSprite("battle/bullets/omegaspamton/pipis/gigapipis_shards_5", self.x+self.sprite.width, self.y+self.sprite.height, self.layer+1)
				shard:addFX(ColorMaskFX())
				shard:setScale(2)
				shard.physics.direction = math.rad(-300)
				shard.physics.speed = 13
				shard.physics.gravity = 2
				shard.physics.friction = 0.05
				shard.graphics.spin = math.rad(Utils.pick({-1, 1}))
				shard = self.wave:spawnSprite("battle/bullets/omegaspamton/pipis/gigapipis_shards_6", self.x+self.sprite.width, self.y+self.sprite.height, self.layer+1)
				shard:addFX(ColorMaskFX())
				shard:setScale(2)
				shard.physics.direction = math.rad(-230)
				shard.physics.speed = 13
				shard.physics.gravity = 2
				shard.physics.friction = 0.05
				shard.graphics.spin = math.rad(Utils.pick({-1, 1}))
				self.visible = false
				local initangle = MathUtils.random(80)
				local initspeed = 10
				local initscale = 2
				local bulcount = 14
				Game.battle.timer:script(function(wait)
					for i = 1, 8 do
						for j = 0, bulcount do
							local bul = self.wave:spawnBullet("omegaspamton/pipisbullet", self.x+self.sprite.width, self.y+self.sprite.height)
							bul:setScale(initscale)
							bul.physics.direction = math.rad(initangle + MathUtils.random(20))
							bul.physics.speed = 2 + initspeed
							initangle = initangle + (360 / bulcount)
						end
						initspeed = initspeed - 1
						initangle = initangle + 8
						initscale = initscale - 0.2
						wait(2/30)
					end
				end)
				Game.battle.timer:after(2.5, function()
					self.wave.finished = true
				end)
				self.con = 2
			end
		end
		self.frametimer = self.frametimer + DTMULT
	end
	if self.shaker > 0 then
		self.graphics.shake_x = MathUtils.random(-self.shaker, self.shaker)
		self.graphics.shake_y = MathUtils.random(-self.shaker, self.shaker)
	end
end

return GigaPipisBomb