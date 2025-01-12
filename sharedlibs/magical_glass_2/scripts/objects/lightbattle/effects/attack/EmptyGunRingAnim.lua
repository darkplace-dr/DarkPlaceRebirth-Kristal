local EmptyGunRingAnim, super = Class(Object, "EmptyGunRingAnim")

function EmptyGunRingAnim:init()
    super.init(self)

    self.inherit_color = true

    self.rings = 0
    self.timer = 0
end

function EmptyGunRingAnim:update()
    if self.rings < 3 then
        if self.timer ~= 0 then
            self.timer = Utils.approach(self.timer, 0, DTMULT)
        else
            local ring = EmptyGunRing()
            self:addChild(ring)

            self.rings = self.rings + 1
            self.timer = 2
        end
    end

    super.update(self)
end

return EmptyGunRingAnim