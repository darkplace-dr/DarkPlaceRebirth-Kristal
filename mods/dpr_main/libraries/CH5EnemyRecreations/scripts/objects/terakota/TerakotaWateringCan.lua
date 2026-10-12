local TerakotaWateringCan, super = Class(Sprite)

function TerakotaWateringCan:init(x, y)
    super.init(self, "battle/bullets/terakota/wateringcan", x, y)

    self:setScale(1)
    self:setOriginExact(14, 17)

    self.timer = 0
    self.con = 0
    self.slower = false
    self.alpha = 0
end

function TerakotaWateringCan:update()
    super.update(self)

    if Game.battle.soul then
        if Input.down("cancel") then
        else
            if Input.down("right") then
                idealangle = -20;
                image_xscale = -1;
            end
            
            if Input.down("left") then
                idealangle = 20;
                image_xscale = 1;
            end
        end
        
        if Game.battle.soul then
            local hx, hy = Game.battle.soul:getRelativePos()
            self:setLayer(BATTLE_LAYERS["soul"] - 2)
            
            if self.scale_x == -1 then
                self.x = hx + 16
            end
            
            if self.scale_x == 1 then
                self.x = hx + 5
            end
            
            self.y = hy - 0
        end
        
        local idealangle = 0
        local idealimagealpha = 0.7
        self.rotation = MathUtils.lerp(self.rotation, -math.rad(self.idealangle), 0.25 * DTMULT)
        
        if self.alpha < 1 then
            self.alpha = self.alpha + 0.1 * DTMULT
        end
    else
        self.alpha = -0.4
    end
end

return TerakotaWateringCan