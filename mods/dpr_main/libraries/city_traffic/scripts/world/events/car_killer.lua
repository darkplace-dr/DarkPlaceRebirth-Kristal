---@diagnostic disable inject-field
local CarKiller, super = Class(Event)

function CarKiller:init(data)
    super.init(self, data)

    local pr = data.properties

    self.explode_car = pr["explode"]
    self.quieter_explosion = pr["explode_quieter"]
end

return CarKiller