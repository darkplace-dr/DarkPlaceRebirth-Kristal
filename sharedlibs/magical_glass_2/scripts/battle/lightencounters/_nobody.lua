local encounter, super = Class(LightEncounter, "_nobody")

function encounter:init()
    super.init(self)
    self.music = "toomuch"
end

function encounter:onBattleStart()
    Game.battle:startCutscene(function(cutscene)
        cutscene:text("[font:main_mono, 15]* But nobody came.")
        if Game.battle.encounter_group then
            Game.battle.encounter_group:setFlag("exhausted", true)
        end
    end):after(function()
        Game.battle:setState("TRANSITIONOUT")
    end)
    Game.battle.soul.visible = true
    return true
end

return encounter