local DiamondMix, super = Class(Bullet)

function DiamondMix:init(x, y, dir)
    super.init(self, x, y, "battle/bullets/diamond_vert")
	
	self.alpha = 0
    self:fadeToSpeed(1, 0.1)
    self.collider = PolygonCollider(self, {{16, 11}, {18, 16}, {16, 21}, {14, 16}, {16, 11}})
    self.collidable = false

    self.tp = 2.5
	self.time_bonus = 2.5
	
    self.difficulty = 1
    self.times = 0
    self.type = 0
end

function DiamondMix:update()
    if self.collidable == false then
        if self.alpha < 1 then
            if self.type == 1 then
                self.physics.speed_y = 3
                self.physics.gravity = -0.5
            end
        else
            if self.type == 0 then
                if Game.battle.soul.y < self.y then
                    self.physics.speed_y = 1
                    self.physics.gravity = -0.2
                else
                    self.physics.speed_y = -2
                    self.physics.gravity = 1
                end
            end
            self.collidable = true
        end
    end

    if self.type == 0 then
        if self.physics.speed > 8 then
            self.physics.speed = 8
        end
    end
    
    if self.y > 500 then
        self:remove()
    end
    
    if self.y < -20 then
        self:remove()
    end

	super.update(self)
end

function DiamondMix:draw()
	if self.collidable == false then
		love.graphics.push()
		love.graphics.origin()
		Draw.draw(self.sprite.texture, self.x, self.y, 0, 3 - (self.alpha * 2), 3 - (self.alpha * 2), 16, 16)
		love.graphics.pop()
	end
	Draw.setColor(1,1,1,self.alpha)
	self.scale_x = 2 - self.alpha
	self.scale_y = 2 - self.alpha
	super.draw(self)
end

return DiamondMix