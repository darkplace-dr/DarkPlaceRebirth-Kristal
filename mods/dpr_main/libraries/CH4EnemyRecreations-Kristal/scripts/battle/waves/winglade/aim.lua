local WingladeAimAttack, super = Class(Wave)

function WingladeAimAttack:init()
    super.init(self)
    self.time = 7
    self.attack_controllers = {}
    self.called_before_end = false
end

function WingladeAimAttack:onStart()
    local attackers = self:getAttackers()

    for _, attacker in ipairs(attackers) do
        local controller = WingladeAim(attacker, self)
        Game.battle:addChild(controller)
        -- Kristal.Console:log(Utils.dump(controller))
        table.insert(self.attack_controllers, controller)
    end
end

function WingladeAimAttack:update()
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

function WingladeAimAttack:beforeEnd()
    local attackers = self:getAttackers()

    for _, attacker in ipairs(attackers) do
        for _, controller in ipairs(self.attack_controllers) do
            controller:beforeEnd()
        end
    end
end

return WingladeAimAttack