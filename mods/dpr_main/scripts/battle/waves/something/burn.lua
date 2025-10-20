local DiamondsAim, super = Class(Wave)

function DiamondsAim:init()
	super.init(self)
end

function DiamondsAim:onStart()
	local x = Game.battle.arena.right + 100
        local y = Game.battle.arena.bottom - 60

        local bullet = self:spawnBullet("bug_black", x, y)
		self.timer:script(function(wait)
			wait(1/3)
			bullet.targeting = false
			bullet.graphics.grow = 0
			wait(1/2)
			local bullet2 = self:spawnBullet("bug_white", bullet.x, bullet.y, bullet.rotation)
			bullet2:setLayer(self.layer + 0.01)
			wait(1/3)
			bullet.graphics.grow = 0.2
			bullet:fadeOutAndRemove(0.2)
		end)
		local x = Game.battle.arena.left - 100
        local y = Game.battle.arena.bottom - 60

        local bullet = self:spawnBullet("bug_black", x, y)
		self.timer:script(function(wait)
			wait(1/3)
			bullet.targeting = false
			bullet.graphics.grow = 0
			wait(1/2)
			local bullet2 = self:spawnBullet("bug_white", bullet.x, bullet.y, bullet.rotation)
			bullet2:setLayer(self.layer + 0.01)
			wait(1/3)
			bullet.graphics.grow = 0.2
			bullet:fadeOutAndRemove(0.2)
		end)
		local x = Game.battle.arena.left + 75
        local y = Game.battle.arena.top - 60

        local bullet = self:spawnBullet("bug_black", x, y)
		self.timer:script(function(wait)
			wait(1/3)
			bullet.targeting = false
			bullet.graphics.grow = 0
			wait(1/2)
			local bullet2 = self:spawnBullet("bug_white", bullet.x, bullet.y, bullet.rotation)
			bullet2:setLayer(self.layer + 0.01)
			wait(1/3)
			bullet.graphics.grow = 0.2
			bullet:fadeOutAndRemove(0.2)
		end)
		local x = Game.battle.arena.left + 75
        local y = Game.battle.arena.bottom + 60

        local bullet = self:spawnBullet("bug_black", x, y)
		self.timer:script(function(wait)
			wait(1/3)
			bullet.targeting = false
			bullet.graphics.grow = 0
			wait(1/2)
			local bullet2 = self:spawnBullet("bug_white", bullet.x, bullet.y, bullet.rotation)
			bullet2:setLayer(self.layer + 0.01)
			wait(1/3)
			bullet.graphics.grow = 0.2
			bullet:fadeOutAndRemove(0.2)
		end)
	self.timer:every(0.84, function()
        local x = Game.battle.arena.right + 100
        local y = Game.battle.arena.bottom - 60

        local bullet = self:spawnBullet("bug_black", x, y)
		self.timer:script(function(wait)
			wait(1/3)
			bullet.targeting = false
			bullet.graphics.grow = 0
			wait(1/2)
			local bullet2 = self:spawnBullet("bug_white", bullet.x, bullet.y, bullet.rotation)
			bullet2:setLayer(self.layer + 0.01)
			wait(1/3)
			bullet.graphics.grow = 0.2
			bullet:fadeOutAndRemove(0.2)
		end)
    end)
	self.timer:every(0.84, function()
        local x = Game.battle.arena.left - 100
        local y = Game.battle.arena.bottom - 60

        local bullet = self:spawnBullet("bug_black", x, y)
		self.timer:script(function(wait)
			wait(1/3)
			bullet.targeting = false
			bullet.graphics.grow = 0
			wait(1/2)
			local bullet2 = self:spawnBullet("bug_white", bullet.x, bullet.y, bullet.rotation)
			bullet2:setLayer(self.layer + 0.01)
			wait(1/3)
			bullet.graphics.grow = 0.2
			bullet:fadeOutAndRemove(0.2)
		end)
    end)
	self.timer:every(0.84, function()
        local x = Game.battle.arena.left + 75
        local y = Game.battle.arena.top - 60

        local bullet = self:spawnBullet("bug_black", x, y)
		self.timer:script(function(wait)
			wait(1/3)
			bullet.targeting = false
			bullet.graphics.grow = 0
			wait(1/2)
			local bullet2 = self:spawnBullet("bug_white", bullet.x, bullet.y, bullet.rotation)
			bullet2:setLayer(self.layer + 0.01)
			wait(1/3)
			bullet.graphics.grow = 0.2
			bullet:fadeOutAndRemove(0.2)
		end)
    end)
	self.timer:every(0.84, function()
        local x = Game.battle.arena.left + 75
        local y = Game.battle.arena.bottom + 60

        local bullet = self:spawnBullet("bug_black", x, y)
		self.timer:script(function(wait)
			wait(1/3)
			bullet.targeting = false
			bullet.graphics.grow = 0
			wait(1/2)
			local bullet2 = self:spawnBullet("bug_white", bullet.x, bullet.y, bullet.rotation)
			bullet2:setLayer(self.layer + 0.01)
			wait(1/3)
			bullet.graphics.grow = 0.2
			bullet:fadeOutAndRemove(0.2)
		end)
    end)
end

return DiamondsAim