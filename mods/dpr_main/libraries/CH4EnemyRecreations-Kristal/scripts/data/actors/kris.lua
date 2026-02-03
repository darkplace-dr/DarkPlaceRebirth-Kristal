local actor, super = HookSystem.hookScript("kris")

function actor:init()
    super.init(self)

    TableUtils.merge(self.animations, {
        ["pirouette"] = {"pirouette", 4/30, true},
    }, false)

    TableUtils.merge(self.offsets, {
        ["pirouette"] = {0, 0},
    }, false)
end

return actor