local item, super = Class(Item, "faded_ribbon")

function item:init()
    super.init(self)

    -- Display name
    self.name = "Faded Ribbon"

    -- Item type (item, key, weapon, armor)
    self.type = "armor"
    -- Item icon (for equipment)
    self.icon = "ui/menu/icon/armor"

    -- Battle description
    self.effect = ""
    -- Shop description
    self.shop = ""
    -- Menu description
    self.description = "A faded hair ribbon that slightly\nincreases your defense."

    -- Default shop price (sell price is halved)
    self.price = 100
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
        defense = 2
    }
    -- Bonus name and icon (displayed in equip menu)
    self.bonus_name = "Cuteness"
    self.bonus_icon = "ui/menu/icon/up"

    -- Equippable characters (default true for armors, false for weapons)
    self.can_equip = {
        dess = false,
        calypso = false,
    }

    -- Character reactions
    if Game.chapter == 2 then
        self.reactions = {
            susie = "...How do I wear this?",
            ralsei = "It's... wearable?",
            noelle = "... feels familiar.",
        }
        self.susie_rejection = "I said NO! C'mon already!"
    else
        self.reactions = {
            susie = "...How do I wear this?",
            ralsei = "It's... wearable?",
            noelle = "... feels familiar.",
        }
        self.susie_rejection = "Nope. Wouldn't even stay anyways."
    end
    TableUtils.merge(self.reactions, {
        hero = "...It's falling apart.",
        dess = "ew how would i wear this",
        jamm = "How ...adorable?",
        ["jamm+marcy"] = "It... doesn't fit on you, Marcy.",
        calypso = "It's fallin apart.",
        noel = "I'm so FANCY",
        ceroba = "Makes me feel nostalgic.",
        len = "(Why is it beige.)",
    })
end

function item:canEquip(character, slot_type, slot_index)
    if character.id == "susie" and not character:getFlag("can_wear_ribbons", false) then
        return false
    end

    return super.canEquip(self, character, slot_type, slot_index)
end

function item:getReaction(user_id, reactor_id)
    if user_id == "susie" and reactor_id == "susie" then
        local susie = Game:getPartyMember("susie")

        if not susie:getFlag("can_wear_ribbons", false) then
            return self.susie_rejection
        end
    end

    return super.getReaction(self, user_id, reactor_id)
end

return item
