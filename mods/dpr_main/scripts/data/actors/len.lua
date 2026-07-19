---@type Actor
local actor, super = Class("len", true)

function actor:init(style)
    super.init(self, style)

    self.animations_jack = {
        ["battle/idle"]         = {"face/len/hoodless/face/neutral", 1/15, false, next="battle/blink", duration=TableUtils.pick({40/30, 75/30, 90/30})},

        ["battle/blink"]        = {self:getSpritePath() .. "/battle_jack/blink", 3/30, true, next="battle/idle", duration=12/30},
        ["battle/attack"]       = {"face/len/hoodless/face/dumb", 1/15, false, next="battle/attack_finish", duration=7/15},
        ["battle/attack_finish"]= {"face/len/hoodless/face/dumb", 1/15, false},
        ["battle/act"]          = {"face/len/hoodless/face/happy", 1/15, false, next="battle/act_finish", duration=9/15},
        ["battle/act_finish"]   = {"face/len/hoodless/face/happy", 1/15, false},
        ["battle/spell"]        = {"face/len/hoodless/face/happy", 1/15, true, next="battle/spell_finish", duration=8/15},
        ["battle/spell_finish"] = {"face/len/hoodless/face/happy", 1/15, false},
        ["battle/item"]         = {"face/len/hoodless/face/happy", 1/15, true, next="battle/item_finish", duration=6/12},
        ["battle/item_finish"]  = {"face/len/hoodless/face/happy", 1/15, false},
        ["battle/spare"]        = {"face/len/hoodless/face/happy", 1/15, true, next="battle/spare_finish", duration=8/15},
        ["battle/spare_finish"] = {"face/len/hoodless/face/happy", 1/15, false},

        ["battle/attack_ready"] = {"face/len/hoodless/face/dumb", 1/15, false},
        ["battle/act_ready"]    = {"face/len/hoodless/face/happy", 1/15, false},
        ["battle/spell_ready"]  = {"face/len/hoodless/face/happy", 1/15, false},
        ["battle/item_ready"]   = {"face/len/hoodless/face/happy", 1/15, false},
        ["battle/defend_ready"] = {"face/len/hoodless/face/neutral_closed", 1/15, false},

        ["battle/act_end"]      = {"face/len/hoodless/face/happy", 1/15, false, next="battle/idle", duration=4/15},

        ["battle/hurt"]         = {self:getSpritePath() .. "/battle_jack/hurt", 1/15, false, temp=true, duration=0.5},
        ["battle/defeat"]       = {self:getSpritePath() .. "/battle_jack/defeat", 1/15, false},

        ["battle/transition"]   = {"face/len/hoodless/face/neutral", 1/15, false},
        ["battle/intro"]        = {"face/len/hoodless/face/neutral", 1/15, true},
        ["battle/victory"]      = {"face/len/hoodless/face/neutral", 1/15, true},
    }
    -- Table of sprite offsets (indexed by sprite name)
    TableUtils.merge(self.offsets, {
        -- Battle offsets (jackenstein)
        ["battle_jack/idle"]   = {-14, -32},
        ["battle_jack/blink"]  = {-14, -32},
        ["battle_jack/act"]    = {-14, -32},
        ["battle_jack/attack"] = {-14, -32},
        ["battle_jack/defend"] = {-14, -32},
        ["battle_jack/item"]   = {-14, -32},
        ["battle_jack/spell"]  = {-14, -32},
        ["battle_jack/defeat"] = {-14, -32},
        ["battle_jack/hurt"]   = {-14, -32},
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

function actor:getSpritePath()
    if Game.battle and Game.battle.encounter.is_jackenstein then
        return ""
    else
        return super.getSpritePath(self)
    end
end

return actor