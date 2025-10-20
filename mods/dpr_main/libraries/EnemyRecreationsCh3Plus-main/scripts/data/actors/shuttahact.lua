local ShuttahAct, super = Class(Actor)

function ShuttahAct:init()
    super.init(self)

    self.width = 50
    self.height = 68

    self.path = "enemies/shuttah/act"

    self.default = "smile"

    self.animations = {
        ["smile"] = {"smile"},
        ["banana"] = {"banana"},
        ["frown"] = {"frown"}
    }
end

return ShuttahAct