local DESSBABY, super = Class(Map)

function DESSBABY:onEnter()
	self.starbg = Object(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
	self.starbg:setLayer(Game.world:parseLayer("floor")-self.depth_per_layer/10)

	self.starbg.textures = Assets.getFramesOrTexture("ui/tv_starbgtile/rainbow/starbgtile")
	self.starbg.timer = 0

	self.starbg.alpha = 1
	self.starbg.starbg_height = 150

	self.starbg.draw = HookSystem.override(self.starbg.draw, function(orig, ...)
		orig(...)
		if not self.starbg.textures then return end
		self.starbg.timer = self.starbg.timer + DTMULT

		local frame = (math.floor(self.starbg.timer)%#self.starbg.textures)+1
		Draw.setColor(1, 0, 0, self.starbg.alpha)

		Draw.pushScissor()
		Draw.scissor(0, 0, SCREEN_WIDTH, self.starbg.starbg_height)
		Draw.drawWrapped(self.starbg.textures[frame], true, true, self.starbg.timer, self.starbg.timer, 0, 2, 2)
		Draw.popScissor()
	end)

	if not self.starbg.textures then
		print("Problem here with self.starbg")
	end

	Game.world:addChild(self.starbg)
end

return DESSBABY