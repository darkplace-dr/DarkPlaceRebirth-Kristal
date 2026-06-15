local SharpshootTarget, super = Class(Object)

function SharpshootTarget:init(sprite, x, y)
    super.init(self, x, y)
	self.sprite = Sprite(sprite, 0, 0)
	self.sprite:setScale(1, 1)
	self:addChild(self.sprite)
	
	self.rotation = 0
	self.sparehp = 9
	self.spare = false
	self.hittable = false
	self.visible = false
	self.enemy = nil
	self.shake = 0
	
	self.type = nil
end

function SharpshootTarget:doSpare()
	self.hittable = false
	self.physics.speed_y = -12
	self.physics.gravity = 1
	self.physics.gravity_direction = math.rad(270)
	self.physics.speed_x = 20
	Assets.playSound("hitcar_little")
	if self.type == "shadowguy_hat" then
		Game.battle.timer:tween(0.7, self.enemy._darken_fx, {color = {1, 1, 1}}, nil, function()
			self.enemy:removeFX(self.enemy._darken_fx)
			self.enemy._darken_fx = nil
		end)
		self.enemy:setAnimation("idle_bunny")
	end
	if self.spare then
		self.alpha = 0
		self.enemy.sharpshoot_spared = true
		self.enemy:spare()
	end
	Game.battle.timer:after(26/30, function()
		self:remove()
	end)
end

function SharpshootTarget:update()
	super.update(self)
	if not self.hittable then
		self.rotation = self.rotation - math.rad(4) * DTMULT
		return
	end
	if self.shake > 0 then
		self.shake = self.shake - DTMULT
	end
end

function SharpshootTarget:draw()
	love.graphics.translate(self.shake - (Utils.random(self.shake) * 2), self.shake - (Utils.random(self.shake) * 2))
	super.draw(self)
	love.graphics.translate(0, 0)
	
	if DEBUG_RENDER and self.collider then
        self.collider:draw(0, 0, 1)
    end
end

return SharpshootTarget