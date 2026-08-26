---@class Border.cliffside : ImageBorder
local MyBorder, super = Class(ImageBorder)

function MyBorder:init()
    super.init(self, "dev")
    self.fx_color = {Game.party[1]:getColor()}
	self.fx_color_con = 0
	self.fx_color_timer = 0
	if Game:getFlag("devDinerBorderState", nil) == nil then
		if Game.world.map.id == "floor2/dev/party" then
			Game:setFlag("devDinerBorderState", 1)
			Game:setFlag("devDinerBorderCol", Game:getFlag("devDinerBorderNewCol", self.fx_color))
		elseif Game.world.map.id == "floor2/dev/coffeeshop" then
			Game:setFlag("devDinerBorderState", 2)
			Game:setFlag("devDinerBorderCol", {0.13,0.7,0.3})
		else
			Game:setFlag("devDinerBorderState", 0)
			Game:setFlag("devDinerBorderCol", {0.3,0.19,1})
		end
		Game:setFlag("devDinerBorderNewCol", Game:getFlag("devDinerBorderCol", {0.3,0.19,1}))
	end
end

function MyBorder:draw()
	local curState = Game:getFlag("devDinerBorderState", 0)
	local curCol = Game:getFlag("devDinerBorderCol", {0.3,0.19,1})
	local newCol = Game:getFlag("devDinerBorderNewCol", {0.3,0.19,1})
    if Game.world.map.id == "floor2/dev/party" then
		if #Game.party >= 4 then
			if self.fx_color_con == 0 then
				self.fx_color = ColorUtils.mergeColor({Game.party[1]:getColor()}, {Game.party[2]:getColor()}, self.fx_color_timer)
				if self.fx_color_timer >= 1 then
					self.fx_color_timer = 0
					self.fx_color_con = 1
				end
			end
			if self.fx_color_con == 1 then
				self.fx_color = ColorUtils.mergeColor({Game.party[2]:getColor()}, {Game.party[3]:getColor()}, self.fx_color_timer)
				if self.fx_color_timer >= 1 then
					self.fx_color_timer = 0
					self.fx_color_con = 2
				end
			end
			if self.fx_color_con == 2 then
				self.fx_color = ColorUtils.mergeColor({Game.party[3]:getColor()}, {Game.party[4]:getColor()}, self.fx_color_timer)
				if self.fx_color_timer >= 1 then
					self.fx_color_timer = 0
					self.fx_color_con = 3
				end
			end
			if self.fx_color_con == 3 then
				self.fx_color = ColorUtils.mergeColor({Game.party[4]:getColor()}, {Game.party[1]:getColor()}, self.fx_color_timer)
				if self.fx_color_timer >= 1 then
					self.fx_color_timer = 0
					self.fx_color_con = 0
				end
			end
			self.fx_color_timer = MathUtils.approach(self.fx_color_timer, 1, 0.01*DTMULT)
		elseif #Game.party == 3 then
			if self.fx_color_con > 2 then self.fx_color_con = 0 end -- reset
			if self.fx_color_con == 0 then
				self.fx_color = ColorUtils.mergeColor({Game.party[1]:getColor()}, {Game.party[2]:getColor()}, self.fx_color_timer)
				if self.fx_color_timer >= 1 then
					self.fx_color_timer = 0
					self.fx_color_con = 1
				end
			end
			if self.fx_color_con == 1 then
				self.fx_color = ColorUtils.mergeColor({Game.party[2]:getColor()}, {Game.party[3]:getColor()}, self.fx_color_timer)
				if self.fx_color_timer >= 1 then
					self.fx_color_timer = 0
					self.fx_color_con = 2
				end
			end
			if self.fx_color_con == 2 then
				self.fx_color = ColorUtils.mergeColor({Game.party[3]:getColor()}, {Game.party[1]:getColor()}, self.fx_color_timer)
				if self.fx_color_timer >= 1 then
					self.fx_color_timer = 0
					self.fx_color_con = 0
				end
			end
			self.fx_color_timer = MathUtils.approach(self.fx_color_timer, 1, 0.01*DTMULT)
		elseif #Game.party == 2 then
			if self.fx_color_con > 1 then self.fx_color_con = 0 end -- reset
			if self.fx_color_con == 0 then
				self.fx_color = ColorUtils.mergeColor({Game.party[1]:getColor()}, {Game.party[2]:getColor()}, self.fx_color_timer)
				if self.fx_color_timer >= 1 then
					self.fx_color_timer = 0
					self.fx_color_con = 1
				end
			end
			if self.fx_color_con == 1 then
				self.fx_color = ColorUtils.mergeColor({Game.party[2]:getColor()}, {Game.party[1]:getColor()}, self.fx_color_timer)
				if self.fx_color_timer >= 1 then
					self.fx_color_timer = 0
					self.fx_color_con = 0
				end
			end
			self.fx_color_timer = MathUtils.approach(self.fx_color_timer, 1, 0.01*DTMULT)
		else
			self.fx_color = {Game.party[1]:getColor()}
		end
		if Kristal.Config["simplifyVFX"] then
			self.fx_color = {Game.party[1]:getColor()}
		end
		Game:setFlag("devDinerBorderState", 1)
		Game:setFlag("devDinerBorderNewCol", self.fx_color)
	elseif Game.world.map.id == "floor2/dev/coffeeshop" and curState ~= 2 then
		Game:setFlag("devDinerBorderState", 2)
		Game:setFlag("devDinerBorderNewCol", {0.13,0.7,0.3})
	elseif Game.world.map.id ~= "floor2/dev/party" and Game.world.map.id ~= "floor2/dev/coffeeshop" and curState ~= 0 then
		Game:setFlag("devDinerBorderState", 0)
		Game:setFlag("devDinerBorderNewCol", {0.3,0.19,1})
	end
	Game:setFlag("devDinerBorderCol", ColorUtils.mergeColor(curCol, newCol, 1 - (1 - (0.1 ^ DTMULT))))
    Draw.setColor(curCol, BORDER_ALPHA)
    super.draw(self)
end

function MyBorder:update()
    super.update(self)
end

return MyBorder