local item, super = Class(Item, "memory_guts")

function item:init()
    super.init(self)

    -- Display name
    self.name = "Memory Guts"

    -- Item type (item, key, weapon, armor)
    self.type = "armor"
    -- Item icon (for equipment)
    self.icon = "ui/menu/icon/armor"

    -- Battle description
    self.effect = ""
    -- Shop description
    self.shop = ""
    -- Menu description
    self.description = "For those whose dreams are nightmares."

    -- Default shop price (sell price is halved)
    self.price = 800
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
        defense = -3,
        magic = 9,
        attack = 0,
    }
    -- Bonus name and icon (displayed in equip menu)
    self.bonus_name = "Fun"
    self.bonus_icon = "ui/menu/icon/smile"

    -- Equippable characters (default true for armors, false for weapons)
    self.can_equip = {}

    -- Character reactions
    self.reactions = {

    }
end

function item:applyMoneyBonus(gold)
    return gold * (1.11)
end

return item