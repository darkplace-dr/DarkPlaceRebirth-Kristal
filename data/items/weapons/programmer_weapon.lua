local item, super = Class(Item, "programmer_weapon")

function item:init()
    super.init(self)

    -- Display name
    self.name = "Prog Weapon"

    -- Item type (item, key, weapon, armor)
    self.type = "weapon"
    -- Item icon (for equipment)
    self.icon = ""

    -- Battle description
    self.effect = ""
    -- Shop description
    self.shop = "It says to\nreturn"
    -- Menu description
    self.description = "Only those who know how to program can hold this."

    -- Default shop price (sell price is halved)
    self.price = 110
    -- Whether the item can be sold
    self.can_sell = true
    self.sell_price = 101

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
		defense = 4,
		magic = 4
    }
    -- Bonus name and icon (displayed in equip menu)
    self.bonus_name = "Basic"
    self.bonus_icon = nil

    -- Equippable characters (default true for armors, false for weapons)
	-- This weapon is DEV CHARACTER SPECIFIC
    self.can_equip = {
        brenda = true,
        jamm = true,
    }

    -- Character reactions
    self.reactions = {
        susie = "It's too confusing...",
        ralsei = "I can't wrap my head around it...",
		dess = "id rather get someone else to do it for me",
        noelle = "Print??? Return??? What is this saying???",
		jamm = "Oh, yeah. This is easy to read."
    }
	self.rdReactions = Utils.copy(self.reactions)
	self.rdReactions["dess"] = "That weirdo might like this."
end

return item