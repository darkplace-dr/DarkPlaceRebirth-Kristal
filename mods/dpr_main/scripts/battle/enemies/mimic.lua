---@class EnemyBattler.Mimic : EnemyBattler
local Mimic, super = Class(EnemyBattler)

function Mimic:init()
    super.init(self)

    -- Enemy name
    self.name = "Mimic"
    -- Sets the actor, which handles the enemy's sprites (see scripts/data/actors/dummy.lua)
    self:setActor("ufoofdoom")

    -- Enemy health
    self.max_health = 4400
    self.health = 4400
    -- Enemy attack (determines bullet damage)
    self.attack = 10
    -- Enemy defense (usually 0)
    self.defense = 2
    -- Enemy reward
    self.money = 1000
    self.experience = 50
	self.service_mercy = 0
    self.milestone = true
	
	self.boss = true

    -- Mercy given when sparing this enemy before its spareable (20% for basic enemies)
    self.spare_points = 0

    -- List of possible wave ids, randomly picked each turn
    self.waves = {
        "mimic/starsidesmimic",
		"mimic/starcirclemimic",
		"mimic/starfademimic",
        "mimic/dual_movingarena_mimic",
        "mimic/bouncymimic",
        "mimic/pebblerain",
		-- add more, please :)
		-- (PS, bonus points if it's an upgraded version of another enemy's attack to stick with the theme)
    }

    -- Dialogue randomly displayed in the enemy's speech bubble
    self.dialogue = {
        "Uheehee!",
		"Happy New Year 1998!",
		"Don't forget!",
		"Don't forget, 1998!",
		"Will you find out?", -- this is a reference to one of the best websites ever created and as such i elect to never remove it no matter how little it makes sense
		-- for those who want to know........ https://jessiespizza.neocities.org/
    }

    -- Check text (automatically has "ENEMY NAME - " at the start)
    self.check = "AT 10 DF 2\n* Uheehee!"

    -- Text randomly displayed at the bottom of the screen each turn
    self.text = {
        "* Uheehee!",
        "* The air grows cold.",
        "* ...",
    }
    -- Text displayed at the bottom of the screen when the enemy has low health
    self.low_health_text = "* Mimic grows exhausted."
	self.tired_percentage = 0.15

    self:registerAct("Mutate", "TP to\nEnergy", nil, 10)
	self:registerAct("X-Mutate", "All to\nEnergy", "all", 25)
	self:registerAct("Send", "Send All\nEnergy", "all")
    
    -- TODO: Write a Mimic:spare() override for this
    --self.exit_on_defeat = false

    self.killable = false

    self.current_actor = "ufoofdoom"

    self:addFX(ShaderFX("wave", {
        ["wave_sine"] = function () return Kristal.getTime() * 100 end,
        ["wave_mag"] = function () return self:getFXWaveMag() end,
        ["wave_height"] = 2,
        ["texsize"] = { SCREEN_WIDTH, SCREEN_HEIGHT }
    }), "funky_mode")
end

function Mimic:getFXWaveMag()
    return Utils.clampMap(self.alpha, 1, 0.5, 2, 64)
end

function Mimic:morph(actor_id)
    if self.current_actor == actor_id then return end
    self.current_actor = actor_id
    Game.battle.timer:script(function(wait)
        self:fadeTo(0.5, 0.2)
        wait(0.3)
        self:setActor(actor_id)
        self:fadeTo(0.5, 0)
        self:fadeTo(1, 0.25)
    end)
end

function Mimic:onAct(battler, name)
    if name == "Mutate" then
		Assets.playSound("sparkle_gem")
		for _, ally in ipairs(Game.battle.party) do
			ally:sparkle(1, 1, 1)
		end
		self.encounter.energy = self.encounter.energy + 10
		if self.encounter.energy >= 100 then
			self.encounter.energy = 150
			return "* Energy raised to "..self.encounter.energy.."%![wait:10]\n* Full power!"
		end
        return "* Energy raised to "..self.encounter.energy.."%!"
	elseif name == "X-Mutate" then
		Assets.playSound("boost")
		for _, ally in ipairs(Game.battle.party) do
			ally:sparkle(1, 1, 1)
            ally:flash()
		end
		self.encounter.energy = self.encounter.energy + 25
		if self.encounter.energy >= 100 then
			self.encounter.energy = 150
			return "* Energy raised to "..self.encounter.energy.."%!!![wait:10]\n* Full power!"
		end
        return "* Energy raised to "..self.encounter.energy.."%!!!"
	elseif name == "Send" then
		if self.encounter.energy <= 0 then
			return "* There's nothing to send!"
		end

        Assets.playSound("scytheburst")
        self:flash()
    
        self:addMercy(math.ceil(self.encounter.energy / 3.75))
        self.encounter.energy = 0
        
        return "* Energy was sent to Mimic!"
    elseif name == "Standard" then --X-Action
        self.encounter.energy = self.encounter.energy + 5
		return "* "..battler.chara:getName().." generated a bit of energy!"
    end

    -- If the act is none of the above, run the base onAct function
    -- (this handles the Check act)
    return super.onAct(self, battler, name)
end

function Mimic:onDefeat(damage, battler)
    if self.encounter.id ~= "mimicboss" then
        return super.onDefeat(self, damage, battler)
    end

    -- mark us as defeated first
    -- sprite is not destroyed yet
    --[[if not Mod:isInRematchMode() then
        self:defeat("KILLED", true)
    else
        self:defeat("VIOLENCE", true)
    end]]
    self:defeat("KILLED", true)
end

return Mimic
