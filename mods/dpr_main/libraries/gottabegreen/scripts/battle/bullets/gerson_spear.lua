local Spear, super = Class(PolarBullet, "gerson_spear")
--- @class "gerson_spear" : PolarBullet
--- A yellow spear that travels towards the center of the arena, for use with the green soul mode.
--- To have it turn red when it's the closest, add a SpearRedChecker as a child of your wave.
--- 
--- @field sprite_name_normal   string  The name of the sprite when normal.
--- @field sprite_name_red      string  The name of the sprite to use when this spear is the closest one to the soul.
--- @field is_red?              boolean If the spear is currently the closest one to the soul, or nil if setSprite has been used directly to override the sprite.

--- @param speed?   number  speed, or null for the default speed of 12px/f
function Spear:init(phi, rho, speed)
    super.init(self, phi, rho, "bullets/spr_spear_arrow")
    self:setScale(1,1)
    
    -- adjust collider height
    --local old_height = self.collider.height
    --self.collider.height = self.collider.height / (self.scale_y*2)
    --local hdiff = self.collider.height - old_height
    --self.collider.y = self.collider.y - (hdiff/2)
    
    -- Speed the bullet moves (pixels per frame at 30FPS)
    self.physics.speed = speed or 12
    
    self.sprite_name_normal = "bullets/spr_spear_arrow"
    self.sprite_name_red = "bullets/spr_spear_arrow_highlight_0"
    self.is_red = false
end

function Spear:setSprite(texture, speed, loop, on_finished)
    self.is_red = nil
    return super.setSprite(self, texture, speed, loop, on_finished)
end
--- Set whether the spear is "red" (closest to the soul).
--- This will change the sprite to the appropriate one (sprite_name_normal or sprite_name_red).
--- If self.is_red is nil (i.e. the sprite has been changed prior using setSprite), then this function will have no effect.
--- @param now_red  boolean If true, change to the red sprite. If false, change to the normal sprite.
function Spear:setRed(now_red)
    if self.is_red == nil then -- don't update if our sprite has been overwritten
        return
    end
    
    local sprite_name = self.sprite_name_normal
    if now_red then
        sprite_name = self.sprite_name_red
    end
    super.setSprite(self, sprite_name)
    self.is_red = now_red
end

return Spear