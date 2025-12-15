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

    self.low_health_percentage = 0.15

    self:registerAct("Red Buster", "Red\nDamage", {"susie"}, 60)

    self.phase2_start_text = false
    self.phase3_start_text = false
    self.phase4_start_text = false
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
    Game.battle.encounter.bg.max_alpha = 0
    Game.battle.encounter.bg.desses = false
    Game.battle.encounter.bg.deltarune = false
    Game.battle.encounter.afterimages = false
    self:defeat("KILLED", true)
end

function Dess:getEncounterText()
    local has_spareable_text = self.spareable_text and self:canSpare()

    local priority_spareable_text = Game:getConfig("prioritySpareableText")
    if priority_spareable_text and has_spareable_text then
        return self.spareable_text
    end

    if self.low_health_text and self.health <= (self.max_health * self.low_health_percentage) then
        return self.low_health_text

    elseif self.tired_text and self.tired then
        return self.tired_text

    elseif has_spareable_text then
        return self.spareable_text
    end

    if self.phase4_start_text then
        self.phase4_start_text = false
        return "* Stars shine brighter.\n* The end is near."
    elseif self.phase3_start_text then
        self.phase3_start_text = false
        return "* The memories are flooding back."
    elseif self.phase2_start_text then
        self.phase2_start_text = false
        return "* Suddenly, something changed."
    end

    return TableUtils.pick(self.text)
end

return Dess
