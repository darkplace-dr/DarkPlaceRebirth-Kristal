local item, super = Class(Item, "hypocrite_whip")

function item:init()
    super.init(self)

    -- Display name
    self.name = "Hypocrite Whip"

    -- Item type (item, key, weapon, armor)
    self.type = "weapon"
    -- Item icon (for equipment)
    self.icon = "ui/menu/icon/scarf"

    -- Battle description
    self.effect = ""
    -- Shop description
    self.shop = ""
    -- Menu description
    self.description = "Allows you to appear stronger than you actually are by having a cool eel whip."

    -- Default shop price (sell price is halved)
    self.price = 60
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
        attack = 3,
    }
    -- Bonus name and icon (displayed in equip menu)
    self.bonus_name = "HP 25%"
    self.bonus_icon = "ui/menu/icon/down"

    -- Equippable characters (default true for armors, false for weapons)
    self.can_equip = {
        hero = true,
        mario = true,
        kris = true,
        ralsei = true,
        berdly = true,
    }

    -- Character reactions
    self.reactions = {
        hero = "I feel just like John Wick!",
        kris = "...",
        ralsei = "I don't feel just like John Wick!",
        berdly = "Ha, I feel just like John Wick!",
        mario = "Mama Mia! I feel just like John Wick!",
        ceroba = "(Who is John Wick???)",
        dess = "I am John John Wick.",
        noel = "That would be suicide",
        susie = "Who the hell is John Wick?",
    }
end

function item:onBattleUpdate(battler)
    battler.thorn_ring_timer = (battler.thorn_ring_timer or 0) + DTMULT

    if battler.thorn_ring_timer >= 6 then
        battler.thorn_ring_timer = battler.thorn_ring_timer - 6

        if battler.chara:getHealth() > Utils.round(battler.chara:getStat("health") / 4) then
            battler.chara:setHealth(battler.chara:getHealth() - 1)
        end
    end
end

return item