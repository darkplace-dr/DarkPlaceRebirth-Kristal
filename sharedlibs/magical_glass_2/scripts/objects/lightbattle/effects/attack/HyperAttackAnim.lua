local HyperAttackAnim, super = Class(Sprite, "HyperAttackAnim")

function HyperAttackAnim:init(x, y, texture, options)
    options = options or {}
    if type(texture) == "table" then
        options = texture
        texture = nil
    end

    super.init(self, texture or "effects/attack/hyperfist", x, y)

    self.layer = BATTLE_LAYERS["above_ui"] + 5

    self.attack_sound = options["sound"] or "punchstrong"
    self.attack_sound_pitch = options["sound_pitch"] or 1

    self.crit = options["crit"]
    self.crit_sound = options["crit_sound"] or "saber3"

    self.shake = options["shake"] or true

    self.after_func = options["after"] or function() end

    self:setOrigin(0.5)
    self:setColor(options["color"] or COLORS.white)
end

function HyperAttackAnim:onAdd()
    local sound = Assets.stopAndPlaySound(self.attack_sound)
    sound:setPitch(self.attack_sound_pitch)
    
    if self.crit then
        Assets.stopAndPlaySound(self.crit_sound)
    end

    self:play(2/30, false, function()
        self.after_func()
        self:remove()
    end)

    if self.shake then
        Game.battle:shakeCamera(3, 3, 2)
    end
end

function HyperAttackAnim:update()
    self:move(-2 * DTMULT, -2 * DTMULT)
    self:move(Utils.random(4) * DTMULT, Utils.random(4) * DTMULT)

    super.update(self)
end

return HyperAttackAnim