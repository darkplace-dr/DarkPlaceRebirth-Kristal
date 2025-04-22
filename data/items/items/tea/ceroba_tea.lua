local item, super = Class(HealItem, "ceroba_tea")

function item:init()
    super.init(self)

    -- Display name
    self.name = "Ceroba Tea"
    -- Name displayed when used in battle (optional)
    self.use_name = nil

    -- Item type (item, key, weapon, armor)
    self.type = "item"
    -- Item icon (for equipment)
    self.icon = nil

    -- Battle description
    self.effect = "Healing\nvaries"
    -- Shop description
    self.shop = ""
    -- Menu description
    self.description = "It's own-flavored tea.\nThe flavor just says \"Ceroba.\""
    -- Amount healed (HealItem variable)
    self.heal_amount = 50
    -- Amount this item heals for specific characters
    -- Party member this tea is from
    local tea_self = "ceroba"
    local placeholder = 50
    self.heal_amounts = {
		["susie"] = 90,
		["ralsei"] = 70,
		["noelle"] = 60,
		["dess"] = 90,
		["ceroba"] = 0,
        ["brenda"] = 200,
		["jamm"] = 70,
    }

    -- Default shop price (sell price is halved)
    self.price = 10
    -- Whether the item can be sold
    self.can_sell = true

    -- Consumable target mode (ally, party, enemy, enemies, or none)
    self.target = "ally"
    -- Where this item can be used (world, battle, all, or none)
    self.usable_in = "all"
    -- Item this item will get turned into when consumed
    self.result_item = nil
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
	susie = {
	    susie = "Dang, that's pretty good!",
	    ceroba = "(Didn't expect that.)",
	},
	ralsei = {
	    susie = "Cool.",
	    ralsei = "It's good!",
	    ceroba = "(I'm glad.)",
	},
	noelle = {
	    noelle = "I think it's alright...",
	    ceroba = "(Okay.)",
	},
    dess = {
	    dess = "I feel Roba taste",
	    susie = "(...what?)",
	    ralsei = "(I don't get it)",
	    noelle = "(Is that good?)",
	    ceroba = "(What's that supposed to mean!?)",
	},
	ceroba = "Tasteless.",
    brenda = {
        brenda = "(Women... pretty...)",
        ceroba = "... Why are you looking at me like that?",
        dess = "Ah, I take it you are a resident of the island of Lesbos?",
        susie = "Dude, you look like a tomato, haha!",
        noel = "I thought cantalopes were GREEN, not RED."
    },
	jamm = {
		jamm = "I get the taste...",
		ceroba = "What did you mean by that...?"
	},
    }
end

function item:getBattleHealAmount(id)
    -- Dont heal less than 40HP in battles
    return math.max(40, super.getBattleHealAmount(self, id))
end

return item