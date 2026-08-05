local item, super = Class(Item, "justiceaxe")

function item:init()
    super.init(self)

    -- Display name
    self.name = "JusticeAxe"

    -- Item type (item, key, weapon, armor)
    self.type = "weapon"
    -- Item icon (for equipment)
    self.icon = "ui/menu/icon/axe"

    -- Battle description
    self.effect = ""
    -- Shop description
    self.shop = ""
    -- Menu description
    self.description = "It has no special powers. However, in order to\nattain this item, you became much stronger!"

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
        attack = 12,
    }
    -- Bonus name and icon (displayed in equip menu)
    self.bonus_name = "???"
    self.bonus_icon = "ui/menu/icon/magic"

    -- Equippable characters (default true for armors, false for weapons)
    self.can_equip = {
        susie = true,
        len = true,
    }

    -- Character reactions
    self.reactions = {
        susie = "Watch this, old man!",
        ralsei = "... isn't Susie amazing?",
        noelle = "... Susie beat up an old man!?",
        jamm = {
            jamm = "So you... robbed an old guy?",
            calypso = "That be NOT what they said!"
        },
        calypso = "This be very impressive, but alas...",
        ceroba = "It's like from a history book...",
        len = "Ack! i... *uf* I can barely carry this!",
    }
    self.len_axe_progress_flag = "len_axe_handling"
end

function item:getReaction(user_id, reactor_id, miniparty)
    if reactor_id == "len" then
        local len_axe_progress = Game:getFlag(self.len_axe_progress_flag, 0)
        if len_axe_progress > 12 then
            return "Lets do this thing some justice."
        elseif len_axe_progress > 7 then
            return "Why can't justice be lighter?"
        elseif len_axe_progress > 3 then
            return "I can feel the justice on my back..."
        end
    end
    super.getReaction(self, user_id, reactor_id, miniparty)
end

function item:onAttackHit(battler, enemy, damage)
    if battler.chara.id == "len" then
        local len_axe_progress = Game:getFlag(self.len_axe_progress_flag, 0)
        local backslash = 40 / (1 + len_axe_progress / 20)
        if backslash > 0 then
            battler:hurt(backslash, true)
        end
        Game:addFlag(len_axe_progress, 1)
    end
end

return item
