local GhostHouseLock, super = Class(Solid)

function GhostHouseLock:init(x, y, width, height, sprite, ox, oy)
    super.super.init(self, x, y, width, height)
	self.offsetx = ox
	self.offsety = oy
	self.bar_sprite = Assets.getTexture("battle/ghost_house/"..sprite)
    self.layer = BATTLE_LAYERS["above_arena"]

    if width and height then
        self:setHitbox(-self.offsetx, -self.offsety, width*self.bar_sprite:getWidth(), height*self.bar_sprite:getHeight())
    end

    -- Damage applied to the soul when its squished against another solid by this one
    self.squish_damage = 0
    self.color = {0, 0.75, 0}
end

function GhostHouseLock:draw()
	Draw.setColor(self:getColor())
	Draw.draw(self.bar_sprite, 0, 0, 0, self.width, self.height, self.offsetx, self.offsety)
    super.draw(self)
end

return GhostHouseLock