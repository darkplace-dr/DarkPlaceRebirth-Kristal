local spell, super = Class(Spell, "dark_tomb")

function spell:init()
    super.init(self)

    -- Display name
    self.name = "Dark Tomb"
    -- Name displayed when cast (optional)
    self.cast_name = nil

    -- Battle description
    self.effect = "Damage w/\nDark and HP"
    -- Menu description
    self.description = "Shadowly dark inbues and engulfs\nthe target in exhange of\nHP, Depends on Magic."

    -- TP cost
    self.cost = 16

    -- Target mode (ally, party, enemy, enemies, or none)
    self.target = "enemy"

    -- Tags that apply to this spell
    self.tags = {"damage"}
end

---@param target EnemyBattler
function spell:onCast(user, target)
    if Game.battle and Game.battle.encounter.is_jackenstein then
        Game.battle.timer:after(0.2, function()
            local dmg = 1
            if MathUtils.randomInt(1, 1001) == 1 then
                dmg = 2
            end

            user:hurt(dmg, true)

            Assets.playSound("squeaky", dmg)
        end)

        return
    end

    local chara = user.chara
    local attack_sound = chara.attack_sound
    if chara.level <= 1 then
        Assets.playSound(attack_sound)
    else
        Assets.playSound(attack_sound, 1, 0.9)
    end

    local dmg = chara.health / 2
    user:hurt(MathUtils.round(dmg / (chara.level)))
    target:hurt(MathUtils.round(dmg * (chara:getStat("magic") / 4) * 1 + (chara.level / 12)), user, function()
        target:darkify()
    end)
end

return spell