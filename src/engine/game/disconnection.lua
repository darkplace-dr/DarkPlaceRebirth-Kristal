---@class Console : Object
---@overload fun(...) : Console
local Console, super = Class(Object)

function Console:init(texty)
    super.init(self, 0, 0)
	
	self.rect = Rectangle(0, 0, 640, 480)
	self.rect:setColor(0, 0, 0, 1)
	self:addChild(self.rect)
    
	self.disc_text = Text("No Device Connected", 0, 200, 640, 480, {font_size=64, align="center"})
	self:addChild(self.disc_text)
    
	self.desc_text = Text(texty or "Please connect your device.", 0, 480, 640, 480, {align="center"})
	self.desc_text.alpha = 0
	self:addChild(self.desc_text)
	
	Game.stage.timer:tween(3, self.desc_text, {alpha = 1})
	Game.stage.timer:tween(3, self.desc_text, {y = 270}, "out-cubic")
	
	self.music = Game:getActiveMusic()
	self.old_volume = self.music.volume
	self.music.volume = 0
end

function Console:onRemove(parent)
	self.music.volume = self.old_volume
end

return Console