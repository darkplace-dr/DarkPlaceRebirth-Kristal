local EnemyBattler, super = HookSystem.hookScript(EnemyBattler)

function EnemyBattler:init(actor, use_overlay)
    super.init(self, actor, use_overlay)

    -- Whether this enemy can die, and whether it's Undertale's death or Deltarune's death
    self.can_die = Game:isLight() and true or false
    self.ut_death = Game:isLight() and true or false

    -- Whether this enemy should use line dust particles upon death when ut_death is enabled
    -- If set to nil, it will be automatically set depending on the enemy's width
    self.line_dust = nil

    self.tired_percentage = Game:isLight() and 0 or 0.5
    self.spare_percentage = Game:isLight() and 0.25 or 0
    self.low_health_percentage = Game:isLight() and 0.25 or 0.5
end

function EnemyBattler:onHurt(damage, battler)
    super.onHurt(self, damage, battler)

    if self.health <= (self.max_health * self.spare_percentage) then
        self.mercy = 100
    end
end

function EnemyBattler:getAttackDamage(damage, battler, points)
    if damage > 0 then
        return damage
    end
    if Game:isLight() then
        return ((battler.chara:getStat("attack") * points) / (750 / 11)) - (self.defense * (11 / 5))
    else
        return super.getAttackDamage(self, damage, battler, points)
    end
end

function EnemyBattler:freeze()
    super.freeze(self)

    if Game:isLight() and self.can_freeze then
        Game.battle.money = Game.battle.money - 24 + 4
    end
end

function EnemyBattler:defeat(reason, violent)
    super.defeat(self, reason, violent)

    if violent then
        if Game:isLight() and (self.done_state == "KILLED" or self.done_state == "FROZEN") then
            Mod.libs["magical-glass"].kills = Mod.libs["magical-glass"].kills + 1
        end
        if Mod.libs["magical-glass"].random_encounter and Mod.libs["magical-glass"].random_encounter.population then
            Mod.libs["magical-glass"].random_encounter:addFlag("violent", 1)
        end
    else
        Game.battle.xp = Game.battle.xp - self.experience
    end
end

function EnemyBattler:onDefeat(damage, battler)
    if self.exit_on_defeat then
        if self.can_die then
            if self.ut_death then
                self:onDefeatVaporized(damage, battler)
            else
                self:onDefeatFatal(damage, battler)
            end
        else
            self:onDefeatRun(damage, battler)
        end
    else
        self.sprite:setAnimation("defeat")
    end
end

function EnemyBattler:onDefeatVaporized(damage, battler)
    self.hurt_timer = -1

    Assets.playSound("vaporized", 1.2)

    local sprite = self:getActiveSprite()

    sprite.visible = false
    sprite:stopShake()

    local death_x, death_y = sprite:getRelativePos(0, 0, self)
    local death
    if self:isLineDust() then
        death = DustEffectLine(sprite:getTexture(), death_x, death_y, true, function() self:remove() end)
    else
        death = DustEffect(sprite:getTexture(), death_x, death_y, true, function() self:remove() end)
    end

    death:setColor(sprite:getDrawColor())
    death:setScale(sprite:getScale())
    self:addChild(death)

    self:defeat("KILLED", true)
end

function EnemyBattler:isLineDust()
    if self.line_dust == nil then
        return self.width * self.scale_x > 120
    end
    return self.line_dust
end

return EnemyBattler