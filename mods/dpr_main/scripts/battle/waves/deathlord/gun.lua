local DeathLordGun, super = Class(Wave)

function DeathLordGun:init()
    super.init(self)
    self.siner = 0
end

function DeathLordGun:onStart()
    self.startmove = false
    self.timer:script(function(wait)
		Assets.stopAndPlaySound("glock")
		wait(0.5)
		self.startmove = true
		self.timer:every(1/5, function()
			local attackers = self:getAttackers()
			for _, attacker in ipairs(attackers) do
				local x, y = attacker:getRelativePos(attacker.sprite.vibratex - 3, attacker.sprite.vibratey + 20)
				local angle = MathUtils.angle(x, y, Game.battle.soul.x, Game.battle.soul.y)

				attacker.sprite.x = 2
				attacker.sprite.show_gunflash = true
				Game.battle.timer:after(2/30, function()
					attacker.sprite.x = 0
					attacker.sprite.show_gunflash = false
				end)
				local bullet = self:spawnBullet("deathlord/gunbullet", x, y, angle, 28)
				Assets.stopAndPlaySound("gunshot_dl")
			end
		end)
	end)
    local arena = Game.battle.arena
    self.arena_start_x = arena.x
    self.arena_start_y = arena.y
end

function DeathLordGun:update()
    if self.startmove == true then
		self.siner = self.siner + DT
		local offset = math.sin(self.siner * 3) * 60
		Game.battle.arena:setPosition(self.arena_start_x, self.arena_start_y + offset)
    end
    super.update(self)
end

return DeathLordGun