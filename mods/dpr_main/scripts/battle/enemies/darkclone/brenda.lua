local DarkCloneBrenda, super = Class(EnemyBattler)

function DarkCloneBrenda:init()
    super.init(self)

    self.name = "Brenda?"
    self:setActor("darkclone/brenda")
    
    self.path = "battle/enemies/darkclone/brenda/battle"
    self.default = "idle"
    self:setAnimation("idle")

    self.max_health = 40 * Game:getPartyMember("brenda"):getStat("health")
    self.health = 40 * Game:getPartyMember("brenda"):getStat("health")
    self.attack = Game:getPartyMember("brenda"):getStat("attack") / 3
    self.defense = Game:getPartyMember("brenda"):getStat("defense") + Game:getPartyMember("brenda"):getStat("magic") / 2
    self.tired_percentage = -1
    self.money = 0

    self.disable_mercy = true

    self.experience = 5000

    self.spare_points = 0

    self.waves = {
    }

    self.dialogue = {
    }

    self.check = ""

    self.text = {
        "* It observes your movements.",
        "* It's you.[wait:10].[wait:10].[wait:10]?",
        "* Smells like gunpowder.",
        "* Smells like a bonfire."
    }

    self.killable = false

    self.usedskills = {}
    self.fireball = false
end

function DarkCloneBrenda:onAct(battler, name)
    if name == "Standard" then
        Game.battle:startActCutscene("darkclone/brenda", "xaction")
        return
    end

    return super.onAct(self, battler, name)
end

function DarkCloneBrenda:onHurt(...)
    super.onHurt(self, ...)

    if not (self.powder and Game.battle.state ~= "ATTACKING") then
        self.defense = (self.defense + 1) * 1.5
    end
end

function DarkCloneBrenda:update()
    super.update(self)

    if Game.battle.state == "ATTACKING" then
        local skillknow = false
        for i, v in ipairs(self.usedskills) do
            if v == "attack" then
                skillknow = true
            end
        end
        if skillknow == false then
            table.insert(self.usedskills, "attack")
        end

        local defense = self.defense
        if self.powder_immunity then
            self.defense = Game:getPartyMember("brenda"):getStat("defense") + Game:getPartyMember("brenda"):getStat("magic") / 2
        end

        local health = self.health
        Game.battle.timer:after(1/30, function()
            if self.health < health then
                if self.powder_immunity then
                    self.powder_immunity = false
                end
            end
            if Game.battle.state ~= "ATTACKING" and self.powder_immunity then
                self.defense = defense
            end
        end)
    end

    for i, v in ipairs(self.usedskills) do
        self:updateAttacks(v)
    end
end

function DarkCloneBrenda:updateAttacks(skill)
    if skill == "attack" then
        local learntskill = false
        for i, v in ipairs(self.waves) do
            if v == "darkclone/brenda/shoot" then
                learntskill = true
            end
        end
        if learntskill == false then
            table.insert(self.waves, "darkclone/brenda/shoot")
        end
    elseif skill == "multiflare" then
        if self.fireball == false then
            self.fireball = true
        end
        local learntskill = false
        for i, v in ipairs(self.waves) do
            if v == "darkclone/brenda/flare" then
                learntskill = true
            end
        end
        if learntskill == false then
            table.insert(self.waves, "darkclone/brenda/flare")
        end
    elseif skill == "powderkeg" and not Game.battle:getPartyBattler("brenda").powder then
        local learntskill = false
        for i, v in ipairs(self.waves) do
            if v == "darkclone/brenda/powder" then
                learntskill = true
            end
        end
        if learntskill == false then
            table.insert(self.waves, "darkclone/brenda/powder")
        end
    end
end

return DarkCloneBrenda
