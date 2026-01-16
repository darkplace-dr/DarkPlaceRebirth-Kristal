local actor, super = HookSystem.hookScript("kris")

function actor:init()
    super.init(self)

    TableUtils.merge(self.animations, {
        ["dance"]     = {"dance", 1/6, true},
        ["pirouette"] = {"pirouette", 4/30, true},
    }, false)

    TableUtils.merge(self.offsets, {
        ["dance"] = {0, 0},
        ["pirouette"] = {0, 0},
    }, false)
end

return actor