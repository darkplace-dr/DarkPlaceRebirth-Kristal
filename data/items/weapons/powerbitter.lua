local item, super = Class(Item, "powerbitter")

function item:init()
    super.init(self)

    -- Display name
    self.name = "PowerBitter"

    -- Item type (item, key, weapon, armor)
    self.type = "weapon"
    -- Item icon (for equipment)
    self.icon = "ui/menu/icon/axe"

    -- Battle description
    self.effect = ""
    -- Shop description
    self.shop = ""
    -- Menu description
    self.description = "A plastic scythe with flickering green and yellow colors. Heals you each time you FIGHT!"

    -- Default shop price (sell price is halved)
    self.price = 1000
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
        attack = -1,
        magic = 5,
    }
    -- Bonus name and icon (displayed in equip menu)
    self.bonus_name = "AttackHeal"
    self.bonus_icon = "ui/menu/icon/up"

    -- Equippable characters (default true for armors, false for weapons)
    self.can_equip = {
        susie = true,
        suzy = true,
        hero = true,
    }

    -- Character reactions
    self.reactions = {
        susie = "There goes my lightsaber! *nom*",
        suzy = "Chomp, Chomp!",
        ceroba = "I'm... Not a farmer.",
        dess = "i hate stardew valley",
        noel = "Insufficent.",
        hero = "This thing is BUSTED!",
        jamm = "I don't have a green thumb.",
    }
end

function item:onAttackHit(battler, enemy, damage)
    local heal_amount = math.ceil(battler.chara:getStat("health") * 0.15)

    battler:heal(heal_amount)
end

return item
