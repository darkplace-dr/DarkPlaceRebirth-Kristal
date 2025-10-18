local LaninoElnina, super = Class(Encounter)

function LaninoElnina:init()
    super.init(self)

    self.text = "* This time, the weather sticks together!"

    self.music = "deltarune/rudebuster_boss"
    self.background = true

    self:addEnemy("lanino", 520, 180)
    self:addEnemy("elnina", 560, 308)

    self.weather = {"rain", "snow", "sun", "moon"}
    self.current_weather = TableUtils.pick(self.weather)
end

function LaninoElnina:getEncounterText()
    if Game.battle.enemies[1] then
        if Game.battle.enemies[1].mercy >= 90 then
            return "* Lanino and Elnina are hyping each other up! Just survive!"
        else
            if self.current_weather == "rain" then
                return "* The forecast whispers nothings like sweet droplets."
            elseif self.current_weather == "snow" then
                return "* The forecast sparkles with cold beauty."
            elseif self.current_weather == "sun" then
                return "* The forecast burns with hot passion."
            elseif self.current_weather == "moon" then
                return "* The forecast shines with a soft romantic glow."
            end
        end
    else
        return self:getInitialEncounterText()
    end
end

return LaninoElnina