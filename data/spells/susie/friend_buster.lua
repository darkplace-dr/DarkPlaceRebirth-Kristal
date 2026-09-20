local spell, super = Class(Spell, "friend_buster")

function spell:init()
    super.init(self)

    -- Display name
    self.name = "Friend Buster"
    -- Name displayed when cast (optional)
    self.cast_name = nil

    -- Battle description
    self.effect = "Rude\ndamage"
    -- Menu description
    self.description = "Deals moderate Rude-elemental damage to\none friend. Depends on Attack & Magic."
    -- Check description
    self.check = {"Deals moderate Rude-elemental damage to\none friend.", "* Depends on Attack & Magic."}

    -- TP cost
    self.cost = 50

    -- Target mode (ally, party, enemy, enemies, or none)
    self.target = "ally"

    -- Tags that apply to this spell
    self.tags = {"rude", "damage"}
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
        local blast = RudeBusterBeam(false, x, y, tx, ty, function(damage_bonus, play_sound)
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
        end)
        blast.layer = BATTLE_LAYERS["above_ui"]
        Game.battle:addChild(blast)
    end)
    return false
end

function spell:getDamage(user, target, damage_bonus)
    local _, yellowhat_count = user.chara:checkArmor("yellowhat")

    local magic_part = user.chara:getStat("magic") * (5 + (yellowhat_count * 0.5))
    local attack_part = user.chara:getStat("attack") * (11 + yellowhat_count)

    local damage = math.ceil(magic_part + attack_part - (target.chara:getStat("defense") * 3)) + damage_bonus

    if user.chara:checkWeapon("virobuster") then
        if target.chara:getHealth() <= target.chara:getStat("health") / 2 then
            damage = damage * 2
        end
    end

    if (Game.battle and Game.battle.headwind > 0) then
        damage = math.floor(damage * 1.25)
    end

    return damage
end

function spell:hasWorldUsage(chara)
    return true
end

function spell:onWorldCast(user, target)
    local _, yellowhat_count = user:checkArmor("yellowhat")

    local magic_part = user:getStat("magic") * (5 + (yellowhat_count * 0.5))
    local attack_part = user:getStat("attack") * (11 + yellowhat_count)

    local damage = math.ceil(magic_part + attack_part - (target:getStat("defense") * 3))

    if user:checkWeapon("virobuster") then
        if target:getHealth() <= target:getStat("health") / 2 then
            damage = damage * 2
        end
    end

    Assets.playSound("rudebuster_hit")
    Assets.playSound("hurt")
    target:setHealth(math.max(1, target:getHealth() - damage))
end

return spell
