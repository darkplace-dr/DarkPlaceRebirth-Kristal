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

    self.waves = {}

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
	self.phaseturn = 0
	self.myattackchoice = 0
	self.default_dialogue = true
end

function Tenna:getNextWaves()
    if self.myattackchoice == 0 then
        return { "tenna/allstar_cast" }
    end
    if self.myattackchoice == 1 then
        return { "tenna/smashcut" }
    end
    if self.myattackchoice == 2 then
        return { "tenna/rimshot_stars" }
    end
end

function Tenna:addScore(points)
    local tenna_bg = Game.stage:getObjects(TennaBattleBackground)[1]
    --local tenna_zoom = Game.stage:getObjects(TennaZoom())[1]
    --local minigame_ui = Game.stage:getObjects(TennaMinigameUI())[1]

    if tenna_bg then
        local _multiplier = 1
        local _multi_minigame_adjustment = 1
        
        if self.minigameactivated then
            if self.minigamecount >= 6 then
                _multi_minigame_adjustment = 0.65
            end
            
            _multiplier = (self.pointsmultiplierthisturn + self.pointsmultiplier) * _multi_minigame_adjustment
            self.pointsmultiplierthisturn = self.pointsmultiplierthisturn - 1
            
            if self.pointsmultiplierthisturn < 1 then
                self.pointsmultiplierthisturn = 1
            end
        end
        
        --if not tenna_zoom then
            tenna_bg.addscore = tenna_bg.addscore + MathUtils.round(points * _multiplier)
        --elseif minigame_ui then
        --    minigame_ui.myscore = minigame_ui.myscore + MathUtils.round(points * _multiplier)
        --end
    end
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

function Tenna:setPhase()
	self.phaseturn = self.phaseturn + 1
	
    if self.phaseturn == 1 then
        self.myattackchoice = 0
    end

    if self.phaseturn == 2 then
        self.myattackchoice = 1
    end

    if self.phaseturn == 3 then
        self.myattackchoice = 2
        self.phaseturn = 0
	end
end

function Tenna:getEnemyDialogue()
    if self.dialogue_override then
        local dialogue = self.dialogue_override
        self.dialogue_override = nil
        return dialogue
    end

    if self.default_dialogue then
	    if self.myattackchoice == 0 then
			return "WE'VE GOT AN\nALL-STAR CAST!"
		end
		if self.myattackchoice == 1 then
			return "HOW BOUT A\nLITTLE SLICE\nOF LIFE!?"
		end
		if self.myattackchoice == 2 then
			return  "How about we\nplay you a\nRIMSHOT!?"
		end
	end

    return TableUtils.pick(self.dialogue)
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