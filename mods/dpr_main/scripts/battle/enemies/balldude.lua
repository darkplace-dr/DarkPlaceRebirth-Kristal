local BallDude, super = Class(EnemyBattler)

function BallDude:init()
    super.init(self)

    self.name = "Ball Dude"
    self:setActor("balldude")

    self.max_health = 900
    self.health = 900
    self.attack = 12
    self.defense = 3
    self.money = 150
    self.experience = 26

    self.spare_points = 20

    self.waves = {
        "balldude1",
        --"bobberry1",
        --"bobberry2"
    }

    self.dialogue = {
        "ballular",
		"heck yeah",
		"it's ball dude\nbaby"
    }

    self.check = "AT 12 DF 3\n* Heck yeah."

    self.text = {
        "* Ball Dude is just balling it up.",
        "* Ball Dude is having a ball of a time.",
        "* Ball Dude is just here.",
    }
    self.low_health_text = "* Ball Dude is losing his spherical shape."

    self:registerAct("Tennis", "MERCY...?")
    self:registerAct("X-Tennis", "MERCY...?", "all")

    self.killable = true
end

function BallDude:onAct(battler, name)
    if name == "Tennis" then
		Game.battle.racket1 = true
        return "* You grab a Tennis racket and get ready to ball!"

    elseif name == "X-Tennis" then
		Game.battle.racket1 = true
		Game.battle.racket2 = true
		return "* All of you grab Tennis rackets and get ready to ball!"

    elseif name == "Standard" then
        if battler.chara.id == "susie" then
            self:addMercy(25)
            return "* Susie started hitting Ball Dude with a tennis racket repeatedly."
        elseif battler.chara.id == "berdly" then
            self:addMercy(25)
            return "* Berdly tried to play tennis![wait:10]\n* (He failed miserably.)"
        elseif battler.chara.id == "dess" then
            self:addMercy(50)
            return "* Dess uses her bat as a tennis racket."
        else
            return "* "..battler.chara:getName().." straightened the\ndummy's hat."
        end
    end

    return super.onAct(self, battler, name)
end

function BallDude:getEncounterText()
    if love.math.random(0, 100) < 3 then
        return "* Smells like a tennis ball canister."
    else
        return super.getEncounterText(self)
    end
end

return BallDude
