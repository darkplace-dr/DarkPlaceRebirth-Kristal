local PipisDefusal, super = Class(Wave)

function PipisDefusal:init()
    super.init(self)
	
	self.time = -1
	self:setArenaSize(110, 240)
	self:setArenaPosition(230, 175)
	self.soul_start_y = 175 + 90
	Game.battle.encounter.small_soul = true
	self.pipis = nil
	self.pipis_sign = nil
	self.has_text = true
	self.defused = false
end

function PipisDefusal:createLayout()
	local arena = Game.battle.arena
	local x = arena.left
	local y = arena.top
	local xc = arena.x
	local yc = arena.y
	local hx = Game.battle.soul.x
	local hy = Game.battle.soul.y
	-- WALLS
	self:spawnObject(Solid(true, x, y+180, 36, 4))
	self.door = self:spawnObject(Solid(true, x+36, y+180, 38, 4))
	self:spawnObject(Solid(true, x+74, y+180, 36, 4))
	self:spawnObject(Solid(true, x+28, y+120, 82, 4))
	self:spawnObject(Solid(true, x, y+60, 82, 4))
	self.switch = self:spawnObject(GigaPipisSwitch(x+28, y+25))
	self.switch:setLayer(BATTLE_LAYERS["below_soul"])
end

function PipisDefusal:onStart()
	Game.battle.soul.speed = Game.battle.soul.speed / 2
	self:createLayout()
    self.timer:script(function(wait)
		local omega = Game.battle.enemies[1]
		local arena = Game.battle.arena
		self.timer:tween(0.2, omega, {y = 720}, "linear")
		--Assets.playSound("pipisbomb_stinger")
		self.pipis = self:spawnObject(GigaPipisBomb(0, 0, 6), arena.right+40, -240)
		self.pipis.text.visible = false
		self.pipis_sign = self:spawnSprite("battle/bullets/omegaspamton/pipis/sign", -320, -240, self.pipis.layer)
		self.pipis_sign:setScale(1)
		self.pipis_sign:setOriginExact(101,0)
		self.timer:tween(2, self.pipis, {y = arena.y-100}, "in-bounce")
		wait(2)
		Assets.playSound("noise")
		self.door.alpha = 0.25
		self.door.collidable = false
		self.pipis.text.visible = true
		self.pipis.countdown = true
		if self.has_text then
			local encounter_text = Game.battle.battle_ui.encounter_text
			encounter_text:setSkippable(false)
			encounter_text:setAdvance(false)
			encounter_text:setText("[instant]* Defuse the Omega Pipis before it gets the chance to explode!")
		end
		--wait(3.9)
		--self:defusePipis()
	end)
end

function PipisDefusal:defusePipis()
	if self.pipis.con < 2 and not self.defused then 
		self.defused = true
		Assets.playSound("won")
		self.pipis.countdown = false
		self.pipis:removeFX("mask")
		if self.pipis.shaketween then
			Game.battle.timer:cancel(self.pipis.shaketween)
		end
		self.pipis.shaker = 0
		self.pipis.graphics.shake_friction = 1
		self.pipis.text.color = COLORS["lime"]
		if self.has_text then
			local encounter_text = Game.battle.battle_ui.encounter_text
			encounter_text:setSkippable(false)
			encounter_text:setAdvance(false)
			encounter_text:setText("[instant]* Pipis defused!")
		end
		self.timer:after(1.5, function()
			self.finished = true
		end)
	end
end

function PipisDefusal:onEnd()
    Game.battle.battle_ui:clearEncounterText()
end

function PipisDefusal:update()
	super.update(self)
	if self.pipis and self.pipis_sign then
		self.pipis_sign.x = self.pipis.x + self.pipis.sprite.width/2 + MathUtils.random(0, 2)
		self.pipis_sign.y = self.pipis.y - 32 + MathUtils.random(0, 2)
		self.pipis_sign.visible = self.pipis.visible
	end
	if self.switch.switch_pressed then
		self:defusePipis()
	end
end

return PipisDefusal