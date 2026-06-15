local Note, super = Class(Bullet)

function Note:init(x, y, index, dir, alpha)
    -- Last argument = sprite path
    self.image_index = index
    super.init(self, x, y, "battle/bullets/organikk/musical_notes_"..self.image_index)
    self.sprite:stop()
    --self.special = special
    --self.remove_offscreen = false
    self:setScale(1)
    self.layer = 800
	
    self.timer = 0
    self.go = false
    self.go2 = false
    self.siner = MathUtils.random(100)
    self.siner2 = 1
	
    self.d = dir
    self.ok = false
    if alpha then
        self:setScale(0)
    end
end

function Note:update()
    super.update(self)
    if self.go then
        self.siner = self.siner + (1 / 6) * DTMULT
        self.x = self.x + (math.sin(self.siner / 2)) * 3 * DTMULT

        self.timer = self.timer + (1 * DTMULT)
        if self.timer >= 2 then
            local aimg = AfterImage(self.sprite, 0.7, 0.07)
            Game.battle:addChild(aimg)
            self.timer = self.timer - 2
        end
    end

    if self.go2 then
        self.physics.direction = self.d
        if self.scale_x <= 1 and not self.ok then
            self.scale_x = self.scale_x + 0.2 * DTMULT
            self.scale_y = self.scale_y + 0.2 * DTMULT
        else
            self.ok = true
            self.scale_x = 1
            self.scale_y = 1
            if self.physics.speed <= 4 then
                self.physics.speed = math.min(self.physics.speed + 0.5 * DTMULT, 4)
            else
                self.physics.speed = 4
            end
        end

        self.siner2 = self.siner2 + (1 / 6) * DTMULT
        self.y = self.y + (math.sin(self.siner2 / 1)) * 2 * DTMULT

        self.timer = self.timer + (1 * DTMULT)
        if self.timer >= 2 then
            local aimg = AfterImage(self.sprite, 0.7, 0.07)
            Game.battle:addChild(aimg)
            self.timer = self.timer - 2
        end
    end
end

return Note