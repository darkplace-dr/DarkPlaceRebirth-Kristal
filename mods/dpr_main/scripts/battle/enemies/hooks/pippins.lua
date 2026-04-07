local enemy, super = Class("pippins", true)

function enemy:onShortAct(battler, name)
    if name == "Standard" then
        if battler.chara.id == "jamm" then
            local dice1 = love.math.random(1, 6)
            local dice2 = love.math.random(1, 6)
            self:addMercy(math.floor((dice1 + dice2) * 100 / 12))
			Assets.playSound("wing")
			if(self.mercy >= 100) then
                self:setAnimation("spared")
            end
			self:shake(4)
            return "* Jamm rolled " .. dice1 .. " and " .. dice2 .. "!"
        end
    end
    
    return super.onShortAct(self, battler, name)
end

function enemy:onAct(battler, name)
    if name == "Standard" then
        if battler.chara.id == "jamm" then
            local dice1 = love.math.random(1, 6)
            local dice2 = love.math.random(1, 6)
            self:addMercy(math.floor((dice1 + dice2) * 100 / 12))
			Assets.playSound("wing")
			if(self.mercy >= 100) then
                self:setAnimation("spared")
            end
			self:shake(4)
            return "* Jamm rolled two dice...\n* He rolled " .. dice1 .. " and " .. dice2 .. "!"
        end
    end
    
    return super.onAct(self, battler, name)
end

return enemy
