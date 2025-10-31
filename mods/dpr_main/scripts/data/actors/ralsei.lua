local actor, super = Class("ralsei", true)

function actor:init(style)
    super.init(self, style)

    self.animations_jack = {
        ["battle/idle"]         = {"battle_jack/idle", 1/15, false, next="battle/blink", duration=TableUtils.pick({40/30, 75/30, 90/30})},

        ["battle/blink"]         = {"battle_jack/blink", 3/30, true, next="battle/idle", duration=12/30},
        ["battle/attack"]       = {"battle_jack/attack", 1/15, false, next="battle/attack_finish", duration=7/15},
        ["battle/attack_finish"] = {"battle_jack/attack", 1/15, false},
        ["battle/act"]          = {"battle_jack/act", 1/15, false, next="battle/act_finish", duration=9/15},
        ["battle/act_finish"]   = {"battle_jack/act", 1/15, false},
        ["battle/spell"]        = {"battle_jack/spell", 1/15, true, next="battle/spell_finish", duration=8/15},
        ["battle/spell_finish"] = {"battle_jack/spell", 1/15, false},
        ["battle/item"]         = {"battle_jack/item", 1/15, true, next="battle/item_finish", duration=6/12},
        ["battle/item_finish"]  = {"battle_jack/item", 1/15, false},
        ["battle/spare"]        = {"battle_jack/spare", 1/15, true, next="battle/spare_finish", duration=8/15},
        ["battle/spare_finish"] = {"battle_jack/spare", 1/15, false},

        ["battle/attack_ready"] = {"battle_jack/attack", 1/15, false},
        ["battle/act_ready"]    = {"battle_jack/act", 1/15, false},
        ["battle/spell_ready"]  = {"battle_jack/spell", 1/15, false},
        ["battle/item_ready"]   = {"battle_jack/item", 1/15, false},
        ["battle/defend_ready"] = {"battle_jack/defend", 1/15, false},

        ["battle/act_end"]      = {"battle_jack/act", 1/15, false, next="battle/idle", duration=4/15},

        ["battle/hurt"]         = {"battle_jack/hurt", 1/15, false, temp=true, duration=0.5},
        ["battle/defeat"]       = {"battle_jack/defeat", 1/15, false},

        ["battle/transition"]   = {"battle_jack/idle", 1/15, false},
        ["battle/intro"]        = {"battle_jack/idle", 1/15, true},
        ["battle/victory"]      = {"battle_jack/idle", 1/15, true},
    }
    -- Table of sprite offsets (indexed by sprite name)
    TableUtils.merge(self.offsets, {
        -- Battle offsets (jackenstein)
        ["battle_jack/idle"] = {0, 0},
        ["battle_jack/blink"] = {0, 0},
        ["battle_jack/act"] = {0, 0},
        ["battle_jack/attack"] = {0, 0},
        ["battle_jack/defend"] = {0, 0},
        ["battle_jack/item"] = {0, 0},
        ["battle_jack/spell"] = {0, 0},
        ["battle_jack/defeat"] = {0, 0},
        ["battle_jack/hurt"] = {0, 0},
    }, false)
end

function actor:getAnimation(anim)
	if Game.battle and Game.battle.encounter.is_jackenstein and self.animations_jack[anim] ~= nil then
		if anim == "battle/idle" then
			self.animations_jack[anim].duration = TableUtils.pick({40/30, 75/30, 90/30})
		end
        return self.animations_jack[anim] or nil
    else
        return super.getAnimation(self, anim)
    end
end

return actor