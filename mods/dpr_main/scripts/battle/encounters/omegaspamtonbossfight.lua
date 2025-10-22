local OmegaSpamton, super = Class(Encounter)

function OmegaSpamton:init()
    super.init(self)

    self.text = "* Omega Spamton emerges!"
	self.progress = 0

    self.music = "none"
	--if Mod:isInRematchMode() then
    	--self.background = true
	--else
		self.background = true
	--end

    self.omega = self:addEnemy("omega_spamton", 770, 1350)
    self.omega:setAnimation("static")

	self.flee = false

    self.boss_rush = false

    if Game:getFlag("omegaspamton_defeated") == true then
        self.boss_rush = true
    end
end

function OmegaSpamton:onBattleInit()
    super.onBattleInit(self)
    if self.boss_rush == true then
        Game.battle.dojo_bg = DojoBG({1, 1, 1})
        Game.battle:addChild(Game.battle.dojo_bg)
    end
end

function OmegaSpamton:onBattleStart()
	Game.battle:startCutscene("omegaspamton_intro", "omegaspamton_intro")
end

function OmegaSpamton:beforeStateChange(old, new)
    local override = false

    if not old == "CUTSCENE" then
        if Game.battle.enemies[1].health <= 0 then
            Game.battle.music:fade(0, 1)
            Game.battle:startCutscene("omegaspamton_intro", "omegaspamton_outro")
            override = true
        end

        if Game.battle.enemies[1].mercy >= 100 then
            Game.battle.music:fade(0, 1)
            Game.battle:startCutscene("omegaspamton_intro", "omegaspamton_outro_alt")
            override = true
        end
    end

    if new == "ENEMYDIALOGUE" then
        if Game.battle.enemies[1] then
            local cutscene = Game.battle:startCutscene("omegaspamton_fight.talk")
            cutscene:after(function()
                Game.battle:setState("DIALOGUEEND")
            end)
        else
            Game.battle:setState("VICTORY")
        end
    end

    if new == "ACTIONS" and self.progress >= 200 then
        local spamton = Game.battle.enemies[1]
        if spamton ~= nil then
            spamton.lowestHP = math.min(spamton.health, spamton.lowestHP)
            if spamton.lastHealed ~= Game.battle.turn_count then
                spamton:heal(spamton.max_health)
                spamton.lastHealed = Game.battle.turn_count
            end
        end
    end

    return override
end

function OmegaSpamton:skip()
	local spamton = Game.battle.enemies[1]
	spamton.defense = spamton.defense - 30
	spamton.attack = spamton.attack - 15
end

return OmegaSpamton