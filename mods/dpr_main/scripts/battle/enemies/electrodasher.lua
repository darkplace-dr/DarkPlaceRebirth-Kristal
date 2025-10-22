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
        "basic",
        "aiming",
        "movingarena"
    }

    self.check = "AT 8 DF 0\n* Cotton heart and button eye\n* Looks just like a fluffy guy."

    self.text = {}

    self.low_health_text = "* The Electrodasher looks like it's\nabout to fall over."

    self:registerAct("Smile")
    self:registerAct("Tell Story", "", {"ralsei"})

    self.killable = true
end

function Electrodasher:update()
    super.update(self)
end

function Electrodasher:onAct(battler, name)
    if name == "Smile" then
        self:addMercy(100)
        self.dialogue_override = "... ^^"
        return {
            "* You smile.[wait:5]\n* The Electrodasher smiles back.",
            "* It seems the Electrodasher just wanted\nto see you happy."
        }

    elseif name == "Tell Story" then
        for _, enemy in ipairs(Game.battle.enemies) do
            enemy:setTired(true)
        end
        return "* You and Ralsei told the Electrodasher\na bedtime story.\n* The enemies became [color:blue]TIRED[color:reset]..."

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

function Electrodasher:getEncounterText()
    if love.math.random(0, 100) < 3 then
        return "* Smells like car batteries."
    else
        return super.getEncounterText(self)
    end
end

return Electrodasher