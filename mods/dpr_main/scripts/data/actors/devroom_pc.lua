local actor, super = Class(Actor, "devroom_pc")

function actor:init()
    super.init(self)
	
    self.name = "Dev Diner PC"

    self.width = 60
    self.height = 60

    self.hitbox = {0, 42, 42, 18}

    self.flip = nil

    self.path = "world/npcs/devroom_pc"
    self.default = "off"

    self.animations = {
        ["off"] = {"off", 0, true},
		["on"] = {"on", 0, true},
		["happy"] = {"happy", 0, true},
		["loading"] = {"loading", 0.1, true},
		["wonka"] = {"wonka", 0, true}
    }

    self.offsets = {
    }
end

return actor