local actor, super = HookSystem.hookScript("ralsei")

function actor:init(style)
    super.init(self)
end

function actor:initChapter2()
    super.initChapter2(self)

    TableUtils.merge(self.animations, {
        ["dance"]               = {"dance", 1/6, true},
        ["pirouette"]           = {"pirouette", 4/30, true},
        ["nuzzle"]              = {"nuzzle", 1/10, false},
        ["sing"]                = {"sing", 1/5, true},
    }, false)

    TableUtils.merge(self.offsets, {
        ["dance"] = {0, 0},
        ["pirouette"] = {0, 0},
        ["nuzzle"] = {-1, 0},
        ["sing"] = {0, 0},
    }, false)
end

return actor
