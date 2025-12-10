local StarwingsHyper, super = Class(Wave)

function StarwingsHyper:init()
    super.init(self)
    self.time = 16
    self.starwalker = self:getAttackers()[1]

    self.colormask = nil
    self.during_handle = nil

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
            self.colormask = self.starwalker:addFX(ColorMaskFX())
            self.colormask.amount = 0
            self.timer:tween(0.5, self.colormask, { amount = 1 })
            self.shake_timer = 0
            self.colorsiner = 0
            self.during_handle = self.timer:during(1, function()
                self.colorsiner = self.colorsiner + DTMULT
                self.colormask.color = ColorUtils.mergeColor(COLORS.white, COLORS.yellow, (0.75 + math.sin(self.colorsiner / 3)) * 0.25)

                self.shake_timer = self.shake_timer + 0.1 * DTMULT
                self.starwalker.graphics.shake_x = Utils.random(-self.shake_timer, self.shake_timer)
                self.starwalker.graphics.shake_y = Utils.random(-self.shake_timer, self.shake_timer)
            end)
        end)

        self.timer:after(0.8 * self.speed, function ()
            if (self.during_handle) then
                self.timer:cancel(self.during_handle)
                self.during_handle = nil
            end
            self.starwalker.graphics.shake_x = 0
            self.starwalker.graphics.shake_y = 0
            self.starwalker:removeFX(self.colormask)
            self.colormask = nil

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
