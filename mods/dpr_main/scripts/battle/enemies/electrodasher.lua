local Electrodasher, super = Class(EnemyBattler)

function Electrodasher:init()
    super.init(self)

    self.name = "Electrodasher"
    self:setActor("electrodasher")
    self:setAnimation("idle")

    self.max_health = 421
    self.health = 421
    self.attack = 6
    self.defense = 0
    self.money = 97

    self.experience = 5

    self.spare_points = 10

    self.waves = {
        "electrodasher/hoopwaves"
    }

    self.check = "AT 9 DF 5\n* Always loves to go fast, which often results in speeding tickets."

    self.text = {}

    self.low_health_text = "* Electrodasher is in need of repairs."

    self:registerAct("Outrace", "25%\nand\nSPEED up")
    self:registerAct("SlowDown", "TIRE by\nslowing\ndown")
    self:registerAct("PhotoPose", "35%\nMercy", "all")

    self.killable = true
end

function Electrodasher:update()
    super.update(self)
end

function Electrodasher:onAct(battler, name)
    if name == "Outrace" then
        self:addMercy(35)
		Assets.playSound("cardrive", 1, 1.5)
		Game.battle.encounter.slow_down = false
		Game.battle.encounter.speed_up = true
        return "* You flare up with adrenaline and\ntry to outrace Electrodasher![wait:5]\n* The SOUL moves way faster now!"
    elseif name == "SlowDown" then
        self:setTired(true)
		Game.battle.encounter.speed_up = false
		Game.battle.encounter.slow_down = true
        return "* You tell Electrodasher to slow it down a notch.\n* Electrodasher became TIRED..."
    elseif name == "Standard" then --X-Action
        self:addMercy(50)
        if battler.chara.id == "ralsei" then
            return "* Ralsei bowed politely.\n* The Electrodasher spiritually bowed\nin return."
        elseif battler.chara.id == "susie" then
            Game.battle:startActCutscene("Electrodasher", "susie_punch")
            return
        else
            return "* "..battler.chara:getName().." straightened the\nElectrodasher's hat."
        end
    end

    return super.onAct(self, battler, name)
end

function Electrodasher:onHurt(damage, battler)
    Game.battle.timer:after(5/30, function()
        Assets.playSound("bigcar_yelp")
    end)

    return super.onHurt(self)
end

function Electrodasher:onTurnEnd()
    if Game.battle.encounter.speed_up then
		Game.battle.encounter.speed_up = false
    end
    if Game.battle.encounter.slow_down then
		Game.battle.encounter.slow_down = false
    end
end

function Electrodasher:getEncounterText()
    if love.math.random(0, 100) < 3 then
        return "* Smells like car batteries."
    else
        return super.getEncounterText(self)
    end
end

return Electrodasher