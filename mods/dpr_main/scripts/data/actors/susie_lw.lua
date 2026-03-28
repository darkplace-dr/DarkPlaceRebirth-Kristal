local actor, super = HookSystem.hookScript("susie_lw")

function actor:init()
    super.init(self)

    TableUtils.merge(self.animations, {
        ["jump_ball"] = {"ball", 1/15, true},
    }, false)
end

return actor