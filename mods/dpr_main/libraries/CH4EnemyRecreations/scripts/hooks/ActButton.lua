local ActButton, super = HookSystem.hookScript(ActButton)

function ActButton:hasSpecial()
    if Game.battle.encounter.unleash_threshold and Game.tension >= Game.battle.encounter.unleash_threshold then
		return true
	end
	return super.hasSpecial(self)
end

return ActButton