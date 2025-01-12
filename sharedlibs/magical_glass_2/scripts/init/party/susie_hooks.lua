Utils.hook(Registry.getPartyMember("susie"), "init", function(orig, self)
    orig(self)

    self.lw_stats = {
        health = 30,
        attack = 12,
        defense = 10,
        magic = 1
    }

    self.lw_weapon_default = "light/toothbrush"
    self.lw_armor_default = "light/bandage"
end)

Utils.hook(Registry.getPartyMember("susie"), "onLightLevelUp", function(orig, self, level)
    self.lw_stats = {
        health = 26 + level * 4,
        attack = 10 + level * 2,
        defense = 9 + math.ceil(level / 4),
        magic = 1 + math.ceil(level / 4),
    }

    if level >= self:getLightMaxLV() then
        self.lw_stats.health = 99
    end
end)