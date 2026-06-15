local badge, super = Class(Badge, "jackpot_jab")

function badge:init()
    super.init(self)

    -- Display name
    self.name = "Jackpot Jab"

    self.type = "badge"

    -- Menu description
    self.description = "Allow Hero to use Jackpot Jab in battle, dealing scaling damage for 16% of TP."

    -- The cost of putting it on
    self.badge_points = 1

    -- Default shop price (sell price is halved)
    self.price = 180
end

function badge:update(equipped)
    if equipped and Game:hasPartyMember("hero") and not Game:getPartyMember("hero"):hasSpell("jackpot_jab") then
        Game:getPartyMember("hero"):addSpell("jackpot_jab")
    end
    if not equipped and Game:hasPartyMember("hero") and Game:getPartyMember("hero"):hasSpell("jackpot_jab") then
        Game:getPartyMember("hero"):removeSpell("jackpot_jab")
    end
end

return badge