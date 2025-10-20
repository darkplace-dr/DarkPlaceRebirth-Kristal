local GreatBeam, super = Class(Bullet)

function GreatBeam:init(x, y, dir, speed)
    -- Last argument = sprite path
	self:setScale(8)
    super.init(self, x, y, "battle/bullets/fire")
	self.color = {1,1,0}


    -- Move the bullet in dir radians (0 = right, pi = left, clockwise rotation)
    self.physics.direction = dir
    -- Speed the bullet moves (pixels per frame at 30FPS)
    self.physics.speed = speed
	self.destroy_on_hit = false
end

function GreatBeam:update()
    -- For more complicated bullet behaviours, code here gets called every update
	if self.y > Game.battle.arena.bottom - 10 then
		Assets.playSound("impact")
		local x, y = self:getRelativePos(self.width/2, self.height/2, Game.battle)
		local beam3 = self.wave:spawnBullet("mir_puff", x, y, math.rad(270), 8)
		local beam4 = self.wave:spawnBullet("mir_puff", x, y, math.rad(90), 2)
		self:remove()
	end

    super.update(self)
end

return GreatBeam
