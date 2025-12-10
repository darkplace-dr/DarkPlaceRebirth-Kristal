local item, super = Class(Item, "fire_shard")

function item:init()
    super.init(self)

    -- Display name
    self.name = "Fire Shard"

    -- Item type (item, key, weapon, armor)
    self.type = "weapon"
    -- Item icon (for equipment)
    self.icon = "ui/menu/icon/shardb"

    -- Battle description
    self.effect = ""
    -- Shop description
    self.shop = ""
    -- Menu description
    self.description = "A shard of hot energy fabricated from\npowerful Fire magic power."

    -- Default shop price (sell price is halved)
    self.price = 480
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
        attack = 6,
        magic = 14
    }
    -- Bonus name and icon (displayed in equip menu)
    self.bonus_name = "Heat"
    self.bonus_icon = "ui/menu/icon/fire"

    -- Equippable characters (default true for armors, false for weapons)
    self.can_equip = {
        bor = true
    }

    -- Character reactions
    self.reactions = {
        bor = "It's smoking hot!",
        jamm = "Nope! Not holding THAT!",
        ceroba = "My fur's gonna burn...",
    }
end

return item
