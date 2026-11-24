local BreakSpot, super = Class(Event)

function BreakSpot:init(data)
    super.init(self, data.x, data.y, { data.width, data.height })

    local properties = data and data.properties or nil
    self.shine = Sprite("world/events/shine", properties.shine_x or MathUtils.round(self.width / 2), properties.shine_y or MathUtils.round(self.height / 2))
    self.shine:play(8 / 30, true)
    self.shine:setOrigin(0.5)
    self.shine:setScale(2)
    self:addChild(self.shine)

    self.siner = 0
end

function BreakSpot:onInteract()
    Game.world:openMenu(BreakMenu())
    return true
end

function BreakSpot:update()
    self.siner = self.siner + DTMULT

    local alphatarg = (math.sin(self.siner / 30) * 0.5) + 0.8
    if Game.world.menu ~= nil or Game.world:hasCutscene() then
        alphatarg = 0
    end

    self.shine.alpha = MathUtils.lerp(self.shine.alpha, alphatarg, 1 - (1 - 0.5) ^ DTMULT)

    super.update(self)
end

return BreakSpot
