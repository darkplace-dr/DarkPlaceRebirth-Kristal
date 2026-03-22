---@class CerobaDiamondBuff : Sprite
---@overload fun(...) : CerobaDiamondBuff
local CerobaDiamondBuff, super = Class(Sprite)

function CerobaDiamondBuff:init(x, y, callback)
    super.init(self, "effects/spells/ceroba/diamond", x or 0, y or 0)

    self:setOriginExact(24, 24) -- accuracy
    self:setScale(2)
	if Game.battle.soul.color ~= Game:getSoulColor() then -- awful color fix hack
		self:setColor(Game.battle.soul.color)
	else
		self:setColor(Game:getSoulColor())
	end
    self:play(1/15, false, function() self.fade_out = true end)
    self.buff_applied = false
    self.fade_out = false
    self.timer_active = false
    self.remove_delay_timer = 0
    Assets.playSound("ceroba_trap")
	self.callback_function = callback or nil
end

function CerobaDiamondBuff:onRemove(parent)
	super.onRemove(self, parent)
	if self.callback_function then
        self.callback_function()
		self.callback_function = nil
    end
end

function CerobaDiamondBuff:update()
    if self.frame >= 8 and not self.buff_applied then
        Game.pp = Game.pp + 1
        Game.pp = MathUtils.clamp(Game.pp, 0, 1)
        Game.battle.soul:addChild(SoulGlowEffect())
        Assets.playSound("equip_armor")
        self.buff_applied = true
    end

    if self.fade_out then
        self.alpha = self.alpha - 0.15 * DTMULT
        if self.alpha <= 0 and not self.timer_active then
            self.timer_active = true
        end
    end

    if self.remove_delay_timer >= 30 then
        self:remove()
    end

    if self.timer_active then
        self.remove_delay_timer = self.remove_delay_timer + DTMULT
    end

    super.update(self)
end

return CerobaDiamondBuff