local ScissorsActNodeBig, super = Class(Sprite)

function ScissorsActNodeBig:init(x, y)
    super.init(self, "ui/battle/cut/bigcircle", x, y)

    self:setScale(0.7)
    self:setOriginExact(25, 25)
    self.alpha = 0.25
    self.visible = false

    self.collider = CircleCollider(self, 25, 25, 25)

    self.con = 0
end

function ScissorsActNodeBig:update()
    Object.startCache()
    for _, line in ipairs(Game.stage:getObjects(ScissorsLine)) do
        if line.collider:meetsCollider(self.collider) then
            self.con = 1
            self.color = COLORS.red
        end
    end
    Object.endCache()

    super.update(self)
end

function ScissorsActNodeBig:draw()
    super.draw(self)

    if DEBUG_RENDER then
        self.collider:draw(1, 0, 0)
    end
end

return ScissorsActNodeBig
