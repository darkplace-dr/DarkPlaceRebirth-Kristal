local TeevieSpikes, super = Class(Event, "teevie_spikes")

function TeevieSpikes:init(data)
    super.init(self, data)
	
	self.sprite_up = data.properties["sprite"] or "world/events/teevie_quiz/spikes_up"
	self.sprite_down = data.properties["spritedown"] or "world/events/teevie_quiz/spikes_down"
	
	self.flag = data.properties["flag"]
	self.default = data.properties["default"]
	if self.default == nil then
		self.default = false
	end
	
	self.solid = false
	self:setSprite(self.sprite_down)
end

function TeevieSpikes:update()
	if self.flag then
		if Game:getFlag(self.flag, false) == true or Game:getFlag(self.flag, false) == false then
			if self.default then
				if Game:getFlag(self.flag, false) == false then
					self:setSprite(self.sprite_up)
				else
					self:setSprite(self.sprite_down)
				end
				self.solid = not Game:getFlag(self.flag, false)
			else
				if Game:getFlag(self.flag, false) == true then
					self:setSprite(self.sprite_up)
				else
					self:setSprite(self.sprite_down)
				end
				self.solid = Game:getFlag(self.flag, false)
			end
		end
	elseif self.default == true then
		self:setSprite(self.sprite_up)
		self.solid = true
	else
		self:setSprite(self.sprite_down)
		self.solid = false
	end
	super.update(self)
end

function TeevieSpikes:getDebugInfo()
	local info = super.getDebugInfo(self)
	if self.flag then
		table.insert(info, "Flag: "    .. self.flag)
	end
	return info
end

return TeevieSpikes