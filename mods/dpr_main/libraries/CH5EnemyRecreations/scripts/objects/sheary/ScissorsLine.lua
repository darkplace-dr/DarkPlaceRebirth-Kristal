local ScissorsLine, super = Class(Sprite)

function ScissorsLine:init(x, y, x2, y2, count, controller)
    super.init(self, "ui/battle/cut/whitepixel", x, y)

    self.controller = controller

    self.layer = self.layer + 1

    self.collider = Hitbox(self, 0, 0, 1, 1)

    self.con = 0
    self.timer = 0
    self.count = count or 0
    self.x2 = x2 or 0
    self.y2 = y2 or 0
end

function ScissorsLine:update()
    if self.con == 1 then
        self.timer = self.timer + DTMULT
        self.color = COLORS.white
        self.alpha = MathUtils.lerp(1, 0, self.timer / 30)
        if self.timer >= 30 then
            self:remove()
        end
    end

    Object.startCache()
    for _, line in ipairs(Game.stage:getObjects(ScissorsLine)) do
        if line.collider:meetsCollider(self.collider) then
            local donot = false
            if math.abs(self.count - line.count) < 3 then
                donot = true
            end
            if (self.count >= 4 or line.count >= 4) and not donot then
                self.controller.acttimer = self.controller.acttimermax
            end
        end
    end
    Object.endCache()

    super.update(self)
end

function ScissorsLine:draw()
    super.draw(self)

    if DEBUG_RENDER then
        self.collider:draw(0, 1, 0)
    end
end

return ScissorsLine
