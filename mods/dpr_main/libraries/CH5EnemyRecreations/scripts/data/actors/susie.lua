local actor, super = HookSystem.hookScript("susie")

function actor:init()
    super.init(self)

    TableUtils.merge(self.animations, {
        ["battle/idle_embarrassed"] = { "lookaway_embarrass", 1 / 5, true },
        ["battle/idle_dizzy"] = { "dizzy", 1 / 5, true },
    }, false)

    TableUtils.merge(self.offsets, {
        ["lookaway_embarrass"] = { -22, -1 },
        ["dizzy"] = { -26, 2 },
    }, false)
end

return actor
