local item, super = Class(Item, "mystic_staff")

function item:init()
    super.init(self)

    -- Display name
    self.name = "MysticStaff"

    -- Item type (item, key, weapon, armor)
    self.type = "weapon"
    -- Item icon (for equipment)
    self.icon = "ui/menu/icon/staff"

    -- Battle description
    self.effect = ""
    -- Shop description
    self.shop = ""
    -- Menu description
    self.description = "A dark purple staff with a lilac crystal orb.\nGrants a high magical bonus."

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
        magic = 5,
    }
    -- Bonus name and icon (displayed in equip menu)
    self.bonus_name = "Magic Up"
    self.bonus_icon = "ui/menu/icon/up"

    -- Equippable characters (default true for armors, false for weapons)
    self.can_equip = {
        ceroba = true,
        nell = true,
    }

    -- Character reactions
    self.reactions = {
        susie = "Well, if I have to.",
        ralsei = "Not my type of magic...",
        noelle = "(It looks...)",
		dess = "\"mystic\" my ass",
        brenda = "",
        jamm = "",
        ceroba = "Good fit for a hero. But not me.",
        nell = "Back to origins, eh?"
    }
end

return item