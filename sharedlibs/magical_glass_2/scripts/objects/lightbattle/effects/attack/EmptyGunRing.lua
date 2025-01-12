local EmptyGunRing, super = Class(Sprite, "EmptyGunRing")

function EmptyGunRing:init()
    super.init(self, "effects/attack/gunshot_remnant")

    self.inherit_color = true
    self:setOrigin(0.5)

    self.growing = true
end

function EmptyGunRing:update()
    if self.growing then
        self:setScale(self:getScale() + 0.5 * DTMULT)

        if self:getScale() > 3.5 then
            self.growing = false
        end
    else
        self:setScale(self:getScale() - 0.3 * DTMULT)

        self.alpha = self.alpha - 0.2 * DTMULT
        if self.alpha < 0.1 then
            self:remove()
        end    
    end

    super.update(self)
end

return EmptyGunRing