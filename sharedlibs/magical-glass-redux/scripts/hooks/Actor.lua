local Actor, super = HookSystem.hookScript(Actor)

function Actor:init()
    super.init(self)

    self.use_light_battler_sprite = false
    self.light_battler_parts = {}
end

function Actor:getWidth()
    if Game.battle and Game.battle.light and not Game.battle.ended and self.use_light_battler_sprite and self.light_battle_width then
        return self.light_battle_width
    else
        return super.getWidth(self)
    end
end

function Actor:getHeight()
    if Game.battle and Game.battle.light and not Game.battle.ended and self.use_light_battler_sprite and self.light_battle_height then
        return self.light_battle_height
    else
        return super.getHeight(self)
    end
end

function Actor:addLightBattlerPart(id, data)
    self.use_light_battler_sprite = true
    if type(data) == "string" then
        self.light_battler_parts[id] = {["create_sprite"] = self.path .. "/" .. data}
    else
        self.light_battler_parts[id] = data
    end
end

function Actor:getLightBattlerPart(part)
    return self.light_battler_parts[part]
end

function Actor:createLightBattleSprite(enemy)
    return LightEnemySprite(self, enemy)
end

return Actor