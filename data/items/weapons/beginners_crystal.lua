local item, super = Class(Item, "beginners_crystal")

function item:init()
    super.init(self)

    -- Display name
    self.name = "StarterCrystal"

    -- Item type (item, key, weapon, armor)
    self.type = "weapon"
    -- Item icon (for equipment)
    self.icon = "ui/menu/icon/diamond"

    -- Battle description
    self.effect = ""
    -- Shop description
    self.shop = ""
    -- Menu description
    self.description = "An old magical crystal that has seen\nsome use over the years."

    -- Default shop price (sell price is halved)
    self.price = 60
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
        attack = 0,
    }
    -- Bonus name and icon (displayed in equip menu)
    self.bonus_name = nil
    self.bonus_icon = nil

    -- Equippable characters (default true for armors, false for weapons)
    self.can_equip = {
        ddelta = true,
    }

    -- Character reactions
    self.reactions = {
        ddelta = "i should probably get a new one",
		dess = "made too many meth jokes already",
        jamm = "How do I even use this?",
        ceroba = "You want me to hit with a CRYSTAL?",
        noel = "Dull, Drained, Useless.",
    }
end

function item:convertToLightEquip(chara)
    return "light/magic_ball"
end

return item