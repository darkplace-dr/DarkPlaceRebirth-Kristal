local JackensteinLightUp, super = Class(Wave)

function JackensteinLightUp:update()
    -- Code here gets called every frame

    super.update(self)
end

function JackensteinLightUp:init()
	super.init(self)
	self.time = 900/30
	self.has_arena = false
	local center_x, center_y = SCREEN_WIDTH/2, (SCREEN_HEIGHT - 155)/2 - 10
	self.soul_start_x =  center_x
	self.soul_start_y = center_y + 90 + 5
end

function JackensteinLightUp:onArenaEnter()
	super.onArenaEnter(self)
	Game.battle.timer:tween(7/30, Game.battle.soul, {alpha = 0}, "in-linear")
	Game.battle.timer:after(7/30, function()
		local light = Game.battle.encounter.heartlight
		light.radius = 60
		light.biggerrad = 15
		light.supercharged = true
		if Game.battle.encounter.light_up then
			light.radius = light.radius + 5
		end
		light:setLayer(BATTLE_LAYERS["below_soul"])
		local center_x, center_y = SCREEN_WIDTH/2, (SCREEN_HEIGHT - 155)/2 - 10
		self.arena = self:spawnObject(GhostHouseArena(center_x, center_y, "lightup"))
		self.darkness = self:spawnObject(DarknessOverlayJackenstein(self.arena.x, self.arena.y, self.arena.width, self.arena.height))
		self.darkness:setLayer(BATTLE_LAYERS["above_soul"])
		self.sprite_fade = self:spawnSprite("battle/ghost_house/lightup_bg", self.arena.x, self.arena.y)
		self.sprite_fade:setOrigin(0.5, 0.5)
		self.sprite_fade:setScale(2,2)
		self.sprite_fade:setColor(0,0,0)
		self.sprite_fade:setLayer(BATTLE_LAYERS["above_bullets"])
		self.sprite_fade:fadeOutSpeedAndRemove(0.025)
		Game.battle:swapSoul(JackensteinSoul())
		Game.battle.soul.alpha = 1
		Game.battle.soul.x = self.arena.x
		Game.battle.soul.y = self.arena.y + 90 + 5
		Game.battle.soul.speed = Game.battle.soul.speed
		self:createLayout()
	end)
	return true
end

function JackensteinLightUp:createLayout()
	local x = self.arena.left
	local y = self.arena.top
	local xc = self.arena.x
	local yc = self.arena.y
	local hx = Game.battle.soul.x
	local hy = Game.battle.soul.y
	local debug_draw = false
	-- WALLS
	self:spawnObject(Solid(debug_draw, x+0*2, y+0*2, 2*2, 102*2))
	self:spawnObject(Solid(debug_draw, x+0*2, y+0*2, 136*2, 2*2))
	self:spawnObject(Solid(debug_draw, x+134*2, y+0*2, 2*2, 102*2))
	self:spawnObject(Solid(debug_draw, x+0*2, y+100*2, 136*2, 2*2))
	self:spawnObject(Solid(debug_draw, x+2*2, y+34*2, 6*2, 2*2))
	self:spawnObject(Solid(debug_draw, x+39*2, y+34*2, 14*2, 2*2))
	self:spawnObject(Solid(debug_draw, x+83*2, y+34*2, 14*2, 2*2))
	self:spawnObject(Solid(debug_draw, x+128*2, y+34*2, 6*2, 2*2))
	self:spawnObject(Solid(debug_draw, x+2*2, y+67*2, 6*2, 2*2))
	self:spawnObject(Solid(debug_draw, x+39*2, y+67*2, 14*2, 2*2))
	self:spawnObject(Solid(debug_draw, x+83*2, y+67*2, 14*2, 2*2))
	self:spawnObject(Solid(debug_draw, x+128*2, y+67*2, 6*2, 2*2))
	self:spawnObject(Solid(debug_draw, x+45*2, y+2*2, 2*2, 5*2))
	self:spawnObject(Solid(debug_draw, x+45*2, y+29*2, 2*2, 12*2))
	self:spawnObject(Solid(debug_draw, x+45*2, y+62*2, 2*2, 12*2))
	self:spawnObject(Solid(debug_draw, x+45*2, y+96*2, 2*2, 4*2))
	self:spawnObject(Solid(debug_draw, x+89*2, y+2*2, 2*2, 5*2))
	self:spawnObject(Solid(debug_draw, x+89*2, y+29*2, 2*2, 12*2))
	self:spawnObject(Solid(debug_draw, x+89*2, y+62*2, 2*2, 12*2))
	self:spawnObject(Solid(debug_draw, x+89*2, y+96*2, 2*2, 4*2))
	-- JACKOLANTERN
	local pumpkin_x = xc
	local pumpkin_y = yc - 160
	self:spawnBullet("jackenstein/jackolantern_merciful", pumpkin_x, pumpkin_y)
end

function JackensteinLightUp:beforeEnd()
	if Game.battle.soul then
		Game.battle:swapSoul(Soul())
	end
	return false
end

return JackensteinLightUp