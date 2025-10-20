local LightFairy, super = Class(Object)

function LightFairy:init(x, y)
    super.init(self, x, y)
	
    self.sprite = Assets.getFrames("world/events/lightfairy")

    self.siner = Utils.random(6000)
    self.sinx = (Utils.random(15) + 18)
    self.siny = (Utils.random(15) + 18)
	
    self.period = (0.5 + Utils.random(1))
    self.speed = 0.1
    self.factor = 1
end

function LightFairy:update()
    super.update(self)

    self.x = self.x + (math.sin((self.siner / self.sinx)) * self.period) * DTMULT
    self.y = self.y + (math.sin((self.siner / self.siny)) * self.period) * DTMULT
    self.siner = self.siner + DTMULT
end

function LightFairy:draw()
    super.draw(self)

    local image_alpha = (math.sin((self.siner / 26)) * self.factor)
	local frame = math.floor(self.siner / 10) % #self.sprite + 1
	local image_scale = (3 + math.sin((self.siner / 12)))
	
	Draw.setColor(1, 1, 1, image_alpha)
    Draw.draw(self.sprite[frame], self.x, self.y, 0, image_scale, image_scale)
end

return LightFairy