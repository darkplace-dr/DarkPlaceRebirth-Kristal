local LightAttackBoltGroupSingle, super = Class(Object, "LightAttackBoltGroupSingle")

function LightAttackBoltGroupSingle:init(base_x, base_y, target, battler, start_active)
    super.init(self)

    self.target = target

    self.battler = battler
    self.weapon = self.battler.chara:getWeapon()

    self.start_position = self.weapon:getBoltStartOffset()
    self.multibolt_positions = self:processMultiboltPositions(self.weapon:getMultiboltVariance())
    self.relative_multibolt_variance = self.weapon.relative_multibolt_variance

    self.count = self.weapon:getBoltCount()
    self.direction = self.weapon:getBoltDirection()
    self.speed = math.abs(self.weapon:getBoltSpeed())
    self.acceleration = nil

    if self.direction == "left" then
        self.base_x = base_x + self.target.start_x_left
    elseif self.direction == "right" then
        self.base_x = base_x + self.target.start_x_right
    end
    self.base_y = base_y

    self.color = {self.battler.chara:getLightAttackBoltColor()}

    self.score = 0
    self.stretch = 0
    
    self.bolts = {}
    self:createBolts()

    self.active = start_active or true
    self.attacked = false
end

function LightAttackBoltGroupSingle:processMultiboltPositions(variance)
    if type(variance) == "table" then
        local positions = {}
        for _,ipos in ipairs(variance) do
            if type(ipos) == "table" then
                table.insert(positions, Utils.pick(ipos))
            elseif type(ipos) == "number" then
                table.insert(positions, ipos)
            end
        end
        return positions
    elseif type(variance) == "number" then
        return variance
    end
end

function LightAttackBoltGroupSingle:getCurrentBolt()
    if not self.attacked and #self.bolts > 0 then
        return self.bolts[1]
    end
end

function LightAttackBoltGroupSingle:isMultibolt()
    return self.count > 1
end

function LightAttackBoltGroupSingle:getDistance()
    return self:getCurrentBolt().x - self.target.bolt_target
end

function LightAttackBoltGroupSingle:getMultiboltDistance()
    return math.floor(self:getCurrentBolt().x / self.speed) - math.floor(self.target.bolt_target / self.speed)
end

function LightAttackBoltGroupSingle:checkMiss()
    if self:isMultibolt() then
        if self.direction == "left" and (self:getDistance() < -self.target.multi_miss_threshold) then
            return true
        elseif self.direction == "right" and (self:getDistance() > self.target.multi_miss_threshold) then
            return true
        end
    else
        if self.direction == "left" and (self:getDistance() < -self.target.miss_threshold) then
            return true
        elseif self.direction == "right" and (self:getDistance() > self.target.miss_threshold) then
            return true
        end
    end
    return false
end

function LightAttackBoltGroupSingle:createBolts()
    for i = 1, self.count do
        local bolt
        if self.direction == "left" then
            local bolt_x = self.base_x + self.start_position
            if i > 1 then
                if type(self.multibolt_positions) == "number" then
                    if self.relative_multibolt_variance then
                        bolt_x = self.bolts[i - 1].x + self.multibolt_positions
                    else
                        bolt_x = self.base_x + self.multibolt_positions
                    end
                elseif type(self.multibolt_positions) == "table" then
                    if self.relative_multibolt_variance then
                        bolt_x = self.bolts[i - 1].x + self.multibolt_positions[i - 1]
                    else
                        bolt_x = self.base_x + self.multibolt_positions[i - 1]
                    end
                end
            end

            bolt = LightAttackBolt(bolt_x, 1, nil, i > 1)
            bolt.y = self.base_y
            bolt.physics.speed_x = -self.speed
        elseif self.direction == "right" then
            local bolt_x = self.base_x - self.start_position
            if i > 1 then
                if type(self.multibolt_positions) == "number" then
                    if self.relative_multibolt_variance then
                        bolt_x = self.bolts[i - 1].x - self.multibolt_positions
                    else
                        bolt_x = self.base_x - self.multibolt_positions
                    end
                elseif type(self.multibolt_positions) == "table" then
                    if self.relative_multibolt_variance then
                        bolt_x = self.bolts[i - 1].x - self.multibolt_positions[i - 1]
                    else
                        bolt_x = self.base_x - self.multibolt_positions[i - 1]
                    end
                end
            end

            bolt = LightAttackBolt(bolt_x, 1, nil, i > 1)
            bolt.y = self.base_y
            bolt.physics.speed_x = self.speed
        end
        self.target:addChild(bolt)
        table.insert(self.bolts, bolt)
    end
