local LightWorldBullet, super = Class(WorldBullet)

function LightWorldBullet:init(x, y, texture)
    super.init(self, x, y, texture)
    
    -- Clearing unused stuff
    self.damage = nil
    self.battle_fade = nil
    
    -- Useable variables
    self.hazard_encounter = nil
    self.light = true
end

function LightWorldBullet:getDebugInfo()
    local info = Object.getDebugInfo(self)
    table.insert(info, "Battle Type: " .. (self.light and "Light" or "Dark"))
    table.insert(info, "Encounter: " .. self.hazard_encounter)
    table.insert(info, "Destroy on hit: " .. (self.destroy_on_hit and "True" or "False"))
    table.insert(info, "Remove when offscreen: " .. (self.remove_offscreen and "True" or "False"))
    return info
end

function LightWorldBullet:onCollide(soul)
    if self.hazard_encounter and Game.inv_frames <= 0 then
        local inv_frames = self:getInvulnFrames()
        Game:setInvulnFrames(inv_frames)
        Game:encounter(self.hazard_encounter, true, nil, nil, self.light)
    end
    
    if self.destroy_on_hit then
        self:remove()
    end
end

function LightWorldBullet:getDrawColor()
    return Object.getDrawColor(self)
end

return LightWorldBullet