local OmegaSpamton, super = Class(EnemyBattler)

function OmegaSpamton:init()
    super.init(self)

    -- Enemy name
    self.name = "Omega Spamton"
    -- Sets the actor, which handles the enemy's sprites (see scripts/data/actors/dummy.lua)
    self:setActor("omegaspamton")
    self:setScale(1.5)

    -- Enemy health
    self.max_health = 15000
    self.health = 15000
    self.lowestHP = self.health
    -- Enemy attack (determines bullet damage)
    self.attack = 180
    -- Enemy defense (usually 0)
    self.defense = 200
    -- Enemy reward
    self.money = 5500
    --[[self.experience = Mod:isInRematchMode() and 0 or 1500]] 
	self.service_mercy = 0
    self.milestone = true   -- good luck getting Miss Pauling in this fight but yeah
	
	self.boss = true
	
	self.defeat_type = "none"
	
	self.exit_on_defeat = false

    -- Mercy given when sparing this enemy before its spareable (20% for basic enemies)
    self.spare_points = 1

    -- List of possible wave ids, randomly picked each turn
    self.waves = {
        --"omegaspamton/biglaser"
        "omegaspamton/popuptest"
    }

    -- Dialogue randomly displayed in the enemy's speech bubble
    self.dialogue = {
    }

    -- Check text (automatically has "ENEMY NAME - " at the start)
    self.check = "AT "..self.attack.." DF "..self.defense.."\n* Final boss...[wait:10] of Kris and Susie Gamer Time,[wait:5] that is."

    -- Text randomly displayed at the bottom of the screen each turn
    self.text = {
        "* The air crackles with freedom.",
        "* This is the end.",
        "* It's the finale.",
    }
    -- Text displayed at the bottom of the screen when the enemy has low health
    self.low_health_text = "* Smoke is coming out of Omega Spamton's wounds.."
	self.tired_percentage = 0

    -- Register act called "Smile"
    self:registerAct("Downgrade", "Lower\nstats.", nil, 25)

    self.xaction_flag = false
end

function OmegaSpamton:onAct(battler, name)
    if name == "Downgrade" then
        -- Give the enemy 100% mercy
        --self:addMercy(20)
        -- Change this enemy's dialogue for 1 turn
        --self.dialogue_override = "god I fucking love orbs"
		
		Assets.playSound("laz_c")
		
        -- Act text (since it's a list, multiple textboxes)
        local attackLowered = self.attack > 10
        self.attack = math.max(10, self.attack - 15)
		self.defense = self.defense - 30
		self.check = "AT "..self.attack.." DF "..self.defense.."\n* Final boss...[wait:10] of Kris and Susie Gamer Time,[wait:5] that is."
        return {
            attackLowered and "* Spamton was downgraded![wait:5]\n* -15 attack & -30 defense!"
            or "* Spamton was downgraded![wait:5]\n* -30 defense![wait:5]\nAttack can't go any lower.",
        }
    elseif name == "X-Downgrade" then
        Assets.playSound("laz_c")
		
        -- Act text (since it's a list, multiple textboxes)
		self.defense = self.defense - 100
		self.check = "AT "..self.attack.." DF "..self.defense.."\n* Final boss...[wait:10] of the GamerTimer section,[wait:5] that is."
        return "* Spamton was greatly downgraded![wait:5]\n* -100 defense!"
    elseif name == "Standard" then --X-Action
        -- Give the enemy 50% mercy
        self:addMercy(1)
        return "* "..battler.chara:getName().." pleaded for mercy!"
    end
    
    -- If the act is none of the above, run the base onAct function
    -- (this handles the Check act)
    return super.onAct(self, battler, name)
end

return OmegaSpamton
