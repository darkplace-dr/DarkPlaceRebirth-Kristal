local EncounterZone, super = Class(Event, "encounterzone")

function EncounterZone:init(data)
    super.init(self, data.x, data.y, data.width, data.height)

    local properties = data.properties or {}

    self.group = MagicalGlass:createEncounterGroup(properties["encounter_group"])
    self.debug_color = properties["debug_color"] or COLORS.green

    local shapes = {
        "rectangle",
        "circle",
        "ellipse",
        "polygon",
        "polyline"
    }
    if Utils.containsValue(shapes, data.shape) then
        self.collider = Utils.colliderFromShape(self, data)
    elseif data.shape == "point" then
        self.map_wide = true
    end
end

function EncounterZone:onAddToStage()
    table.insert(MagicalGlass.__encounter_zones, self)
end

function EncounterZone:onRemoveFromStage()
    Utils.removeFromTable(MagicalGlass.__encounter_zones, self)
end

function EncounterZone:onFootstep(num)
    if Game.state == "OVERWORLD" and self.collider then
        if Game.world and Game.world.player then
            if self.collider:collidesWith(Game.world.player) or self.map_wide then
                self.group:onFootstep(num)
            end
        end
    end
end

function EncounterZone:update()
    super.update(self)

    if Game.state == "OVERWORLD" and self.collider then
        if Game.world and Game.world.player then
            if self.collider:collidesWith(Game.world.player) or self.map_wide then
                if self.group:canStartEncounter() then
                    self.group:startEncounter()
                end
            end
        end
    end
end

function EncounterZone:draw()
    super.draw(self)
    
    if DEBUG_RENDER and self.collider then
        self.collider:draw(self.debug_color)
    end
end

return EncounterZone