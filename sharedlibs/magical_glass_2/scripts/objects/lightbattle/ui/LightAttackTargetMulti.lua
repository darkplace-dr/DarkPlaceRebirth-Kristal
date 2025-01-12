local LightAttackTargetMulti, super = Class(Object, "LightAttackTargetMulti")

function LightAttackTargetMulti:init(attackers, x, y)
    super.init(self, x, y)

    self.attackers = attackers
    
    self.bolt_target = -174

    self.start_x = 303

    self.bolt_y = -64

    self.stretch_base = 546

    self.miss_threshold = 114

    self.bolt_groups = {}

    self.sprite = Sprite("ui/lightbattle/dumbtarget_multi", -5)
    self.sprite:setOrigin(0.5)
    self:addChild(self.sprite)

    self.delay = 5
    self.started = false

    self.done = false
    self.cancelled = false

    self.fading = false
end

function LightAttackTargetMulti:setup()
    for i, battler in ipairs(self.attackers) do
        local x
        if i == 1 then
            x = Utils.pick({0, 30})
        else
            x = Utils.pick({30, 60, 90})
        end
        local group = LightAttackBoltGroupMulti(x, self.bolt_y, 1 / #Game.battle.party, self, battler)
        self:addChild(group)
        table.insert(self.bolt_groups, group)
    end
end

function LightAttackTargetMulti:getStretch(score)
    return (self.stretch_base - score) / self.stretch_base
end

function LightAttackTargetMulti:onKeyPressed(key)
    if not self.done and Input.isConfirm(key) then
        local closest, closest_groups = self:getClosestGroups()

        if closest then
            for _,group in ipairs(closest_groups) do
                local points, stretch = group:hit()

                if group.attacked then
                    local action = Game.battle:getActionBy(group.battler)
                    action.points = points
                    action.stretch = stretch
                    action.group = group

                    if Game.battle:processAction(action) then
                        Game.battle:finishAction(action)
                    end
                end
            end
        end
    end
end

function LightAttackTargetMulti:getClosestGroups()
    local distance
    local closest
    local closest_groups = {}

    for _,group in ipairs(self.bolt_groups) do
        if not group.attacked then
            distance = Utils.round(math.abs(group:getDistance()))
            if not closest then
                closest = distance
                table.insert(closest_groups, group)
            elseif distance == closest then
                table.insert(closest_groups, group)
            elseif distance < closest then
                closest = distance
                closest_groups = {group}
            end
        end
    end

    return closest, closest_groups
end

function LightAttackTargetMulti:update()
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
        if not self:allDone() then
            for _,group in ipairs(self.bolt_groups) do
                if not group.attacked and group:checkMiss() then
                    local points, stretch = group:miss()
                    if #group.bolts == 0 then
                        local action = Game.battle:getActionBy(group.battler)
                        action.points = points or 0
                        action.group = group
                        action.stretch = stretch
    
                        if not group:isMultibolt() then
                            action.missed = true
                        else
                            if action.points == 0 then
                                action.missed = true
                            end
                        end
    
                        if Game.battle:processAction(action) then
                            Game.battle:finishAction(action)
                        end
                    end

                    if self:allDone() then
                        self.done = true
                    end
                end
            end
        end
    end

    if self.cancelled or self.fading then
        self.sprite.scale_x = self.sprite.scale_x - 0.06 * DTMULT
        self.sprite.alpha = self.sprite.alpha - 0.08 * DTMULT

        if self.sprite.scale_x < 0.08 or self.sprite.alpha < 0.08 then
            self:remove()
        end
    end
end

function LightAttackTargetMulti:allDone()
    local finished_groups = 0
    for _,group in ipairs(self.bolt_groups) do
        if group.attacked then
            finished_groups = finished_groups + 1
        end
    end

    return (#self.bolt_groups == finished_groups)
end

function LightAttackTargetMulti:endAttack(cancelled)
    if cancelled then
        self.cancelled = true
    else
        self.fading = true
    end

    for _,group in ipairs(self.bolt_groups) do
        group:removeAllBolts()
    end

    self.done = true
end

function LightAttackTargetMulti:draw()
    super.draw(self)

    if DEBUG_RENDER then
        Draw.setColor(COLORS.red)
        Draw.rectangle("fill", self.bolt_target - 6, -self.sprite.height/2, 12, self.sprite.height)
    end
end

return LightAttackTargetMulti