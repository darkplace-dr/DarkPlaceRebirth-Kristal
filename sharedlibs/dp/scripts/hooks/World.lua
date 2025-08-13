---@class World : World
local World, super = Utils.hookScript(World)

-- The MB easter egg won't happen when entering any DLCs or maps in this list
-- The list only needs to find the given string in the id so you don't have to add every single map to the list
-- Especially if they're all in a folder, as the folder name appears in the id
-- 
-- But hey, I'd be cool if this list could stay as short as possible, especially the DLC one :D
World.mb_blacklist = {
    dlcs = {},
    maps = {
        "conversion_rooms",
        "nothing",
        "grey_cliffside/dead_room1_start"
    },
}

function World:canMb(map)
    if (Kristal.DebugSystem:isMenuOpen() or Game:getFlag("s", false) or (self:hasCutscene() or Game.battle)) then
        return false
    end
    -- Something important might be loading if Mod or Game.world.map is nil, let's not interrupt it
    if not (Mod and Mod.info and Mod.info.id) or not (self.map and self.map.id) then
        return false
    end
    for obj,list in pairs(self.mb_blacklist) do
        for _,id in ipairs(list) do

            if obj == "dlcs" and (Mod and Mod.info and Mod.info.id) then
                if Mod.info.id == id then
                    return false
                end
            elseif obj == "maps" then
                if isClass(map) and map:includes(Map) then
                    if map.id:find(id) then
                        return false
                    end
                elseif type(map) == "string" then
                    if map:find(id) then
                        return false
                    end
                end
            end
        end
    end
    return true
end

function World:shouldMb(map)
    if not self:canMb(map) then return false end
    local chance
    if DP:shouldWeIncreaseTheRateAtWhichYouGainNightmaresOrNot() then
        chance = love.math.random(1, 10) == 6
    else
        chance = love.math.random(1, 1000) == 666
    end
    return chance
end

function World:loadMap(...)
    if self.map and self.map.id then
        Game:setFlag("PREVMAP", self.map.id)
    end
    super.loadMap(self, ...)
end

return World
