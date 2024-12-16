---@class MirrorEffect : Sprite
---@overload fun(...) : MirrorEffect
local MirrorEffect, super = Class(ActorSprite)

function MirrorEffect:init(x, y)
    super.init(self, "dess")

	--self.attached = Game:getPartyMember("dess")
	--self.texture = Assets.getTexture("party/dess/battle/idle_1")
    --self.texture = Assets.getTexture("party/"..self.attached.char.id.."/battle/idle")
	--self:set("party/"..self.attached.chara.id.."/battle/idle")
	
    --self.success = success == nil or success
    self.siner = 0
	self.alpha = 0
	self.x = x
	self.y = y
	self.scale_x = 2
	self.scale_y = 2
	self:setOrigin(0.5, 0.5)
end

function MirrorEffect:update()
	if not self.attached then
		self:remove()

	else --lol
    self.siner = self.siner + DTMULT
    if self.alpha < 0.25 then
		self.alpha = self.alpha + 0.05
	end
	self.x = self.attached.x + math.sin(self.siner / 8) * 20
	self.y = (self.attached.y + math.cos(self.siner / 8) * 20) - 50 -- I AM A LAZY PIECE OF SHIT!!!!!!!!! :]]]]]]]]]]]]]

    if not self.attached.chara.reflectNext then
		Assets.stopSound("mirrorbreak")
		Assets.playSound("mirrorbreak")
        self:remove()
    end

    super.update(self)
	end
end

--function MirrorEffect:draw()
    --local amp = 40
    --local x, y = math.sin(self.siner / 6) * amp, (math.cos(self.siner / 6) * amp) / 2

    --local r,g,b,a = self:getDrawColor()
    --Draw.setColor(r, g, b, a * 0.8)
    --Draw.draw(self.texture, x, y, 0, 3, 2, self.texture:getWidth(), self.texture:getHeight())

    --super.draw(self)
--end

return MirrorEffect