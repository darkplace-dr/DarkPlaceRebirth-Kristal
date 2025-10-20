local SpaceBG, super = Class(Sprite)

function SpaceBG:init()
    super.init(self, "world/maps/devroom/spacebg", 0, 0)

    self.wrap_texture_x = true
    self:setScale(1)

    self.parallax_x = 0
    self.parallax_y = 0

    self.physics.speed_x = 0.3
    self.debug_select = false

    self.space_bg = true

end

return SpaceBG
