local actor, super = Class(Actor, "alexa")

function actor:init()
    super.init(self)

    self.name = "Alexa"

    -- Width and height for this actor, used to determine its center
    self.width = 17
    self.height = 34

    self.hitbox = {0, 25, 17, 11}

    self.color = {253/255, 190/255, 219/255}

    self.path = "world/npcs/alexa"
	
    self.voice = "alexa"
	
    self.default = ""

    -- Table of sprite animations
    self.animations = {}

    self.offsets = {}
end

return actor