local item, super = Class(HealItem, "StarBit")

function item:init()
    super.init(self)

    -- Display name
    self.name = "StarBit"

    -- Item type (item, key, weapon, armor)
    self.type = "item"
    -- Item icon (for equipment)
    self.icon = nil

    -- Battle description
    self.effect = "Heals\n60HP"
    -- Shop description
    self.shop = "Stars\ndirectly\nfrom the depths\nof space!!\n+60HP"
    -- Menu description
    self.description = "Normal star shaped candy.\nNothing special. +60HP."

    -- Amount healed (HealItem variable)
    self.heal_amount = 70

    -- Default shop price (sell price is halved)
    self.price = 200
    -- Whether the item can be sold
    self.can_sell = false

    -- Consumable target mode (ally, party, enemy, enemies, or none)
    self.target = "ally"
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

    -- Character reactions (key = party member id)
    self.reactions = {
        susie = "Too small!",
        ralsei = "It's popping in my mouth!",
    }
end

return item