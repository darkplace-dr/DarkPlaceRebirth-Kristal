local item, super = Class(HealItem, "lemonade")

function item:init()
    super.init(self)

    -- Display name
    self.name = "Lemonade"
    -- Name displayed when used in battle (optional)
    self.use_name = "Lemonade"

    -- Item type (item, key, weapon, armor)
    self.type = "item"
    -- Item icon (for equipment)
    self.icon = nil

    -- Battle description
    self.effect = "Heals\n20\nHP"
    -- Shop description
    self.shop = "Refreshing\ndrink.\nHeals 20HP"
    -- Menu description
    self.description = "A cold, lemon-flavored beverage. Best part is that it's home-made! Heals +20HP"

    -- Amount this item heals for specific characters
    self.heal_amounts = {
        ["kris"] = 20,
        ["susie"] = 20,
        ["ralsei"] = 20,
        ["noelle"] = 20,
		["dess"] = 20,
        ["brenda"] = 20,
		["jamm"] = 20,
        ["noel"] = 20,
        ["ceroba"] = 20,
        ["hero"] = 20,
	}

    -- Default shop price (sell price is halved)
    self.price = 60
    -- Whether the item can be sold
    self.can_sell = true

    -- Consumable target mode (party, enemy, noselect, or none/nil)
    self.target = "ally"
    -- Where this item can be used (world, battle, all, or none/nil)
    self.usable_in = "all"
    -- Item this item will get turned into when consumed
    self.result_item = nil
    -- Will this item be instantly consumed in battles?
    self.instant = false

    -- Character reactions (key = party member id)

    self.reactions = { -- can't think of any rn. feel free to add some.
        susie = "",
        ralsei = "",
        noelle = "",
		dess = "",
        brenda = "",
		jamm = "",
		noel = "",
        ceroba = "",
        hero = "",
	}
end

-- Function overrides go here

function item:onWorldUse(target)
    return super.onWorldUse(self, target)
end

return item