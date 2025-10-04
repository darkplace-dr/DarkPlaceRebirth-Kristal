local badge, super = Class(Badge, "less_ruder")

function badge:init()
    super.init(self)

    -- Display name
    self.name = "Less Ruder"

    self.type = "badge"

    -- Menu description
    self.description = "Converts Susie's PaciBuster to a normal Pacify."

    -- The cost of putting it on
    self.badge_points = 1

    -- Default shop price (sell price is halved)
    self.price = 180
end

function badge:update(equipped)
    if equipped and Game:hasPartyMember("susie") then
        if Game:getPartyMember("susie"):hasSpell("pacibuster") then
            Game:getPartyMember("susie"):removeSpell("pacibuster")
        end
        if not Game:getPartyMember("susie"):hasSpell("pacify") then
            Game:getPartyMember("susie"):addSpell("pacify")
        end
    end
    if not equipped and Game:hasPartyMember("susie") then
        if Game:getPartyMember("susie"):hasSpell("pacify") then
            Game:getPartyMember("susie"):removeSpell("pacify")
        end
        if not Game:getPartyMember("susie"):hasSpell("pacibuster") then
            Game:getPartyMember("susie"):addSpell("pacibuster")
        end
    end
end

return badge