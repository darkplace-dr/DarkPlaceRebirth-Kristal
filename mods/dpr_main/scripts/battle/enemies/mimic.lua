---@class EnemyBattler.Mimic : EnemyBattler
local Mimic, super = Class(EnemyBattler)

function Mimic:init()
    super.init(self)

    self.name = "Mimic"
    self:setActor("ufoofdoom")

    self.max_health = 2200
    self.health = 2200
    self.attack = 7
    self.defense = 0
    self.money = 500
    self.experience = 50
    if Mod:isInRematchMode() then
        self.experience = 0
    end

    self.service_mercy = 0
    self.milestone = true

    self.boss = true

    self.spare_points = 0

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

    self.dialogue = {
        "Uheehee!",
        "Happy New Year 1998!",
        "Don't forget!",
        "Don't forget, 1998!",
        "Will you find out?", -- this is a reference to one of the best websites ever created and as such i elect to never remove it no matter how little it makes sense
        -- for those who want to know........ https://jessiespizza.neocities.org/
    }

    self.check = "Shapeshifter.\n* Not much to say about them besides that."

    self.text = {
        "* You can hear laughter coming from Mimic.",
        "* The air grows cold.\n* You feel like you're in space.",
        "* You notice the lack of outside sounds.",
        "* Mimic considers what to shapeshift in next turn.",
        "* Feels like deja vu."
    }
    self.tired_text = "* Mimic grows exhausted."

    self.tired_percentage = 0.2

    self:registerShortAct("Mutate", "TP to\nEnergy", nil, 10)
    self:registerAct("X-Mutate", "All to\nEnergy", "all", 25)
    self:registerAct("Send", "Send All\nEnergy")

    -- TODO: Write a Mimic:spare() override for this
    --self.exit_on_defeat = false

    self.killable = false

    self.current_actor = "ufoofdoom"

    self:addFX(ShaderFX("wave", {
        ["wave_sine"] = function() return Kristal.getTime() * 100 end,
        ["wave_mag"] = function() return self:getFXWaveMag() end,
        ["wave_height"] = 2,
        ["texsize"] = { SCREEN_WIDTH, SCREEN_HEIGHT }
    }), "funky_mode")
end

function Mimic:isXActionShort(battler)
    return true
end

function Mimic:onAct(battler, name)
    if name == "Mutate" then
        return self:onShortAct(battler, name)
    elseif name == "X-Mutate" then
        Assets.playSound("sparkle_gem", 1, 1.2)
        Assets.playSound("sparkle_gem", 1, 1.5)
        for _, ally in ipairs(Game.battle.party) do
            ally:sparkle(1, 1, 1)
            ally:flash()
        end
        self.encounter.energy = self.encounter.energy + 25
        if self.encounter.energy >= 100 then
            self.encounter.energy = 150
            return "* Energy raised to MAX![wait:10]\n* Full power!!!"
        end
        return "* Everyone generated energy!!!"
    elseif name == "Send" then
        if self.encounter.energy <= 0 then
            return "* But there was nothing to send!"
        end

        Assets.playSound("scytheburst")
        self:flash()

        self:addMercy(math.ceil(self.encounter.energy / 3))
        self.encounter.energy = 0

        return "* All energy was sent to Mimic!"
    elseif name == "Standard" then
        return self:onShortAct(battler, name)
    end

    return super.onAct(self, battler, name)
end

function Mimic:onShortAct(battler, name)
    if name == "Mutate" then
        Assets.stopAndPlaySound("sparkle_gem", 1, 1.2)
        battler:sparkle(1, 1, 1)
        battler:flash()
        self.encounter.energy = self.encounter.energy + 10
        if self.encounter.energy >= 100 then
            self.encounter.energy = 150
            return "* Energy raised to MAX![wait:10] Full power!!!"
        end
        return "* " .. battler.chara:getName() .. " generated some energy!"
    elseif name == "Standard" then
        Assets.stopAndPlaySound("sparkle_gem", 1, 1.5)
        battler:sparkle(1, 1, 1)
        battler:flash()
        self.encounter.energy = self.encounter.energy + 5
        if self.encounter.energy >= 100 then
            self.encounter.energy = 150
            return "* Energy raised to MAX![wait:10] Full power!!!"
        end
        return "* " .. battler.chara:getName() .. " generated a bit of energy!"
    end
end

function Mimic:getEncounterText()
    if (self:getSpareableText() and self:canSpare()) or (self:getLowHealthText() and self:hasLowHealth()) or (self:getTiredText() and self:isTired()) then
        return super.getEncounterText(self)
    end

    if self.encounter.energy == 150 then
        return "* The energy is MAXED OUT!\n* Time to [color:yellow]SEND[color:reset]!"
    end

	if MathUtils.randomInt(101) < 3 then
		return "* Smells like a broken mirror."
	end

    return super.getEncounterText(self)
end

function Mimic:onDefeat(damage, battler)
    if self.encounter.id ~= "mimicboss" then
        return super.onDefeat(self, damage, battler)
    end

    -- mark us as defeated first
    -- sprite is not destroyed yet
    if not Mod:isInRematchMode() then
        self:defeat("KILLED", true)
    else
        self:defeat("VIOLENCE", true)
    end
end

function Mimic:getFXWaveMag()
    return MathUtils.rangeMap(self.alpha, 1, 0.5, 2, 64)
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

return Mimic
