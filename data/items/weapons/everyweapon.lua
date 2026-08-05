local item, super = Class(Item, "everyweapon")

function item:init()
    super.init(self)

    -- Display name
    self.name = "Evrywpn"

    -- Item type (item, key, weapon, armor)
    self.type = "weapon"
    -- Item icon (for equipment)
    self.icon = "ui/menu/icon/question"

    -- Battle description
    self.effect = ""
    -- Shop description
    self.shop = ""
    -- Menu description
    self.description = "A strange weapon. It's shifting shape makes\nit easier to land critical."

    -- Default shop price (sell price is halved)
    self.price = 0
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
        attack = 8,
        defense = 5
    }
    -- Bonus name and icon (displayed in equip menu)
    self.bonus_name = "Critical"
    self.bonus_icon = "ui/menu/icon/up"

    -- Equippable characters (default true for armors, false for weapons)
    self.can_equip = {
        kris = true,
        hero = true,
        susie = true,
        ralsei = true,
        jamm = true,
        calypso = true,
        ceroba = true,
        berdly = true,
        pink = true,
        apm = true,
        zenore = true,
        brenda = true,
        dess = true,
        bor = true,
        ddelta = true,
        jerdly = true,
        len = true, -- it's already here?? weird
        mario = true,
        nell = true,
        noel = true,
        osw = true,
        pauling = true,
    }

    -- Character reactions
    self.reactions = {
        susie = "This is a weird-shaped ax.",
        ralsei = "Uh, I guess I can wear it...?",
        noelle = "That's a ring???",
        jamm = "...I guess it works as a sling.",
        calypso = {
            calypso = "Equip dialogue.",
            len = "You can't just say equip dialogue!",
        },
        ceroba = "...It fits.",
        berdly = "This is one floppy halberd.",
        dess = "Time for me to J.D. batter",
        mario = "Hammer time",
        len = "Feeling great.",
    }
end

function item:convertToLightEquip(chara)
    return "light/clay"
end

function item:getAttackCritBoxSize(battler)
    return 1.5
end

return item
