local OmegaSpamton, super = Class(Encounter)

function OmegaSpamton:init()
    super.init(self)

    self.text = "* Omega Spamton emerges!"
	self.progress = 0

    self.music = "none"
	--if Mod:isInRematchMode() then
    	--self.background = true
	--else
		self.background = false
	--end

    self.omega = self:addEnemy("omega_spamton", 770, 1350)
    self.omega:setAnimation("static")

	self.flee = false

    self.boss_rush = false

    if Game:getFlag("omegaspamton_defeated") == true then
        self.boss_rush = true
    end

	self.small_soul = false
end

function OmegaSpamton:createBackground()
    if self.background then
        return Game.battle:addChild(DojoBG({1, 1, 1}))
    end
end

function OmegaSpamton:createSoul(x, y)
	if self.small_soul then
		return JackensteinSoul(x, y)
	end
    return Soul(x, y)
end

function OmegaSpamton:onBattleStart()
	Game.battle:startCutscene("omegaspamton", "intro")
end

function OmegaSpamton:beforeStateChange(old, new)
    local override = false

    if new == "ENEMYDIALOGUE" then
        if self.omega then
            if self.omega.defeat_normal or self.omega.defeat_violent then
                Game.battle.music:fade(0, 1)
                if self.omega.defeat_normal then
                    Game.battle:startCutscene("omegaspamton", "outro")
                elseif self.omega.defeat_violent then
                    Game.battle:startCutscene("omegaspamton", "outro_alt")
                end
                override = true
            elseif not self.omega.sleep_mode then
                local cutscene = Game.battle:startCutscene("omegaspamton_fight.talk")
                cutscene:after(function()
                    Game.battle:setState("DIALOGUEEND")
                end)
            end
        else
            Game.battle:setState("VICTORY")
        end
    end

    if new == "ACTIONS" and self.progress >= 200 then
        local spamton = self.omega
        if spamton ~= nil and not spamton.sleep_mode then
            spamton.lowestHP = math.min(spamton.health, spamton.lowestHP)
            if spamton.lastHealed ~= Game.battle.turn_count then
                spamton:heal(spamton.max_health)
                spamton.lastHealed = Game.battle.turn_count
            end
        end
    end

    return override
end

function OmegaSpamton:getPartyPosition(index)
    local krloc = {110, 190}
    local suloc = {110, 250}
    local raloc = {110, 310}

    if #Game.party == 1 then
        krloc = {110, 250}
    elseif #Game.party == 2 then
        krloc = {110, 220}
        suloc = {110, 280}
    end

    if index == 1 then
        return krloc[1], krloc[2]
    elseif index == 2 then
        return suloc[1], suloc[2]
    elseif index == 3 then
        return raloc[1], raloc[2]
    else
        return super.getPartyPosition(self, index)
    end
end

return OmegaSpamton