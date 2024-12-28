local item, super = Class(Item, "beginners_wand")

function item:init()
    super.init(self)

    -- Display name
    self.name = "B.'s Wand"

    -- Item type (item, key, weapon, armor)
    self.type = "weapon"
    -- Item icon (for equipment)
    self.icon = "ui/menu/icon/wand"

    -- Battle description
    self.effect = ""
    -- Shop description
    self.shop = ""
    -- Menu description
    self.description = "A beginner's magic wand."

    -- Default shop price (sell price is halved)
    self.price = 40
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
        nelle = true,
    }

    -- Character reactions
    self.reactions = {
        susie = "THAT'S JUST A STICK!",
        ralsei = "Oh... It's... What's that?",
        noelle = "I don't think I can use it...",
		dess = "your a wizard, harry",
        brenda = "Uh... Abracadabra?",
		jamm = "I'm not really a wizard.",
        noel = "",
        nelle = "Ah, my first wand..."
    }
end

function item:convertToLightEquip(inventory)
    return "light/foam_dart_rifle"
end

return item