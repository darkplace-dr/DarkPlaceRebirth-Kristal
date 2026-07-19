local spell, super = Class(Spell, "dark_steal")

function spell:init()
    super.init(self)

    -- Display name
    self.name = "Dark Steal"
    -- Name displayed when cast (optional)
    self.cast_name = nil

    -- Battle description
    self.effect = "Heal all\nCosts HP"
    -- Menu description
    self.description = "Shadowly dark restores a little HP to\nall party members in exhange of\nHP, Depends on Enemies and Magic."

    -- TP cost
    self.cost = 50

    -- Target mode (ally, party, enemy, enemies, or none)
    self.target = "party"

    -- Tags that apply to this spell
    self.tags = {"heal"}
end

function spell:onCast(user, target)
    local heal = user.chara:getStat("magic") * 6
    local dmg = heal * (2 / (user.chara:getStat("magic") / 6))
    local party = Game.battle.party

    if Game.battle and Game.battle.encounter.is_jackenstein then
        for i,battler in ipairs(party) do
            Game.battle.timer:after(0.2 * i, function()
                local chosen_dmg = 1
                if MathUtils.randomInt(1, 1001) == 1 then
                    chosen_dmg = 2
                end

                battler:hurt(chosen_dmg, true)
                heal = heal + MathUtils.round(chosen_dmg) / 2
                
                Assets.playSound("squeaky", chosen_dmg)
            end)
        end
    end

    Game.battle.timer:after(1.2, function()
        user:hurt(dmg * 2)
        if Game.battle and not Game.battle.encounter.is_jackenstein then
            local enemies = Game.battle.enemies
            for _,enemy in ipairs(enemies) do
                local enemy_dmg = dmg / 4 * ((user.chara:getStat("magic") / 8) / 2)
                heal = heal + MathUtils.round(enemy_dmg) / 2
                enemy:hurt(MathUtils.round(enemy_dmg), user)
            end
        end

        local heal_amount = Game.battle:applyHealBonuses(MathUtils.round(heal), user.chara)
        for _,battler in ipairs(target) do
            print("healing: " .. battler.chara.id)
            if battler.chara.id == user.chara.id then
                battler:heal(MathUtils.round(heal_amount / 8))
            else
                battler:heal(heal_amount)
            end
        end
    end)
end

return spell