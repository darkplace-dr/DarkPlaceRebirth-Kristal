local actor, super = Class(Actor, "goku")

function actor:init()
    super.init(self)

    self.name = "goku"

    self.width = 71/2
    self.height = 109/2

    self.hitbox = {5, 22, 19, 11}

    self.flip = nil

    self.path = "world/npcs"
    self.default = "goku"

    self.animations = {}

    self.offsets = {}
end

function actor:onSpriteInit(sprite)
    -- I was too lazy to actually remake the sprite to be smaller
    -- And Kristal handles x0.5 scaling better than Aseprite
    sprite:setScale(0.5)
    sprite.cutout_bottom = -37
    sprite.y = 9.5
end

return actor