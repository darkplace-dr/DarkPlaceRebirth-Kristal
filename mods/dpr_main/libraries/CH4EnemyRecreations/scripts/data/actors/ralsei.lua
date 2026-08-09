local actor, super = HookSystem.hookScript("ralsei")

function actor:init(style)
    super.init(self)
end

function actor:initChapter2()
    super.initChapter2(self)

    TableUtils.merge(self.animations, {
        ["pirouette"]           = {"pirouette", 4/30, true},
        ["nuzzle"]              = {"nuzzle", 1/10, false},
        ["sing"]                = {"sing", 1/5, true},
    }, false)

    TableUtils.merge(self.offsets, {
        ["pirouette"] = {1, -1},
        ["nuzzle"] = {-1, 0},
        ["sing"] = {2, -2},
    }, false)
end

return actor
