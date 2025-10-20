local item, super = Class(TensionItem, "dancing_tear")

function item:init()
    super.init(self)

    -- Display name
    self.name = "Dancing Tear"
    -- Name displayed when used in battle (optional)
    self.use_name = nil

    -- Item type (item, key, weapon, armor)
    self.type = "item"
    -- Item icon (for equipment)
    self.icon = nil

    -- Battle description
    self.effect = "Raises\nTP\n64%"
    -- Shop description
    --self.shop = "Tense Shadow\nRaises TP\nby 48%\nin battle."
    -- Menu description
    self.description = "A tear that refuses to stop being a tear.\nRaises TP by 64% in battle."

    -- Amount of TP this item gives (TensionItem variable)
    self.tp_amount = 64

    -- Default shop price (sell price is halved)
    self.price = 600
    -- Whether the item can be sold
    self.can_sell = true

    -- Consumable target mode (ally, party, enemy, enemies, or none)
    self.target = "party"
    -- Where this item can be used (world, battle, all, or none)
    self.usable_in = "all"
    -- Item this item will get turned into when consumed
    self.result_item = nil
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
    self.reactions = {}
end

return item