local SharpshootTarget, super = Class(Object)

function SharpshootTarget:init(sprite, x, y)
    super.init(self, x, y)
	self.sprite = Sprite(sprite, 0, 0)
	self.sprite:setScale(1, 1)
	self:addChild(self.sprite)
	
	self.sparehp = 9
	self.spare = false
	self.hittable = false
	self.visible = false
	self.enemy = nil
	self.copyMov = nil
	self.shake = 0
	self.already_spared = false
end

function SharpshootTarget:doSpare()
	self.hittable = false
	self.spare = true
	self.physics.speed_y = -12
	self.physics.gravity = 1
	self.physics.gravity_direction = math.rad(270)
	self.physics.speed_x = 20
	self.already_spared = true
	Assets.playSound("hitcar_little")
	Game.battle.timer:after(26/30, function()
		self:reset()
	end)
end

function SharpshootTarget:reset()
	self:resetPhysics()
	self.spare = false
	self.visible = false
	self.hittable = true
	self.sparehp = 9
	self.copyMov = nil
end

function SharpshootTarget:update()
	super.update(self)
	
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