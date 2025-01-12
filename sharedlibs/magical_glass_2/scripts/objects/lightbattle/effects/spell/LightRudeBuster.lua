local LightRudeBuster, super = Class(Object, "LightRudeBuster")

function LightRudeBuster:init(red, target_x, target_y, after)
    super.init(self)

    self.target_x = target_x
    self.target_y = target_y
    self.red = red

    local start_x = self.target_x
    local start_y = self.target_y - 220

    self.left_beam = LightRudeBusterBeam(red, start_x + 90, start_y, target_x, target_y)
    Game.battle:addChild(self.left_beam)
    self.right_beam = LightRudeBusterBeam(red, start_x - 90, start_y, target_x, target_y)
    Game.battle:addChild(self.right_beam)

    self.timer = 0

    self.pressed = false

    self.after_func = after
end

function LightRudeBuster:onAdd()
    Input.clear("confirm", true)
end

function LightRudeBuster:update()
    self.timer = self.timer + DTMULT

    if Input.pressed("confirm") then
        self.pressed = true
    end

    if self.timer >= 10 then
        self.left_beam:remove()
        self.right_beam:remove()

        if self.after_func then
            self.after_func(self.pressed)
        end
        Assets.playSound("rudebuster_hit")
        for i = 1, 8 do
            local burst = RudeBusterBurst(self.red, self.target_x, self.target_y, math.rad(45 + ((i - 1) * 90)), i > 4)
            if self.red then
                burst:setScale(4)
                burst.physics.speed = 40
            else
                burst:setScale(3)
                burst.physics.speed = 35
            end
            burst.layer = self.layer + (0.01 * i)
            self.parent:addChild(burst)
        end
        self:remove()
        return
    end

    super.update(self)
end

return LightRudeBuster