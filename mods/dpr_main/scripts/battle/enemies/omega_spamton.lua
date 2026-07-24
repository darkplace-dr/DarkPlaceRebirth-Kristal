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
    self.low_health_text = "* Smoke is coming out of Omega Spamton's wounds..."
	self.tired_percentage = 0

    self:registerAct("Downgrade", "Lower\nstats", nil, 25)

    self.xaction_flag = false
    self.sleep_mode = false
    self.defeat_normal = false
    self.defeat_violent = false
end

function OmegaSpamton:xSlashEffect(battler)
    battler:setAnimation("battle/attack")
    battler:flash()
    local a = AfterImage(battler, 1)
    a.physics.speed_x = 2.5
    a.layer = battler.layer - 1
    Game.battle:addChild(a)
	a = AfterImage(battler, 0.6)
    a.physics.speed_x = 5
    a.layer = battler.layer - 2
    Game.battle:addChild(a)

    Assets.stopAndPlaySound("scytheburst", 1, 1.2)

    local x, y = self:getRelativePos(self.width / 2, self.height / 2, Game.battle)
    local attacksprite = battler.chara:getWeapon() and battler.chara:getWeapon():getAttackSprite(battler, enemy) or battler.chara:getAttackSprite()
    local dmg_sprite = Sprite(attacksprite or "effects/attack/cut", x, y)
    dmg_sprite:setOrigin(0.5, 0.5)
    dmg_sprite:setScale(2, 2)
    dmg_sprite.layer = self.layer + 0.1
    dmg_sprite:play(1 / 15, false, function() dmg_sprite:remove() end)
    Game.battle:addChild(dmg_sprite)
end

function OmegaSpamton:onAct(battler, name)
    if name == "Check" then
        return "* OMEGA SPAMTON - AT "..self.attack.." DF "..self.defense.."\n* Final boss...[wait:10] of the GamerTime section,[wait:5] that is."
    elseif name == "Downgrade" then
        self:xSlashEffect(battler)

        local attackLowered = self.attack > 10
        self.attack = math.max(10, self.attack - 15)
		self.defense = self.defense - 30
        return {
            attackLowered and "* Spamton was downgraded![wait:5]\n* -15 attack & -30 defense!"
            or "* Spamton was downgraded![wait:5]\n* -30 defense![wait:5]\nAttack can't go any lower.",
        }
    elseif name == "X-Downgrade" then
        for _, battler in ipairs(Game.battle.party) do
            self:xSlashEffect(battler)
        end

		self.defense = self.defense - 150
        return "* Spamton was greatly downgraded![wait:5]\n* -150 defense!"
    elseif name == "Standard" then
        self:xSlashEffect(battler)

        local attackLowered = self.attack > 10
        self.attack = math.max(10, self.attack - 5)
		self.defense = self.defense - 15
        return attackLowered and "* "..battler.chara:getName().." downgraded Spamton![wait:5]\n* -5 attack & -15 defense!"
        or "* "..battler.chara:getName().." downgraded Spamton![wait:5]\n* -15 defense![wait:5]\nAttack can't go any lower."
    end

    return super.onAct(self, battler, name)
end

function OmegaSpamton:getNextWaves()
    if self.sleep_mode then
        return nil
    end

    return super.getNextWaves(self)
end

function OmegaSpamton:onHurt(damage, battler)
	super.onHurt(self, damage, battler)

    if self.health <= 0 then
        self.sleep_mode = true
        if Game:getFlag("can_kill") then
            self.defeat_violent = true
        end
    end
end

function OmegaSpamton:spare(pacify)
    self.defeat_normal = true
end

return OmegaSpamton
