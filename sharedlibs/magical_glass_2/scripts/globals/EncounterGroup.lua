local EncounterGroup = Class(nil, "EncounterGroup")

function EncounterGroup:init()
    self.initial_steps = 2
    self.initial_population = 2

    self.encounters = {}
    self.empty_encounter = "_nobody"

    self.group_id = self.id
end

function EncounterGroup:getInitialSteps()
    return self.initial_steps
end

function EncounterGroup:getEncounters()
    -- this is where you'd change encounters on a per room basis
    return self.encounters
end

function EncounterGroup:getNextEncounter()
    if #self:getEncounters() > 0 then
        if self:getFlag("population", self.initial_population) > 0 then
            return Utils.pick(self.encounters)
        else
            return self.empty_encounter
        end
    end
end

function EncounterGroup:onFootstep()
    self:setFlag("steps", self:getFlag("steps", self:getInitialSteps()) - 1, self:getInitialSteps())
end

function EncounterGroup:canStartEncounter()
    return not Game.world.encountering_enemy and 
               self:getFlag("steps", self:getInitialSteps()) <= 0
end

function EncounterGroup:onEnemyKilled(enemy)
    self:setFlag("population", self:getFlag("population", self.initial_population) - 1, self.initial_population)
end

function EncounterGroup:startEncounter()
    local encounter = self:getNextEncounter()
    if encounter then
        Game.lock_movement = true
        Game.world.encountering_enemy = true
        Game.world.player:alert((15 + Utils.random(5)) / 30, {callback = function()
            Game.lock_movement = false
            Game.world.encountering_enemy = false
            Game:encounter(encounter)
            Game.battle.encounter_group = self
            self:reset()
        end})
    end
end

function EncounterGroup:reset()
    self:setFlag("steps", self:getInitialSteps())
end

function EncounterGroup:setFlag(flag, value)
    Game:setFlag("encounter_group#"..self.group_id..":"..flag, value)
end

function EncounterGroup:getFlag(flag, default)
    return Game:getFlag("encounter_group#"..self.group_id..":"..flag, default)
end

function EncounterGroup:addFlag(flag, amount)
    return Game:addFlag("encounter_group#"..self.group_id..":"..flag, amount)
end

function EncounterGroup:canDeepCopy()
    return false
end

return EncounterGroup