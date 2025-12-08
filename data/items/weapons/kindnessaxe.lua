local item, super = Class(Item, "kindnessaxe")

function item:init()
    super.init(self)

    -- Display name
    self.name = "KindnessAxe"

    -- Item type (item, key, weapon, armor)
    self.type = "weapon"
    -- Item icon (for equipment)
    self.icon = "ui/menu/icon/axe"

    -- Battle description
    self.effect = ""
    -- Shop description
    self.shop = ""
    -- Menu description
    self.description = "With that, the KINDNESS must be freed."

    -- Default shop price (sell price is halved)
    self.price = 0
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
        attack = 10,
        magic = 4,
    }
    -- Bonus name and icon (displayed in equip menu)
    self.bonus_name = "Kindness"
    self.bonus_icon = "ui/menu/icon/magic"

    -- Equippable characters (default true for armors, false for weapons)
    self.can_equip = {
        susie = true,
    }

    -- Character reactions
    self.reactions = {
        susie = "Watch this, old man!",
        ralsei = "... isn't Susie amazing?",
        noelle = "... Susie beat up an old man!?",
        jamm = "So you... robbed an old guy?",
        ceroba = "It's like from a history book..."
    }
end

function item:onEquip(character, replacement)
    if character.id == "susie" then
        Game:setFlag("kindness_heal", true)
        self.bonus_name = "Kindness"
        self.bonus_icon = "ui/menu/icon/magic"
    end
    return true
end

function item:onUnequip(character, replacement)
    if character.id == "susie" then
        Game:setFlag("kindness_heal", false)
        self.bonus_name = nil
        self.bonus_icon = nil
    end
    return true
end

return item
