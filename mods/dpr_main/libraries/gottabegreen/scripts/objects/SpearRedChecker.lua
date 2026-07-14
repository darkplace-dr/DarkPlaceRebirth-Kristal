local SpearRedChecker, super = Class(Object)

-- Utility class that sets the closest spear to red
function SpearRedChecker:init()
    super.init(self)
    
    self.prev_closest_spear = nil
end

function SpearRedChecker:update()
    -- find closest spear
    local closest_spear = nil
    local closest_dist = math.huge
    for _,spear in ipairs(Game.stage:getObjects(PolarBullet)) do
        if spear:isFullyActive() then
            local dist = math.abs(spear:getRho()) - 32 - (spear.width/2) -- pick the closest to the boundrary (approximately)
            dist = dist / math.max(1,spear.physics.speed) -- divide by speed to get the first to reach the boundrary (but ensure no div by 0)
            if dist < closest_dist then
                closest_spear = spear
                closest_dist = dist
            end
        end
    end
    
    -- update spear states
    if closest_spear ~= self.prev_closest_spear then
        if self.prev_closest_spear ~= nil and self.prev_closest_spear.setRed ~= nil then
            self.prev_closest_spear:setRed(false)
        end
        if closest_spear ~= nil and closest_spear.setRed ~= nil then
            closest_spear:setRed(true)
        end
        self.prev_closest_spear = closest_spear
    end
end

return SpearRedChecker