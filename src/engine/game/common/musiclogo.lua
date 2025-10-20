local musiclogo, super = Class(Object)

function musiclogo:init(logo, x, y, color)
    super.init(self, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
    self.present = true

    self.timer = 0

    self.parallax_x = 0
    self.parallax_y = 0

    --local logo = Sprite("objects/musiclogos/" .. logo or "objects/musiclogos/field", x or 180, y or 120)
    local logo = Text("[font:musiclogo]♪~".. logo, x or 180, y or 120)
    logo:addFX(OutlineFX((color and color or {17/255, 31/255, 151/255}), {
        thickness = 1,
        amount = 1
    }))

    logo:setScale(2)
    logo.alpha = 0
    self:addChild(logo)

    Game.world.timer:tween(1, logo, {x = x - 20, alpha = 1}, "out-sine")

    Game.world.timer:after(4, function()
        Game.world.timer:tween(1, logo, {x = x - 40, alpha = 0}, "out-sine")
        self.present = false
    end)

end

function musiclogo:update()
    if self.present == false then
        self.timer = self.timer + 1
        if self.timer == 32 then self:remove() end
    end
end

return musiclogo