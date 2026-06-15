local ActionBox, super = HookSystem.hookScript(ActionBox)

function ActionBox:init(x, y, index, battler)
    super.init(self, x, y, index, battler)

    if Kristal.getLibConfig("magical-glass", "light_world_dark_battle_color_override") and Game:isLight() then
        self.head_sprite:addFX(ShaderFX("color", {targetColor = MG_PALETTE["light_world_dark_battle_color"]}))
    end

    self.hp_karma_sprite = false
end

function ActionBox:update()
    super.update(self)

    if Game.battle.encounter.karma_mode then
        if not self.hp_karma_sprite then
            self.hp_sprite:setSprite("ui/hp_kr")
            self.hp_karma_sprite = true
        end
    else
        if self.hp_karma_sprite then
            self.hp_sprite:setSprite("ui/hp")
            self.hp_karma_sprite = false
        end
    end
end

return ActionBox