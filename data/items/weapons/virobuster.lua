local item, super = Class(Item, "virobuster")

function item:init()
    super.init(self)

    -- Display name
    self.name = "ViroBuster"

    -- Item type (item, key, weapon, armor)
    self.type = "weapon"
    -- Item icon (for equipment)
    self.icon = "ui/menu/icon/axe"

    -- Battle description
    self.effect = ""
    -- Shop description
    self.shop = ""
    -- Menu description
    self.description = "An axe designed specifically to kill corrupted programs. Buster spells deal 2x damage to foes."

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
        attack = 5,
        magic  = 4,
    }
    -- Bonus name and icon (displayed in equip menu)
    self.bonus_name = "Final Blow"
    self.bonus_icon = "ui/menu/icon/demon"

    -- Equippable characters (default true for armors, false for weapons)
    self.can_equip = {
        susie = true,
        len = true,
    }

    -- Character reactions
    self.reactions = {
        susie = "Time for some imminent axecution!",
        ralsei = "It feels... dangerous?",
        noelle = "U-um, th-this is for Susie.",
        dess = "woah it hates me, cool!",
        brenda = "Yeah uh, keep that away from me please.",
		jamm = "Hey, can I use this for Deoxynn? No? Damn...",
        calypso = "I don't have any buster moves.",
        ceroba = "Not really useful to me.",
        noel = "(Not yet.)",
        len = "I can *uf* weight it's power...",
    }

    self.len_axe_progress_flag = "len_axe_handling"
end

function item:getReaction(user_id, reactor_id, miniparty)
    if reactor_id == "len" then
        local len_axe_progress = Game:getFlag(self.len_axe_progress_flag, 0)
        if len_axe_progress > 30 then
            return "Hitting that alt+f4 on enemies."
        elseif len_axe_progress > 18 then
            return "More light than before atleast."
        elseif len_axe_progress > 10 then
            return "Im getting downed again, ain't i?"
        end
    end
    super.getReaction(self, user_id, reactor_id, miniparty)
end

function item:onAttackHit(battler, enemy, damage)
    if battler.chara.id == "len" then
        local len_axe_progress = Game:getFlag(self.len_axe_progress_flag, 0)
        local backslash = 200 / (1 + len_axe_progress / 20)
        if backslash > 0 then
            battler:hurt(backslash, true)
        end
        Game:addFlag(len_axe_progress, 1)
    end
end

return item
