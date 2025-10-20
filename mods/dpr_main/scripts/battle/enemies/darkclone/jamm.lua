local DarkCloneJamm, super = Class(EnemyBattler)

function DarkCloneJamm:init()
    super.init(self)

    self.name = "Jamm?"
    self:setActor("darkclone/jamm")
    
    self.path = "battle/enemies/darkclone/jamm/battle"
    self.default = "idle"
    self:setAnimation("idle")

    self.max_health = 25 * Game:getPartyMember("jamm"):getStat("health")
    self.health = 25 * Game:getPartyMember("jamm"):getStat("health")
    self.attack = Game:getPartyMember("jamm"):getStat("attack") / 3
    self.defense = Game:getPartyMember("jamm"):getStat("defense")
    self.money = 0

    self.disable_mercy = true
    
    self.boss = false       -- becomes true if you use DarkShot

    self.experience = 5000

    self.spare_points = 0

    self.waves = {
    }

    self.dialogue = {
    }

    self.check = "You don't know what this is."

    self.text = {
        "* It observes your movements.",
        "* It's you.[wait:10].[wait:10].[wait:10]?",
    }

    self.killable = false

    self.knows_skills = {}
end

function DarkCloneJamm:onAct(battler, name)
    if name == "Standard" then
        Game.battle:startActCutscene("darkclone/jamm", "xaction")
        return
    end

    return super.onAct(self, battler, name)
end

function DarkCloneJamm:onHurt(...)
    super.onHurt(self, ...)

    if not (self.powder and Game.battle.state ~= "ATTACKING") then
        self.defense = (self.defense + 1) * 1.5
    end
end

function DarkCloneJamm:update()
    super.update(self)

    if Game.battle.state == "ATTACKING" then
        local skillknow = false
        for i, v in ipairs(self.knows_skills) do
            if v == "attack" then
                skillknow = true
            end
        end
        if skillknow == false then
            table.insert(self.knows_skills, "attack")
        end
    end
end

function DarkCloneJamm:addAttacks(skill)
    if Utils.containsValue(self.knows_skills, skill) then return end
    
    table.insert(self.knows_skills, skill)
end

return DarkCloneJamm
