local BreakSpot, super = Class(Event)

function BreakSpot:init(data)
    super.init(self, data.x, data.y, { data.width, data.height })

    self:setOrigin(0.5)
    self:setSprite("world/events/shine", 8 / 30)

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

    self.sprite.alpha = MathUtils.lerp(self.sprite.alpha, alphatarg, 0.5)

    super.update(self)
end

return BreakSpot
