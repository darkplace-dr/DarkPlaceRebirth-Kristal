local item, super = Class(Item, "saber10")

function item:init()
    super.init(self)

    -- Display name
    self.name = "Saber10"

    -- Item type (item, key, weapon, armor)
    self.type = "weapon"
    -- Item icon (for equipment)
    self.icon = "ui/menu/icon/sword"

    -- Battle description
    self.effect = ""
    -- Shop description
    self.shop = "Tsun-type\narmaments"
    -- Menu description
    self.description = "A saber made of 10 cactus needles.\nFortunately, can deal more than 10 damage."

    -- Default shop price (sell price is halved)
    self.price = Game.chapter <= 3 and 610 or 710
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
        attack = 6,
    }
    -- Bonus name and icon (displayed in equip menu)
    self.bonus_name = nil
    self.bonus_icon = nil

    -- Equippable characters (default true for armors, false for weapons)
    self.can_equip = {
        kris = true,
        hero = true,
        len = true,
    }

    -- Character reactions
    self.reactions = {
        hero = "Now THAT is cool.",
        susie = "Nah, I'd snap it.",
        ralsei = "You want to... pierce my ears...?",
        noelle = "(I'm not against using it, but...)",
        dess = "this is too op for me",
        jamm = "Ow! Prickly...",
        calypso = "...why 10?",
        ceroba = "I'm not risking getting prickled.",
    }
    self.len_reactions = {
        "Ow... (It's... that...)", -- blood?!
        "WDYM THAT'S NOT HOW YOU USE IT?!?",
        "...",
    }
    self.len_owchie_flag = "len_saber10_progress"
end

function item:convertToLightEquip(chara)
    return "light/cactusneedle"
end

function item:getReaction(user_id, reactor_id, miniparty)
    if reactor_id == "len" then
        local len_owchie_progress = Game:getFlag(self.len_owchie_flag, 0)
        local reaction = self.len_reactions[len_owchie_progress] or self.len_reactions[#self.len_reactions]
        return reaction
    end
    return super.getReaction(self, user_id, reactor_id, miniparty)
end

function item:onEquip(character, replacement)
    if character.id == "len" then
        local len_owchie_progress = Game:getFlag(self.len_owchie_flag, 0)

        if len_owchie_progress == 0 then
            character:setHealth(character:getHealth() - 1)
        end

        Game:addFlag(self.len_owchie_flag, 1)
    end
    super.onEquip(self, character, replacement)
end

return item
