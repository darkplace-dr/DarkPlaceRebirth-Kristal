local item, super = Class(Item, "undertale/punch_card")

function item:init()
    super.init(self)

    -- Display name
    self.name = "Punch Card"
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
    -- Item this item will get turned into when consumed
    self.result_item = nil
    -- Will this item be instantly consumed in battles?
    self.instant = false
    
end

function item:getATIncrease(user)
    if user.chara:getStat("attack") > 28 then
        return 2
    elseif user.chara:getStat("attack") > 26 then
        return 3
    elseif user.chara:getStat("attack") > 23 then
        return 4
    elseif user.chara:getStat("attack") > 18 then
        return 5
    else
        return 6
    end
end

function item:onWorldUse(target)
    Game.world:closeMenu()
    Game.world.timer:after(1/30, function()
        if Kristal.getLibConfig("magical-glass", "punch_card_exploit") then
            ImageViewerBroken("world/punchcard")
        else
            Game.world:openMenu(ImageViewer("world/punchcard"))
        end
    end)
    return false
end

function item:getLightBattleText(user, target)
    if Utils.containsValue(user.chara:getWeapon() and user.chara:getWeapon().tags or {}, "punch") then
        return {
            "* OOOORAAAAA!!![wait:10]\n* "..user.chara:getNameOrYou().." rips up the punch card!",
            "* "..(select(2, user.chara:getNameOrYou()) and user.chara.id == Game.battle.party[1].chara.id and "Your" or user.chara:getNameOrYou().."'s").." hands are burning![wait:10]\n* AT increased by "..self:getATIncrease(user).."!"
        }
    else
        return {
            "* OOOORAAAAA!!![wait:10]\n* "..user.chara:getNameOrYou().." rips up the punch card!",
            "* But nothing happened."
        }
    end
end

function item:getBattleText(user, target)
    if Utils.containsValue(user.chara:getWeapon() and user.chara:getWeapon().tags or {}, "punch") then
        return {
            "* OOOORAAAAA!!![wait:10]\n* "..user.chara:getName().." rips up the punch card!",
            "* "..user.chara:getName().."'s hands are burning![wait:10]\n* AT increased by "..self:getATIncrease(user).."!"
        }
    else
        return {
            "* OOOORAAAAA!!![wait:10]\n* "..user.chara:getName().." rips up the punch card!",
            "* But nothing happened."
        }
    end
end

function item:onLightBattleUse(user, target)
    Game.battle:battleText(self:getLightBattleText(user, target))
    if Utils.containsValue(user.chara:getWeapon() and user.chara:getWeapon().tags or {}, "punch") then
        Assets.playSound("tearcard")
        user.chara:addStatBuff("attack", self:getATIncrease(user))
    end
    return true
end

function item:onBattleUse(user, target)
    if Utils.containsValue(user.chara:getWeapon() and user.chara:getWeapon().tags or {}, "punch") then
        Assets.playSound("tearcard")
        user.chara:addStatBuff("attack", self:getATIncrease(user))
    end
    return true
end

return item