local encounter, super = Class(LightEncounter)

function encounter:init()
    super.init(self)

    self.text = "* You tripped into a line of Moldsmals."

    self:addEnemy("moldsmal", SCREEN_WIDTH/2 - 255 + (Game.battle.tension and 40 or 0), 234)
    self:addEnemy("moldsmal", SCREEN_WIDTH/2 - 53 + (Game.battle.tension and 40 or 0), 234)
    self:addEnemy("moldsmal", SCREEN_WIDTH/2 + 151 + (Game.battle.tension and 37 or 0), 234)
end

return encounter