local item, super = Class(Item, "tinkatinHammer")

function item:init()
    super.init(self)

    -- Display name
    self.name = "TinkatinHammer"

    -- Item type (item, key, weapon, armor)
    self.type = "weapon"
    -- Item icon (for equipment)
    self.icon = "ui/menu/icon/axe"

    -- Battle description
    self.effect = ""
    -- Shop description
    self.shop = "A warning sign."
    -- Menu description
    self.description = "A warning sign that got ripped from the ground.\nKinda shaped like a hammer."

    -- Default shop price (sell price is halved)
    self.price = 400
    -- Whether the item can be sold
    self.can_sell = false

    -- Consumable target mode (ally, party, enemy, enemies, or none)
    self.target = "none"
    -- Where this item can be used (world, battle, all, or none)
    self.usable_in = "all"
    -- Item this item will get turned into when consumed
    self.result_item = nil
    -- Will this item be instantly consumed in battles?
    self.instant = false

    -- Equip bonuses (for weapons and armor)
    self.bonuses = {
        attack = 8,
        magic = -2,
    }
    -- Bonus name and icon (displayed in equip menu)
    self.bonus_name = nil
    self.bonus_icon = nil

    -- Equippable characters (default true for armors, false for weapons)
    self.can_equip = {
        susie = true,
        suzy = true,
    }

    -- Character reactions
    self.reactions = {
        susie = "There's a bit of blood in the corner!",
        suzy = "My enemies will be very warned!!",
    }
end

return item