local white_glows, super = Class(Sprite)

function white_glows:init()
    super.init(self, "world/bg/glows", 0, 0)
                    local code = self:addFX(ShaderFX("glitch", {
            ["iTime"] = function() return Kristal.getTime() end,
            ["iResolution"] = {SCREEN_WIDTH, SCREEN_HEIGHT}
        }), "color_shift_mode")


    self.wrap_texture_x = true
    self.wrap_texture_y = true
    self:setScale(4)

    self.parallax_x = 0
    self.parallax_y = 0

    self.physics.speed_x = 0.4
    self.physics.speed_y = -0.4
    self.debug_select = false
end

return white_glows
