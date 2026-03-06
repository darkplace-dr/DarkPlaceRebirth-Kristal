---@class Pointsbox : Object
---@overload fun(...) : Pointsbox
local Pointsbox, super = Class(Object)

function Pointsbox:init()
    super.init(self, 56, 220)

    self:setParallax(0, 0)

    if Game.world and Game.world.player and Game.world.camera then
        local player_x, _ = Game.world.player:localToScreenPos()
        if player_x <= 320 then
            self.x = self.x + 320
        end
    end

    self.box = UIBox(0, 0, 201, 57)
    self.box.layer = -1
    self:addChild(self.box)

    self.font = Assets.getFont("main")
end

function Pointsbox:draw()
    super.draw(self)

    love.graphics.setFont(self.font)
    Draw.setColor(PALETTE["world_text"])
    love.graphics.print("$" .. Game.money, 38 - 36, 318 - 220 - 100)
    love.graphics.print(Game:getFlag("points", 0), 38 - 36, 318 + 26 - 220 - 100)
    love.graphics.print("POINTs", 38 + 80 - 36, 318 + 26 - 220 - 100)
end

return Pointsbox