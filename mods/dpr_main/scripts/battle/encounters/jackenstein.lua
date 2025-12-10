local Jackenstein, super = Class(Encounter)

function Jackenstein:init()
    super.init(self)

    -- Text displayed at the bottom of the screen at the start of the encounter
    self.text = "* Darkness constricts you...\n* [color:yellow]TP[color:reset] Gain reduced outside of [color:yellow]TREASURE![color:reset]"

    self.music = "deltarune/pumpkin_boss"
    self.background = false
	self.hide_world = true
	self.is_jackenstein = true
    -- Add the dummy enemy to the encounter
	self.jackenstein = self:addEnemy("jackenstein", 442+90/2, 60+107)

    self.reduced_tension = true
	self.flee = false

	self.scaredy_cat = false
	self.treasure_hunt = false
	self.light_up = false

    self.default_xactions = false
	self.color_mask = nil
	self.fadeaway = false
	self.flashtimer = 0
	for _,battler in ipairs(Game.battle.party) do
		if not battler.actor.animations_jack then
			battler.visible = false
		end
	end
end

function Jackenstein:getPartyPosition(index)
    local x, y = 0, 0
    local battler = Game.battle.party[index]
    if #Game.battle.party == 1 then
        x = 80
        y = 140
		if battler.chara.id == "susie" then
			x = 52
			y = 120
		end
    elseif #Game.battle.party == 2 then
        x = 80
        y = 100 + (80 * (index - 1))
		if battler.chara.id == "susie" then
			x = 52
			y = 90 + (80 * (index - 1))
		end
    elseif #Game.battle.party == 3 then
        x = 80
        y = 50 + (80 * (index - 1))
		if battler.chara.id == "susie" then
			x = 52
			y = 30 + (80 * (index - 1))
		end
    end
    local ox, oy = battler.chara:getBattleOffset()
    x = x + (battler.actor:getWidth() / 2 + ox) * 2
    y = y + (battler.actor:getHeight() + oy) * 2
    return x, y
end

function Jackenstein:update()
	local jack = self.jackenstein
	if not self.fadeaway then
		if jack.alpha < 1 then
			jack.alpha = jack.alpha + 0.1 * DTMULT
		end
    else
		if jack.alpha > 0 then
			jack.alpha = jack.alpha - 0.1 * DTMULT
		end
	end
	
	super.update(self)
end

function Jackenstein:onWavesDone()
	super.onWavesDone(self)
	self.fadeaway = false
    for _,light in ipairs(Game.stage:getObjects(LightJackenstein)) do
		light:remove()
	end
    for _,arrow in ipairs(Game.stage:getObjects(GhostHouseExitArrow)) do
		arrow:remove()
	end
    if self.heartlight then
		self.heartlight.supercharged = false
		self.heartlight.radius = 40
		self.heartlight.biggerrad = 12
	end
	if Game.battle.turn_count == 3 then
		Game.battle.battle_ui.jackenstein_dancers.dancing_jackolantern_con = 1
	end
    self.scaredy_cat = false
	self.treasure_hunt = false
	self.light_up = false
end

function Jackenstein:onDialogueEnd()
	local flash = JackensteinFlashFade(self.jackenstein.sprite.eyes.texture, 0, 0)
    flash.layer = self.jackenstein.layer - 1
    self.jackenstein.sprite.eyes:addChild(flash)
	self.fadeaway = true
	Game.battle.timer:after(14/30, function()
		if self.heartlight then
			self.heartlight.current_radius = 0
			if self.light_up then
				self.heartlight.radius = self.heartlight.radius + 10
				self.heartlight.biggerrad = self.heartlight.biggerrad + 12
			end
		end
		Game.battle:setState("DEFENDINGBEGIN")
	end)
end

function Jackenstein:onBattleStart(battler)
    for _,battler in ipairs(Game.battle.party) do
        if battler.chara.id == "susie" then
			Game.battle:registerXAction("susie", "TreasureHunt", "Easier\npickup", 2)
		elseif battler.chara.id == "ralsei" then
			Game.battle:registerXAction("ralsei", "LightUp", "Increase\nlight", 1)
		elseif battler.chara.id == "dess" then
			Game.battle:registerXAction("dess", "LightUp", "Increase\nlight", 1)
		end
	end
	self.heartlight = HeartLightJackenstein(0, 0, {1,1,1})
    self.heartlight.alpha = 1
    Game.battle:addChild(self.heartlight)
end

return Jackenstein
