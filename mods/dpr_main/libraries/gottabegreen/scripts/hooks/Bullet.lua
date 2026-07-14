local Bullet, super = Utils.hookScript(Bullet)

--- @field green_deflect_collider  Collider|nil    The collider to use in collidesWith_greenDeflect, or nil to use the regular collider.

function Bullet:init(...)
    super.init(self,...)
    
    self.green_deflect_collider = nil
end
function Bullet:draw()
    super.draw(self)
    if DEBUG_RENDER and self.green_deflect_collider then
        self.green_deflect_collider:drawFor(self,0,1,0)
    end
end

--- Called when blocked by the green soul mode.
--- @param crit boolean If the block was a "crit"
--- @return     boolean If truthy, prevents the "default" hit highlight and crit tp reward.
function Bullet:onGreenDeflect(crit)
    -- play sound
    self:playGreenDeflectSound(crit)
    
    -- remove bullet
    self:remove()
end
--- Play the green soul deflection sound. Called by the default onGreenDeflect implementation.
function Bullet:playGreenDeflectSound(crit)
    if crit then
        Assets.playSound("bell_bounce_short")
    else
        Assets.playSound("bell")
    end
end


--- Called instead of regular collidesWith when checking if the bullet is deflected by the green soul.
--- The default implementation returns the boolean AND of self:collidesWith and self.green_deflect_collider (if non-nil)
--- The regular collider is still used for checking if the bullet hits/hurts the soul.
---
--- This allows you to use e.g. a simple line collider rather than a hitbox that may spill over into other lanes.
---
--- @param other  Collider    The collider to check against.
--- @returns boolean    true if the provided blocker collider collides with this bullet.
function Bullet:collidesWith_greenDeflect(other)
    if self:collidesWith(other) then
        if self.green_deflect_collider then -- limit by the green soul collider
            return self.green_deflect_collider:collidesWith(other)
        else
            return true
        end
    end
    return false
end


return Bullet