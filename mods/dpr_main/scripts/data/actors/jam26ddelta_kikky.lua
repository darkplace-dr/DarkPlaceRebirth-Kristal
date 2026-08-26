local actor, super = Class(Actor, "jam26ddelta_kikky")


function actor:init()
    super.init(self)
    self.name = "Kikky"

    self.width = 41
    self.height = 40
    self.hitbox = {8, 30, 24, 10}
    self.soul_offset = {8, 16}
    self.path = "world/maps/floor2/darkjam_26/ddelta/kikky/kikky"
    self.default = "walk"
    self.voice = nil
    self.portrait_path = nil
    self.portrait_offset = nil
    self.can_blush = false
	self.flip = "left"
    self.animations = {
        ["walk"] = {"walk", 1/15, true},
        ["attack"] = {"attack", 1/15, true},
        ["dance"] = {"dance", 1/15, true},
    }
    self.offsets = {
        ["walk"] = {0, 0},
        ["attack"] = {0, 0},
        ["dance"] = {0, 0},
    }
end

return actor