local Tenna, super = Class(EnemyBattler)

function Tenna:init()
    super.init(self)

    self.name = "Tenna"
    self:setActor("tenna")
	self:setAnimation("idle")

    self.max_health = 5500
    self.health = 5500
    self.attack = 13
    self.defense = 0
    self.money = 0

    self.experience = 0
    self.spare_points = 0

    self.waves = {
        "tenna/allstar_cast",
		"tenna/rimshot_stars"
    }

    self.dialogue = {
        "IT'S!\nTV!\nTIME!"
    }

    self.check = "Isn't it about time you\ngot a new TV?"

    self.text = {
        "* CLAP AND CHEER, SMILE AND SCREAM! ENTERTAINMENT ON YOUR SCREEN!",
        "* COWABUNGA-DERO! THAT'S THE SMOOTH TASTE OF TV TIME!",
        "* FRESH FROM THE JUICE! FRESH FROM THE JUICE!",
        "* HEAR THAT WHINE!? THAT'S YOUR CRT ASKING FOR A WALK!!",
        "* DON'T TOUCH THAT DIAL! THINGS ARE HEATING UP!",
    }

    self.tired_percentage = 0

    self:registerAct("ILoveTV", "Earn\nscore")
    self:registerAct("SpinWheel", "Random\nTenna", "all", 50)

    if Game.inventory:hasItem("lancer") then
        self:registerAct("SpadeCheat", "Prevent\nscore loss", nil, 42)
    end

    self.killable = true

    self.healthphase = 1

    --for SpadeCheat ACT
    --[[
    self.lancer = ActorSprite("lancer")
    self.lancer.x, self.lancer.y = 320, 240
    self.lancer:setScale(2)
    self.lancer:setOrigin(0.5, 1)
    Game.battle:addChild(self.lancer)
    self.collider = Hitbox(self.lancer, 14, 23, 16, 10)
    self.lancer.collider = self.collider

    self.lancerindex = 0
    self.lancerspin = false
    self.lancercheat = false
    self.lancercheatpoints = 0
    ]]
end

function Tenna:update()
	super.update(self)
	self.actor:onBattleUpdate(self)
end

function Tenna:getEncounterText()
	local text = super.getEncounterText(self)
	Game.battle.battle_ui.encounter_text.battletimer = -1

    if self.healthphase == 1 and self.health < (self.max_health * 0.5) then
        self.healthphase = 2
        text = "* OUCH! H-HEY! WATCH WHERE YOU, UH, SWING THOSE THINGS! HAHA!"
    elseif self.healthphase == 2 and self.health < (self.max_health * 0.25) then
        self.healthphase = 3
        text = "* H-HEY, ANYONE NOTICED MY HP IS GOING DOWN!? ANYONE!?"
    elseif self.healthphase == 3 and self.health < (self.max_health * 0.166) then
        self.healthphase = 4
        text = "* WHAT AN EVENT!! THE CONTESTANTS APPEAR TO BE KILLING ME!!"
    end
	return text, "battle", "tenna"
end

function Tenna:onAct(battler, name)
    if name == "ILoveTV" then
        return "* Placeholder..."
    elseif name == "SpinWheel" then
        return "* Placeholder..."

    elseif name == "SpadeCheat" then
        return "* Placeholder..."
    elseif name == "Standard" then
        self:addMercy(50)
        if battler.chara.id == "susie" then
            return "* Susie made a placeholder..."
        elseif battler.chara.id == "ralsei" then
            return "* Ralsei made a placeholder..."
        elseif battler.chara.id == "dess" then
            return "* Dess made a placeholder..."
        else
            return "* "..battler.chara:getName().." made a placeholder."
        end
    end

    return super.onAct(self, battler, name)
end

return Tenna