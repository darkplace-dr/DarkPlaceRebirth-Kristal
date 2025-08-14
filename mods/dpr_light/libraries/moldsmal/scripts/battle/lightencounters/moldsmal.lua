local encounter, super = Class(LightEncounter)

function encounter:init()
    super.init(self)

    self.text = "* Moldsmal blocked the way!"

    self:addEnemy("moldsmal", SCREEN_WIDTH/2 - 54 + (Game.battle.tension and 40 or 0), 234)
end

return encounter