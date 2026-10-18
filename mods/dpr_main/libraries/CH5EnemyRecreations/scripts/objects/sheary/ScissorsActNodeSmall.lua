local ScissorsActNodeSmall, super = Class(Sprite)

function ScissorsActNodeSmall:init(x, y, controller)
    super.init(self, "ui/battle/cut/bigcircle", x, y)

    self:setScale(0.3)
    if controller.valuecut then
        self:setScale(0.2)
    end
    self:setOriginExact(25, 25)
    self.alpha = 0.25
    self.visible = false

    self.collider = CircleCollider(self, 25, 25, 25)

    self.con = 0

    Game.battle:addChild(ScissorsActNodeBig(self.x, self.y))
end

function ScissorsActNodeSmall:update()
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

function ScissorsActNodeSmall:draw()
    super.draw(self)

    if DEBUG_RENDER then
        self.collider:draw(1, 0, 0)
    end
end

return ScissorsActNodeSmall
