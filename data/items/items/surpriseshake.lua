local item, super = Class(HealItem, "surpriseshake")

function item:init()
    super.init(self)

    self.name = "SurpriseShake"
    self.use_name = nil

    self.type = "item"
    self.icon = nil

    self.effect = "Healing\nvaries"
    self.shop = "Hundreds\nof unique\nflavors!\n+100 or 50HP"
    self.description = "A Milkshake with a surprise flavor.\nMay or may not be the person's favorite."

    self.heal_amount = 100
    self.heal_amount_bad = 50

    self.price = 200
    self.can_sell = true

    self.target = "ally"
    self.usable_in = "all"
    self.result_item = nil
    self.instant = false

    self.bonuses = {}
    self.bonus_name = nil
    self.bonus_icon = nil

    self.can_equip = {}

    -- when the character gets their favorite flavor or just the one they like
    self.reactions = {
        susie = "Hey, it's mossy!",
        ralsei = "It's strawberry!",
        noelle = "Hey, it's like eggnog!",
		dess = "hoooolyyyyy shiiiiiieeeeeet",
        jamm = "Hey, chicken terriyaki!",
        calypso = "Aye, the taste o' rum!",
        noel = "I got a good one.",
        ceroba = "Something... floral?",
    }

    -- when the character gets the flavor they dislike or just some random flavor
    self.reactions_bad = {
        susie = "GAH! VEGGIES!",
        ralsei = "It's all salty...",
        noelle = "Hey, why is it warm!?",
		dess = "ew it's sweet",
        jamm = "Ugh, kale...",
        calypso = "Argh, seaweed...",
        noel = "HOW MANY STUFF IS IN HERE!?",
        ceroba = "Ugh... It's lemon...",
    }

    self:setFlag("next_heal", TableUtils.pick({"good", "bad"}))
end

function item:getReactions()
    if self:getFlag("next_heal") == "good" then
        return self.reactions
    elseif self:getFlag("next_heal") == "bad" then
        return self.reactions_bad
    end
end

function item:getHealAmount(id)
    if self:getFlag("next_heal") == "good" then
        return self.heal_amount
    elseif self:getFlag("next_heal") == "bad" then
        return self.heal_amount_bad
    end
end

function item:onWorldUse(target)
    self:setFlag("next_heal", TableUtils.pick({"good", "bad"}))

    return super.onWorldUse(self, target)
end

function item:onBattleUse(user, target)
    self:setFlag("next_heal", TableUtils.pick({"good", "bad"}))

    super.onBattleUse(self, user, target)
end

return item
