local encounter, super = Class(LightEncounter)

function encounter:init()
    super.init(self)

    self.text = "* Moldsmal and Moldsmal block\nthe way."

    self:addEnemy("moldsmal", SCREEN_WIDTH/2 - 154 + (Game.battle.tension and 40 or 0), 234)
    self:addEnemy("moldsmal", SCREEN_WIDTH/2 + 50 + (Game.battle.tension and 40 or 0), 234)
end

return encounter