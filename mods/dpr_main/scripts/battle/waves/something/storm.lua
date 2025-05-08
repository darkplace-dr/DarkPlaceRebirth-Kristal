local DiamondsAim, super = Class(Wave)

function DiamondsAim:init()
	super.init(self)
	self.siner = 0
	self:setArenaSize(72, 150)
end

function DiamondsAim:onStart()
	local arena = Game.battle.arena
    self.arena_start_x = arena.x
    self.arena_start_y = arena.y
    self.timer:every(0.55, function()
        --local x = Utils.random(Game.battle.arena.right + 150, Game.battle.arena.right + 250)
        local x = SCREEN_WIDTH + 20
		local y = Utils.random(Game.battle.arena.top - 120, Game.battle.arena.bottom + 120)

        local bullet = self:spawnBullet("bug_black", x, y)
		self.timer:script(function(wait)
			--wait(1/4)
			bullet.targeting = false
			bullet.graphics.grow = 0
			--wait(1/5)
			local bullet2 = self:spawnBullet("bug_white", bullet.x, bullet.y, bullet.rotation)
			bullet2:setLayer(self.layer + 0.01)
			--wait(1/5)
			bullet.graphics.grow = 0.2
			bullet:fadeOutAndRemove(0.2)
		end)
    end)
	self.timer:every(0.7, function()
        --local x = Utils.random(Game.battle.arena.right + 150, Game.battle.arena.right + 250)
        local x2 = Utils.random(SCREEN_WIDTH - 520, SCREEN_WIDTH - 20)
		local y2 = Utils.random(Game.battle.arena.bottom + 350, Game.battle.arena.bottom + 300)

        local bullet = self:spawnBullet("bug_black", x2, y2)
		self.timer:script(function(wait)
			--wait(1/4)
			bullet.targeting = false
			bullet.graphics.grow = 0
			--wait(1/5)
			local bullet2 = self:spawnBullet("bug_white", bullet.x, bullet.y, bullet.rotation)
			bullet2:setLayer(self.layer + 0.01)
			--wait(1/5)
			bullet.graphics.grow = 0.2
			bullet:fadeOutAndRemove(0.2)
		end)
    end)
	self.timer:every(0.9, function()
        --local x = Utils.random(Game.battle.arena.right + 150, Game.battle.arena.right + 250)
        local x3 = Utils.random(SCREEN_WIDTH - 520, SCREEN_WIDTH - 20)
		local y3 = Utils.random(Game.battle.arena.top - 150, Game.battle.arena.top - 100)

        local bullet = self:spawnBullet("bug_black", x3, y3)
		self.timer:script(function(wait)
			--wait(1/4)
			bullet.targeting = false
			bullet.graphics.grow = 0
			--wait(1/5)
			local bullet2 = self:spawnBullet("bug_white", bullet.x, bullet.y, bullet.rotation)
			bullet2:setLayer(self.layer + 0.01)
			--wait(1/5)
			bullet.graphics.grow = 0.2
			bullet:fadeOutAndRemove(0.2)
		end)
    end)
end

function DiamondsAim:update()
    -- Increment timer for arena movement
    self.siner = self.siner + DT

    -- Calculate the arena Y offset
    local offset = math.sin(self.siner * 2.5) * 28

    -- Move the arena
    Game.battle.arena:setPosition(self.arena_start_x + offset, self.arena_start_y)

    super.update(self)
end

return DiamondsAim