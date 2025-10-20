local SharpshootHud, super = Class(Object)

function SharpshootHud:init()
    super.init(self, 0, 0)

	self.ammo = 30
	self.sharpshootlength = 0
	self.stopshooting = 0
	
	self.font = Assets.getFont("main")
	self.heart = Assets.getTexture("player/sharpshoot_heart")
	self.hourglass = Assets.getTexture("ui/hourglass")
end

function SharpshootHud:draw()
	love.graphics.setColor(1,1,1,1)
	love.graphics.setFont(self.font)
	love.graphics.print("AMMO", SCREEN_WIDTH/2-self.font:getWidth("AMMO")/2, 10)
	love.graphics.print(tostring(self.ammo).." x", SCREEN_WIDTH/2-15-self.font:getWidth(tostring(self.ammo).." x")/2, 43)
	Draw.draw(self.heart, SCREEN_WIDTH/2+26-10, 62-10)
	local b = 180 - (self.sharpshootlength * 0.911)
	if self.sharpshootlength < 180 then
		love.graphics.setColor(0,1,1,1)
		love.graphics.rectangle("fill", 240, 290, b, 10)
		love.graphics.setColor(1,1,1,1)
		Draw.draw(self.hourglass, 240-18, 295-18, 0, 2, 2)
	end
	love.graphics.setColor(1,1,1,1)
	super.draw(self)
end

return SharpshootHud