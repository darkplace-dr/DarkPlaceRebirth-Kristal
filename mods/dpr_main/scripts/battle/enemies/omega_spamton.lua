local OmegaSpamton, super = Class(EnemyBattler)

function OmegaSpamton:init()
    super.init(self)

    self.name = "Omega Spamton"
    self:setActor("omegaspamton")
    self:setScale(1.5)

    self.max_health = 15000
    self.health = 15000
    self.lowestHP = self.health
    self.attack = 180
    self.defense = 200
    self.money = 5500
    self.experience = --[[Mod:isInRematchMode() and 0 or]] 1500
	self.service_mercy = 0
    self.milestone = true -- good luck getting Miss Pauling in this fight but yeah

	self.boss = true

	self.defeat_type = "none"

	self.exit_on_defeat = false

    self.spare_points = 1

    self.waves = {
        "omegaspamton/biglaser"
        --"omegaspamton/popuptest"
        --"omegaspamton/pipisdefusal"
    }

    self.dialogue = {}

    self.text = {
        "* The air crackles with freedom.",
        "* This is the end.",
        "* It's the finale.",
    }
    self.low_health_text = "* Smoke is coming out of Omega Spamton's wounds.."
	self.tired_percentage = 0

    self:registerAct("Downgrade", "Lower\nstats", nil, 25)

    self.xaction_flag = false
end

function OmegaSpamton:onAct(battler, name)
    if name == "Check" then
        return "* OMEGA SPAMTON - AT "..self.attack.." DF "..self.defense.."\n* Final boss...[wait:10] of the GamerTime section,[wait:5] that is."
    elseif name == "Downgrade" then
		Assets.playSound("laz_c")
        local attackLowered = self.attack > 10
        self.attack = math.max(10, self.attack - 15)
		self.defense = self.defense - 30
        return {
            attackLowered and "* Spamton was downgraded![wait:5]\n* -15 attack & -30 defense!"
            or "* Spamton was downgraded![wait:5]\n* -30 defense![wait:5]\nAttack can't go any lower.",
        }
    elseif name == "X-Downgrade" then
        Assets.playSound("laz_c")
		self.defense = self.defense - 100
        return "* Spamton was greatly downgraded![wait:5]\n* -100 defense!"
    elseif name == "Standard" then
        self:addMercy(1)
        return "* "..battler.chara:getName().." pleaded for mercy!"
    end

    return super.onAct(self, battler, name)
end

return OmegaSpamton
