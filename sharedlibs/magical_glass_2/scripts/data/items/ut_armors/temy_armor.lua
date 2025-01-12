local temy_armor, super = Class(LightEquipItem, "mg_item/temy_armor")

function temy_armor:init()
    super.init(self)

    -- Display name
    self.name = "temy armor"
    -- Name displayed in the normal item select menu
    self.short_name = "Temmie AR"
    -- Name displayed in the normal item select menu during a serious encounter
    self.serious_name = "Tem.Armor"
    -- Name displayed in the light world stat menu
    self.equip_name = "Temmie Armor"

    -- Item type (item, key, weapon, armor)
    self.type = "armor"
    -- Whether this item is for the light world
    self.light = true

    -- Shop description
    self.shop = "ARMOR 20DF\nmakes\nbattles\ntoo easy"
    
    self.shop_dont_show_change = true
    -- Default shop sell price
    self.sell_price = 500
    -- Whether the item can be sold
    self.can_sell = true

    -- Item description text (unused by light items outside of debug menu)
    self.description = "The things you can do with a college education!"

    -- Light world check text
    self.check = {
        "Armor DF 20\n* The things you can do with\na college education!",
        "* Raises ATTACK when worn.\n* Recovers HP every other turn.\n* INV up slightly."
    }

    -- Where this item can be used (world, battle, all, or none)
    self.usable_in = "all"

    -- Equip bonuses (for weapons and armor)
    self.bonuses = {
        defense = 20,
        attack = 10,
        inv = 15/30
    }
end

function temy_armor:showEquipText(target)
    Game.world:showText("* " .. target:getNameOrYou() .. " donned the Temmie Armor.")
end

function temy_armor:getLightBattleText(user, target)
    return "* " .. target.chara:getNameOrYou() .. " donned the Temmie Armor."
end

function temy_armor:getPrice()
    local price = 9999
    for i = 1, math.min(MagicalGlass:getGameOvers(), 30) do
        if i == 1 then
            price = price - 999
        elseif i <= 5 then
            price = price - 1000
        elseif i <= 9 then
            price = price - 500
        elseif i <= 17 then
            price = price - 200
        elseif i <= 19 then
            price = price - 150
        end
        if i >= 20 then
            price = 1000
        end
        if i >= 25 then
            price = 750
        end
        if i >= 30 then
            price = 500
        end
    end
    return price
end

function temy_armor:onLightBattleNextTurn(battler, turn)
    if turn % 2 == 0 then
        battler:heal(1)
        Assets.stopAndPlaySound("power")
    end
end

return temy_armor