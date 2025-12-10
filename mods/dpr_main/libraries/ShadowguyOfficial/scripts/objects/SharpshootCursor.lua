local SharpshootCursor, super = Class(Object)

function SharpshootCursor:init(x, y)
    super.init(self, x, y)
	
	self.x = 200
	self.y = 157
	self.xstart = self.x
	self.ystart = self.y
	
	self.timer = 0
	self.siner = 66
	self.con = 0
	self.ammo = 30
	self.shoottimer = 0
	self.stopshooting = 0
	
	self.shoot_target = nil
	
	self:setOrigin(0.5, 0.5)
	self.target = {}
	self.alpha = 0
	self:setScale(3,3)
	self.target[1] = Sprite("player/sharpshoot_cursor", 0, 0)
	self.target[1]:setOrigin(0.5, 0.5)
	self.target[1].alpha = self.alpha / 4
	self.target[1]:setScale(self.scale_x + 0.5, self.scale_y + 0.5)
	self:addChild(self.target[1])
	self.target[2] = Sprite("player/sharpshoot_cursor", 0, 0)
	self.target[2]:setOrigin(0.5, 0.5)
	self.target[2].alpha = self.alpha / 3
	self.target[2]:setScale(self.scale_x, self.scale_y)
	self:addChild(self.target[2])
	self.target[3] = Sprite("player/sharpshoot_cursor", 0, 0)
	self.target[3]:setOrigin(0.5, 0.5)
	self.target[3].alpha = self.alpha / 1.5
	self.target[3]:setScale(self.scale_x - 0.5, self.scale_y - 0.5)
	self:addChild(self.target[3])
	self.fired_heart = false
	self.shoot_x = 0
	self.shoot_y = 0
	self.font = Assets.getFont("main")
	self.heart = Assets.getTexture("player/sharpshoot_heart")
	self.hourglass = Assets.getTexture("ui/hourglass")
	self.hud = SharpshootHud()
	self.hud.layer = BATTLE_LAYERS["ui"]
	Game.battle:addChild(self.hud)
end

function SharpshootCursor:onRemove()
	super.onRemove(self)
	self.hud:remove()
end

function SharpshootCursor:update()
	super.update(self)
	
	self.siner = self.siner + DTMULT
	if Input.down("down") then
		self.y = self.y + 12 * DTMULT
	end
	if Input.down("up") then
		self.y = self.y - 12 * DTMULT
	end
	if Input.down("right") then
		self.x = self.x + 12 * DTMULT
	end
	if Input.down("left") then
		self.x = self.x - 12 * DTMULT
	end
	if self.y < 0 then
		self.y = 0
	end
	if self.y > 300 then
		self.y = 300
	end
	if self.x < 320 then
		self.x = 320
	end
	if self.x > 600 then
		self.x = 600
	end
	if self.con == 0 then
		self.timer = self.timer + DTMULT
		self.alpha = MathUtils.lerp(0, 1, self.timer/12)
		self:setScale(MathUtils.lerp(self.scale_x, 1, self.timer/12),MathUtils.lerp(self.scale_y, 1, self.timer/12))
		self.rotation = MathUtils.lerp(self.rotation, math.rad(394), 0.08*DTMULT)
		local xx = MathUtils.lerp(300, 0, self.timer/12)
		self.x = MathUtils.lerp(self.xstart, self.xstart + 280 + xx, self.timer/12)
		if self.timer >= 12 then
			self.rotation = 0
			self.timer = 0
			self.con = 1
			self.savey = self.y
		end
	end
	if self.con == 1 then
		self.shoottimer = self.shoottimer + DTMULT
		if Input.down("menu") and self.shoottimer > 0 and self.ammo > 0 and self.stopshooting == 0 then
			self.shoottimer = -3
			if Game.party[1]:getHealth() > 0 then
				local x, y = Game.battle.party[1].heart_point_x, Game.battle.party[1].heart_point_y
                local effect = Sprite("effects/attack/slap_n")
                effect:setOrigin(0.5, 0.5)
                effect:setScale(0.5, 0.5)
                effect:setColor(COLORS["red"])
                effect:setPosition(x, y)
				effect.layer = BATTLE_LAYERS["top"]
                Game.battle:addChild(effect)
                effect:play(1/30, false, function(s) s:remove() end)
				local heart = SharpshootHeart(x, y, self)
				Game.battle:addChild(heart)
				self.ammo = self.ammo - 1
			end
			if (#Game.party == 2 or #Game.party == 3) and Game.party[2]:getHealth() > 0 then
				local x, y = Game.battle.party[2].heart_point_x, Game.battle.party[2].heart_point_y
                local effect = Sprite("effects/attack/slap_n")
                effect:setOrigin(0.5, 0.5)
                effect:setScale(0.5, 0.5)
                effect:setColor(COLORS["red"])
                effect:setPosition(x, y)
				effect.layer = BATTLE_LAYERS["top"]
                Game.battle:addChild(effect)
                effect:play(1/30, false, function(s) s:remove() end)
				local heart = SharpshootHeart(x, y, self)
				Game.battle:addChild(heart)
				self.ammo = self.ammo - 1
			end
			if #Game.party == 3 and Game.party[3]:getHealth() > 0 then
				local x, y = Game.battle.party[3].heart_point_x, Game.battle.party[3].heart_point_y
                local effect = Sprite("effects/attack/slap_n")
                effect:setOrigin(0.5, 0.5)
                effect:setScale(0.5, 0.5)
                effect:setColor(COLORS["red"])
                effect:setPosition(x, y)
				effect.layer = BATTLE_LAYERS["top"]
                Game.battle:addChild(effect)
                effect:play(1/30, false, function(s) s:remove() end)
				local heart = SharpshootHeart(x, y, self)
				Game.battle:addChild(heart)
				self.ammo = self.ammo - 1
			end
			Assets.playSound("noise", 0.8, 1.2)
			self.fired_heart = true
		end
		if self.ammo < 1 or self.stopshooting == 2 then
			self.ammo = 0
			self:fadeOutAndRemove(10/30)
			self.con = 2
		end
	end
	self.target[1].alpha = self.alpha / 4
	self.target[2].alpha = self.alpha / 3
	self.target[3].alpha = self.alpha / 1.5
	self.target[1]:setScale(self.scale_x + 0.5, self.scale_y + 0.5)
	self.target[2]:setScale(self.scale_x, self.scale_y)
	self.target[3]:setScale(self.scale_x - 0.5, self.scale_y - 0.5)
	self.target[1].x = math.sin(self.siner / 4) * 2
	self.target[1].y = math.cos(self.siner / 4) * 2
	self.hud.ammo = self.ammo
	self.hud.sharpshootlength = self.sharpshootlength
	self.hud.stopshooting = self.stopshooting
end

return SharpshootCursor