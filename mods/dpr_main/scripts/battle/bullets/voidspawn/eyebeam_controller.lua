local EyeBeamController, super = Class(Bullet)

function EyeBeamController:init(x, y, voidspawn)
    super.init(self, x, y, nil)

    self.voidspawn = voidspawn
    self.timer = 0
    self.state = "CHARGING" -- CHARGING, FIRING
end

function EyeBeamController:update()
    super.update(self)

    self.x = self.voidspawn.x + self.voidspawn.sprite.iris_x - self.voidspawn.sprite.width/2 + 12
    self.y = self.voidspawn.y + self.voidspawn.sprite.iris_y - self.voidspawn.sprite.width/2 + self.voidspawn.sprite.y + 18

    self.timer = self.timer + DT
end

function EyeBeamController:draw()
    super.draw(self)

    if self.state == "CHARGING" then
        Draw.setColor(1,1,1)
        love.graphics.circle("fill", self.x, self.y, (self.timer * 5) + math.sin(self.timer*10))
    end
end

return EyeBeamController