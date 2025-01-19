local Dess, super = Class(Encounter)

function Dess:init()
    super.init(self)

    self.text = "* Dess stands in your way."

    self.music = "dessimation"
    self.background = false

    self.dess = self:addEnemy("dess")
end

function Dess:onReturnToWorld(events)
end

function Dess:onActionsEnd()
    if (self.dess.done_state == "VIOLENCE" or self.dess.done_state == "KILLED")
        and not self.death_cine_played then
        self.death_cine_played = true
        local cutscene = Game.battle:startCutscene("dess.dies", nil, self.dess)
        cutscene:after(function ()
            Game.battle:setState("ENEMYDIALOGUE")
        end)
        return true
    end
end

return Dess