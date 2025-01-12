local LightAttackTargetSingle, super = Class(Object, "LightAttackTargetSingle")

function LightAttackTargetSingle:init(attacker, x, y)
    super.init(self, x, y)

    self.attacker = attacker
    
    self.bolt_target = 0

    self.start_x_left = 303
    self.start_x_right = -303

    self.bolt_y = -64
    
    self.stretch_base = 546

    self.miss_threshold = 280
    self.multi_miss_threshold = 2

    self.bolt_group = nil

    self.sprite = Sprite("ui/lightbattle/dumbtarget")
    self.sprite:setOrigin(0.5)
    self:addChild(self.sprite)

    self.delay = 1
    self.started = false

    self.done = false
    self.cancelled = false

    self.fading = false
end

function LightAttackTargetSingle:setup()
    self.bolt_group = LightAttackBoltGroupSingle(0, self.bolt_y, self, self.attacker)
    self:addChild(self.bolt_group)
end

function LightAttackTargetSingle:getStretch(score)
    return (self.stretch_base - score) / self.stretch_base
end

function LightAttackTargetSingle:onKeyPressed(key)
    if not self.done and Input.isConfirm(key) then
        if self.bolt_group then
            local points, stretch = self.bolt_group:hit()
            if self.bolt_group.attacked then
                if self.bolt_group:isMultibolt() then
                    self.fading = true
                end

                local action = Game.battle:getActionBy(self.bolt_group.battler)
                action.points = points
                action.stretch = stretch
                action.group = self.bolt_group

                if Game.battle:processAction(action) then
                    Game.battle:finishAction(action)
                end

                self.done = true
            end
        end
    end
end

function LightAttackTargetSingle:update()
    if self.delay ~= 0 then
        self.delay = Utils.approach(self.delay, 0, DTMULT)
    else
        if not self.started then
            self.started = true
            self:setup()
        end
    end

    super.update(self)

    if self.started and not self.done then
        if not self.bolt_group.attacked then
            if self.bolt_group:checkMiss() then
                local points, stretch = self.bolt_group:miss()
                if #self.bolt_group.bolts == 0 then
                    local action = Game.battle:getActionBy(self.bolt_group.battler)
                    action.points = points or 0
                    action.group = self.bolt_group
                    action.stretch = stretch

                    if not self.bolt_group:isMultibolt() then
                        action.missed = true
                    else
                        if action.points == 0 then
                            action.missed = true
                        end
                        self.fading = true
                    end

                    if Game.battle:processAction(action) then
                        Game.battle:finishAction(action)
                    end

                    self.done = true
                end
            end
        end
    end

    if self.cancelled or self.fading then
        if not self.bolt_group:isMultibolt() then
            self.sprite.scale_x = self.sprite.scale_x - 0.06 * DTMULT
        end
        self.sprite.alpha = self.sprite.alpha - 0.08 * DTMULT

        if self.sprite.scale_x < 0.08 or self.sprite.alpha < 0.08 then
            self:remove()
        end
    end
end

function LightAttackTargetSingle:endAttack(cancelled)
    self.done = true

    if cancelled then
        self.cancelled = true
    else
        self.fading = true
    end

    self.bolt_group:removeAllBolts()
end

function LightAttackTargetSingle:draw()
    super.draw(self)

    if DEBUG_RENDER then
        Draw.setColor(COLORS.red)
        Draw.rectangle("fill", self.bolt_target - 6, -self.sprite.height/2, 12, self.sprite.height)
    end
end

return LightAttackTargetSingle