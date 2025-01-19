local TornNotebookAnim, super = Class(Object, "TornNotebookAnim")

function TornNotebookAnim:init(x, y, crit, options)
    super.init(self, x, y)

    options = options or {}

    self.layer = BATTLE_LAYERS["above_ui"] + 5

    self.attack_sound = options["sound"] or "notebook_attack"
    self.attack_sound_pitch = options["sound_pitch"] or 0.9

    self.hit_sound = options["hit_sound"] or "punchstrong"
    self.hit_sound_pitch = options["hit_sound"] or 1

    self.crit = crit
    self.crit_sound = options["crit_sound"] or "saber3"

    self.after_func = options["after"] or function() end

    self:setColor(options["color"] or COLORS.white)

    self.notebook_sprite = nil
    self.notebook_siner = 0
    self.notebook_hit = false

    self.timer = 0
end

function TornNotebookAnim:onAdd()
    local sound = Assets.stopAndPlaySound(self.attack_sound)
    sound:setPitch(self.attack_sound_pitch)

    self.notebook_sprite = Sprite("effects/attack/notebook_attack")
    self.notebook_sprite:setScale(2)
    self.notebook_sprite:setOrigin(0.5)
    self.notebook_sprite.inherit_color = true
    self:addChild(self.notebook_sprite)
end

function TornNotebookAnim:update()
    self.timer = self.timer + DTMULT
    self.notebook_siner = self.notebook_siner + DTMULT

    if self.notebook_sprite then
        if self.timer < 15 then
            self.notebook_sprite.scale_x = (math.cos(self.notebook_siner / 2) * 2)
        elseif self.timer > 15 then
            if not self.notebook_hit then
                self.notebook_sprite:setScale(2)

                Assets.stopAndPlaySound(self.hit_sound)
                if self.crit then
                    Assets.stopAndPlaySound(self.crit_sound)
                end

                self.notebook_sprite:setAnimation({"effects/attack/frypan_impact", 1/30, true})
                self.notebook_hit = true
            else
                self.notebook_sprite:setScale(self.notebook_sprite:getScale() + 0.5 * DTMULT)
                
                if self.notebook_sprite:getScale() > 4 then
                    self.notebook_sprite.alpha = self.notebook_sprite.alpha - 0.3 * DTMULT
                end

                if self.notebook_sprite.alpha < 0.1 then
                    self.notebook_sprite:remove()
                end
            end
        end
    end

    if self.timer >= 27 then
        self.after_func()
        self:remove()
    end

    super.update(self)
end

return TornNotebookAnim