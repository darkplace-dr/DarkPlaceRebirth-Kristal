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

    self.used_s_action = false
    self.changecolorcon = 0
    self.changecolorcount = 0
    self.changecolortimer = 0

    self.colortarget = { 1, 1, 1 }
    self.colortarget2 = { 1, 1, 1 }

    self.fountain_snd = Assets.getSound("fountain_make")
    self.soundtimer = 0
    self.pitchtarget = 0
    self.pitchtarget2 = 0
    self.pitch = 0

    self.closedcaptioncon = 0
    self.closedcaptioncon2 = 0
    self.closedcaptiontimer = 0
end

function Zapper:update()
    super.update(self)

    -- S-Action-related code
    if self.used_s_action then
        if not self.fountain_snd:isPlaying() then
            self.fountain_snd:play()
        end

        if self.changecolorcon == 0 then
            self.colortarget2 = {self:HSV(Utils.random(0, 255, 1)/255, 250/255, 255/255)}

            if self.changecolorcount == 5 then
                self.colortarget2 = { 1, 1, 1 }
            end

            self.pitchtarget2 = 1 + love.math.random(2)
            self.changecolorcon = 1
        end
        if self.changecolorcon == 1 then
            self.changecolortimer = self.changecolortimer + (1 * DTMULT)
            self:setColor(Utils.mergeColor(self.colortarget, self.colortarget2, self.changecolortimer / 3))
            self.pitch = Utils.lerp(self.pitchtarget, self.pitchtarget2, self.changecolortimer / 3)
            self.fountain_snd:setPitch(self.pitch)

            if self.changecolortimer == 3 then
                self.colortarget = self.colortarget2
                self.pitchtarget = self.pitchtarget2
                self.changecolorcount = self.changecolorcount + (1 * DTMULT)
                self.changecolorcon = 0
                self.changecolortimer = 0
            end
        end

        if self.changecolorcount == 6 then
            self.fountain_snd:stop()
            self:setColor(COLORS.white)
            self.changecolorcount = 0
            self.used_s_action = false
        end
    end
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

            Assets.playSound("damage")
            self:hurt(0, nil, nil, nil, false)
            self:onHurt(0, nil)
            self.hurt_timer = 1
            self.used_s_action = true

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

-- Function from the love2d wiki, converts HSV to RGB
function Zapper:HSV(h, s, v)
    if s <= 0 then return v,v,v end
    h = h*6
    local c = v*s
    local x = (1-math.abs((h%2)-1))*c
    local m,r,g,b = (v-c), 0, 0, 0
    if h < 1 then
        r, g, b = c, x, 0
    elseif h < 2 then
        r, g, b = x, c, 0
    elseif h < 3 then
        r, g, b = 0, c, x
    elseif h < 4 then
        r, g, b = 0, x, c
    elseif h < 5 then
        r, g, b = x, 0, c
    else
        r, g, b = c, 0, x
    end
    return r+m, g+m, b+m
end

return Zapper