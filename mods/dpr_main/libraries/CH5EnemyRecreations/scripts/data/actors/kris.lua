local actor, super = HookSystem.hookScript("kris")

function actor:init()
    super.init(self)

    TableUtils.merge(self.animations, {
        ["flutter"] = { "flutter", 1 / 7, true },
    }, false)

    TableUtils.merge(self.offsets, {
        ["flutter"] = { -10, -7 },
    }, false)
end

return actor
