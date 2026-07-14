local PolarBullet, super = Class(Bullet)

--- @class PolarBullet : Bullet
--- PolarBullets allow you to operate on their coordinates in a polar(-inspired) form,
---  representing them as closing in on a center "pole".
---  This makes them well-suited for green soul attacks.
--- 
--- The system used uses one angle and one coordinate, relative to an x/y "pole" (typically the center of the arena):
---  phi - The clockwise angle around the pole.
---  rho - The distance from the pole. Higher values are further away.
---
--- Since Kristal uses (and expects) left-handed cartesian coordinates, PolarBullets still use x/y coordinates internally,
--- doing the maths to convert between the two systems as needed.
---
--- @field pole_x   number  The x-coordinate of the pole, in the same coordinate space as this object's x/y coordinates.
--- @field pole_y   number  The y-coordinate of the pole.
--- @field phi      number  The phi value in radians.

--- @param phi       number                 angle CW around the pole
--- @param rho       number                 distance from the pole
--- @param texture   string|love.Image      
--- @param pole?     {1:number,2:number}    The pole. If nil, uses the arena center.
function PolarBullet:init(phi, rho, texture, pole)
    super.init(self,nil,nil,texture)
    
    local pole = pole or {Game.battle.arena:getCenter()}
    self.pole_x = pole[1]
    self.pole_y = pole[2]
    
    self.physics.match_rotation = true -- use sprite rotation by default
    self.facing_offset = math.pi -- by default, face inwards
    
    -- move to correct position
    self:setPositionPolar(phi, rho)
    
    -- default green deflection collider is a line down the middle
    self.green_deflect_collider = LineCollider(self, 0, self.height/2, self.width, self.height/2)
end

--- @return number  The X-coordinate of the pole, in the same coordinate space as the PolarBullet's x/y coordinates.
--- @return number  The Y-coordinate of the pole.
function PolarBullet:getPole()
    return self.pole_x, self.pole_y
end
--- @return number  This bullet's X-coordinate relative to the pole.
--- @return number  This bullet's Y-coordinate relative to the pole.
function PolarBullet:getRelXY()
    return self.x - self.pole_x, self.y - self.pole_y
end

--- @return number  This bullet's phi angle.
function PolarBullet:getPhi()
    local relx, rely = self:getRelXY()
    return -math.atan2(-rely, relx) -- (we convert rely from left- to right-handed and phi from ccw to cw)
end
--- @return number  This bullet's rho coordinate.
function PolarBullet:getRho()
    local relx, rely = self:getRelXY()
    return math.sqrt(relx*relx + rely*rely)
end

--- A combined version of getPhi and getRho
--- @return number  This bullet's phi angle.
--- @return number  This bullet's rho coordinate.
function PolarBullet:getPositionPolar()
    local relx, rely = self:getRelXY()
    local rho = math.sqrt(relx*relx + rely*rely)
    local phi = -math.atan2(-rely, relx) -- (we convert rely from left- to right-handed and phi from ccw to cw)
    return rho, phi
end
--- Set phi and rho to new values
--- @param phi  number  The new phi value.
--- @param rho  number  The new rho value.
function PolarBullet:setPositionPolar(phi, rho)
    -- note: Kristal is x-right, y-down, CW
    --       whereas the cos/sin formula is for x-right, y-up, CCW
    -- so we must negate phi (CW <-> CCW) and negate the Y parameter (y-up <-> y-down)
    local relx =  rho*math.cos(-phi)
    local rely = -rho*math.sin(-phi)
    
    self:setRelXY(relx, rely)
end

--- Set the pole to a new x/y coordinate
--- @param x            number  The new x coordinate.
--- @param y            number  The new y coordinate.
--- @param fixed_self?  boolean If true, the bullet stays in the same x/y position. If false or nil, it moves to the new position, keeping phi and rho (roughly) the same.
function PolarBullet:setPole(x, y, fixed_self)
    local relx, rely
    if not fixed_self then
        relx, rely = self:getRelXY()
    end
    self.pole_x = x
    self.pole_y = y
    if not fixed_self then
        self:setRelXY(relx, rely)
    end
end
--- Set the bullet's x/y coordinates relative to the pole.
--- @param x            number  The new x coordinate.
--- @param y            number  The new y coordinate.
function PolarBullet:setRelXY(relx, rely)
    self:setPosition(self.pole_x + relx, self.pole_y + rely)
end

--- Get the "facing offset" - the difference between phi and the direction the bullet faces
function PolarBullet:getFacingOffset()
    return self.facing_offset
end
--- Set the "facing offset" - the difference between phi and the direction the bullet faces
function PolarBullet:setFacingOffset(facing_offset)
    self.facing_offset = facing_offset
    self:updateDirection()
end

function PolarBullet:setPosition(x,y)
    super.setPosition(self,x,y)
    self:updateDirection()
end
function PolarBullet:updateDirection()
    self:setDirection(self:getPhi() + self.facing_offset)
end

return PolarBullet