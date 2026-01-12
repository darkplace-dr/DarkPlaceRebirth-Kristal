---@class Map : Map
local Map, super = HookSystem.hookScript(Map)

function Map:init(world, data)
    super.init(self, world, data)
end

function Map:loadTiles(layer, depth)
    if not StringUtils.startsWith(layer.name, "cyltower") then
        return super.loadTiles(self, layer, depth)
    end
    if not self.cyltower then
        self.cyltower = CylinderTower(self, depth)
        self.world:addChild(self.cyltower)
    end
    self.cyltower:addLayer(layer, depth)
    table.insert(self.tile_layers, tilelayer)
    if StringUtils.startsWith(layer.name:lower(), "battleborder") then
        table.insert(self.battle_borders, tilelayer)
    end
end

function Map:loadLayer(layer, depth)
    if layer.type == "objectgroup" then
        if StringUtils.startsWith(layer.name:lower(), "climbareas") then
            return self:loadClimbAreas(layer, depth)
        end
    end
    return super.loadLayer(self, layer, depth)
end

function Map:createTileObject(data, x, y, width, height)
    if data.gid then
        local gid, flip_x, flip_y = TiledUtils.parseTileGid(data.gid)
        local tileset, tile_id = self:getTileset(gid)
        return TileObject(tileset, tile_id, x or data.x, y or data.y, width or data.width, height or data.height, math.rad(data.rotation or 0), flip_x, flip_y, data.properties)
    end
end

function Map:loadClimbAreas(layer, depth)
    local parent = self.world

    self.events_by_layer[layer.name] = {}
    for _,v in ipairs(layer.objects) do
        v.width = v.width or 0
        v.height = v.height or 0
        v.center_x = v.x + v.width / 2
        v.center_y = v.y + v.height / 2

        -- Get width/height of the full polygon (usable when a polygon is not supported on an object)
        if v.polygon then
            local min_x, max_x, min_y, max_y = 0, 0, 0, 0
            for _, point in ipairs(v.polygon) do
                min_x = math.min(point.x, min_x)
                max_x = math.max(point.x, max_x)
                min_y = math.min(point.y, min_y)
                max_y = math.max(point.y, max_y)
            end

            v.width = max_x - min_x
            v.height = max_y - min_y
            v.center_x = v.x - min_x + v.width / 2
            v.center_y = v.y - min_y + v.height / 2
        end

        local obj
        -- TODO: Make ClimbArea a registered event (after DPR updates its Kristal ver)
        obj = Registry.creatEvent("climbarea", v)
        obj.x = obj.x + (layer.offsetx or 0)
        obj.y = obj.y + (layer.offsety or 0)
        if not obj.object_id then
            obj.object_id = v.id
        end
        if not obj.unique_id then
            obj.unique_id = v.properties["uid"]
        end
        obj.layer = depth
        obj.data = v

        parent:addChild(obj)

        table.insert(self.events, obj)

        self.events_by_name[v.name] = self.events_by_name[v.name] or {}
        table.insert(self.events_by_name[v.name], obj)
        table.insert(self.events_by_layer[layer.name], obj)

        if v.id then
            self.events_by_id[v.id] = obj
            self.next_object_id = math.max(self.next_object_id, v.id)
        end
    end
end

return Map
