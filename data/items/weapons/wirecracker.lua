local item, super = Class(Item, "wirecracker")

function item:init()
    super.init(self)

    -- Display name
    self.name = "WireCracker"

    -- Item type (item, key, weapon, armor)
    self.type = "weapon"
    -- Item icon (for equipment)
    self.icon = "ui/menu/icon/fire"

    -- Battle description
    self.effect = ""
    -- Shop description
    self.shop = ""
    -- Menu description
    self.description = "A giant, plug-shapped glove with green-ish fire.\nGood for people who know how to use it."

    -- Default shop price (sell price is halved)
    self.price = 1225
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
        attack = 7,
        magic = 6,
    }
    -- Bonus name and icon (displayed in equip menu)
    self.bonus_name = "CheatHeal"
    self.bonus_icon = "ui/menu/icon/magic"

    -- Equippable characters (default true for armors, false for weapons)
    self.can_equip = {
        hero = true,
        noelle = true,
        kris = true,
    }

    -- Character reactions
    self.reactions = {
        hero = "That's... electrifying.",
        susie = "Is that an arm? Gross.",
        ralsei = "... Is cheating allowed?",
        noelle = "(It... fits?)",
        dess = "can i eat it",
        ceroba = "Don't even try it."
    }
end

function item:onAttackHit(battler, enemy, damage)
    local heal_amount = math.ceil(battler.chara:getStat("health") * 0.25)

    battler:heal(heal_amount)
end

return item
