local BasicAttackAnim, super = Class(Sprite, "BasicAttackAnim")

function BasicAttackAnim:init(x, y, texture, stretch, options)
    super.init(self, texture or "effects/attack/strike", x, y)

    options = options or {}

    self.layer = BATTLE_LAYERS["above_ui"] + 5

    self.stretch = stretch
    if Game.battle.allow_party then
        self.stretch = nil
    end

    self.attack_sound = options["sound"] or "laz_c"
    self.attack_sound_pitch = options["sound_pitch"] or 1

    self.crit = crit
    self.crit_sound = options["crit_sound"] or "criticalswing"

    self.after_func = options["after"] or function() end

    self:setColor(options["color"] or MagicalGlass.PALETTE["player_attack"])
    self:setOrigin(options["origin"] or 0.5)
end

function BasicAttackAnim:onAdd()
    local sound = Assets.stopAndPlaySound(self.attack_sound)
    sound:setPitch(self.attack_sound_pitch)

    if self.crit then
        Assets.stopAndPlaySound(self.crit_sound)
    end

    local speed
    if self.stretch then
        speed = (self.stretch / 4) / 1.6 -- probably isn't accurate
        self:setScale((self.stretch * 2) - 0.5)
    else
        speed = 2/30
    end

    self:play(speed, false, function()
        self.after_func()
        self:remove()
    end)
end

return BasicAttackAnim