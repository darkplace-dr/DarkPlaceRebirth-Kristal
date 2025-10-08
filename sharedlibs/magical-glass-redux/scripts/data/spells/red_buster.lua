local spell, super = Class("red_buster", true)

function spell:init()
    super.init(self)
    
    self.check = {"Deals large Red-elemental damage to\none foe.", "* Depends on Attack & Magic."}
end

function spell:onLightCast(user, target)
    user.delay_turn_end = true
    Game.battle.timer:after(15/30, function()
        Assets.playSound("rudebuster_swing")
        local x, y = (SCREEN_WIDTH/2), SCREEN_HEIGHT
        local tx, ty = target:getRelativePos(target.width/2, target.height/2, Game.battle)
        local blast = RudeBusterBeam(true, x, y, tx, ty, function(pressed)
            local damage = self:getDamage(user, target, pressed)
            if pressed then
                Assets.playSound("scytheburst")
            end
            target:hurt(damage, user)
            target:flash()
            Game.battle:finishAction()
        end)
        blast.layer = LIGHT_BATTLE_LAYERS["above_arena_border"]
        Game.battle:addChild(blast)
    end)
    return false
end

function spell:getDamage(user, target, pressed, damage_bonus)
    if pressed then
        damage_bonus = 40
    else
        damage_bonus = 0
    end
    if Game:isLight() then
        local damage = math.ceil((user.chara:getStat("magic") * 2) + (user.chara:getStat("attack") * 5) - (target.defense * 4)) + 40 + damage_bonus
        return damage
    else
        return super.getDamage(self, user, target, damage_bonus)
    end
end

return spell