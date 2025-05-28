---@class Border.cliffside : ImageBorder
local MyBorder, super = Class(ImageBorder)

function MyBorder:init()
    super.init(self, "dev")
	if Game:getFlag("devDinerBorderState", nil) == nil then
		if Game.world.map.id == "floor2/dev/party" then
			Game:setFlag("devDinerBorderState", 1)
			Game:setFlag("devDinerBorderCol", Game.party[1].color)
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
		Game:setFlag("devDinerBorderState", 1)
		Game:setFlag("devDinerBorderNewCol", Game.party[1].color)
	elseif Game.world.map.id == "floor2/dev/coffeeshop" and curState ~= 2 then
		Game:setFlag("devDinerBorderState", 2)
		Game:setFlag("devDinerBorderNewCol", {0.13,0.7,0.3})
	elseif Game.world.map.id ~= "floor2/dev/party" and Game.world.map.id ~= "floor2/dev/coffeeshop" and curState ~= 0 then
		Game:setFlag("devDinerBorderState", 0)
		Game:setFlag("devDinerBorderNewCol", {0.3,0.19,1})
	end
	Game:setFlag("devDinerBorderCol", Utils.mergeColor(curCol, newCol, 0.1*DTMULT))
    Draw.setColor(curCol, BORDER_ALPHA)
    super.draw(self)
end

function MyBorder:update()
    super.update(self)
end

return MyBorder