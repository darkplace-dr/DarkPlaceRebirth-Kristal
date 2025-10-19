local StarwingsHyper, super = Class(Wave)

function StarwingsHyper:init()
    super.init(self)
    self.time = 16
    self.starwalker = self:getAttackers()[1]

    self.speed = 1
    self.size = 1
end

function StarwingsHyper:onStart()
    self.starwalker:setMode("shoot")
    self.timer:everyInstant(2 * self.speed, function ()
        self.starwalker.sprite:set("starwalker_shoot_1")
        Assets.playSound("wing")

        self.timer:after(0.2 * self.speed, function()
            Assets.playSound("boost")
        end)

        self.timer:after(0.8 * self.speed, function ()
            self.starwalker.sprite:set("starwalker_shoot_2")
            Assets.playSound("wing")
            Assets.playSound("starhyper", 0.7, (1 + MathUtils.random(0.2)) - MathUtils.random(0.3))
            local star = self:spawnBullet("starwalker/starbullet_hyper", self.starwalker.x - 20, self.starwalker.y - 40)
            star.inv_timer = 10/30
            star.physics.direction = math.atan2(Game.battle.soul.y - star.y, Game.battle.soul.x - star.x)
            star.physics.speed = 8
            star.physics.friction = -0.25
        end)
        self.timer:after(1 * self.speed, function ()
            self.starwalker.sprite:set("wings")
        end)
    end)
end

function StarwingsHyper:onEnd()
    self.starwalker:setMode("normal")
    self.starwalker.sprite:set("wings")
    super.onEnd(self)
end

function StarwingsHyper:update()
    super.update(self)
end

return StarwingsHyper
