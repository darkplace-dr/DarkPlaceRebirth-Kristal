---@class Actor.kris : Actor
local actor, super = Class("kris", true)

function actor:init()
    super.init(self)
    Utils.merge(self.offsets, {
        -- TODO: Accuracy.
        ["climb/climb"] = {0, 0},
        ["climb/charge"] = {0, 3},
        ["climb/slip_left"] = {0, 0},
        ["climb/slip_right"] = {0, 0},
        ["climb/land_left"] = {0, 0},
        ["climb/land_right"] = {0, 0},
        ["climb/jump_up"] = {0, 0},
        ["climb/jump_left"] = {0, 0},
        ["climb/jump_right"] = {0, 0},
    })
end

-- TODO: This sucks.
function actor:getOffset(sprite)
    local ox, oy = super.getOffset(self, sprite)
    if Utils.startsWith(sprite, "climb") then
        ox, oy = ox - 5, oy + 4
    end
    return ox, oy
end

function actor:hasOffset(sprite)
    if super.hasOffset(self, sprite) then return true end
end

return actor