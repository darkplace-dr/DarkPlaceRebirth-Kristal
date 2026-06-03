local BattleCutscene, super = HookSystem.hookScript(BattleCutscene)

function BattleCutscene:text(text, portrait, actor, options)
    super.text(self, Game.battle.light and ("[shake:" .. Mod.libs["magical-glass"].light_battle_shake_text .. "]" .. text) or text, portrait, actor, options)
end

return BattleCutscene