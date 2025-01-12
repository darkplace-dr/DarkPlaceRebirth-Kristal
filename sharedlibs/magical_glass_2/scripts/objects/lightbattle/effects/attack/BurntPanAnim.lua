local BurntPanAnim, super = Class(Object, "BurntPanAnim")

function BurntPanAnim:init(x, y, crit, options)
    super.init(self, x, y)

    options = options or {}

    self.layer = BATTLE_LAYERS["above_ui"] + 5

    self.attack_sound = options["sound"] or "frypan"
    self.attack_sound_pitch = options["sound_pitch"] or 1

    self.crit = crit
    self.crit_sound = options["crit_sound"] or "saber3"

    self.after_func = options["after"] or function() end
    
    self:setColor(options["color"] or COLORS.white)

    self.played_crit_sound = false

    self.timer = 0
end

function BurntPanAnim:onAdd()
    local sound = Assets.stopAndPlaySound(self.attack_sound)
    sound:setPitch(self.attack_sound_pitch)

    local impact_sprite = BurntPanImpactAnim()
    self:addChild(impact_sprite)

    local stars = BurntPanStarAnim()
    self:addChild(stars)
end

function BurntPanAnim:update()
    self.timer = self.timer + DTMULT

    if self.crit then
        if self.timer >= 1 and not self.played_crit_sound then
            Assets.stopAndPlaySound(self.crit_sound)
            self.played_crit_sound = true
        end
    end

    if self.timer >= 25 then
        self.after_func()
        self:remove()
    end

    super.update(self)
end

return BurntPanAnim