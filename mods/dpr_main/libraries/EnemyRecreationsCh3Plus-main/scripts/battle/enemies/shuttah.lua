local Shuttah, super = Class(EnemyBattler)

function Shuttah:init()
    super.init(self)

    self.name = "Shuttah"
    self:setActor("shuttah")

    self.max_health = 421
    self.health = self.max_health
    self.attack = 8
    self.defense = 0
    self.money = 100
    self.spare_points = 10

    self.waves = {
        "shuttah/cameracapture"
    }

    self.dialogue = {
        "My memory is\nphotographic,\nphoto-TASTIC!\nWanna see?",
        "Work it baby,\nWORK it!",
        "How are we\nLOOKING today?",
        "How's my ATTACK ALBUM?\nI'll let you in it too!",
        "POSE and... HOLD!\nCan we get a little smolder?",
        "The energy, baby,\nEYE am LOVING it!"
    }

    self.check = "When its eyes snap\nshut, memories are made\nin grey."

    self.text = {
        "* Shuttah sings in a gasping voice.",
        "* Shuttah considers the best lighting for its attack.",
        "* Shuttah struttahs.",
        "* Shuttah takes selfies from two angles at once."
    }

    self.spareable_text = "* Shuttah preps for its RECRUITment portrait."
    self.tired_percentage = 1/3
    self.low_health_percentage = 1/3
    self.low_health_text = "* Shuttah's starting to look sepia."
    self.tired_text = "* Shuttah is so TIRED, it can't keep its shutters open."

    self:registerAct("EasyPhoto", "Timely\nphoto", {"ralsei"})
    self:registerAct("ToughPhoto", "Fast\nphoto")
    self:registerAct("PowerPhoto", "Extra\nMercy", {"susie"}, 25)
    
    self.last_challenge = nil
    self.last_challenge_fail = false
end

function Shuttah:onAct(battler, name)
    local time, miss_add, success_add
    if name == "EasyPhoto" then
        time = 10
        miss_add = 25
        success_add = 80
    elseif name == "ToughPhoto" then
        time = 5
        miss_add = 25
        success_add = 80
    elseif name == "PowerPhoto" then
        time = 10
        miss_add = 50
        success_add = 100
    end

    if time then
        Game.battle:addChild(ShuttahSnapAct(self, time, miss_add, success_add, false))
        return
    end

    if name == "Standard" then
        return self:onShortAct(battler, name)
    end

    return super.onAct(self, battler, name)
end

function Shuttah:isXActionShort(battler)
    return true
end

function Shuttah:onShortAct(battler, name)
    if name == "Standard" then --X-Action
        -- Adds 5% mercy for the miniboss encounter instead
        if battler.chara.id == "ralsei" then
            self:addMercy(35)
            local flavor_text = {
                "* Ralsei stared into the camera!",
                "* Ralsei has a perfect hair day!",
                "* Ralsei's photo got overexposed!"
            }
            return Utils.pick(flavor_text)
        elseif battler.chara.id == "susie" then
            local flavor_text = {
                "* Susie sneezes during a photo!",
                "* Susie blurs during a photo!",
                "* Susie blinks during a photo!"
            }
            self:addMercy(25)
            return Utils.pick(flavor_text)
        else
            self:addMercy(25)
            return "* "..battler.chara:getName().." stared into the camera!"
        end
    end

    return super.onShortAct(self, battler, name)
end

function Shuttah:getEncounterText()
    -- It seems like theres a 3/101 chance that this text overrides everything
    -- according to the decompiled code??? (Idk how GameMaker code works)
    if Utils.random(0, 100, 1) < 3 then
        return "* Smells like a darkroom... ironically enough."
    end

    return super.getEncounterText(self)
end

return Shuttah