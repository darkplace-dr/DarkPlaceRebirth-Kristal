local RudinnRanger, super = Class(EnemyBattler)

function RudinnRanger:init()
    super.init(self)

    self.name = "Rudinn Ranger"
    self:setActor("rudinnranger")

    self.path = "enemies/rudinnranger"
    self.default = "idle"

    self.max_health = 170
    self.health = 170
    self.attack = 8
    self.defense = 0
    self.money = 45

    self.spare_points = 25

    self.dialogue = {
        "Long live\nthe king!",
        "Glimmer\nglammor",
        "Perish,\nLightners!",
        "I'm the,\ndiamond,\nhere's the\nrough!"
    }

    self.waves = {
        "rudinnranger/slasher"
    }

    self.check = "AT 8 DEF 0\n* Ideally multicolored, but they \nall wanted to be red."

    self.text = {
        "* Rudinn Ranger gleams gallantly.",
        "* Rudinn Ranger puts a power \nlimiter on its feelings.",
        "* Rudinn Ranger fantasizes about divine gems.",
        "* Rudinn Ranger pledges \nallegiance.",
        "* Smells like crystal."
    }

    self.low_health_text = "* Rudinn Ranger's luster begins \nto fade."

    self:registerAct("Convince")
    self:registerAct("Compliment", "", {"susie"})

    self.text_override = nil
end

function RudinnRanger:isXActionShort(battler)
    return true
end

function RudinnRanger:onShortAct(battler, name)
    if name == "Lecture" then
        self:setAnimation("tired")
        self.setTired(true)
        print("You lectured the enemies on the\nimportance of kindness.")
        if battler.chara.id == "kris" then
            return "* You lectured the enemies on the\nimportance of kindness."
        else
            return "* " .. battler.chara:getName() .. " lectured the enemies on the\nimportance of kindness."
        end
    elseif name == "Standard" then
        self:addMercy(100)
        if battler.chara.id == "noelle" then
            return "* Noelle encouraged the enemies!"
        elseif battler.chara.id == "susie" then
            return "* Susie motivated the enemies!"
        elseif battler.chara.id == "ralsei" then
            return "* Ralsei reasoned with the enemies!"
        end
    end
    return nil
end

function RudinnRanger:onAct(battler, name)
    if name == "Convince" then
    elseif name == "Compliment" then
    elseif name == "Standard" then
        self:addMercy(50)
        if battler.chara.id == "noelle" then
            return
        elseif battler.chara.id == "susie" then
            return
        elseif battler.chara.id == "ralsei" then
            return
        end
    end
    return super.onAct(self, battler, name)
end

function RudinnRanger:getEnemyDialogue()
    if self.text_override then
        local dialogue = self.text_override
        self.text_override = nil
        return dialogue
    end

    return TableUtils.pick(self.dialogue)
end

return RudinnRanger