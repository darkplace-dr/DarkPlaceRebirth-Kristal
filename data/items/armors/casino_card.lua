local item, super = Class(Item, "casino_card")

function item:init()
    super.init(self)

    -- Display name
    self.name = "Casino Card"

    -- Item type (item, key, weapon, armor)
    self.type = "armor"
    -- Item icon (for equipment)
    self.icon = "ui/menu/icon/armor"

    -- Battle description
    self.effect = ""
    -- Shop description
    self.shop = "Gamble\nafter battle"
    -- Menu description
    self.description = "A unique card recieved in Gamblopolis.\nTurns every battle into a gamble."

    -- Default shop price (sell price is halved)
    self.price = 100
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
        defense = 1,
    }
    -- Bonus name and icon (displayed in equip menu)
    self.bonus_name = "$ +/-???%"
    self.bonus_icon = "ui/menu/icon/dice"

    -- Equippable characters (default true for armors, false for weapons)
    self.can_equip = {
        ceroba = false
    }

    -- Character reactions
    self.reactions = {
        dess = "aw dang it",
        jamm = "No stranger to this.",
        ["jamm+marcy"] = "Gamble in moderation, Marcy.",
        ceroba = "You want me to wear... A card?"
    }
end

function item:applyMoneyBonus(gold)
    -- return -30
    ---@type {snd:string, n:number}[]
    local options = {
        {n = -gold/2, snd = "error"},
        {n = 1, snd = "awkward"},
        {n = gold/8, snd = "boowomp"},
        {n = gold, snd = "bump"},
        {n = gold*1.2, snd = "boost"},
        {n = gold*3, snd = "great_shine"},
    }
    local choice = Utils.pick(options)
    Assets.playSound(choice.snd)
    return choice.n
end

return item