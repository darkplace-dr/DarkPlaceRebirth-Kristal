---@class Actor.tenna_fc : Actor
local actor, super = Class(Actor, "tenna_fc")

function actor:init()
    super.init(self)
    self.path = "world/npcs/tenna_fc"
    self.portrait_path = "face/tenna_fc"
    self.voice = "tenna_fc"
    self.default = "idle"
    self.offsets = {
        ["aurafarming"] = {-7, 0};
        ["idle"] = {0, 0};
        ["pensive"] = {2, -2};
        ["flying"] = {-18, -7};
    }
    self.width, self.height = 34, 87
    self.name = "FC!Tenna"
    self.portrait_offset = {-8, -20}
    self.hitbox = {0, self.height - 20, self.width, 20}
    self.animations = {
        ["flying"] = {"flying", 0.1, true}
    }
end

return actor
