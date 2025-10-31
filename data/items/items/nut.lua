local item, super = Class(HealItem, "nut")

function item:init()
    super.init(self)

    -- Display name
    self.name = "Nut"
    -- Name displayed when used in battle (optional)
    self.use_name = nil

    -- Item type (item, key, weapon, armor)
    self.type = "item"
    -- Item icon (for equipment)
    self.icon = nil

    -- Battle description
    self.effect = "Heals\n60HP"
    -- Shop description
    self.shop = "One big\nnut that\nheals 60HP"
    -- Menu description
    self.description = "Heals 60 HP. A big nut that used to be half of a peanut."

    -- Amount healed (HealItem variable)
    self.heal_amount = 60

    -- Default shop price (sell price is halved)
    self.price = 60
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
        susie = "Yeahh!! It's huge!",
        ralsei = {
            ralsei = "Yum!!!",
            susie = "Hey, feed ME!!!"
        },
        noelle = "(This could grow a giant tree...)",
        jamm = "Huh. Just like the baseball games..."
    }
end

return item
