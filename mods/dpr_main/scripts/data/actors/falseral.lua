local actor, super = Class(Actor, "falseral")

function actor:init()
    super.init(self)


    self.width = 40
    self.height = 72

    self.path = "world/npcs/falseral"
    

    -- Table of sprite animations
    self.animations = {
        ["idle"]               = {"idle", 0/30, true},
        ["falseral_d"]               = {"falseral_d", 0/30, true},
        ["falseral_s"]               = {"falseral_s", 0/30, true},
        
    }
self.default = "idle"
    self.offsets = {
        -- Movement offsets
        ["idle"] = {0, 0},
        ["falseral_d"] = {0, 0},
        ["falseral_s"] = {0, 0},
    }
end

return actor