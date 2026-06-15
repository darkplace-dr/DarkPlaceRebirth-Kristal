local HoopWaves, super = Class(Wave)

function HoopWaves:init()
    super.init(self)
	
	self.time = 200/30
    self.enemies = self:getAttackers()
	self.timer2 = Timer()
	self.flashes = {}
end

function HoopWaves:onStart()
    -- Every 0.33 seconds...
	local arena = Game.battle.arena
	for _, enemy in ipairs(self.enemies) do
		self.timer:everyInstant(0.33, function()
			Assets.playSound("camera_flash", 1, MathUtils.random(1, 1.2))
			local x, y = enemy.x, enemy.y - 30
			local hoop_len = MathUtils.randomInt(6, 16)
			local target_y = TableUtils.pick({arena.top + hoop_len*2 + 18, arena.y, arena.bottom - hoop_len*2 - 18})
			local flash_scale = MathUtils.random(1.5, 2)
			local flash_scale_x = MathUtils.random(1.75, 2.5)
			local flash = self:spawnSprite("world/events/teevie_cameras/flash", x, y)
			flash:setOrigin(0.5)
			flash:setScale(flash_scale_x,flash_scale)
			flash.lifetime = 30 + 16
			flash.timer = 0
			flash.faded = false
			flash:play(1.5/30, false)
			table.insert(self.flashes, flash)
			local bullet = self:spawnBullet("electrodasher/hoop", x, y)
			bullet.physics.speed = 8
			bullet.physics.friction = -0.15
			bullet.remove_offscreen = true
			self.timer:tween(16/30, bullet, {y = target_y}, "out-quad")
			self.timer:after(4/30, function()
				self.timer:tween(16/30, bullet, {hoop_top_y = -hoop_len, hoop_bottom_y = hoop_len}, "out-expo")
			end)
		end)
	end
end

function HoopWaves:update()
    super.update(self)
	for i,flash in ipairs(self.flashes) do
		flash.timer = flash.timer + DTMULT
		if flash.timer >= 6 and not flash.faded then
			flash:fadeToSpeed(0, 8/30)
			flash.faded = true
		end
		if flash.timer >= flash.lifetime then
			flash:remove()
			table.remove(self.flashes, i)
		end
	end
end

return HoopWaves