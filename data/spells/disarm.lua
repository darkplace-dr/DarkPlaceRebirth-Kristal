local spell, super = Class(Spell, "disarm")

function spell:init()
    super.init(self)

    -- Display name
    self.name = "Disarm"

    -- Battle description
    self.effect = "Disarm\nEnemy"
    -- Menu description
    self.description = "Attempts to disarm an enemy. Depends on their weapon grip."
    -- Check description
    self.check = "Attempts to disarm an enemy. Depends on their weapon grip."

    -- TP cost
    self.cost = 72

    -- Target mode (ally, party, enemy, enemies, or none)
    self.target = "enemy"

    -- Tags that apply to this spell
    self.tags = {"Disarm"}
end

function spell:getCastMessage(user, target)
	local text = {"* "..user.chara:getName().." attempted to disarm "..target.name.."..."}
	success, reason = target:attemptDisarm()
	if success then
		target.disarmed = true
		target:onDisarm()
	end
	table.insert(text, reason)
    return text
end

function spell:getLightCastMessage(user, target)
    local text = {"* "..user.chara:getName().." attempted to disarm "..target.name.."..."}
	success, reason = target:attemptDisarm()
	if success then
		target.disarmed = true
		target:onDisarm()
	end
	table.insert(text, reason)
    return text
end

return spell
