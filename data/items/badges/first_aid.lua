local badge, super = Class(Badge, "first_aid")

function badge:init()
    super.init(self)

    -- Display name
    self.name = "First Aid"

    self.type = "badge"

    -- Menu description
    self.description = "Allow Suzy to perform First Aid in battle, healing 25 HP for 0 TP!"

    -- The cost of putting it on
    self.badge_points = 1

    -- Default shop price (sell price is halved)
    self.price = 180
end

function badge:update(equipped)
    if equipped and Game:hasPartyMember("suzy") and not Game:getPartyMember("suzy"):hasSpell("first_aid") then
        Game:getPartyMember("suzy"):addSpell("first_aid")
    end
    if not equipped and Game:hasPartyMember("suzy") and Game:getPartyMember("suzy"):hasSpell("first_aid") then
        Game:getPartyMember("suzy"):removeSpell("first_aid")
    end
end

return badge