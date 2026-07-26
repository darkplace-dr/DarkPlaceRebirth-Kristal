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
        susie = "BEST SNACK EVER!!",
        ralsei = "I'm... At a loss of words.", -- imagine little stars in his eyes
        noelle = "Holy cheese and crackers...",
		dess = "i'm eating this one",
        jamm = "Woah, feels like I'm in space!",
        calypso = "Reminds me o' the night sky...",
        noel = "THAT'S SUPPOSED TO BE IMPOSSIBLE!?!?", -- curse of being forbidden to lead the party
        ceroba = "Woah, it's... Amazing!",
    }

    -- Good
    self.reactions_2 = {
        susie = "Second best, not bad!",
        ralsei = "It's, um, really good!",
        noelle = "Hey, it's the good one, right?",
		dess = "hey that's not the best one",
        jamm = "Tastes... cottony.",
        calypso = "Aye, a stellar taste.",
        noel = "Man am I glad I'm the second.",
        ceroba = "Better than I expected.",
    }

    -- Alright
    self.reactions_3 = {
        susie = "I hoped for better.",
        ralsei = "It's okay!",
        noelle = "At least it's... Not too bad?",
		dess = "man that's REALLY not the best one",
        jamm = "...I mean, it's alright, I guess.",
        calypso = "Reminds me o' the endless nights...",
        noel = "At least I'm not in the back-back.",
        ceroba = "A bit... sour...?",
    }

    -- Bad
    self.reactions_4 = {
        susie = "Ugh, why did I get that one!?",
        ralsei = "Oh, I... got unlucky, haha.",
        noelle = "Huh? Is that a prank?",
		dess = "man u suck",
        jamm = "...Why do I get the bad corner!?",
        calypso = "Argh, there always be a bad one...",
        noel = "Of course the back ones get the worst.",
        ceroba = "Agh, it's all crunchy...",
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
