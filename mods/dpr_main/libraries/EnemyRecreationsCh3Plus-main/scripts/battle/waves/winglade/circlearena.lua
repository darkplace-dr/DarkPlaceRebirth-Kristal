local RotateAround, super = Class(Wave)

function RotateAround:init()
    super.init(self)
    self.time = 7
    self.attack_controllers = {}
    self.called_before_end = false
end

function RotateAround:onStart()
    local attackers = self:getAttackers()

    for _, attacker in ipairs(attackers) do
        local controller = WingladeCircle(attacker, self)
        Game.battle:addChild(controller)
        table.insert(self.attack_controllers, controller)
    end
end

function RotateAround:update()
    super.update(self)

    if Game.battle.wave_length - Game.battle.wave_timer < 18 / 30 and not self.called_before_end then
        self.called_before_end = true
        local attackers = self:getAttackers()

        for _, attacker in ipairs(attackers) do
            for _, controller in ipairs(self.attack_controllers) do
                controller:beforeEnd()
            end
        end
    end
end

function RotateAround:beforeEnd()
    local attackers = self:getAttackers()

    for _, attacker in ipairs(attackers) do
        for _, controller in ipairs(self.attack_controllers) do
            controller:beforeEnd()
        end
    end
end

return RotateAround