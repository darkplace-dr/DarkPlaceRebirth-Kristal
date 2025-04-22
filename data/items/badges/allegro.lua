local badge, super = Class(Badge, "allegro")

function badge:init()
    super.init(self)

    -- Display name
    self.name = "Allegro"

    self.type = "badge"

    -- Menu description
    self.description = "Allow Hero to use Allegro in battle, dealing 20% HP for 100 TP."

    -- The cost of putting it on
    self.badge_points = 1

    -- Default shop price (sell price is halved)
    self.price = 180
end

function badge:update(equipped)
    if equipped and Game:hasPartyMember("hero") and not Game:getPartyMember("hero"):hasSpell("allegro") then
        Game:getPartyMember("hero"):addSpell("allegro")
    end
    if not equipped and Game:hasPartyMember("hero") and Game:getPartyMember("hero"):hasSpell("allegro") then
        Game:getPartyMember("hero"):removeSpell("allegro")
    end
end

return badge