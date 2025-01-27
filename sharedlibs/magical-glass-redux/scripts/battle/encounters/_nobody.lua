local encounter, super = Class(Encounter)

function encounter:init()
    super:init(self)

    -- Text displayed at the bottom of the screen at the start of the encounter
    self.text = "[font:main_mono,15]* But nobody came."

    -- Is a "But Nobody Came"/"Genocide" Encounter
    self.nobody_came = true

    self.music = nil
end

function encounter:onStateChange(old, new)
    if old == "INTRO" and new == "ACTIONSELECT" then
        Game.world.music:stop()
        Game.world.music:resume()
        Game.world.music:play("toomuch", 1)
        Game.battle:setState("VICTORY")
    end
end

function encounter:getVictoryText()
    return self.text
end

function encounter:getVictoryMoney(money)
    return 0
end

function encounter:getVictoryXP(xp)
    return 0
end

return encounter