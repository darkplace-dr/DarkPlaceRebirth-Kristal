local ActionButton, super = HookSystem.hookScript(ActionButton)

function ActionButton:hasSpecial()
    if self.type == "act" then
        if Game.battle.encounter.unleash_threshold and Game.tension >= Game.battle.encounter.unleash_threshold then
			return true
		end
	end
	return super.hasSpecial(self)
end

return ActionButton