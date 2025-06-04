local item, super = Class(Item, "broken_leadmaker")

function item:init()
    super.init(self)

    -- Display name
    self.name = "BrknLedMakr"

    -- Item type (item, key, weapon, armor)
    self.type = "armor"
    -- Item icon (for equipment)
    self.icon = "ui/menu/icon/armor"

    -- Battle description
    self.effect = ""
    -- Shop description
    self.shop = ""
    -- Menu description
    self.description = "A broken Lead Maker.\nUseless..."

    -- Default shop price (sell price is halved)
    self.price = 2
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
        defense = 0.5,
    }
    -- Bonus name and icon (displayed in equip menu)
    self.bonus_name = "Worth"
    self.bonus_icon = "ui/menu/icon/downb"

    -- Equippable characters (default true for armors, false for weapons)
    self.can_equip = {
	}

    -- Character reactions
    self.reactions = {
        suzy = "Look! It's my hard work!",
    }
end

function item:applyMoneyBonus(gold)
    return gold * 1.5
end

return item