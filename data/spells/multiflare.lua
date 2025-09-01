local spell, super = Class(Spell, "multiflare")

function spell:init()
    super.init(self)

    self.name = "MultiFlare"
	self.cast_name = "MULTIFLARE"

    self.effect = "Fire\nBarrage"
    self.description = "Shoots multiple fireballs at random targets.\nDeals FIRE elemental damage."
	self.check = {"", "* Depends on Magic."}

    self.cost = 32

    self.target = "enemies"

    self.tags = {"Damage", "Fire"}
end

function spell:getCastMessage(user, target)
    return "* "..user.chara:getName().." used "..self:getCastName().."!"
end

function spell:onCast(user, target)
    user:setAnimation("battle/multiflare")

    Game.battle.timer:after(1/4, function()
        for i = 1, 10, 1 do
            Game.battle.timer:after((i * 0.15), function()
                if #Game.battle:getActiveEnemies() >= 1 then
                    target = Game.battle:getActiveEnemies()[love.math.random(1,#Game.battle:getActiveEnemies())]

                    if target.id == "darkclone/brenda" then
                        local skillknow = false
                        for _, v in ipairs(target.usedskills) do
                            if v == "multiflare" then
                                skillknow = true
                            end
                        end
                        if skillknow == false then
                            table.insert(target.usedskills, "multiflare")
                        end
                        if target.powder then
                            target.defense = Game:getPartyMember("brenda"):getStat("defense") + Game:getPartyMember("brenda"):getStat("magic") / 2
                            target.powder_immunity = true
                        end
                    end

                    Assets.playSound("noise")
                    local x, y = user:getRelativePos(user.width, user.height/2 - 4, Game.battle)
                    local tx, ty = target:getRelativePos(target.width/2, target.height/2, Game.battle)
                    local flare = MultiFlareFireball(x, y, tx, ty, function()
                        local damage = self:getDamage(user, target)
                        target:hurt(damage, user)
                        if target.powder then
                            Assets.playSound("bomb")
                        end
                    end)
                    flare.layer = BATTLE_LAYERS["above_ui"]
                    Game.battle:addChild(flare)
                end
            end)
        end
    end)

    Game.battle.timer:after(3, function()
        Game.battle:finishActionBy(user)
    end)

    return false
end

function spell:onLightCast(user, target)
    local damage = self:getDamage(user, target)

    return false
end

function spell:getDamage(user, target)
    local damage = math.ceil((user.chara:getStat("magic") * 6) - (target.defense * 4))
    if target.powder then
        damage = damage * 2
        target.powder_damage = true
    end
    if target.health <= 0 then
        damage = 0
    end
    return damage
end

return spell
