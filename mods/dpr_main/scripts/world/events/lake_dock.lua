local LakeDock, super = Class(Event, "lake_dock")

function LakeDock:init(data)
    super.init(self, data)

    local properties = data.properties or {}
    self.properties = properties
    
    self.obj = properties["dock"] or properties["object"] or properties["obj"]
    self.boat = properties["boat"] or properties["boatdock"]
end

function LakeDock:onAdd(parent)
    super.onAdd(self, parent)
end

function LakeDock:onRemove(parent)
    super.onRemove(self, parent)
end

function LakeDock:trigger(player)
    local boat = player.boat
    if boat then
        boat.boarding = false
        boat.onboard = nil
        local target, id = self:getTarget(self.boat, boat)
        local ptarget_x, ptarget_y = self:getPlayerTarget(self.obj)
        boat.targetX, boat.targetY = boat.x + boat.offsetX, boat.y - boat.offsetY
        boat.dockX, boat.dockY = target.x, target.y
        -- print(target.x or "nah")
        -- print(target.y or "nah")
        boat.obj = {x = boat.x, y = boat.y}
        boat.ptarget_x, boat.ptarget_y = ptarget_x, ptarget_y
        boat:updateRide()
    end
end

function LakeDock:onInteract(player, dir)
    self:trigger(player)
end

function LakeDock:onEnter(player)
    self:trigger(player)
end

function LakeDock:getTarget(obj, boat)
    local id = obj.id
    local event = Game.world.map:getEvent(id)
    local x, y
    if not event then
        x,y = Game.world.map:getMarker(id)
    else
        x, y = event.x, event.y
    end
    if x == boat.x and y == boat.y then
        x, y = boat.startX, boat.startY
    end
    return {x = x, y = y}, id
end

function LakeDock:getPlayerTarget(obj)
    return Game.world.map:getMarker(obj.id)
end

function LakeDock:draw()
    super.draw(self)
end

return LakeDock