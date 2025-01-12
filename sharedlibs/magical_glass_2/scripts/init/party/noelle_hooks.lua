Utils.hook(Registry.getPartyMember("noelle"), "init", function(orig, self)
    orig(self)

    self.lw_stats = {
        health = 20,
        attack = 10,
        defense = 10,
        magic = 4
    }

    self.lw_weapon_default = "light/ring"
    self.lw_armor_default = "light/wristwatch"
end)

Utils.hook(Registry.getPartyMember("noelle"), "onLightLevelUp", function(orig, self, level)
    self.lw_stats = {
        health = 16 + level * 4,
        attack = 8 + level * 2,
        defense = 9 + math.ceil(level / 4),
        magic = 2 + level * 2,
    }

    if level >= self:getLightMaxLV() then
        self.lw_stats.health = 99
    end
end)