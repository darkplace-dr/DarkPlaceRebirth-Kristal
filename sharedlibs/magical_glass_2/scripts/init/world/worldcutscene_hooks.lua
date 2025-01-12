Utils.hook(WorldCutscene, "startDarkEncounter", function(orig, self, encounter, transition, enemy, options)
    options = options or {}
    transition = transition ~= false
    Game:encounterDark(encounter, transition, enemy)
    if options.on_start then
        if transition and (type(transition) == "boolean" or transition == "TRANSITION") then
            Game.battle.timer:script(function(wait)
                while Game.battle.state == "TRANSITION" do
                    wait()
                end
                options.on_start()
            end)
        else
            options.on_start()
        end
    end

    local battle_encounter = Game.battle.encounter
    local function waitForEncounter(self) return (Game.battle == nil), battle_encounter end

    if options.wait == false then
        return waitForEncounter, battle_encounter
    else
        return self:wait(waitForEncounter)
    end
end)

Utils.hook(WorldCutscene, "startLightEncounter", function(orig, self, encounter, transition, enemy, options)
    options = options or {}
    transition = transition ~= false
    Game:encounterLight(encounter, transition, enemy)
    if options.on_start then
        if transition and (type(transition) == "boolean" or transition == "TRANSITION") then
            Game.battle.timer:script(function(wait)
                while Game.battle.state == "TRANSITION" do
                    wait()
                end
                options.on_start()
            end)
        else
            options.on_start()
        end
    end

    local battle_encounter = Game.battle.encounter
    local function waitForEncounter(self) return (Game.battle == nil), battle_encounter end

    if options.wait == false then
        return waitForEncounter, battle_encounter
    else
        return self:wait(waitForEncounter)
    end
end)