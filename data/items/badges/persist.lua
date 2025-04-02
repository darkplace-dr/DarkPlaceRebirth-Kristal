local badge, super = Class(Badge, "persist")

function badge:init()
    super.init(self)

    -- Display name
    self.name = "Persist"

    self.type = "badge"

    -- Menu description
    self.description = "Allow Hero to persist in battle, healing 50 HP to self for 20 TP!"

    -- The cost of putting it on
    self.badge_points = 1

    -- Default shop price (sell price is halved)
    self.price = 180
end

function badge:update(equipped)
    if equipped and Game:hasPartyMember("hero") and not Game:getPartyMember("hero"):hasSpell("persist") then
        Game:getPartyMember("hero"):addSpell("persist")
    end
    if not equipped and Game:hasPartyMember("hero") and Game:getPartyMember("hero"):hasSpell("persist") then
        Game:getPartyMember("hero"):removeSpell("persist")
    end
end

return badge