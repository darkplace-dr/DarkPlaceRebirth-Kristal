local apartments, super = Class(Map)

function apartments:load()
	super.load(self)
	if (Game:getFlag("hometown_time", "day") == "morning" or Game:getFlag("hometown_time", "day") == "evening") then
		self.overlay = Rectangle(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
		if Game:getFlag("hometown_time", "day") == "morning" then
			self.overlay.color = ColorUtils.hexToRGB("#0D0538")
			self.overlay.alpha = 0.3 
		elseif Game:getFlag("hometown_time", "day") == "evening" then		
			self.overlay.color = ColorUtils.hexToRGB("#230023")
			self.overlay.alpha = 0.5 
		end
		self.overlay:setLayer(WORLD_LAYERS["below_ui"])
		self.overlay:setParallax(0)
		self.world:addChild(self.overlay)
	end
end

return apartments