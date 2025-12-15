local item, super = Class(Item, "chosen_ax")

function item:init()
    super.init(self)

    -- Display name
    self.name = "Chosen Ax"

    -- Item type (item, key, weapon, armor)
    self.type = "weapon"
    -- Item icon (for equipment)
    self.icon = "ui/menu/icon/axe"

    -- Battle description
    self.effect = ""
    -- Shop description
    self.shop = ""
    -- Menu description
    self.description = "Axe of the novice hero.\nEquippable by both sword and axe wielders."

    -- Default shop price (sell price is halved)
    self.price = nil
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
        attack = 1,
        magic = 2,
    }
    -- Bonus name and icon (displayed in equip menu)
    self.bonus_name = nil
    self.bonus_icon = nil

    -- Equippable characters (default true for armors, false for weapons)
    self.can_equip = {
        kris = true,
        hero = true,
        susie = true,
        suzy = true,
    }

    -- Character reactions
    self.reactions = {
        hero = "That's pretty cool, actually.",
        susie = "Now we're talking!",
        suzy = "Chosen One? Heck Yeah!",
        ralsei = "Ummm... it's a bit big.",
        noelle = "It's... pretty heroic...",
	    dess = "Too too heavy",
        brenda = "I can't carry THAT.",
	    jamm = "I mean, I'm not THAT strong...",
        noel = "Now, I'm gonna pull a [Red Buster]!",
        ceroba = "(It's not THAT heavy...)"
    }
end

return item