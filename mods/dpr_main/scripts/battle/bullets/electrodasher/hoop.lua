local HoopBullet, super = Class(Bullet)

function HoopBullet:init(x, y)
    super.init(self, x, y)

    self.physics.direction = math.rad(180)
	
	self.hoop_top_tex = Assets.getTexture("battle/bullets/electrodasher/hoop_top")
	self.hoop_middle_tex = Assets.getFrames("battle/bullets/electrodasher/hoop_middle")
	
	self.hoop_top_y = 0
	self.hoop_bottom_y = 0
	self.hoop_siner = 0
	self.hoop_colliders = {}
	self.hoop_colliders[1] = Hitbox(self, -5, 2, 10, 5)
	self.hoop_colliders[2] = Hitbox(self, -5, -5, 10, 5)
	self.collider = ColliderGroup(self, self.hoop_colliders)
	
	self:setOrigin(0.5, 0.5)
end

function HoopBullet:update()
    super.update(self)
	self.hoop_siner = self.hoop_siner + DTMULT
	self.hoop_colliders[1] = Hitbox(self, -5, 2 + self.hoop_bottom_y, 10, 5)
	self.hoop_colliders[2] = Hitbox(self, -5, -5 + self.hoop_top_y, 10, 5)
end

function HoopBullet:draw()
    super.draw(self)
	Draw.draw(self.hoop_top_tex, 0, self.hoop_top_y, 0, 1, 1, 7, 9)
	Draw.draw(self.hoop_top_tex, 0, self.hoop_bottom_y, 0, 1, -1, 7, 9)
    love.graphics.stencil(function()
		love.graphics.push()
		love.graphics.origin()
        local last_shader = love.graphics.getShader()
        love.graphics.setShader(Kristal.Shaders["Mask"])
		Game.battle.soul:fullDraw(false)
        love.graphics.setShader(last_shader)
		love.graphics.pop()
    end, "replace", 1)
    love.graphics.setStencilTest("less", 1)
	love.graphics.setColor(0.5,0.5,0.5,1)
    Draw.pushScissor()
    Draw.scissor(-7, self.hoop_top_y, 14, self.hoop_bottom_y*2+1)
	Draw.drawWrapped(self.hoop_middle_tex[(math.floor(self.hoop_siner/4)-1)%#self.hoop_middle_tex+1], false, true, -7, self.hoop_top_y)
	Draw.drawWrapped(self.hoop_middle_tex[(math.floor(-self.hoop_siner/4)-1)%#self.hoop_middle_tex+1], false, true, 4, self.hoop_top_y)
    Draw.popScissor()
	love.graphics.setStencilTest()
	love.graphics.setColor(1,1,1,1)
end

return HoopBullet