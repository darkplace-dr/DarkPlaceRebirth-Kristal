local item, super = Class(Item, "mg_item/bad_memory")

function item:init()
    super.init(self)

    -- Display name
    self.name = "Bad Memory"
    -- Name displayed in the normal item select menu
    self.short_name = "BadMemory"

    -- Item type (item, key, weapon, armor)
    self.type = "item"
    -- Whether this item is for the light world
    self.light = true

    -- Default shop sell price
    self.sell_price = 300
    -- Whether the item can be sold
    self.can_sell = true

    -- Item description text (unused by light items outside of debug menu)
    self.description = "?????"

    -- Light world check text
    self.check = "Hurts 1 HP\n* ?????"

    -- Consumable target mode (ally, party, enemy, enemies, or none)
    self.target = "ally"
    -- Where this item can be used (world, battle, all, or none)
    self.usable_in = "all"
end

function item:getWorldUseText(target)
    if target.you then
        if target:getHealth() > 3 then
            return "* You consume the Bad Memory.\n* You lost 1HP."
        else
            return "* You consume the Bad Memory.\n* Your HP was maxed out."
        end
    else
        if target:getHealth() > 3 then
            return "* "..target:getName().." consumes the Bad Memory.\n* "..target:getName().." lost 1HP."
        else
            return "* "..target:getName().." consumes the Bad Memory.\n* "..target:getName().."'s HP was maxed out."
        end
    end
end

function item:playWorldUseSound(target)
    if target:getHealth() > 3 then
        Game.world.timer:script(function(wait)
            Assets.stopAndPlaySound("swallow")
            wait(10/30)
            Assets.stopAndPlaySound("hurt")
        end)
    else
        Game.world.timer:script(function(wait)
            Assets.stopAndPlaySound("swallow")
            wait(10/30)
            Assets.stopAndPlaySound("power")
        end)
    end
end


function item:onWorldUse(target)
    self:playWorldUseSound(target)
    Game.world:showText(self:getWorldUseText(target))

    if target:getHealth() > 3 then
        target:setHealth(target:getHealth() - 1)
    else
        target:setHealth(target:getStat("health"))
    end

    return true
end

function item:getLightBattleText(user, target)
    if target.chara.you then
        if target.chara:getHealth() > 3 then
            return "* You consume the Bad Memory.\n* You lost 1HP."
        else
            return "* You consume the Bad Memory.\n* Your HP was maxed out."
        end
    else
        if target.chara:getHealth() > 3 then
            return "* "..target.chara:getName().." consumes the Bad Memory.\n* "..target.chara:getName().." lost 1HP."
        else
            return "* "..target.chara:getName().." consumes the Bad Memory.\n* "..target.chara:getName().."'s HP was maxed out."
        end
    end
end

function item:playLightBattleUseSound(target)
    if target.chara:getHealth() > 3 then
        Game.battle.timer:script(function(wait)
            Assets.stopAndPlaySound("swallow")
            wait(10/30)
            Assets.stopAndPlaySound("hurt")
        end)
    else
        Game.battle.timer:script(function(wait)
            Assets.stopAndPlaySound("swallow")
            wait(10/30)
            Assets.stopAndPlaySound("power")
        end)
    end
end

function item:onLightBattleUse(user, target)
    self:playLightBattleUseSound(target)
    Game.battle:battleText(self:getLightBattleText(user, target))
    if target.chara:getHealth() > 3 then
        target:removeHealth(1)
    else
        target:heal(target.chara:getStat("health"), nil, false)
    end
    return true
end

return item