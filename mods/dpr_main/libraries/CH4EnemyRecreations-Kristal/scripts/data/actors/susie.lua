local actor, super = HookSystem.hookScript("susie")

function actor:init(style)
    super.init(self)

    TableUtils.merge(self.animations, {
        ["dance"]            = {"dance", 1/6, true},
        ["sing"]             = {"sing", 1/5, true},
        ["pirouette"]        = {"pirouette", 4/30, true},
        ["attack_unarmed"]   = {"battle/attack_unarmed", 1/15, false},
        ["heal_charge"]      = {"heal_charge", 1/10, false, next="heal_charge_loop"},
        ["heal_charge_loop"] = {"heal_charge_loop", 1/10, true},
        ["heal_end"]         = {"heal_end", 1/10, false},
        ["heal_end_short"]   = {"heal_end", 1/10, false, nil, frames={1,2,3,4,5,6,7,8,9}}, -- gets cut short by something???
    }, false)

    TableUtils.merge(self.offsets, {
        ["crouch"] = {-3, 10},

        ["dance"] = {-3, -1},
        ["sing"] = {-21, -7},
        ["pirouette"] = {-3, -1},
        ["battle/attack_unarmed"] = {-21, -24},
        ["heal_charge"] = {-17, -14},
        ["heal_charge_loop"] = {-17, -14},
        ["heal_end"] = {-17, -14},
    }, false)
end

return actor