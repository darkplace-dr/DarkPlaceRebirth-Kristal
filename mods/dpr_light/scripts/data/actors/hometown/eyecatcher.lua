local actor, super = Class(Actor, "eyecatcher")

function actor:init()
    super.init(self)

    self.name = "EyeCatcher"

    -- Width and height for this actor, used to determine its center
    self.width = 40
    self.height = 38

    -- Hitbox for this actor in the overworld (optional, uses width and height by default)
    self.hitbox = {1, self.height/2, self.width-2, self.height/2}

    -- Path to this actor's sprites (defaults to "")
    self.path = "world/npcs/hometown/eyecatcher"
    -- This actor's default sprite or animation, relative to the path (defaults to "")
    self.default = ""

    self.animations = {}
end

function actor:onSpriteInit(sprite)
    sprite:play(1/4)
    if not Kristal.Config["simplifyVFX"] then
        sprite.sin1 = 100
        sprite.sin2 = 20
    else
        sprite.sin1 = 10
        sprite.sin2 = 30
    end
end

function actor:onSpriteUpdate(sprite)
    sprite.x = sprite.init_x + math.sin(Kristal.getTime()*sprite.sin1)*sprite.sin2
end

return actor