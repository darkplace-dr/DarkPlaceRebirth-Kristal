local spell, super = Class(Spell, "grapeshot")

function spell:init()
    super.init(self)

    self.name = "Grapeshot"
	self.cast_name = "GRAPESHOT"

    self.effect = "Damage\nAll"
    self.description = "Shoot a grapeshot round that damages all enemies.\nDamage is highly variable."
	self.check = {"", "* Depends on Magic."}

    self.cost = 32

    self.target = "enemies"

    self.tags = {"Damage", "Fire"}
end

function spell:getCastMessage(user, target)
    return "* "..user.chara:getName().." used "..self:getCastName().."!"
end

function spell:onCast(user, target)
    user:setAnimation("battle/attack_ready")

    Game.battle.timer:after(1/4, function()
        user:setAnimation("battle/attack")
        Assets.playSound("bigcut")
        for i, v in ipairs(Game.battle:getActiveEnemies()) do
            target = v
            local damage = self:getDamage(user, target)
            v:hurt(damage, user)

            if target.id == "darkclone/brenda" then
                local skillknow = false
                for _, v in ipairs(target.usedskills) do
                    if v == "grapeshot" then
                        skillknow = true
                    end
                end
                if skillknow == false then
                    table.insert(target.usedskills, "grapeshot")
                end
            end
        end
    end)

    Game.battle.timer:after(2, function()
        Game.battle:finishActionBy(user)
    end)

    return false
end

function spell:onLightCast(user, target)
    local damage = self:getDamage(user, target)

    return false
end

function spell:getDamage(user, target)
    local damage = math.ceil(love.math.random(user.chara:getStat("attack"), user.chara:getStat("attack") * 20) - (target.defense * 2))
    return damage
end

return spell
