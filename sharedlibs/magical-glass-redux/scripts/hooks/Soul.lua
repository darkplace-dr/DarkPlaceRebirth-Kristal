local Soul, super = HookSystem.hookScript(Soul)

function Soul:init(x, y, color)
    super.init(self, x, y, color)

    self.speed = Game.battle.soul_speed
    if not Kristal.getLibConfig("magical-glass", "light_world_dark_battle_tension") and Game:isLight() then
        self.graze_collider.collidable = false
    end
end

function Soul:update()
    self.speed = Game.battle.soul_speed

    super.update(self)
end

function Soul:setMonsterSoul(value)
    if self.sprite then
        if value == true then
            self.sprite:setSprite("player/monster/heart_dodge")
        elseif value == false then
            self.sprite:setSprite("!player/heart_dodge")
        else
            self.sprite:setSprite("player/heart_dodge")
        end
    end
    if self.graze_sprite then
        if value == true then
            self.graze_sprite.texture = Assets.getTexture("player/monster/graze")
        elseif value == false then
            self.graze_sprite.texture = Assets.getTexture("!player/graze")
        else
            self.graze_sprite.texture = Assets.getTexture("player/graze")
        end
    end
end

return Soul