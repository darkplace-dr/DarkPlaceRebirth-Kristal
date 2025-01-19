local item, super = Class(LightHealItem, "mg_item/dream")

function item:init()
    super.init(self)

    -- Display name
    self.name = "Dream"
    -- Name displayed in the normal item select menu
    self.short_name = "LastDream"

    -- Item type (item, key, weapon, armor)
    self.type = "item"
    -- Whether this item is for the light world
    self.light = true

    -- Amount this item heals
    self.heal_amount = 12

    -- Default shop sell price
    self.sell_price = 250
    -- Whether the item can be sold
    self.can_sell = true

    -- Item description text (unused by light items outside of debug menu)
    self.description = "The goal of \"Determination.\""

    -- Light world check text
    self.check = "Heals 12 HP\n* The goal of \"Determination.\""

    -- Consumable target mode (ally, party, enemy, enemies, or none)
    self.target = "ally"
    -- Where this item can be used (world, battle, all, or none)
    self.usable_in = "all"
end

function item:onWorldUse(target)
    super.onWorldUse(self, target)
    Game:setFlag("mg#dream_used", true)
    return true
end

function item:getWorldUseText(target)
    if not Game:getFlag("mg#dream_used") then
        return "* Through DETERMINATION,[wait:10] the\ndream became true."
    else
        return "* The dream came true!"
    end
end

function item:onLightBattleUse(user, target)
    super.onLightBattleUse(self, user, target)
    Game:setFlag("mg#dream_used", true)
end

function item:getLightBattleText(user, target)
    if not Game:getFlag("mg#dream_used") then
        return "* Through DETERMINATION,[wait:10] the\ndream became true."
    else
        return "* The dream came true!"
    end
end

return item