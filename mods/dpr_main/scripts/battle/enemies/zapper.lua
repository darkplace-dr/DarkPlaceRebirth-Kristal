local Zapper, super = Class(EnemyBattler)

function Zapper:init()
    super.init(self)

    self.name = "Zapper"
    self:setActor("zapper_b")

    self.max_health = 421
    self.health = 421
    self.attack = 11
    self.defense = 0
    self.money = 80

    self.experience = 10

    self.spare_points = 10

    self.waves = {
        "basic",
    }

    self.dialogue = {
        "Hoofah\ndoofah.",
        "Yeah, yeah,\nMr. Tenna's\norders.",
        "Yeah, yeah,\nshow your ID!",
        "Deez buttons\nain't for\nshow, twerps."
    }
    self.dialogue_loud = {
        "CAN SOMEONE\nTURN THAT\nBACK DOWN?",
        "WHAT? I CAN'T\nHEAR YOU!!!",
        "TURN IT UP??\nOKAY, YOU DA BOSS!"
    }

    self.check = "\"Hoofer\",\n\"Clicker-Clacker\", any name,\nit'll do the work."

    self.text = {
        "* Zapper clicks and clacks, zip\nand zaps.",
        "* Zapper quickly presses the\nbuttons on its chest.",
        "* Zapper keeps just popping all\nnight long.",
        "* Zapper checks if Tenna is\nwatching."
    }
    self.low_health_text = "* Zapper's buttons feel mushy."
    self.tired_text = "* Zapper's seeing visions of\nLanino."
	self.spareable_text = "* Zapper blushes in infrared,\ntoo."

    self:registerAct("VolumeUp", "Bullets\ngive big\nTP...")
    self:registerAct("Mute", "Tire\nenemies", nil, 32)
    self:registerAct("OffButton", "Turn\nit off", "all", 100)

    self.killable = true

    self.volumeturnups = 0
end

function Zapper:onAct(battler, name)
    if name == "VolumeUp" then
        Game.battle:startActCutscene(function(cutscene)
            self:addMercy(25)
            if self.volumeturnups == 0 then
                cutscene:text("* You turned up the volume!")
                cutscene:text("* ...")
                cutscene:text("* The bullets increased in\nvolume, too...!\n(But, they'll give more TP!)")
            else
                cutscene:text("* The bullets increased in\nvolume! Try getting close to\ngather TP!")
            end
            self.dialogue_override = Utils.pick(self.dialogue_loud)
            self.volumeturnups = self.volumeturnups + 1
        end)
        return
    elseif name == "Mute" then
        Game.battle:startActCutscene(function(cutscene)
            cutscene:text("* You hit the MUTE button!")
            Game.battle.music.volume = 0
            cutscene:text("* ...")
            for _, enemy in ipairs(Game.battle.enemies) do
                enemy:setTired(true)
            end
            self:addMercy(75)
            cutscene:text("* All foes became TIRED!")
            self.dialogue_override = "       "
        end)
        return
    elseif name == "OffButton" then
        Game.battle:startActCutscene(function(cutscene)
            cutscene:text("* You hit the OFF button!")
            Game.battle:addChild(TVTurnOff({type=1}))
            cutscene:wait(1.5)
            for _, enemy in ipairs(Game.battle.enemies) do
                enemy:spare()
            end
            cutscene:after(function() Game.battle:setState("VICTORY") end)
        end)
        return
    elseif name == "Standard" then
        if battler.chara.id == "susie" then
            self:addMercy(25)
            self.dialogue_override = "D-don't touch\nthat, you's!"
            return "* Susie mashed random buttons!"
        elseif battler.chara.id == "ralsei" then
            self:addMercy(25)
            self.dialogue_override = "Hey, I can\nsee da music.!"
            return "* Ralsei enabled captions!"
        else
            return "* "..battler.chara:getName().." straightened the\ndummy's hat."
        end
    end

    return super.onAct(self, battler, name)
end

return Zapper