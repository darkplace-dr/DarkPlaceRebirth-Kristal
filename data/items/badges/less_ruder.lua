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
    local name = "susie"
    local hassus = Game:hasPartyMember(name)
    if hassus then
        local sus = Game:getPartyMember(name)
        if equipped then
            if sus:hasSpell("pacibuster") then
                sus:removeSpell("pacibuster")
            end
            if not sus:hasSpell("pacify") then
                sus:addSpell("pacify")
            end
        else
            if sus:hasSpell("pacify") then
                sus:removeSpell("pacify")
            end
            if not sus:hasSpell("pacibuster") then
                sus:addSpell("pacibuster")
            end
        end
    end
end

return badge