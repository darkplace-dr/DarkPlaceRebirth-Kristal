local ToughGloveAttack, super = Class(Object, "ToughGloveAttack")

function ToughGloveAttack:init(weapon, battler, enemy, damage, options)
    super.init(self)

    options = options or {}

    self.battler = battler
    self.weapon = weapon

    self.enemy = enemy
    self.damage = damage

    self.light_punch_sound = options["sound"] or "punchweak"
    self.light_punch_sound_pitch = options["sound_pitch"] or 1

    self.strong_punch_sound = options["sound"] or "punchstrong"
    self.strong_punch_sound_pitch = options["sound_pitch"] or 1

    self.after_func = options["after"] or self.finishAttack

    self:setColor(options["color"] or COLORS.white)

    self.press_indicator = nil
    
    self.done = false

    self.punches = 0
    self.max_punches = options["punches"] or 4

    self.timer = options["punch_time"] and options["punch_time"] * 30 or 60
end

function ToughGloveAttack:onAdd()
    Input.clear("confirm")

    local x, y = self.enemy:getRelativePos(self.enemy.width / 2, self.enemy.height / 2, Game.battle)
    self.press_indicator = PressIndicator(x, y)
    Game.battle:addChild(self.press_indicator)
end

function ToughGloveAttack:update()
    if self.timer ~= 0 then
        self.timer = Utils.approach(self.timer, 0, DTMULT)

        if not self.done then
            if Input.pressed("confirm") then
                if self.press_indicator then
                    self.press_indicator:remove()
                end

                if self.punches + 1 < self.max_punches then
                    self:punch()
                else
                    self:finisherPunch()
                end

                Input.clear("confirm")
            end
        end
    else
        self:finishAttack()
    end

    super.update(self)
end

function ToughGloveAttack:punch()
    self.punches = self.punches + 1

    local sound = Assets.stopAndPlaySound(self.light_punch_sound)
    sound:setPitch(self.light_punch_sound_pitch)

    local x, y = self.enemy:getRelativePos(Utils.random(self.enemy.width), Utils.random(self.enemy.height))
    local punch = Sprite("effects/attack/regfist", x, y)
    punch:setOrigin(0.5)
    punch.layer = BATTLE_LAYERS["above_ui"] + 5
    punch.inherit_color = true
    punch:play(2/30, false, function() punch:remove() end)
    Game.battle:addChild(punch)
end

function ToughGloveAttack:finisherPunch()
    self.punches = self.punches + 1
    
    local after_func = function()
        self:finishAttack()
    end

    local x, y = self.enemy:getRelativePos(self.enemy.width / 2, self.enemy.height / 2)
    local finisher = HyperAttackAnim(x, y, {sound = self.strong_punch_sound, after = after_func, color = self.color})
    Game.battle:addChild(finisher)
end

function ToughGloveAttack:finishAttack()
    if not self.done then
        self.done = true

        if self.press_indicator then
            self.press_indicator:remove()
        end

        local new_damage = math.ceil(self.damage * (self.punches / self.max_punches))
        self.enemy:hurt(new_damage, self.battler)

        Game.battle:finishActionBy(self.battler)

        self:remove()
    end
end

return ToughGloveAttack