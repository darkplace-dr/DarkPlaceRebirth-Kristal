local RimshotStars, super = Class(Wave)

function RimshotStars:init()
    super.init(self)

    self.time = 260/30
    self.tenna = Game.battle:getEnemyBattler("tenna")
    self.type = (self.tenna and self.tenna.hellmode == true) and 129 or 128

    self.btimer = 99
    self.made = false
    self.side1 = 0
    self.side2 = 0
end

function RimshotStars:update()
    super.update(self)

    local arena = Game.battle.arena

    local old_bt = self.btimer
    self.btimer = self.btimer + DTMULT

    if not self.made then
        self.made = true

        self.side1 = MathUtils.randomInt(4)
        self.side2 = self.side1 + 1
        self.side1 = self.side1 * 90
        self.side2 = self.side2 * 90
    end

    if (old_bt < 103 and self.btimer >= 103) or (self.type == 128 and (old_bt < 117 and self.btimer >= 117)) then
        local dir
        if old_bt < 103 and self.btimer >= 103 then
            dir = self.side1
        else
            dir = self.side2
        end

        local maindist = 150
        local sidedist = 0
        local xdist = MathUtils.lengthDirX(maindist, math.rad(dir)) + MathUtils.lengthDirX(sidedist, math.rad(dir + 90))
        local ydist = MathUtils.lengthDirY(maindist, math.rad(dir)) + MathUtils.lengthDirY(sidedist, math.rad(dir + 90))
        local firedir = -math.rad(142 + dir + 11 * ((old_bt < 103 and self.btimer >= 103) and 1 or 0))

        local rimshot_star = self:spawnBullet("tenna/rimshot_star", arena.x + xdist, arena.y + ydist, firedir, 6)
		self.timer:lerpVar(rimshot_star.physics, "speed_x", rimshot_star.physics.speed_x, 3.75, 1)
		self.timer:lerpVar(rimshot_star.physics, "speed_y", rimshot_star.physics.speed_y, 3.75, 1)
    end

    local rate1 = 78
    local rate2 = 50

    if self.type == 129 then
        rate1 = 27
        rate2 = (self.tenna and self.tenna.hellmode == true) and 5 or 20
    end

    local old_modu = (old_bt - rate2) % rate1
    local modu = (self.btimer - rate2) % rate1

    if modu < old_modu then
        Assets.playSound("rimshot")

        for _, bullet in ipairs(Game.stage:getObjects(Registry.getBullet("tenna/rimshot_star"))) do
            bullet.rimshot_timer = 74
        end
    end
end

return RimshotStars