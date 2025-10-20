local encounter, super = Class(LightEncounter)

function encounter:init()
    super.init(self)

    -- Text displayed at the bottom of the screen at the start of the encounter
    self.text = "[font:main_mono,15]* But nobody came."

    self.music = nil
end

function encounter:onBattleStart()
    Game.battle:setState("BUTNOBODYCAME")
    Game.world.music:stop()
    Game.world.music:resume()
    Game.world.music:play("toomuch", 1)
end

return encounter