---@class FunnyText : Object
---@overload fun(...) : FunnyText
local FunnyText, super = Class(Object)

function FunnyText:init(texture, sound, x, y)
    self.texture = Assets.getFramesOrTexture("funnytext/"..texture)
    self.loop_texture = Assets.getFramesOrTexture("funnytext/"..texture.."_loop") or nil
    super.init(self, x, y, self.texture[1]:getWidth(), self.texture[1]:getHeight())
	self:setScale(0,0)
	self.ideal_scale_x = 1
	self.ideal_scale_y = 1
	self.sound = sound
	self.time = 0
	self.frame = 0
	self.shake = 1
	self.speed = 1
	self.looped = false
	self.lerp = nil
	self.in_dialogue = true
end

function FunnyText:onAdd(parent)
	super.onAdd(self, parent)
	self.x = self.x + self.texture[1]:getWidth()/2
	self.y = self.y + self.texture[1]:getHeight()/2
	self.lerp = Game.stage.timer:tween(10/30, self, {scale_x = self.ideal_scale_x, scale_y = self.ideal_scale_y}, "out-elastic")
	if Assets.getSound(self.sound) then
		Assets.playSound(self.sound)
	end
end

function FunnyText:update()
	super.update(self)
	self.time = self.time + (self.speed * DTMULT)

	self.frame = math.floor(self.time)
	-- Seems like this functionality isn't used in DELTARUNE but whatever
	if self.loop_texture and self.frame >= #self.texture and not self.looped then
		self.texture = self.loop_texture
		self.looped = true
		self.time = 0
	end
	if not self.in_dialogue then
		return
	end
	local dtext = self.parent or nil
	if dtext and not dtext:isTyping() then
		if self.lerp then
			Game.stage.timer:cancel(self.lerp)
			self.scale_x = self.ideal_scale_x
			self.scale_y = self.ideal_scale_y
		end
	end
end

function FunnyText:draw()
    Draw.draw(self.texture[(self.frame % #self.texture) + 1], Utils.random(-self.shake, self.shake), Utils.random(-self.shake, self.shake))
    super.draw(self)
end

return FunnyText