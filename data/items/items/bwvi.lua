-- Instead of Item, create a HealItem, a convenient class for consumable healing items
local item, super = Class(HealItem, "bwvi")

function item:init()
    super.init(self)

    -- Display name
    self.name = "B.W.V.I."

    -- Item type (item, key, weapon, armor)
    self.type = "item"
    -- Item icon (for equipment)
    self.icon = nil

    -- Battle description
    self.effect = "Heals\n60 HP"
    -- Shop description
    self.shop = nil
    -- Menu description
    self.description = "A brick with vanilla ice cream as a topping."

    -- Amount healed (HealItem variable)
    self.heal_amount = 60
	self.heal_amounts = {
        kris = 60,
        susie = 60,
        ralsei = 60,
        noelle = 60,
        YOU = 60,
        dess = nil,
        brenda = 60,
		jamm = 60,
        noel = 60,
    }

    -- Default shop price (sell price is halved)
    self.price = 100
    -- Whether the item can be sold
    self.can_sell = true

    -- Consumable target mode (ally, party, enemy, enemies, or none)
    self.target = "ally"
    -- Where this item can be used (world, battle, all, or none)
    self.usable_in = "all"
    -- Will this item be instantly consumed in battles?
    self.instant = false

    -- Equip bonuses (for weapons and armor)
    self.bonuses = {}
    -- Bonus name and icon (displayed in equip menu)
    self.bonus_name = nil
    self.bonus_icon = nil

    -- Equippable characters (default true for armors, false for weapons)
    self.can_equip = {}

    -- Character reactions (key = party member id)
    self.reactions = {
        susie = "Hell yeah! Crunchy!",
        ralsei = "(Am I supposed to eat this?)",
        noelle = "(I'll just lick it off...)",
		dess = "throw it at a window instead",
		jamm = "Remind me to visit the dentist after this.",
    }
	self.rdReactions = Utils.copy(self.reactions)
	self.rdReactions["dess"] = "...no."
end

return item
