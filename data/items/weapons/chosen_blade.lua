local item, super = Class(Item, "chosen_blade")

function item:init()
    super.init(self)

    self.last_stand = true

    -- Display name
    self.name = "Chosen Blade"

    -- Item type (item, key, weapon, armor)
    self.type = "weapon"
    -- Item icon (for equipment)
    self.icon = "ui/menu/icon/sword"

    -- Battle description
    self.effect = ""
    -- Shop description
    self.shop = ""
    -- Menu description
    self.description = "Blade of the chosen one, forged in the depths.\nThe wielder can take a fatal blow in battle."

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
        attack = 0,
        magic = 1,
    }
    -- Bonus name and icon (displayed in equip menu)
    self.bonus_name = "Determination"
    self.bonus_icon = "ui/menu/icon/up"

    -- Equippable characters (default true for armors, false for weapons)
    self.can_equip = {
        kris = true,
        hero = true,
        suzy = true,
    }

    -- Character reactions
    self.reactions = {
        susie = "Me? Some sorta chosen one? Nah.",
        suzy = "Chosen One? Heck Yeah!",
        ralsei = "Um, I don't think this is mine.",
        noelle = "It feels... magical?",
        hero = "Back where it belongs.",
        dess = "little ol' me a hero? surely you're jestin",
        brenda = "Swords aren't really my style.",
        jamm = "What do I look like, the main character?",
        ceroba = "There's no way I can wield THAT.",
        noel = "Overhyped, Underused, yet VERY Interesting...",
    }
end

--function item:convertToLightEquip(chara)
--    return "light/pencil"
--end

return item