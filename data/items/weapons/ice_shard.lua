local item, super = Class(Item, "ice_shard")

function item:init()
    super.init(self)

    -- Display name
    self.name = "Ice Shard"

    -- Item type (item, key, weapon, armor)
    self.type = "weapon"
    -- Item icon (for equipment)
    self.icon = "ui/menu/icon/shardb"

    -- Battle description
    self.effect = ""
    -- Shop description
    self.shop = ""
    -- Menu description
    self.description = "A shard of freezing energy fabricated from\npowerful Ice magic power."

    -- Default shop price (sell price is halved)
    self.price = 640
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
        attack = 8,
        magic = 18
    }
    -- Bonus name and icon (displayed in equip menu)
    self.bonus_name = "Frost"
    self.bonus_icon = "ui/menu/icon/snow"

    -- Equippable characters (default true for armors, false for weapons)
    self.can_equip = {
        bor = true
    }

    -- Character reactions
    self.reactions = {
        bor = "This one looks pretty cool!"
    }
end

return item
