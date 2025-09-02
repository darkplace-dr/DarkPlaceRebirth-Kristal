local actor, super = Class(Actor, "ramb")

function actor:init()
    super.init(self)
    self.name = "Ramb"

    self.width = 25
    self.height = 32

    self.hitbox = {2, 0, 23, 32}
	
    self.flip = nil

    self.path = "world/npcs/ramb"
    self.default = "idle"

    self.voice = nil
    self.portrait_path = nil
    self.portrait_offset = nil

    self.can_blush = false
	
    self.animations = {}	

    self.offsets = {}
end

return actor