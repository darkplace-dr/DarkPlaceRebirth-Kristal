---@class RandomEncounter : Object
---@overload fun(...) : RandomEncounter
local RandomEncounter = Class()

function RandomEncounter:init()
    -- The amount of enemies that can be defeated violently
    self.population = nil
    
    -- The amount of steps it takes to start a random encounter initially
    self.initial_minimum_steps = 20
    -- A random amount of steps that will be added to the step counter initially
    self.initial_random_steps = 5
    -- The minimum amount of steps it takes to start a random encounter
    self.minimum_steps = 30
    -- A random amount of steps that will be added to the step counter
    self.random_steps = 15
    -- The amount of steps it takes to start an empty encounter
    self.empty_steps = 20
    
    -- Whether the steps amount will increase when not that many monsters left
    self.use_population_factor = true
    
    -- The bubble that should appear when a random encounter is triggered
    -- If this is nil, the battle starts instantly
    self.bubble = "effects/alert"
    
    -- The encounter that will happen if the entire population was defeated violently
    self.empty_encounter = "_nobody"
    
    -- Table with the encounters that can be triggered by this random encounter
    self.encounters = {}
    
    -- Whether the encounters are a light or dark encounters
    self.light = true
end

function RandomEncounter:resetSteps(default)
    if not self:populationKilled() then
        local minimum_steps = default and self.initial_minimum_steps or self.minimum_steps
        local random_steps = default and self.initial_random_steps or self.random_steps
        local pop_factor = 1
        if self.use_population_factor and self.population then
            pop_factor = math.min(self.population / (self.population - self:getFlag("violent", 0)), 8)
        end
        MagicalGlassLib.steps_until_encounter = math.ceil((minimum_steps + Utils.round(Utils.random(random_steps))) * pop_factor)
    else
        MagicalGlassLib.steps_until_encounter = self.empty_steps
    end
end

function RandomEncounter:active()
    return true
end

function RandomEncounter:getEncounters()
    return self.encounters
end

function RandomEncounter:getEmptyEncounter()
    return self.empty_encounter
end

function RandomEncounter:getNextEncounter()
    if not self:populationKilled() then
        return Utils.pick(self:getEncounters())
    else
        return self:getEmptyEncounter()
    end
end

function RandomEncounter:populationKilled()
    if self.population and self:getFlag("violent", 0) >= self.population then
        return true
    end
    return false
end

function RandomEncounter:start()
    if not Game.world:hasCutscene() and self:active() and not MagicalGlassLib.initiating_random_encounter then
        if self.bubble then
            Game.lock_movement = true
            MagicalGlassLib.initiating_random_encounter = true
            local timer = (15 + Utils.random(5)) / 30
            if Mod.libs["multiplayer"] then
                for _,player in ipairs(Game.world.other_players) do
                    if player.parent then
                        player:alert(timer, {layer = WORLD_LAYERS["above_events"], sprite = self.bubble})
                    end
                end
            end
            Game.world.player:alert(timer, {layer = WORLD_LAYERS["above_events"], sprite = self.bubble, callback = function() Game:encounter(self:getNextEncounter(), true, nil, nil, self.light);MagicalGlassLib.random_encounter = self.id;Game.lock_movement = false;MagicalGlassLib.initiating_random_encounter = nil end})
        else
            Game:encounter(self:getNextEncounter(), true, nil, nil, self.light)
            MagicalGlassLib.random_encounter = self.id
        end
    end
end

function RandomEncounter:setFlag(flag, value)
    Game:setFlag("randomencounter#"..self.id..":"..flag, value)
end

function RandomEncounter:getFlag(flag, default)
    return Game:getFlag("randomencounter#"..self.id..":"..flag, default)
end

function RandomEncounter:addFlag(flag, amount)
    return Game:addFlag("randomencounter#"..self.id..":"..flag, amount)
end

return RandomEncounter