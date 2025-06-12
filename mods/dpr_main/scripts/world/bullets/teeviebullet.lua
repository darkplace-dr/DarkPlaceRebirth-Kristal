local TeevieBullet, super = Class(WorldBullet)

function TeevieBullet:init(x, y)
    super.init(self, x, y, "battle/bullets/star")

    self.damage = 18

	if Game.world and Game.world.player then
		self.physics.speed_x = (Game.world.player.x + 16 + Utils.random(-30, 30) - self.x) / 48
	end
	self.physics.speed_y = -8
    self.physics.gravity = 0.5

    self.alpha = 0.5
	self:setScale(2,2)
    self:fadeToSpeed(1, 0.1)

	self.timer = 0
end

function TeevieBullet:update()
	self.timer = self.timer + DTMULT
	if self.timer % 1 == 0 then
		local afterimage = AfterImage(self, 1, 0.1)
		afterimage.layer = self.layer - 0.1
		afterimage.graphics.grow_x = -0.1
		afterimage.graphics.grow_y = -0.1
		Game.world:addChild(afterimage)
	end
    if self.timer >= 60 then
        self:remove()
    end

    super.update(self)
end

return TeevieBullet