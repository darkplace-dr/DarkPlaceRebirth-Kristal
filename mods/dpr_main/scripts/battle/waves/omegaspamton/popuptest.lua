local PopupTest, super = Class(Wave)

function PopupTest:init()
    super.init(self)
	
	self.time = -1
	self:setArenaSize(110, 240)
	self:setArenaPosition(300, 175)
end

function PopupTest:onStart()
	self:spawnObject(HiddenSoul(), Game.battle.soul.x, Game.battle.soul.y)
	self:spawnObject(PopupAd(), Game.battle.soul.x, Game.battle.soul.y)
	Kristal.showCursor()
end

function PopupTest:onEnd()
	Kristal.hideCursor()
end

return PopupTest