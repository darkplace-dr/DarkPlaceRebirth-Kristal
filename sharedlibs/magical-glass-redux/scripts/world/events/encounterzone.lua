local EncounterZone, super = Class(Event, "encounterzone")

function EncounterZone:init(data)
    super.init(self)

    data = data or {}

    self.x = data.x
    self.y = data.y
    self.width = data.width
    self.height = data.height

    self.random_encounter = Mod.libs["magical-glass"]:createRandomEncounter(data.properties["randomencounter"])

    if Mod.libs["magical-glass"].steps_until_encounter == nil or Mod.libs["magical-glass"].steps_until_encounter and Mod.libs["magical-glass"].steps_until_encounter < 0 then
        self.random_encounter:resetSteps(true)
    end

    local s = data.shape
    if s == "rectangle" or s == "circle" or s == "ellipse" or s == "polygon" or s == "polyline" then
        self.type = "zone"
        self.collider = Utils.colliderFromShape(self, data)
    else
        self.type = "map"
    end

    self.accepting = false
    Mod.libs["magical-glass"].in_encounter_zone = false
end

function EncounterZone:update()
    super.update(self)

    if Game.world.player and not Game.battle then
        if self.collider:collidesWith(Game.world.player) or self.type == "map" then
            self.accepting = true
        else
            self.accepting = false
        end
    end
    Mod.libs["magical-glass"].in_encounter_zone = self.accepting

    if Mod.libs["magical-glass"].steps_until_encounter and Mod.libs["magical-glass"].steps_until_encounter <= 0 and self.accepting then
        self.random_encounter:resetSteps(false)
        self.random_encounter:start()
    end

end

function EncounterZone:onAddToStage(parent)
    if Mod then
        Mod.libs["magical-glass"].encounters_enabled = true
    end

    super.onAdd(self, parent)
end

function EncounterZone:onRemoveFromStage(stage)
    if Mod then
        Mod.libs["magical-glass"].encounters_enabled = false
    end

    super.onRemove(self, stage)
end

function EncounterZone:draw()
    super.draw(self)

    if DEBUG_RENDER and self.collider and self.accepting then
        love.graphics.push()
        love.graphics.origin()

        love.graphics.setFont(Assets.getFont("main"))
        love.graphics.print({{1, 0, 0},"Encounter Zone!",{1, 1, 0},"\nSteps Until Encounter: ",{1, 1, 1},not Mod.libs["magical-glass"].initiating_random_encounter and (Mod.libs["magical-glass"].steps_until_encounter or "N\\A") or 0}, 8, 0, 0, 1.25)

        love.graphics.pop()
    end
end

function EncounterZone:getDebugInfo()
    local info = super.getDebugInfo(self)
    table.insert(info, "Active: " .. (self.accepting and "True" or "False"))
    return info
end

return EncounterZone