local self = {}

self.name = "Workshop"
self.mod = "dlc_christmas"
self.warp = "christmas/outside/outside_1"

function self:load()
    local date = os.date("*t")
    if date.month == 12 then
        return true
    elseif dae.month == 1 and date.day <= 6 then
        return true
    end
    return false
end

return self