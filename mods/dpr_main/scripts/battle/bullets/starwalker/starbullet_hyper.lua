local StarBulletHyper, super = Class(Bullet)

function StarBulletHyper:init(x, y)
    super.init(self, x, y, "battle/bullets/stormstar_b")

    self:setScale(0.25)
    Game.battle.timer:lerpVar(self, "scale_x", self.scale_x, 0.75, 10)
    Game.battle.timer:lerpVar(self, "scale_y", self.scale_y, 0.75, 10)

    self.grazed = true
    self.graphics.spin = math.rad(45 / 4)

    self.inv_timer = 1 / 30
    self.destroy_on_hit = false

    self.timer = 0
    self.colorsiner = 0
    self.dir = MathUtils.random(360)

    self.starwalker = Game.battle:getEnemyBattler("starwalker")
end

function StarBulletHyper:shouldSwoon(damage, target, soul)
    return true
end

function StarBulletHyper:update()
    super.update(self)
	
    self.colorsiner = self.colorsiner + DTMULT
    self:setColor(ColorUtils.mergeColor(COLORS.white, COLORS.yellow, (0.25 + math.sin(self.colorsiner / 3)) * 0.25))

    if self.x < Game.battle.arena.left - 40 or self.y < Game.battle.arena.top - 40 or self.y > Game.battle.arena.bottom + 40 then
        self:destroy()
    end

    self.timer = self.timer + DTMULT

    if self.parent then
        while self.timer >= 1 do
            self.parent:addChild(AfterImage(self, 0.5, 0.1))
            self.timer = self.timer - 1
        end
    end
end

function StarBulletHyper:destroy()
    self:remove()
	Assets.playSound("explosion", 0.8, 2)
	Assets.playSound("stardrop", 1, 0.85)

    local effect = Sprite("effects/boxing_crescent", self.x, self.y)
    effect:setOrigin(0.5, 0.5)
    effect:setLayer(BATTLE_LAYERS["above_arena"] + 1)
    effect:setScale(4)
    effect:play(1/20, false, function() effect:remove() end)
    Game.battle:addChild(effect)
	
    for i = 1, 10 do
        local offset = self.dir + ((360/10) * i)
        local star = self.wave:spawnBullet(self.starwalker:makeBullet(self.x, self.y))
        star.inv_timer = 10/30
        star:setScale(1)
        star.physics.speed = 1.6
        star.physics.friction = -0.3
        star.physics.direction = -math.rad(offset)
        star.graphics.spin = 0.15
    end
	
    self.dir = self.dir + 9

    for i = 1, 10 do
        local offset = self.dir + ((360/10) * i)
        local star = self.wave:spawnBullet(self.starwalker:makeBullet(self.x, self.y))
        star.inv_timer = 10/30
        star:setScale(1)
        star.physics.speed = 0.8
        star.physics.friction = -0.24
        star.physics.direction = -math.rad(offset)
        star.graphics.spin = 0.15
    end
end

return StarBulletHyper