local actor, super = Class(Actor, "download")

function actor:onSpriteInit(sprite)
    sprite:setScale(0.5, 0.5)
    print(sprite.hitbox)
end

function actor:init()
    super.init(self)
    self.name = "download"
    self.width = 98/2
    self.height = 120/2
    self.hitbox = {0, 120/2, 98/2, 0}
    self.path = "world/npcs/cliffside"
    self.default = "download"
end

return actor