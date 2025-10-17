local LensFlare, super = Class(Wave)

function LensFlare:init()
    super.init(self)

    self.time = 260/30
    self.type = 129

    self.btimer = 99
    self.made = false
    self.side1 = 0
    self.side2 = 0
    self.my_angle = MathUtils.random(360)
end

function LensFlare:onStart()
    local arena = Game.battle.arena

    self.timer:after(11/30, function()
        self:spawnBullet("tenna/lensflare_manager", arena.x + (math.cos(-math.rad(self.my_angle)) * 60), arena.y + (math.sin(-math.rad(self.my_angle)) * 60))
    end)

    self.timer:after(26/30, function()
        self:spawnBullet("tenna/lensflare_manager", arena.x + (math.cos(-math.rad(self.my_angle + 180)) * 60), arena.y + (math.sin(-math.rad(self.my_angle + 180)) * 60))
    end)
end

return LensFlare