local item, super = Class(Item, "harvester")

function item:init()
    super.init(self)

    -- Display name
    self.name = "Harvester"

    -- Item type (item, key, weapon, armor)
    self.type = "weapon"
    -- Item icon (for equipment)
    self.icon = "ui/menu/icon/axe"

    -- Battle description
    self.effect = ""
    -- Shop description
    self.shop = ""
    -- Menu description
    self.description = "A scythe with green hilt and yellow blade. Used to get crops such as Corn! Heals you each turn!"

    -- Default shop price (sell price is halved)
    self.price = 1000
    -- Whether the item can be sold
    self.can_sell = true

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
        magic = 0,
    }
    -- Bonus name and icon (displayed in equip menu)
    self.bonus_name = "IdleHeal"
    self.bonus_icon = "ui/menu/icon/up"

    -- Equippable characters (default true for armors, false for weapons)
    self.can_equip = {
        susie = true,
        suzy = true,
        hero = true,
    }

    -- Character reactions
    self.reactions = {
        susie = "Hey! It grows corn!",
        suzy = "Chomp! Ow, it's sharp!",
        ceroba = "I'm... Not a farmer.",
        dess = "i hate stardew valley",
        noel = "Insufficent.",
        hero = "This thing is BUSTED!",
    }
end

return item