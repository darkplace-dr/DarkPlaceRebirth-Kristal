---@class Map : Map
local Map, super = Utils.hookScript(Map)

function Map:init(world, data)
    super.init(self, world, data)
end

function Map:loadTiles(layer, depth)
    if not Utils.startsWith(layer.name, "cyltower") then
        return super.loadTiles(self, layer, depth)
    end
    if not self.cyltower then
        self.cyltower = CylinderTower(self, depth)
        self.world:addChild(self.cyltower)
    end
    self.cyltower:addLayer(layer, depth)
    table.insert(self.tile_layers, tilelayer)
    if Utils.startsWith(layer.name:lower(), "battleborder") then
        table.insert(self.battle_borders, tilelayer)
    end
end

return Map