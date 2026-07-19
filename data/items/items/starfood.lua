local item, super = Class(HealItem, "starfood")

function item:init()
    super.init(self)

    self.name = "StarSnack"
    self.use_name = nil

    self.type = "item"
    self.icon = nil

    self.effect = "Healing\nchunks"
    self.shop = "Different\ncorner taste\n+250, 200,\n150, or 50 HP"
    self.description = "A snack in the shape of a star.\nEach piece is better than the next."

    self.heal_amounts = {250, 200, 150, 50}

    self.price = 250
    self.can_sell = true

    self.target = "party"
    self.usable_in = "all"
    self.result_item = nil
    self.instant = false

    self.bonuses = {}
    self.bonus_name = nil
    self.bonus_icon = nil

    self.can_equip = {}

    -- Really good
    self.reactions_1 = {
        susie = "",
        ralsei = "",
        noelle = "",
		dess = "",
        jamm = "Woah, feels like I'm in space!",
        calypso = "Reminds me o' the night sky...",
        noel = "",
        ceroba = "",
    }

    -- Good
    self.reactions_2 = {
        susie = "",
        ralsei = "",
        noelle = "",
		dess = "",
        jamm = "Tastes... cottony.",
        calypso = "Aye, a stellar taste.",
        noel = "",
        ceroba = "",
    }

    -- Alright
    self.reactions_3 = {
        susie = "",
        ralsei = "",
        noelle = "",
		dess = "",
        jamm = "...I mean, it's alright, I guess.",
        calypso = "Reminds me o' the endless nights...",
        noel = "",
        ceroba = "",
    }

    -- Bad
    self.reactions_4 = {
        susie = "",
        ralsei = "",
        noelle = "",
		dess = "",
        jamm = "...Why do I get the bad corner!?",
        calypso = "Argh, there always be a bad one...",
        noel = "",
        ceroba = "",
    }
end


function item:getReaction(user_id, reactor_id, miniparty)
    local location
    for i=1, #Game.party do
        if Game.party[i].id == reactor_id then
            location = i
            break
        end
    end
    
    return self["reactions_" .. location][reactor_id] or ""
end

function item:getHealAmount(id)
    for i=1, #Game.party do
        if Game.party[i].id == id then
            return self.heal_amounts[i]
        end
    end
    
    return 25   -- an amount that shouldn't happen so we know if something's wrong
end

return item
