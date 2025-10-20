local GigaPipisBomb, super = Class(Object)

function GigaPipisBomb:init(x, y)
    super.init(self, x, y)
	
    self.sprite = Sprite("battle/bullets/omegaspamton/pipis/gigapipis_bomb")
	self.sprite:setScale(2,2)
	self:addChild(self.sprite)
	self:setOrigin(0.5, 1)
    self.text = Text("59", 71*2, 85*2, 52, 20, {font = "bignumbers"})
	self.text.color = COLORS["red"]
    self:addChild(self.text)
end

function GigaPipisBomb:update()
    super.update(self)
end

return GigaPipisBomb