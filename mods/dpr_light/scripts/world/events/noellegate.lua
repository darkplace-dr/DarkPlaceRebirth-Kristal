local NoelleGate, super = Class(Event)

function NoelleGate:init(data)
    super.init(self, data)

	self:setHitbox(0,0,0,0)
    self:setOrigin(0, 0)
	self:setScale(1)
    self.gate_closed = Assets.getTexture("world/maps/hometown/gate")
    self.gate_right = Assets.getTexture("world/events/noellegate/gate_right")
    self.gate_left = nil
	self.tree_mask = Assets.getTexture("world/events/noellegate/tree_mask")
	self.gate_open_mask = false
	
	self.gate_right_x = 0
	self.gate_right_y = 0
	self.leaves = {}
end

function NoelleGate:onLoad()
	super.onLoad(self)
	self.gate_left = Sprite("world/events/noellegate/gate_left", self.x, self.y)	
	self.gate_left.layer = Game.world:parseLayer("objects")
	self.gate_left:setOrigin(0, 0)
	self.gate_left:setScale(2)
	self.gate_left.alpha = false
	Game.world:addChild(self.gate_left)
	if Game:getFlag("noelle_gate_open", false) == true then
		self.gate_left.x = self.x - 60
		self.gate_left.y = self.y + 60
		self.gate_right_x = 60
		self.gate_right_y = -60
		self.gate_open_mask = true
		self.gate_left.visible = true
	end
end

function NoelleGate:spawnLeaf()
	local leaf_x_pos = self.x + 80 + Utils.random(24)
	local leaf = Sprite("world/events/noellegate/leaf")
	leaf:setOrigin(0, 0)
	leaf:setScale(2, 2)
	leaf.layer = self.layer + 0.01
	leaf.x = leaf_x_pos + 60 + Utils.random(20)
	leaf.y = self.y + 60
	leaf.timer = 0
	leaf.con = 0
	leaf.alpha = 0
	self.world.timer:tween(40/30, leaf, {x = leaf_x_pos + 70 + Utils.random(20), y = self.y + 120}, "out-sine")
	self.world.timer:tween(5/30, leaf, {alpha = 1}, "out-sine")
	table.insert(self.leaves, leaf)
	leaf:play(1/15, true)
	Game.world:addChild(leaf)
end

function NoelleGate:open(lock)
	local lock_mov = lock or false
	local moving_out_of_way = false
	if lock_mov == true then
		Game.lock_movement = true
	end
	Assets.playSound("wing")
	Assets.playSound("paper_surf")
	Game:setFlag("noelle_gate_open", true)
	self.gate_open_mask = true
	self.gate_left.visible = true
	self.world.timer:tween(40/30, self.gate_left, {x = self.x - 60, y = self.y + 60}, "out-sine")
	self.world.timer:tween(40/30, self, {gate_right_x = 60, gate_right_y = -60}, "out-sine")
	if Game.world.player.y >= 220 and Game.world.player.y <= 322 and math.max(508 - Game.world.player.x, 0) > 0 and not self.world:hasCutscene() then
		moving_out_of_way = true
		self.world:detachFollowers()
		self.world.timer:tween(40/30, Game.world.player, {x = Game.world.player.x + 60}, "out-sine")
		if Game.world.followers[1] and Game.world.followers[1].y >= 220 and Game.world.followers[1].y <= 322 and math.max(508 - Game.world.followers[1].x, 0) > 0 then
			self.world.timer:tween(40/30, Game.world.followers[1], {x = Game.world.followers[1].x + 60}, "out-sine")
		end
		if Game.world.followers[2] and Game.world.followers[2].y >= 220 and Game.world.followers[2].y <= 322 and math.max(508 - Game.world.followers[2].x, 0) > 0 then
			self.world.timer:tween(40/30, Game.world.followers[2], {x = Game.world.followers[2].x + 60}, "out-sine")
		end
	end
	self.world.timer:script(function(wait)
		wait(5/30)
		self:spawnLeaf()
		wait(8/30)
		self:spawnLeaf()
		wait(8/30)
		self:spawnLeaf()
	end)
	self.world.timer:after(40/30, function()
		if not self.world:hasCutscene() and moving_out_of_way then
			Game.world.player:interpolateFollowers()
			self.world:attachFollowersImmediate()
		end
		if lock == true then
			Game.lock_movement = false
		end
	end)
end

function NoelleGate:close(lock)
	local lock_mov = lock or false
	if lock_mov == true then
		Game.lock_movement = true
	end
	Assets.playSound("wing")
	Assets.playSound("paper_surf")
	Game:setFlag("noelle_gate_open", false)
	self.world.timer:tween(40/30, self.gate_left, {x = self.x, y = self.y}, "out-sine")
	self.world.timer:tween(40/30, self, {gate_right_x = 0, gate_right_y = 0}, "out-sine")self.world.timer:script(function(wait)
		wait(1/30)
		self:spawnLeaf()
		wait(8/30)
		self:spawnLeaf()
		wait(8/30)
		self:spawnLeaf()
	end)
	self.world.timer:after(40/30, function()
		self.gate_open_mask = false
		self.gate_left.visible = false
		if lock_mov == true then
			Game.lock_movement = false
		end
	end)
end

function NoelleGate:update()
	super.update(self)
	for _,leaf in ipairs(self.leaves) do
		leaf.timer = leaf.timer + DTMULT
		if leaf.timer >= 20 and leaf.con == 0 then
			leaf.con = 1
			Game.world.timer:tween(15/30, leaf, {alpha = 0}, "out-sine")
		end
		if leaf.timer >= 50 then
			leaf:remove()
			Utils.removeFromTable(self.leaves, leaf)
		end
	end
end

function NoelleGate:draw()
	super.draw(self)
	if self.gate_open_mask then
		love.graphics.stencil(function()
			local last_shader = love.graphics.getShader()
			love.graphics.setShader(Kristal.Shaders["Mask"])
			Draw.draw(self.tree_mask, 484 - self.x, 60 - self.y, 0, 2, 2)
			love.graphics.setShader(last_shader)
		end, "replace", 1)
		love.graphics.setStencilTest("less", 1)
		Draw.draw(self.gate_right, self.gate_right_x, self.gate_right_y, 0, 2, 2)
		love.graphics.setStencilTest()
	else
		Draw.draw(self.gate_closed, 0, 0)
	end
end

return NoelleGate