local Pebblin, super = Class(EnemyBattler)

function Pebblin:init()
    super.init(self)

    self.name = "Chloropurr"
    self:setActor("chloropurr")

    self.max_health = 1500
    self.health = 1500
    self.attack = 9
    self.defense = 13
    self.money = 1000
    self.mercyamnt = 0
    self.mercy = 0
       self.tired_percentage = 0.15
    self.low_health_percentage = 0.15
        self.experience = 50
        self.summons = 1
        self.boss = 1

    self.killable = false

    self.spare_points = 2

    self.waves = {
        "chloropurr/armwave",
        "chloropurr/handthrowwave",
        "chloropurr/vines",
        "chloropurr/handthrowwaveloop",
        "chloropurr/vinesarms",
    }

    self.check = "AT 9 DF 16\n* It's a cat. Doesn't seem to want to be your friend... "..self.mercyamnt.." Compound mercy."

    self.text = {
        "* Chloropurr stares creepily.",
        "* Chloropurr wonders if it could learn sign language... If it had hands.",
        "* Smells like an enemy.",
        "* Chloropurr pays the audiance to keep bringing furniture into their room."
    }
    self.low_health_text = "* Chloropurr is starting to wilter."

    self:registerAct("Feed", "Feed\nChloropurr")
    self:registerAct("X-Pet", "Higher\nmercy points", {"susie"}, 16)

    if Game.battle:getPartyBattler("pink") then
        self:registerAct("Pink's idea", "", {"pink"})
    end

    self.resistances = {
        DARK = 0.5,
        STAR = 0.5,
    }
end

function Pebblin:onAct(battler, name)
    if name == "Feed" then
        self.mercyamnt = self.mercyamnt + 1
        self:addMercy(self.mercyamnt)
        if self.mercy <= 10 then
        self.dialogue_override = Utils.pick{"Are- are you SURE???", "I- Why are you giving me water. Why."}
        else
            self.dialogue_override = Utils.pick{"I- I guess???? If you insist???", "There's- There's no harm in having some."}
        end
        if self.mercy <= 10 then
        return "* You left out some water for Chloropurr. They hesitantly have some. +1 compound mercy!"
        else
            if self.mercy >= 10 and self.mercy <= 20 then
            return "* You left out some water for Chloropurr. They slowly drink it. +1 compound mercy!"
            else
                return "* You left out some water for Chloropurr. They lap it up. +1 compound mercy!"
            end
        end

    elseif name == "X-Pet" then
                if self.mercy <= 50 then
                self.attack = self.attack + 2
                self.mercyamnt = self.mercyamnt + 3
                self.dialogue_override = "?!?!"
                self:setAnimation("hurt")
                else
                self.attack = self.attack - 1
                self.mercyamnt = self.mercyamnt + 4
                self.dialogue_override = "..."
                end
                self:addMercy(MathUtils.round(self.mercyamnt))
                if self.mercy <= 50 then
        return {
            "* You and Susie pet Chloropurr.",
            "* They were frightened!\n* Attack up, and compound mercy up! +5 compound mercy"
        }  
    else
        return {
            "* You and Susie pet Chloropurr.",
            "* The chloropurr was less frightened.\n* Attack down, compound mercy up! +4 compound mercy!"
        }  
    end
    elseif name == "Pink's idea" then
        self.dialogue_override = Utils.pick{"...This is me pitying you."}
        return {
            "* Pink beckoned Chloropurr over.",
            "* Pink doesn't say anything, though, for some reason. \n* It works??? +5 compound mercy!"
        }
    elseif name == "Standard" then --X-Action
        self.mercyamnt = self.mercyamnt + 1
        return "* "..battler.chara:getName().." tried to approach Chloropurr... \n* +1 Compound mercy!"
    end

    -- If the act is none of the above, run the base onAct function
    -- (this handles the Check act)
    return super.onAct(self, battler, name)
end

function Pebblin:onSpareable()
    super.onSpareable(self)
    self.waves = {
    }
end
function Pebblin:onDefeat(damage, battler)
    if self.defeat_violent == true then
Game:setFlag("chloropurrBeaten", 1)
    else
        Game:setFlag("chloropurrBeaten", 2)
    end
end
function Pebblin:getEnemyDialogue()
    self:setAnimation("idle")
    local dialogue
    if ((self.mercy >= 50) or (self.health <= 750)) and self.summons == 1 then
    self.summons = 0
    Game.battle.encounter:addEnemy("charafriendling")
    self.waves = {
        "chloropurr/handthrowwaveslow",
        "chloropurr/vines",
        "chloropurr/vinesarmsslow",
    }
    dialogue = {
              "My- My friend! I need you!"
            }
    else
    if self.dialogue_override then
        local dialogue = self.dialogue_override
        self.dialogue_override = nil
        return dialogue
    end
    if self:canSpare() then
        dialogue = {
            "I'm an aquaintance of yours now.",
            "We will make good allies.",
            "Yippee."
        }
    else
        if MathUtils.random(0, 300) == 300 then
            dialogue = {
              "Anyways.\nLet's talk real talk.\nFemboys"
            }
        else
            dialogue = {
                "...",
            }
        end
    end
    end
    return "[float:2]" .. dialogue[math.random(#dialogue)]
end

return Pebblin
