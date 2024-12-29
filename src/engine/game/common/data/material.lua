---@class Material : Class
---@overload fun(...) : Material
local Material = Class()

function Material:init()
    -- Display name
    self.name = "Test Material"
    -- Display name if you have more than 1
    self.plural = nil
    -- Menu description
    self.description = "Example description"

    -- How many of this material you can carry at once
    -- set to nil if you want it to stack infinitely
    self.max_stack = nil

    -- Rarity of the material, determines name color in the menu
    self.rarity = 0
    -- Name color override
    -- Should be formated as {r,g,b,a}
    self.color = nil
    -- Icon sprite path
    self.icon = "materials/no_icon"
end

function Material:getRarityColor(rarity)
    local color = {1,1,1,1} -- Default color
    if rarity == 0 then
        color = {0.5,0.5,0.5,1}
    elseif rarity == 2 then
        color = {0,0,1,1}
    elseif rarity == 3 then
        color = {1,0.5,0,1}
    elseif rarity == 4 then
        color = {0.5,0,0,1}
    end
    return color
end

function Material:getColor()
    if self.color then
        return self.color
    else
        return self:getRarityColor(self.rarity)
    end
end

function Material:getPlural()
    if self.plural then
        return self.plural
    else
        return self.name.."s"
    end
end

return Material