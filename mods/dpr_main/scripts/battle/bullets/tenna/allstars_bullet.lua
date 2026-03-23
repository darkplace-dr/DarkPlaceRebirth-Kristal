local AllStarsBullet, super = Class(Bullet)

function AllStarsBullet:init(x, y)
    super.init(self, x, y, "battle/bullets/tenna/allstars_star")
	
    self.collider = PolygonCollider(self, {
        {18, 24},
        {24, 18},
        {30, 24},
        {24, 30}
    })
    self.collider.collidable = false
	
    self:setOrigin(0.5, 0.5)
    self.scale_x = 0
    self.scale_y = 0
    self.alpha = 0
	
    self.element = 5
    self.destroy_on_hit = true
    self.tp = 2
	
    self.timer = 0
    self.laugh_timer = 0
    self.state = 0
    self.mydir = 0
    self.size = 0

    self.old_hitbox = false -- toggles an older hitbox for the stars
end

function AllStarsBullet:update()
    super.update(self)

    if self.old_hitbox == true then
        self.collider = PolygonCollider(self, {
            {8, 24},
            {10, 25},
            {20, 16},
            {21, 11},
            {22, 10},
            {26, 20},
            {29, 23},
            {42, 24},
            {34, 32},
            {34, 34},
            {39, 40},
            {39, 42},
            {31, 38},
            {27, 34},
            {25, 34},
            {24, 35},
            {12, 43},
            {11, 43},
            {15, 34},
            {12, 28}
        })
    end

    self.laugh_timer = self.laugh_timer + 0.25 * DTMULT
    if self.timer >= 140 and self.state == 0 then
        self.state = 1
    end

    if self.state == 0 then
        self.alpha = MathUtils.approach(self.alpha, 1, 0.05 * DTMULT)
    
        if self.alpha == 1 then
            self.collider.collidable = true
        end
    
        self.scale_x = MathUtils.approach(self.scale_x, self.size, 0.05 * DTMULT)
        self.scale_y = MathUtils.approach(self.scale_y, self.size, 0.05 * DTMULT)
    end

    if self.state == 1 then
        self.collider.collidable = false
        self.scale_x = MathUtils.approach(self.scale_x, 0, 0.05 * DTMULT)
        self.scale_y = MathUtils.approach(self.scale_y, 0, 0.05 * DTMULT)
        self.alpha = MathUtils.approach(self.alpha, 0, 0.05 * DTMULT)
    
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

    if DEBUG_RENDER then
        self.collider:draw(1,0,0)
    end
end

return AllStarsBullet