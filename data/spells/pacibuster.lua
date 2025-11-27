local spell, super = Class(Spell, "pacibuster")

function spell:init()
    super.init(self)

    -- Display name
    self.name = "PaciBuster"
    -- Name displayed when cast (optional)
    self.cast_name = nil

    -- Battle description
    self.effect = "Damage&\nPacify"
    -- Menu description
    self.description = "Rude Buster that pacifies the enemies.\nTwice as low damage if the enemy is TIRED."
    -- Light menu description
    self.check = {"Rude Buster that\npacifies the enemies.", "* Twice as low damage if the\nenemy is TIRED."}

    -- TP cost
    self.cost = 66

    -- Target mode (ally, party, enemy, enemies, or none)
    self.target = "enemy"

    -- Tags that apply to this spell
    self.tags = {"rude", "damage", "spare_tired"}
end

function spell:getCastMessage(user, target)
    return "* "..user.chara:getName().." used "..self:getCastName().."!"
end

function spell:getTPCost(chara)
    local cost = super.getTPCost(self, chara)
    if chara and chara:checkWeapon("devilsknife") then
        cost = cost - 10
    end
    return cost
end

function spell:onCast(user, target)
    local buster_finished = false
    local anim_finished = false
    local function finishAnim()
        anim_finished = true
        if buster_finished then
            Game.battle:finishAction()
        end
    end
    if not user:setAnimation("battle/rude_buster", finishAnim) then
        anim_finished = false
        user:setAnimation("battle/attack", finishAnim)
    end
    Game.battle.timer:after(15/30, function()
        Assets.playSound("rudebuster_swing")
        local x, y = user:getRelativePos(user.width, user.height/2 - 10, Game.battle)
        local tx, ty = target:getRelativePos(target.width/2, target.height/2, Game.battle)
        local blast = PaciBusterBeam(x, y, tx, ty, function(damage_bonus, play_sound)
            local damage = self:getDamage(user, target, damage_bonus)
            if play_sound then
                Assets.playSound("scytheburst")
            end
            target:flash()
            target:hurt(damage, user)
            buster_finished = true
            if anim_finished then
                Game.battle:finishAction()
            end
            if target.tired then
                target:stopShake()
                Assets.playSound("spell_pacify", 1, 1.1)
                target:spare(true)
            else
                local recolor = target:addFX(RecolorFX())
                Game.battle.timer:during(8/30, function()
                    recolor.color = ColorUtils.mergeColor(recolor.color, {0, 0, 1}, 0.12 * DTMULT)
                end, function()
                    Game.battle.timer:during(8/30, function()
                        recolor.color = ColorUtils.mergeColor(recolor.color, {1, 1, 1}, 0.16 * DTMULT)
                    end, function()
                        target:removeFX(recolor)
                    end)
                end)
            end
        end)
        blast.layer = BATTLE_LAYERS["above_ui"]
        Game.battle:addChild(blast)
    end)
    return false
end

function spell:onLightCast(user, target)
    user.delay_turn_end = true
    Game.battle.timer:after(15/30, function()
        Assets.playSound("rudebuster_swing")
        local x, y = (SCREEN_WIDTH/2), SCREEN_HEIGHT
        local tx, ty = target:getRelativePos(target.width/2, target.height/2, Game.battle)
        local blast = PaciBusterBeam(x, y, tx, ty, function(damage_bonus, play_sound)
            local damage = self:getDamage(user, target, damage_bonus)
            if play_sound then
                Assets.playSound("scytheburst")
            end
            target:flash()
            target:hurt(damage, user)
            Game.battle:finishAction()
            if target.tired then
                target:stopShake()
                Assets.playSound("spell_pacify", 1, 1.1)
                target:spare(true)
            else
                local recolor = target:addFX(RecolorFX())
                Game.battle.timer:during(8/30, function()
                    recolor.color = ColorUtils.mergeColor(recolor.color, {0, 0, 1}, 0.12 * DTMULT)
                end, function()
                    Game.battle.timer:during(8/30, function()
                        recolor.color = ColorUtils.mergeColor(recolor.color, {1, 1, 1}, 0.16 * DTMULT)
                    end, function()
                        target:removeFX(recolor)
                    end)
                end)
            end
        end)
        blast.layer = LIGHT_BATTLE_LAYERS["above_arena_border"]
        Game.battle:addChild(blast)
    end)
    return false
end

function spell:getDamage(user, target, damage_bonus)
    local damage = math.ceil((user.chara:getStat("magic") * 5) + (user.chara:getStat("attack") * 11) - (target.defense * 3)) + damage_bonus
    if Game:isLight() then
        damage = math.ceil((user.chara:getStat("magic") * 2) + (user.chara:getStat("attack") * 4) - (target.defense * 3)) + math.ceil(damage_bonus / 1.5)
    end
    if target.tired then
        damage = math.ceil(damage/2)
    end
    return damage
end

return spell