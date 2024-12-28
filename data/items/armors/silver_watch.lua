local item, super = Class(Item, "silver_watch")

function item:init()
    super.init(self)

    -- Display name
    self.name = "Silver Watch"

    -- Item type (item, key, weapon, armor)
    self.type = "armor"
    -- Item icon (for equipment)
    self.icon = "ui/menu/icon/armor"

    -- Battle description
    self.effect = ""
    -- Shop description
    self.shop = ""
    -- Menu description
    self.description = "Grazing bullets affects\nthe turn length by 10% more"

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
        defense = 2,

        graze_time = 0.1,
    }
    -- Bonus name and icon (displayed in equip menu)
    self.bonus_name = "GrazeTime"
    self.bonus_icon = "ui/menu/icon/up"

    -- Equippable characters (default true for armors, false for weapons)
    self.can_equip = {
        dess = false,
        jamm = false,
        noel = false,
    }

    -- Character reactions
    self.reactions = {
        susie = "It's clobbering time.",
        ralsei = "I'm late, I'm late!",
        noelle = "(Th-this was mine...)",
        dess = "aint no WAY you stole from my sister bro",
        jamm = "Nah, I got my own. It's a Fitbit!",
        noel = "I already have a pocket watch...",
    }
	self.rdReactions = Utils.copy(self.reactions)
	self.rdReactions["dess"] = "Give that back!"
end

function item:convertToLightEquip(chara)
    return "light/wristwatch"
end

return item