local MinekraftEvent, super = Class(Event,"minekraft")
local self = MinekraftEvent

function self:init(data)
    super.init(self,data)

    self.properties = data.properties or {}
    self.features = {
        gravity = false,
        force = 5,
        jumpForce = 3,
        speedY = 0,
        gui = false
    }
end

function self:getFeature(feature)
    return self.features[feature]
end

function self:setFeature(feature, value)
    self.features[feature] = value
end

function self:onEnter(player)
    if player ~= Game.world.player then return end
    for k,_ in pairs(self.features) do
        local f = self.properties[k]
        if f then
            self.features[k] = f
        end
    end
end

function self:applyGravity()
    local force = self:getFeature("force") * 60
    local speedY = self:getFeature("speedY")
    Game.world.player:moveY(force*DT,0)
    if speedY < 0 then
        speedY = speedY + 0.1
    end
    if speedY > 0 then
        speedY = speedY - 0.1
    end
    if true then return end
    if not Game.world.followers then return end
    for _,follower in pairs(Game.world.followers) do
        follower:moveY((force*speedY)*DT,0)
    end
    -- print("Gravity Applied!")
end

function self:jump()
    local force = self:getFeature("jumpForce")

    self:setFeature("speedY", force)
end

function self:tryJump()
    if not self:getFeature("gravity") then return end
    local speedY = self:getFeature("speedY")
    if speedY <= 0 then
        jump()
    end
end

function self:update()
    super.update(self)

    -- print("gravity = " .. tostring(self:getFeature("gravity")))
    if self:getFeature("gravity") then
        self:applyGravity()
    end
    if Game.world.player:getDirection() == 3 then
        self:tryjump()
    end
end

return self