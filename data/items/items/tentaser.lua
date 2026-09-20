local item, super = Class(TensionItem, "tentaser")

function item:init()
    super.init(self)

    -- Display name
    self.name = "TenTaser"
    -- Name displayed when used in battle (optional)
    self.use_name = nil

    -- Item type (item, key, weapon, armor)
    self.type = "item"
    -- Item icon (for equipment)
    self.icon = nil

    -- Battle description
    self.effect = "Gain TP 20%\nInfinite\nUses"
    -- Shop description
    self.shop = "Gain TP 20%\nInfinite\nUses"
    -- Menu description
    self.description = "Raises TP by 20% in battle. Can be used as much as you need."

    -- Amount of TP this item gives (TensionItem variable)
    self.tp_amount = 20

    -- Default shop price (sell price is halved)
    self.price = 150
    -- Whether the item can be sold
    self.can_sell = true

    -- Consumable target mode (ally, party, enemy, enemies, or none)
    self.target = "party"
    -- Where this item can be used (world, battle, all, or none)
    self.usable_in = "all"
    -- Item this item will get turned into when consumed
    self.result_item = "tentaser"
    -- Will this item be instantly consumed in battles?
    self.instant = true

    -- Equip bonuses (for weapons and armor)
    self.bonuses = {}
    -- Bonus name and icon (displayed in equip menu)
    self.bonus_name = nil
    self.bonus_icon = nil

    -- Equippable characters (default true for armors, false for weapons)
    self.can_equip = {}

    -- Character reactions
    self.reactions = {
        len = "Feeling tense...?"
    }
end

function item:getDescription()
    if Game:getFlag("tension_storage", false) then
        return "Raises TP by 20%. Can be used as much as you need... But only in battle."
    end
    return self.description
end

function item:onWorldUse(target)
    if Game:getFlag("tension_storage") then -- haha no you're not getting infinite TP in the overworld
        Game.world:showText({
            "* You used TENTASER!",
            "* ... but,[wait:5] it didn't seem to work...",
            "* (... try using it in battle.)"
        })
        return false
    end
    return super.onWorldUse(self, target)
end

return item