local SnowGraveSpell, super = HookSystem.hookScript(SnowGraveSpell)

function SnowGraveSpell:createSnowflake(x, y)
    if Game.battle.light then
        local snowflake = SnowGraveSnowflake(x, y)
        snowflake.physics.gravity = 2
        snowflake.physics.gravity_direction = math.rad(0)
        snowflake.physics.speed_x = -(math.sin(self.timer / 2) * 0.5)
        snowflake.siner = self.timer / 2
        snowflake.rotation = math.rad(90)
        self:addChild(snowflake)

        return snowflake
    else
        return super.createSnowflake(self, x, y)
    end
end

function SnowGraveSpell:update()
    Object.update(self)

    self.timer = self.timer + DTMULT
    self.since_last_snowflake = self.since_last_snowflake + DTMULT

    if self.hurt_enemies then
        self.hurt_enemies = false
        for i, enemy in ipairs(Game.battle.enemies) do
            if enemy then
                enemy.hit_count = 0
                enemy:hurt(
                    self.damage + (Game:isLight() and MathUtils.round(MathUtils.random(50)) or MathUtils.round(MathUtils.random(100))),
                    self.caster,
                    not Game.battle.light and (enemy.ut_death and enemy.onDefeatVaporized or enemy.onDefeatFatal) or nil
                )
                if enemy.health > 0 then
                    enemy:flash()
                else
                    enemy.can_die = true
                end
            end
        end
    end
end

function SnowGraveSpell:draw()
    if Game.battle.light then
        Object.draw(self)

        Draw.setColor(1, 1, 1, self.bgalpha)
        Draw.draw(self.bg)

        self:drawTiled((self.snowspeed / 1.5), (self.timer * 6), self.bgalpha)
        self:drawTiled((self.snowspeed), (self.timer * 8), self.bgalpha * 2)

        if ((self.timer <= 10) and (self.timer >= 0)) then
            if (self.bgalpha < 0.5) then
                self.bgalpha = self.bgalpha + 0.05 * DTMULT
            end
        end

        if (self.timer >= 0) then
            self.snowspeed = self.snowspeed + (20 + (self.timer / 5)) * DTMULT
        end

        if ((self.timer >= 20) and (self.timer <= 75)) then
            self.stimer = self.stimer + 1 * DTMULT

            if self.reset_once then
                self.reset_once = false
                self.since_last_snowflake = 1
            end

            if self.since_last_snowflake > 1 then
                self:createSnowflake(-40, 120 + 55)
                self:createSnowflake(-120, 120 + 0)
                self:createSnowflake(-80, 120 - 45)
                self.since_last_snowflake = self.since_last_snowflake - 1
            end

            if (self.stimer >= 8) then
                self.stimer = 0
            end
        end

        if ((not self.hurt) and ((self.timer >= 95) and (self.damage > 0))) then
            self.hurt = true
            self.hurt_enemies = true
        end

        if (self.timer >= 90) then
            if (self.bgalpha > 0) then
                self.bgalpha = self.bgalpha - 0.02 * DTMULT
            end
        end
        if (self.timer >= 120) then
            Game.battle:finishAction()
            self:remove()
        end
    else
        super.draw(self)
    end
end

return SnowGraveSpell