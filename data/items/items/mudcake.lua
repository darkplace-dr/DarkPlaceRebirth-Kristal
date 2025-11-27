local item, super = Class(HealItem, "mudcake")

function item:init()
    super.init(self)

    -- Display name
    self.name = "MudCake"
    -- Name displayed when used in battle (optional)
    self.use_name = nil

    -- Item type (item, key, weapon, armor)
    self.type = "item"
    -- Item icon (for equipment)
    self.icon = nil

    -- Battle description
    self.effect = "Heals\n130HP to all"
    -- Shop description
    self.shop = "It's a mud cake\nmade of all-natural mud\n+130HP to all"
    -- Menu description
    self.description = "This cake is made of mud.\nIt's made of actual mud."

    -- Amount healed (HealItem variable)
    self.heal_amount = 130

    -- Default shop price (sell price is halved)
    self.price = 400
    -- Whether the item can be sold
    self.can_sell = true

    -- Consumable target mode (ally, party, enemy, enemies, or none)
    self.target = "party"
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
        susie = "Hell yeah! Mud!",
        ralsei = "Can I make one too?",
        noelle = "C- can I not? Please?",
        --floyde = "Woah, this tastes horrid!", --This is a character in my mod which I have not added yet; uncomment when added -- Not gonna uncomment, but it doesn't break anything uncommented
        ceroba = "I guess if I have to eat it.", --Placeholder dialogue, replace if you want
        jamm = "I mean, it's good for your skin, so...",
        brenda = "Placeholder mud dialogue!",--Placeholder dialogue, please replace, Brenda
        berdly = "These are yummy worms.", --Placeholder dialogue, replace if you want
        dess = "Mmm yummy dirt",  --Placeholder dialogue, replace if you want
        noel = "Mud!", --Placeholder dialogue, please replace
        osw = "I am the original         Mudcake.", --Placeholder dialogue, replace if you want
        --I forgot if pauling ever says anything, so this is placeholder dialogue. -- She does not. Let's keep it this way.
        nell = "Placeholder mud dialogue?", --Placeholder dialogue, please replace, Nell
        mario = "It's time for-a me to eat-a this M U D C A K E",
        --Placeholder dialogue, replace if you want -- APM literally can't speak, apart from a few pre-programmed lines.
        hero = "I'm placeholder dialogue.", --Placeholder dialogue, replace if you want
        len = "I'm also placeholder dialogue" --Placehodler dialogue, pleace replace.
    }
end

return item
