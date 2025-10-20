local badge, super = Class(Badge, "tension_health")

function badge:init()
    super.init(self)

    -- Display name
    self.name = "TP-Health"

    self.type = "badge"

    -- Menu description
    self.description = "Converts tension into HP."
    self.shop = "Turns tension\ninto HP."
    -- The cost of putting it on
    self.badge_points = 4

    -- Default shop price (sell price is halved)
    self.price = 830
end

function badge:update(equipped)
    if equipped and Game.battle and Game.tension >= 1 then
        local state = Game.battle.state
        if state == "DEFENDING" or state == "DEFENDINGBEGIN" or state == "ENEMYDIALOGUE" or state == "DEFENDINGEND" then
            Game.tension = Game.tension -1
            local number = math.random(1, #Game.battle.party)
            Game.battle.party[number].chara.health = math.min(Game.battle.party[number].chara.health + 1, Game.battle.party[number].chara.stats.health)
        end
    end
end

return badge