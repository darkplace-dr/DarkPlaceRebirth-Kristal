local Winglade, super = HookSystem.hookScript("winglade")

function Winglade:init()
    super.super.init(self)

    self.name = "Winglade"
    self:setActor("winglade")

    self.max_health = 470
    self.health = 470
    self.attack = 14
    self.defense = 0
    self.money = 155
    self.spare_points = 10

    self.waves = {
        "winglade/circlearena",
        "winglade/aim"
    }

    self.dialogue = {
        "Halo, goodeye!        Halo, goodeye!",
        "Halo, are you listening?            ",
        "You oppose the revolution?          ",
        "Open your eyes        Open your eyes"
    }
    self.dialogue_mercy = {
        "Viva la revolution!  Viva la revolution!",
        "To spin, is to trust"
    }

    self.check = "A radical blade with\nfeathers at the hilt."

    self.text = {
        "* Winglade molts and revolts.",
        "* Winglade watches distrustfully.",
        "* Winglade draws flowers with its\nblade.",
        "* Winglade rotates aggressively."
    }

    self.spareable_text = "* Winglade flutters trustfully."
    self.low_health_text = "* Winglade sheds feathers heavily."
    self.tired_text = "* Winglade's eye flutters shut."

    self.low_health_percentage = 1/3

    self:registerAct("Spin", "Spin\n50%\nmercy")
    self:registerAct("SpinS", "60%\nMercy\nto all", {"susie"})
    self:registerAct("SpinJ", "60%\nMercy\nto all", {"jamm"})
	
	local followers = {}
	
	for k,v in pairs(Game.battle.party) do
		if k ~= 1 then
			table.insert(followers, v.chara.id)
		end
	end
	
    self:registerAct("Whirl", "SPARE\nall!", followers, 64)

    self.transition_ended = false
end

function Winglade:onAct(battler, name)
    if name == "SpinJ" then
        for _, enemy in ipairs(Game.battle:getActiveEnemies()) do
            enemy:addMercy(60)
        end
        Assets.stopAndPlaySound("pirouette", 0.7, 1.1)
        battler:setAnimation('pirouette')
        Game.battle:getPartyBattler('jamm'):setAnimation('pirouette')
        return "* You and Jamm spun masterfully!"
    elseif name == "Whirl" then
        Assets.stopAndPlaySound("pirouette", 0.7, 1.1)
		for k,v in ipairs(Game.battle.party) do
			v:setAnimation("pirouette")
		end
        Game.battle:startActCutscene("wingladewhirl")
        return
    end

    return super.onAct(self, battler, name)
end

function Winglade:onShortAct(battler, name)
    if name == "Standard" and battler.chara.id == "jamm" then
        Assets.stopAndPlaySound("pirouette", 0.7, 1.1)
        battler:setAnimation('pirouette')
        self:addMercy(40)
        return "* Jamm twirls like a ballerina!"
    end

    return super.onShortAct(self, battler, name)
end

return Winglade
