local AttackBox, super = HookSystem.hookScript(AttackBox)

function AttackBox:init(battler, offset, index, x, y)
    super.init(self, battler, offset, index, x, y)

    if Kristal.getLibConfig("magical-glass", "light_world_dark_battle_color_override") and Game:isLight() then
        self.head_sprite:addFX(ShaderFX("color", {targetColor = MG_PALETTE["light_world_dark_battle_color"]}))
    end
end

return AttackBox