local TeevieSneakHead, super = Class(Event)

function TeevieSneakHead:init(data)
    super.init(self, data)
	
	local properties = data.properties or {}
	
	self.type = properties["type"] or "zapper"
	
    self:setSprite("world/npcs/"..self.type.."/couch_outline")
	self.sprite:setScale(Utils.pick({-2,2}),2)
	self.sprite:setOrigin(0.5, 1)
end

function TeevieSneakHead:onLoad()
	super.onLoad(self)
	
	if self:getFlag("killed", false) then
		self:remove()
	end
end

return TeevieSneakHead