end

function LightAttackBoltGroupSingle:removeAllBolts()
    for _,bolt in ipairs(self.bolts) do
        bolt:remove()
    end
    self.bolts = {}
end

function LightAttackBoltGroupSingle:hit()
    local score, stretch
    if self:isMultibolt() then
        score, stretch = self:hitMulti()
    else
        score, stretch = self:hitSingle()
    end

    local enemy = Game.battle:getActionBy(self.battler).target
    self.weapon:onLightBattleBoltHit(self.battler, enemy, self)

    return score, stretch
end

function LightAttackBoltGroupSingle:hitSingle() -- lmao
    local bolt = self:getCurrentBolt()
    local dist = math.floor(math.abs(self:getDistance()))

    self.score = math.max(1, dist)
    self.stretch = self.target:getStretch(self.score)

    bolt:flash()

    self.attacked = true
    
    return self.score, self.stretch
end

function LightAttackBoltGroupSingle:hitMulti()
    local bolt = self:getCurrentBolt()
    local dist = math.floor(math.abs(self:getMultiboltDistance()))
    
    self.score = self.score + self:evaluateMultiHit(dist)

    if self.score > 430 then
        self.score = self.score * 1.8
    end
    if self.score >= 400 then
        self.score = self.score * 1.25
    end

    bolt:burst()

    if dist < 1 then
        bolt.x = self.target.bolt_target
        Assets.stopAndPlaySound("victor")
        bolt.perfect = true
    elseif dist < 5 then
        Assets.stopAndPlaySound("hit")
        bolt:setColor(128/255, 1, 1)
    elseif dist < 28 then
        bolt:setColor(192/255, 0, 0)
    else
        bolt:setColor(192/255, 0, 0)
    end

    table.remove(self.bolts, 1)

    if #self.bolts > 0 then
        self:getCurrentBolt():activate()
    else
        self.attacked = true
    end

    return self.score, 1
end

function LightAttackBoltGroupSingle:evaluateMultiHit(dist)
    if dist < 1 then
        return 110
    elseif dist < 2 then
        return 90
    elseif dist < 3 then
        return 80 
    elseif dist < 4 then
        return 70
    elseif dist < 5 then
        return 50
    elseif dist < 10 then
        return 40
    elseif dist < 16 then
        return 20
    elseif dist < 22 then
        return 15
    elseif dist < 28 then
        return 10
    else
        return 10
    end
end

function LightAttackBoltGroupSingle:miss()
    local score
    if self:isMultibolt() then
        score = self:missMulti()
    else
        score = self:missSingle()
    end

    local enemy = Game.battle:getActionBy(self.battler).target
    self.weapon:onLightBattleBoltMiss(self.battler, enemy, self)

    return score
end

function LightAttackBoltGroupSingle:missSingle()
    self:getCurrentBolt():remove()
    table.remove(self.bolts, 1)
    
    self.attacked = true
end

function LightAttackBoltGroupSingle:missMulti()
    self:getCurrentBolt():fade()
    table.remove(self.bolts, 1)
    
    if #self.bolts > 0 then
        self:getCurrentBolt():activate()
    else
        self.attacked = true
    end

    return self.score, 1
end

return LightAttackBoltGroupSingle