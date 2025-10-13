local Eye, super = Class(Sprite) --Sprite

function Eye:init(x, y)
    super.init(self, "effects/eye_1", x, y)
    self.alpha = 1
    self.scale_x = 2
    self.scale_y = 2
    self.timer = 0
end

function Eye:update()
    super.update(self)
    local kris =  Game.battle:getPartyBattler("kris")
    local enemy = Game.battle:getActiveEnemies()
    if(#enemy == 0) then
        self:remove()
    end
    if(kris.is_down == true) then
        self:remove()
    end
    if(self.timer <= 31) then
        self.timer = self.timer + 1
    end
    if(self.timer == 10) then
        self:setSprite("effects/eye_2")
    end
    if(self.timer == 20) then
        self:setSprite("effects/eye_3")
    end
    if(self.timer == 30) then
        self:setSprite("effects/eye_4")
    end

end

return Eye