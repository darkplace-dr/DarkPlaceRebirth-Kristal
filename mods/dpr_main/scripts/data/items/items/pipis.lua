local item, super = Class("pipis", true)

function item:getDescription()
    local map_properties = Game.world.map.data and Game.world.map.data.properties or nil
    if Game.world.map.id:find("floortv/") or (map_properties and map_properties["alwayspipis"]) then
        if Game:getFlag("pipisItemProgress", 0) == 1 then
            return "A certain person's special \"???\"\nIt's now tweeting."
        elseif Game:getFlag("pipisItemProgress", 0) == 2 then
            return "A certain person's special \"???\"\nIt's now making a clucking noise."
        end
    end
    return self.description
end

return item
