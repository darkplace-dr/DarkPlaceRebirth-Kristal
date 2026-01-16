local DarkShapeTest, super = Class(Wave)

function DarkShapeTest:init()
    super.init(self)

    self.time = 360/30
end

function DarkShapeTest:onStart()
    Game.battle:swapSoul(FlashlightSoul())
	self.spawn_attack_loop = Assets.newSound("spawn_attack")
    self.spawn_attack_loop:setLooping(true)
	self.spawn_attack_loop:play()

    self.timer:everyInstant(15/30, function()
        local arena = Game.battle.arena
        local tempdist = 100 + MathUtils.random(40)
        local tempdir = math.rad(30 + MathUtils.random(360))

        self:spawnBullet("titan/darkshape", arena.x + MathUtils.lengthDirX(tempdist, tempdir), arena.y + MathUtils.lengthDirY(tempdist, tempdir))
    end)

    self.timer:everyInstant(240/30, function()
        local arena = Game.battle.arena
        local tempdist = 100 + MathUtils.random(40)
        local tempdir = math.rad(30 + MathUtils.random(360))

        self:spawnBullet("titan/redshape", arena.x + MathUtils.lengthDirX(tempdist, tempdir), arena.y + MathUtils.lengthDirY(tempdist, tempdir))
    end)
end

function DarkShapeTest:onEnd()
    if Game.battle.soul.ominous_loop then
		Game.battle.soul.ominous_loop:stop()
	end
	self.spawn_attack_loop:stop()
end

return DarkShapeTest