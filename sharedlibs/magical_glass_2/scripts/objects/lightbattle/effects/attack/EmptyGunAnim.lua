local EmptyGunAnim, super = Class(Object, "EmptyGunAnim")

function EmptyGunAnim:init(x, y, crit, options)
    super.init(self, x, y)

    options = options or {}

    self.layer = BATTLE_LAYERS["above_ui"] + 5

    self.attack_sound = options["sound"] or "gunshot"
    self.attack_sound_pitch = options["sound_pitch"] or 1

    self.crit = crit
    self.crit_sound = options["crit_sound"] or "saber3"

    self.after_func = options["after"] or function() end

    self:setColor(options["color"] or COLORS.white)

    self.stab_sprite = nil

    self.stars_spawned = false
    self.rings_spawned = false
    self.after_func_called = false

    self.timer = 0
end

function EmptyGunAnim:onAdd()
    local sound = Assets.stopAndPlaySound(self.attack_sound)
    sound:setPitch(self.attack_sound_pitch)

    self.stab_sprite = Sprite("effects/attack/gunshot_stab")
    self.stab_sprite:setScale(2)
    self.stab_sprite:setOrigin(0.5)
    self.stab_sprite.inherit_color = true
    self.stab_sprite:play(2/30, true)
    self:addChild(self.stab_sprite)
end

function EmptyGunAnim:update()
    self.timer = self.timer + DTMULT

    if not self.stars_spawned and self.timer >= 6 then
        self.stab_sprite:remove()

        local stars = EmptyGunStarAnim()
        stars.layer = 5
        self:addChild(stars)

        self.stars_spawned = true
    end

    if not self.rings_spawned and self.timer >= 7 then
        local ring_anim = EmptyGunRingAnim()
        ring_anim.layer = 3
        self:addChild(ring_anim)

        if self.crit then
            Assets.stopAndPlaySound(self.crit_sound)
        end

        self.rings_spawned = true
    end

    if not self.after_func_called and self.timer >= 24 then
        self.after_func()
        self.after_func_called = true
    end

    if self.timer >= 25 then
        self:remove()
    end

    super.update(self)
end

return EmptyGunAnim