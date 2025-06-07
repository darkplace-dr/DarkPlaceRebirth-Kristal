local Echo, super = Class(Spell, "echo")

function Echo:init()
    super.init(self)

    -- Display name
    self.name = "Echo"
    -- Name displayed when cast (optional)
    self.cast_name = nil

    -- Battle description
    self.effect = "Nothing\nto echo"
    -- Menu description
    self.description = "Echo a spell of one of your allies."

    -- TP cost
    self.cost = 70

    -- Target mode (ally, party, enemy, enemies, or none)
    self.target = "none"

    -- Tags that apply to this spell
    self.tags = {"echo"}
	
	self.current_spell = nil
	self.spells = {}
	self.spell_int = -1
end

function Echo:getCastMessage(user, target)
	if not self.current_spell then
		return "* "..user.chara:getName().."'s voice echoed aimlessly..."
	end
    return "* "..user.chara:getName().." echoed "..self.current_spell:getName().."!"
end

function Echo:onCast(user, target)
	if self.current_spell then
		return self.current_spell:onCast(user, target)
	end
	Game:giveTension(40)
end

return Echo