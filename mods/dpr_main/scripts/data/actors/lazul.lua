local actor, super = Class(Actor, "lazul")

function actor:init()
    super.init(self)

    self.name = "LAzul"
    self.width = 24
    self.height = 47

    self.flip = nil
    self.path = "world/npcs"
    self.default = "lazul"
    --self.voice = ""
    --self.portrait_path = ""
    --self.portrait_offset = {-10, 0}
    self.can_blush = false
    self.talk_sprites = {}
    self.animations = {
    }
    self.offsets = {}
end

return actor