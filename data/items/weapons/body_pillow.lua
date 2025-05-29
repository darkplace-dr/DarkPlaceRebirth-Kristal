local item, super = Class(Item, "body_pillow")

function item:init()
    super.init(self)

    -- Display name
    self.name = "Body Pillow"

    -- Item type (item, key, weapon, armor)
    self.type = "weapon"
    -- Item icon (for equipment)
    self.icon = "ui/menu/icon/bat"

    -- Battle description
    self.effect = ""
    -- Shop description
    self.shop = ""
    -- Menu description
    self.description = "Horrible as a bat, but it is soft and reduces damage well."

    -- Default shop price (sell price is halved)
    self.price = 400
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
        attack = -3,
        defense = 4,
        magic = -1,
    }
    -- Bonus name and icon (displayed in equip menu)
    self.bonus_name = nil
    self.bonus_icon = nil

    -- Equippable characters (default true for armors, false for weapons)
    self.can_equip = {
        dess = true,
    }

    -- Character reactions
    self.reactions = {
		dess = "yo omori reference",
		ralsei = "It'l get dirty as a weapon!",
		susie = "...That's not a weapon.",
        suzy = "...That's armor AT BEST.",
		noelle = "Maybe we can replace the sleeve...",
        brenda = "Why do we have this?",
		jamm = "I am not THAT desperate...",
        ["jamm+marcy"] = "I am not THAT desperate...",
        ceroba = "No.",
        noel = "Soft, Sad, and Ineffective."
    }
end

--function item:convertToLightEquip(chara)
--    return "light/pencil"
--end

return item