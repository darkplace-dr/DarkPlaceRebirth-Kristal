local Mustache2, super = Class(Sprite) --Sprite

function Mustache2:init(x, y)
    super.init(self, "effects/mustache2_1", x, y)
    self.alpha = 1
    self.scale_x = 2
    self.scale_y = 2
    self.timer = 0
end

function Mustache2:update()
    super.update(self)
    local ralsei =  Game.battle:getPartyBattler("ralsei")
    local enemy = Game.battle:getActiveEnemies()
    if(ralsei.is_down == true) then
        self:remove()
    end
    if(#enemy == 0) then
        self:remove()
    end
    if(self.timer <= 31) then
        self.timer = self.timer + 1
    end
    if(self.timer == 10) then
        self:setSprite("effects/mustache2_2")
    end
    if(self.timer == 20) then
        self:setSprite("effects/mustache2_3")
    end
    if(self.timer == 30) then
        self:setSprite("effects/mustache2_4")
    end

end

return Mustache2