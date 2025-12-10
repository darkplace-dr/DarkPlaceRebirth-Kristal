local spell, super = Class(Spell, "spearblaster")

function spell:init()
    super.init(self)

    -- Display name
    self.name = "SpearBlaster"
    -- Name displayed when cast (optional)
    self.cast_name = "SPEAR BLASTER"

    -- Battle description
    self.effect = "Elec\nDamage"
    -- Menu description
    self.description = "Launches a barrage of bullets targeting one\nfoe. Depends on Attack & Magic."
    -- Check description
    self.check = {"Launches a barrage of bullets targeting one foe.", "* Depends on Attack & Magic."}

    -- TP cost
    self.cost = 50

    -- Target mode (ally, party, enemy, enemies, or none)
    self.target = "enemy"

    -- Tags that apply to this spell
    self.tags = {"electric", "damage"}

end

function spell:getCastMessage(user, target)
    return "* "..user.chara:getName().." used "..self:getCastName().."!"
end

function spell:getLightCastMessage(user, target)
    return "* "..user.chara:getName().." used "..self:getCastName().."!"
end

function spell:onCast(user, target)
    user:setAnimation("battle/super_jump")
    Game.battle.timer:after(1/15 * 3.5, function() Assets.playSound("jump") end)
    Game.battle.timer:after(1/15 * 9.5, function()
        Assets.playSound("bell", 0.5, 0.6)
        Assets.playSound("bell", 0.5, 0.8)
    end)
    Game.battle.timer:after(1/15 * 14.5, function()
        Assets.playSound("criticalswing")
        Game.battle.timer:script(function(wait)
            for i = 1, 10 do
                if not target then -- failsafe
                    i = 10
                else
                    Assets.stopAndPlaySound("rocket")
                    local x, y = user:getRelativePos(user.width + 10, user.height/2 - 10, Game.battle)
                    local tx, ty = target:getRelativePos(target.width/2, target.height/2, Game.battle)
                    local bullet = SpearBlasterBullet(x, y, tx, ty, function()
                        if target.done_state == nil then -- failsafe 2
                            Assets.stopAndPlaySound("damage")
                            target:hurt(self:getDamage(user, target), user)
                        end
                    end)
                    Game.battle:addChild(bullet)
                    wait(1/15)
                end
                if i == 10 then
                    wait(1.5)
                    Game.battle:finishAction()
                end
            end
        end)
    end)
    --Game.battle:finishAction()
    return false
end

function spell:onLightCast(user, target)
    Game.battle.timer:after(1/15 * 3.5, function() Assets.playSound("jump") end)
    Game.battle.timer:after(1/15 * 9.5, function()
        Assets.playSound("bell", 0.5, 0.6)
        Assets.playSound("bell", 0.5, 0.8)
    end)
    Game.battle.timer:after(1/15 * 14.5, function()
        Assets.playSound("criticalswing")
        Game.battle.timer:script(function(wait)
            for i = 1, 10 do
                if not target then -- failsafe
                    i = 10
                else
                    Assets.stopAndPlaySound("rocket")
                    local x, y = SCREEN_WIDTH / 2, SCREEN_HEIGHT + 60
                    local tx, ty = target:getRelativePos(target.width/2, target.height/2, Game.battle)
                    local bullet = SpearBlasterBullet(x, y, tx, ty, function()
                        if target.done_state == nil then -- failsafe 2
                            Assets.stopAndPlaySound("damage")
                            target:hurt(self:getDamage(user, target), user)
                        end
                    end)
                    Game.battle:addChild(bullet)
                    wait(1/15)
                end
                if i == 10 then
                    wait(1.5)
                    Game.battle:finishAction()
                end
            end
        end)
    end)
    return false
end

function spell:getDamage(user, target)
    if Game:isLight() then
        local damage = math.ceil((user.chara:getStat("magic") * 2) + user.chara:getStat("attack") - target.defense)
        return damage
    else
        local damage = math.ceil((user.chara:getStat("magic") * 3) + (user.chara:getStat("attack") * 1.5) - (target.defense * 2))
        return damage
    end
end

return spell