local item, super = Class(HealItem, "soda_georg")

function item:init()
    super.init(self)

    -- Display name
    self.name = "Soda Georg"

    -- Item type (item, key, weapon, armor)
    self.type = "item"
    -- Item icon (for equipment)
    self.icon = nil

    -- Battle description
    self.effect = "Legally\nDistinct\nSoda"
    -- Shop description
    self.shop = ""
    -- Menu description
    self.description = "A soda that was given to you."

    -- Amount healed (HealItem variable)
    self.heal_amount = 160

    -- Default shop price (sell price is halved)
    self.price = 70
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
        jamm = "So what was up with that guy...?"
    }
end

function item:getDescription()
    local s = "A soda that was given to you.\nYou got it at "
    -- TODO: Figure out 100 places the Soda Georg guy can interrupt your gameplay.
    return s
end

return item
