local Dess, super = Class(EnemyBattler)

function Dess:init()
    super.init(self)

    self.name = "Dess"
    self:setActor("dessimation")

    self.max_health = 25000
    self.health = 25000
    self.attack = 20
    self.defense = 10
    self.money = 250

    self.experience = 5000
	self.service_mercy = 0
	
	self.boss = true
    self.disable_mercy = true

    self.spare_points = 0
    self.tired_percentage = 0
    self.low_health_percentage = 0.2
    self.milestone = true

    self.waves = {
        "dess/starbeam"
    }

    self.dialogue = {
        "..."
    }

    self.check = "AT 20 DF 10\n* Just another obstacle.\n* Don't underestimate her."

    self.text = {
        "* Stardust fills the air.",
        "* No turning back.",
        "* Dess is preparing a spell.",
        "* Smells like root beer.",
    }
    self.low_health_text = "* Dess is going all out."

    self:registerAct("Red Buster", "Red\nDamage", {"susie"}, 60)
end

function Dess:onAct(battler, name)
    if name == "Red Buster" then
        Game.battle:powerAct("red_buster", battler, "susie")
    elseif name == "Standard" then
        return "* ... But "..battler.chara:getName().." couldn't think of what to do."
    end

    return super.onAct(self, battler, name)
end

function Dess:onDefeat(damage, battler)
    self:defeat("KILLED", true)
end

return Dess
