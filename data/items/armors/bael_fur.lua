local item, super = Class(Item, "bael_fur")

function item:init()
    super.init(self)

    -- Display name
    self.name = "Bael Fur"

    -- Item type (item, key, weapon, armor)
    self.type = "armor"
    -- Item icon (for equipment)
    self.icon = "ui/menu/icon/armor"

    -- Battle description
    self.effect = ""
    -- Shop description
    self.shop = "Defensive\nfur"
    -- Menu description
    self.description = "Flame colored fur obtained from a giant spider, slightly increases defense."

    -- Default shop price (sell price is halved)
    self.price = 12
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
        defense = 1,
    }
    -- Bonus name and icon (displayed in equip menu)
    self.bonus_name = nil
    self.bonus_icon = nil

    -- Equippable characters (default true for armors, false for weapons)
    self.can_equip = {
        ceroba = false
    }

    -- Character reactions
    self.reactions = {
        susie = "Now that's a cool shade of red!",
        suzy = "Now that's a cool shade of orange!",
        ralsei = "I never thought to use this as armor!",
        dess = "Yo you guys killed a giant spider without me?",
        ceroba = "I'm not comfortable with that...",
        jamm = "Anything is armor, I guess...",
        hero = "Fuzzy",
        noel = "1 DEF won't help me.",
    }
end

return item