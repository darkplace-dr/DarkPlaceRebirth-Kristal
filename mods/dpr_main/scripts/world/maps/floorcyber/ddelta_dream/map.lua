local Room1, super = Class(Map)

function Room1:init(world, data)
    super.init(self, world, data)
	self.siner = 0
	self.diamond_data = {
		{flag = "ddeltaDreamDiamondOddStone", item = "oddstone", x = 22, y = 0},
		{flag = false, item = nil, x = 0, y = 22},
		{flag = false, item = nil, x = 44, y = 22},
		{flag = false, item = nil, x = 22, y = 44},
	}
	self.diamond_sprites = {}
end

function Room1:onEnter()
    super.onEnter(self)
	self.diamond = self:getEvent("diamonds_symbol")
	for _, data in ipairs(self.diamond_data) do
		if Game:getFlag(data.flag, false) then
			local outline_sprite = Sprite("world/maps/cyber/ddelta_dream/diamond_outline_1", self.diamond.x + data.x, self.diamond.y + data.y)
			outline_sprite:setScale(2)
			outline_sprite:setLayer(self.diamond.layer + 0.002)
			self.world:addChild(outline_sprite)
			local active_sprite = Sprite("world/maps/cyber/ddelta_dream/diamond_outline_2", self.diamond.x + data.x, self.diamond.y + data.y)
			active_sprite:setScale(2)
			active_sprite:setLayer(self.diamond.layer + 0.003)
			self.world:addChild(active_sprite)
			local item_sprite = Sprite("world/maps/cyber/ddelta_dream/" .. data.item, self.diamond.x + data.x + 20, self.diamond.y + data.y + 20)
			item_sprite:setScale(2)
			item_sprite:setOrigin(0.5, 0.5)
			item_sprite:setLayer(self.diamond.layer + 0.001)
			self.world:addChild(item_sprite)
			table.insert(self.diamond_sprites, {sprite = outline_sprite, active_sprite = active_sprite, item_sprite = item_sprite, x = data.x, y = data.y})
		end
	end
	for _, follower in ipairs(Game.world.followers) do
		follower.visible = false
	end
end

function Room1:update()
    super.update(self)
	if self.diamond then
		self.siner = self.siner + DTMULT
		self.diamond.y = 400 + math.sin(self.siner / 10) * 8
		local dx, dy = self.diamond:getRelativePos(0, 0)
		if #self.diamond_sprites > 0 then
			for _, spr in ipairs(self.diamond_sprites) do
				spr.sprite.x = dx + spr.x * 2
				spr.sprite.y = dy + spr.y * 2
				spr.active_sprite.x = dx + spr.x * 2
				spr.active_sprite.y = dy + spr.y * 2
				spr.active_sprite.alpha = 0.3 + math.sin(self.siner / 5) * 0.3
				spr.item_sprite.x = dx + (spr.x * 2) + 40
				spr.item_sprite.y = dy + (spr.y * 2) + 40 - math.cos(self.siner / 10) * 4
			end
		end
		if Game.world.player then
			if MathUtils.dist(self.diamond.x, self.diamond.y, Game.world.player.x, Game.world.player.y) <= 80 then
			
			end
		end
	end
end

return Room1