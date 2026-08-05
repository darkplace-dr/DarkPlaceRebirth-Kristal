local item, super = Class(Item, "autoaxe")

function item:init()
    super.init(self)

    -- Display name
    self.name = "AutoAxe"

    -- Item type (item, key, weapon, armor)
    self.type = "weapon"
    -- Item icon (for equipment)
    self.icon = "ui/menu/icon/axe"

    -- Battle description
    self.effect = ""
    -- Shop description
    self.shop = "Make sure\nto charge it"
    -- Menu description
    self.description = "Make sure to charge it by\nplugging it into the wall."

    -- Default shop price (sell price is halved)
    self.price = 250
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
        attack = 4,
    }
    -- Bonus name and icon (displayed in equip menu)
    self.bonus_name = "BadIdea"
    self.bonus_icon = "ui/menu/icon/demon"

    -- Equippable characters (default true for armors, false for weapons)
    self.can_equip = {
        susie = true,
        len = true,
    }

    -- Character reactions
    self.reactions = {
        susie = "*chainsaw noises* Hahaha!!",
        ralsei = "(Is this a good idea?)",
        noelle = "*zrrt* A-AHH! Scared myself...",
		dess = "this is a great idea",
        jamm = "Woah! Shakes a lot...",
        calypso = "Ye expect me to focus with that?",
        ceroba = "That is a BAD idea.",
        noel = "Energy Hog",
        len = "I can *uf* feel it's power...",
    }

    self.len_axe_progress_flag = "len_axe_handling"
end

function item:getReaction(user_id, reactor_id, miniparty)
    if reactor_id == "len" then
        local len_axe_progress = Game:getFlag(self.len_axe_progress_flag, 0)
        if len_axe_progress > 12 then
            return "Shocky, but effective."
        elseif len_axe_progress > 7 then
            return "I think i can handle it's power."
        elseif len_axe_progress > 3 then
            return "Its power it's less demanding..."
        end
    end
    super.getReaction(self, user_id, reactor_id, miniparty)
end

function item:onAttackHit(battler, enemy, damage)
    if battler.chara.id == "len" then
        local len_axe_progress = Game:getFlag(self.len_axe_progress_flag, 0)
        local backslash = 30 / (1 + len_axe_progress / 20)
        if backslash > 0 then
            battler:hurt(backslash, true)
        end
        Game:addFlag(len_axe_progress, 1)
    end
end

return item
