local PendulumCH4, super = Class(Wave)

function PendulumCH4:init()
    super.init(self)
	
    self.time = 300/30

    self.enemies = self:getAttackers()
    self.sameattacker = 0
	if #self.enemies > 1 then
		self.sameattacker = #self.enemies-1
	end
end

function PendulumCH4:onStart()
    local ratio = self:getEnemyRatio()
    local arena = Game.battle.arena

    self.pendulum = self:spawnBullet("pendulum", SCREEN_WIDTH/2, arena.y - 200)
    self.pendulum.timer = 8 - math.floor(self.sameattacker * 10 * ratio)

    self.debug_render = true
end

function PendulumCH4:getEnemyRatio()
    local enemies = #Game.battle:getActiveEnemies()
    if enemies <= 1 then
        return 1
    elseif enemies == 2 then
        return 1.6
    elseif enemies >= 3 then
        return 2.3
    end
end

function PendulumCH4:draw()
    super.draw(self)

    if self.debug_render and DEBUG_RENDER then
        love.graphics.setColor(1, 0, 0, 1)
        love.graphics.setFont(Assets.getFont("main"))
		
        local dbg1 = string.format(
[[timer = %d
x = %d    y = %d
centre_x = %d    centre_y = %d
cut = %s
]],
            self.pendulum.timer,  
            self.pendulum.x, self.pendulum.y,
            self.pendulum.centre_x, self.pendulum.centre_y,
            self.cut and "y" or "n"
        )

        love.graphics.printf("--PENDULUM DEBUG--", 10, 380, SCREEN_WIDTH*2, "left", 0, 0.5, 0.5)
        love.graphics.printf(dbg1, 10, 400, SCREEN_WIDTH*2, "left", 0, 0.5, 0.5)
    end
end

return PendulumCH4