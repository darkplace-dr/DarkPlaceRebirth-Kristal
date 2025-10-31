local JackensteinTest, super = Class(Wave)

function JackensteinTest:update()
    -- Code here gets called every frame

    super.update(self)
end

function JackensteinTest:init()
	super.init(self)
	self.time = 999999/30 -- YOUR TAKING TOO LONG
	self.has_arena = false
	local center_x, center_y = SCREEN_WIDTH/2, (SCREEN_HEIGHT - 155)/2 - 10
	self.soul_start_x =  center_x - 112 + 5
	self.soul_start_y = center_y + 41 + 5
	self.pumpkin_x = SCREEN_WIDTH/2
	self.pumpkin_y = SCREEN_HEIGHT/2 - 160
end

function JackensteinTest:onArenaEnter()
	super.onArenaEnter(self)
	Game.battle.timer:tween(7/30, Game.battle.soul, {alpha = 0}, "in-linear")
	Game.battle.timer:after(7/30, function()
		local center_x, center_y = SCREEN_WIDTH/2, (SCREEN_HEIGHT - 155)/2 - 10
		self.arena = self:spawnObject(GhostHouseArena(center_x, center_y, "starter"))
		self.darkness = self:spawnObject(DarknessOverlayJackenstein(self.arena.x, self.arena.y, self.arena.width, self.arena.height))
		self.darkness:setLayer(BATTLE_LAYERS["above_soul"])
		self.sprite_fade = self:spawnSprite("battle/ghost_house/starter_bg", self.arena.x, self.arena.y)
		self.sprite_fade:setOrigin(0.5, 0.5)
		self.sprite_fade:setScale(2,2)
		self.sprite_fade:setColor(0,0,0)
		self.sprite_fade:setLayer(BATTLE_LAYERS["above_bullets"])
		self.sprite_fade:fadeOutSpeedAndRemove(0.025)
		Game.battle:swapSoul(JackensteinSoul())
		Game.battle.soul.alpha = 1
		Game.battle.soul.x = self.arena.x - 112 + 5
		Game.battle.soul.y = self.arena.y + 41 + 5
		if not Game.battle.encounter.scaredy_cat then
			Game.battle.soul.speed = Game.battle.soul.speed / 2
		end
		self:createLayout()
	end)
	return true
end

function JackensteinTest:createLayout()
	local x = self.arena.left
	local y = self.arena.top
	local xc = self.arena.x
	local yc = self.arena.y
	local hx = Game.battle.soul.x
	local hy = Game.battle.soul.y
	local debug_draw = false
	-- WALLS
	self:spawnObject(Solid(debug_draw, x+10*2, y+56*2, 2*2, 31*2))
	self:spawnObject(Solid(debug_draw, x+10*2, y+56*2, 62*2, 2*2))
	self:spawnObject(Solid(debug_draw, x+10*2, y+85*2, 140*2, 2*2))
	self:spawnObject(Solid(debug_draw, x+54*2, y+28*2, 2*2, 28*2))
	self:spawnObject(Solid(debug_draw, x+54*2, y+28*2, 52*2, 2*2))
	self:spawnObject(Solid(debug_draw, x+104*2, y+28*2, 2*2, 28*2))
	self:spawnObject(Solid(debug_draw, x+39*2, y+58*2, 2*2, 8*2))
	self:spawnObject(Solid(debug_draw, x+39*2, y+77*2, 2*2, 8*2))
	self:spawnObject(Solid(debug_draw, x+70*2, y+58*2, 2*2, 8*2))
	self:spawnObject(Solid(debug_draw, x+70*2, y+77*2, 2*2, 8*2))
	self:spawnObject(Solid(debug_draw, x+88*2, y+56*2, 62*2, 2*2))
	self:spawnObject(Solid(debug_draw, x+88*2, y+58*2, 2*2, 8*2))
	self:spawnObject(Solid(debug_draw, x+88*2, y+77*2, 2*2, 8*2))
	self:spawnObject(Solid(debug_draw, x+119*2, y+58*2, 2*2, 8*2))
	self:spawnObject(Solid(debug_draw, x+119*2, y+77*2, 2*2, 8*2))
	self:spawnObject(Solid(debug_draw, x+148*2, y+58*2, 2*2, 14*2))
	-- LOCK
	local lock = self:spawnObject(GhostHouseLock(xc+141, yc+46, 2, 3.2, "solid_bar_end", 2, 0))
	lock:setLayer(self.arena.layer + 3)
	--DOTS
	for linex = 0, 150, 36 do
		self:spawnObject(GhostHouseDot(hx+40+linex-5, hy+3-5))
	end
	for liney = 12, 27, 24 do
		self:spawnObject(GhostHouseDot(xc, yc-12+liney, hy+3-5))
	end
	-- JACKOLANTERN TRIGGER
	self:spawnObject(GhostHouseTrigger(xc-60, yc+16, 3*40, 1*40, false))
	-- KEY
	self:spawnObject(GhostHouseKey(xc, yc-26))
	-- EXIT
	self:spawnObject(GhostHouseExit(lock.x + 8, lock.y + 8, 2, 8*4))
end

function JackensteinTest:beforeEnd()
	if Game.battle.soul then
		Game.battle:swapSoul(Soul())
	end
	return false
end

return JackensteinTest