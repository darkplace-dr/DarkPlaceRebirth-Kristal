local StarsBG, super = Class(Object)

function StarsBG:init(color, back_color, fill)
    super.init(self)

    self.color = color
    self.back_color = back_color or color
    self.fill = fill or {0, 0, 0}
	self.offset = 0
    self.alpha = 0
    self.speed = 0.5
    self.size = 50
	self.layer = BATTLE_LAYERS["bottom"]
	self.alpha_fx = self:addFX(AlphaFX())
    self.image = Assets.getTexture("battle/star_background")

    self.fading_out = false
end

function StarsBG:isFading()
    return self.fading_out
end

function StarsBG:fadeOut()
    self.fading_out = true
end

function StarsBG:update()
    super.update(self)
	self.offset = self.offset + self.speed*DTMULT

    if self.offset > self.size*2 then
        self.offset = self.offset - self.size*2
    end

    if not self.fading_out then
        self.alpha = MathUtils.approach(self.alpha, 1, 0.1 * DTMULT)
    else
        self.alpha = MathUtils.approach(self.alpha, 0, 0.1 * DTMULT)

        if self.alpha <= 0 then
            self:remove()
        end
    end
	self.alpha_fx.alpha = self.alpha
end

function StarsBG:draw()
    super.draw(self)

    self:drawFill()
	self:drawBack()
	self:drawFront()
end

function StarsBG:drawFill()
    local r,g,b,a = unpack(self.fill)
    love.graphics.setColor(r,g,b, a or self.alpha)
    love.graphics.rectangle("fill", -8, -8, SCREEN_WIDTH+16, SCREEN_HEIGHT+16)
end

function StarsBG:drawBack()
    local r,g,b,a = unpack(self.back_color)
    love.graphics.setColor(r,g,b, a or self.alpha/2)
	for x = -100, 740, 50 do
		for y = -100, 580, 50 do
			love.graphics.draw(self.image, x + self.offset/2, y + self.offset/2 + 10)
		end
	end
end

function StarsBG:drawFront()
    local r,g,b,a = unpack(self.color)
    love.graphics.setColor(r,g,b, a or self.alpha)
	for x = 0, 740, 50 do
		for y = 0, 580, 50 do
			love.graphics.draw(self.image, x - self.offset, y - self.offset)
		end
	end
end

return StarsBG