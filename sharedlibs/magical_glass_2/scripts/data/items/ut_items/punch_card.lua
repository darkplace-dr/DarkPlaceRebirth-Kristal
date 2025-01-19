local item, super = Class(Item, "mg_item/punch_card")

function item:init()
    super.init(self)

    -- Display name
    self.name = "Punch Card"
    -- Name displayed in the normal item select menu
    self.short_name = "PunchCard"

    -- Item type (item, key, weapon, armor)
    self.type = "item"
    -- Whether this item is for the light world
    self.light = true

    -- Default shop sell price
    self.sell_price = 15
    -- Whether the item can be sold
    self.can_sell = true

    -- Item description text (unused by light items outside of debug menu)
    self.description = "Used to make punching attacks stronger for one battle."

    -- Light world check text
    self.check = {
        "Battle Item\n* Used to make punching attacks\nstronger for one battle.",
        "* Use outside of battle\nto look at the card."
    }

    -- Consumable target mode (ally, party, enemy, enemies, or none)
    self.target = "none"
    -- Where this item can be used (world, battle, all, or none)
    self.usable_in = "all"
end

function item:onWorldUse(target)
    Game.world:closeMenu()
    Game.world.timer:after(1/30, function()
        Game.world:openMenu(ImageViewer("world/punchcard"))
    end)
    return false
end

function item:getATIncrease(battler)
    if battler.chara:getStat("attack") > 18 then
        return 5
    elseif battler.chara:getStat("attack") > 23 then
        return 4
    elseif battler.chara:getStat("attack") > 26 then
        return 3
    elseif battler.chara:getStat("attack") > 28 then
        return 2
    end
    return 6
end

function item:getLightBattleText(user, target)
    if user.chara:getWeapon():hasTag("punch") then
        if user.chara.you then
            return {
                "* OOOORAAAAA!!![wait:10]\n* You rip up the punch card!",
                "* Your hands are burning![wait:10]\n* AT increased by "..self:getATIncrease(user).."!"
            }
        else
            return {
                "* OOOORAAAAA!!![wait:10]\n* "..user.chara:getName().." rips up the punch card!\n* AT increased by "..self:getATIncrease(user).."!"
            }
        end
    else
        if user.chara.you then
            return {
                "* OOOORAAAAA!!![wait:10]\n* You rip up the punch card!",
                "* But nothing happened."
            }
        else
            return {
                "* OOOORAAAAA!!![wait:10]\n* "..user.chara:getName().." rips up the punch card!",
                "* But nothing happened."
            }
        end
    end
end

function item:onLightBattleUse(user, target)
    Game.battle:battleText(self:getLightBattleText(user, target))
    if user.chara:getWeapon():hasTag("punch") then
        Assets.playSound("tearcard")
        user.chara:addStatBuff("attack", self:getATIncrease(user))
    end
    return true
end

return item