---@class LensFlareManager : Bullet
---@overload fun(...) : LensFlareManager
local LensFlareManager, super = Class(Bullet, "tenna/lensflare_manager")

function LensFlareManager:init(x, y)
    super.init(self, x, y, "battle/bullets/tenna/lensflare_lines")

    self.dir = Utils.angle(Game.battle.arena.x, Game.battle.arena.y, self.x, self.y)
    self.dist = 0
    self.delay = 24
	
    local bul_counter = 0
    Object.startCache()
    for _,bullet in ipairs(Game.stage:getObjects(Registry.getBullet("tenna/lensflare_manager"))) do
        bul_counter = bul_counter + 1
    end
    self.flipside = math.pow(-1, bul_counter)
    Object.endCache()

    self.dist_max = 150
    self.total_rot = 0

    self.collidable = false

    self:setColor(COLORS.gray)
    self.alpha = 0
    Game.battle.timer:lerpVar(self, "alpha", 0, 1, 15)
    Game.battle.timer:lerpVar(self, "scale_x", 0, 2, 15)
    Game.battle.timer:lerpVar(self, "scale_y", 0, 2, 15)

    self.made = false
end

local function sqr(a)
   return a * a
end

local function approachCurve(val, target, amount)
    return MathUtils.approach(val, target, math.max(0.1, math.abs(target - val) / amount) * DTMULT)
end

function LensFlareManager:update()
    super.update(self)

    if not self.made then
        self.bullet1 = self.wave:spawnBullet("battle/bullets/tenna/lenslare1", self.x, self.y)
        self.bullet1.destroy_on_hit = false
        self.bullet1.alpha = 0
        self.bullet1.collidable = false
        Game.battle.timer:lerpVar(self.bullet1, "alpha", 0, 1, 15)

        self.bullet2 = self.wave:spawnBullet("battle/bullets/tenna/lenslare2", self.x, self.y)
        self.bullet2.destroy_on_hit = false
        self.bullet2.alpha = 0
        self.bullet2.collidable = false
        Game.battle.timer:lerpVar(self.bullet2, "alpha", 0, 1, 15)

        self.bullet3 = self.wave:spawnBullet("battle/bullets/tenna/lenslare3", self.x, self.y)
        self.bullet3.destroy_on_hit = false
        self.bullet3.alpha = 0
        self.bullet3.collidable = false
        Game.battle.timer:lerpVar(self.bullet3, "alpha", 0, 1, 15)

        self.made = true
    end

    if self.delay >= 0 then
        self.delay = self.delay - (1 * DTMULT)
    
        if self.delay == 0 then
            self.bullet1.collidable = true
            self.bullet2.collidable = true
            self.bullet3.collidable = true
        end
    else
        self.dist = approachCurve(self.dist, self.dist_max, 20 + (self.dist / 4))
        self.dir = self.dir + (((self.flipside * 3.5 * self.dist) / self.dist_max) * sqr(self.alpha)) * DTMULT

        if self.total_rot < 360 then
            self.total_rot = self.total_rot + ((3.5 * self.dist) / self.dist_max) * DTMULT
            if self.total_rot >= 360 then
                Game.battle.timer:lerpVar(self, "alpha", 1, 0, 20)
                Game.battle.timer:lerpVar(self, "scale_x", 2, 0, 30)
                Game.battle.timer:lerpVar(self, "scale_y", 2, 0, 30)

                self.bullet1.collidable = false
                Game.battle.timer:lerpVar(self.bullet1, "alpha", 1, 0, 20)
                Game.battle.timer:lerpVar(self.bullet1, "scale_x", 2, 0, 30)
                Game.battle.timer:lerpVar(self.bullet1, "scale_y", 2, 0, 30)

                self.bullet2.collidable = false
                Game.battle.timer:lerpVar(self.bullet2, "alpha", 1, 0, 20)
                Game.battle.timer:lerpVar(self.bullet2, "scale_x", 2, 0, 30)
                Game.battle.timer:lerpVar(self.bullet2, "scale_y", 2, 0, 30)

                self.bullet3.collidable = false
                Game.battle.timer:lerpVar(self.bullet3, "alpha", 1, 0, 20)
                Game.battle.timer:lerpVar(self.bullet3, "scale_x", 2, 0, 30)
                Game.battle.timer:lerpVar(self.bullet3, "scale_y", 2, 0, 30)
            end
        end

        local angle = self.dir
        local tdist = self.dist

        self.bullet1.x = self.x + (math.cos(math.rad(-angle)) * (tdist * 0.1)) * DTMULT
        self.bullet1.y = self.y + (math.sin(math.rad(-angle)) * (tdist * 0.1)) * DTMULT

        self.bullet2.x = self.x + (math.cos(math.rad(-angle)) * (tdist * 0.55)) * DTMULT
        self.bullet2.y = self.y + (math.sin(math.rad(-angle)) * (tdist * 0.55)) * DTMULT

        self.bullet3.x = self.x + (math.cos(math.rad(-angle)) * tdist) * DTMULT
        self.bullet3.y = self.y + (math.sin(math.rad(-angle)) * tdist) * DTMULT
    end
end

return LensFlareManager