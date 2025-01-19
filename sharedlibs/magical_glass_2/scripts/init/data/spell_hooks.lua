Utils.hook(Spell, "init", function(orig, self)
    orig(self)
    self.light_cast_name = nil
end)

Utils.hook(Spell, "getLightBattleCastName", function(orig, self, user, target)
    return self.light_cast_name or self:getName()
end)

Utils.hook(Spell, "getLightBattleCastMessage", function(orig, self, user, target)
    return "* " .. user.chara:getName() .. " cast " .. self:getLightBattleCastName() .. "!"
end)

Utils.hook(Spell, "onLightBattleSelect", function(orig, self, user, target) end)
Utils.hook(Spell, "onLightBattleDeselect", function(orig, self, user, target) end)

Utils.hook(Spell, "onLightBattleStart", function(orig, self, user, target)
    Game.battle:battleText(self:getLightBattleCastMessage(user, target))
    local result = self:onLightBattleCast(user, target)
    if result or result == nil then
        Game.battle:finishActionBy(user)
    end
end)

Utils.hook(Spell, "onLightBattleCast", function(orig, self, user, target) end)