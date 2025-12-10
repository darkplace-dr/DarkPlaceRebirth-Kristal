local AllStarsBullet, super = Class(Bullet)

function AllStarsBullet:init(x, y)
    super.init(self, x, y, "battle/bullets/tenna/allstars_star")
	
    self.collider = Hitbox(self, 18, 18, 13, 13)
    self.collider.collidable = false
	
    self:setOrigin(0.5, 0.5)
    self.scale_x = 0
    self.scale_y = 0
    self.alpha = 0
	
    self.element = 5
    self.destroy_on_hit = true
    self.tp = 5
	
    self.timer = 0
    self.laugh_timer = 0
    self.state = 0
    self.mydir = 0
    self.size = 0
end

function AllStarsBullet:update()
    super.update(self)

    self.laugh_timer = self.laugh_timer + 0.25 * DTMULT
    if self.timer >= 140 and self.state == 0 then
        self.state = 1
    end

    if self.state == 0 then
        self.alpha = Utils.approach(self.alpha, 1, 0.05 * DTMULT)
    
        if self.alpha == 1 then
            self.collider.collidable = true
        end
    
        self.scale_x = Utils.approach(self.scale_x, self.size, 0.05 * DTMULT)
        self.scale_y = Utils.approach(self.scale_y, self.size, 0.05 * DTMULT)
    end

    if self.state == 1 then
        self.collider.collidable = false
        self.scale_x = Utils.approach(self.scale_x, 0, 0.05 * DTMULT)
        self.scale_y = Utils.approach(self.scale_y, 0, 0.05 * DTMULT)
        self.alpha = Utils.approach(self.alpha, 0, 0.05 * DTMULT)
    
        if self.scale_x == 0 then
            self:remove()
        end
    end
end

function AllStarsBullet:draw()
    super.draw(self)

    local laugh = Assets.getFrames("battle/bullets/tenna/allstars_laugh")
    local frames = math.floor(self.laugh_timer) % #laugh + 1
	
    Draw.draw(laugh[frames], 1, 1, 0, 1, 1)
end

return AllStarsBullet