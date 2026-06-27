local raoulias, super = Class(EnemyBattler)

function raoulias:init()
    super.init(self)

    self.name = "Raoulias"
    self:setActor("raoulias")

    self.max_health = 470
    self.health = 470

    self.attack = 8

    self.defense = 0

    self.money = 11

    self.experience = 5

    self.spare_points = 10

    self.waves = {
        "raoulias/flower_grow"
    }

    self.dialogue = {
        "*WOOSH* *WOOSH*",
        "* Dum de dum~!",
        "mi. Mi. MI!! Mi. MI!!",
        "*whistle* *whistle*",
    }

    self.check = "AT 8 DF 0\n* allan please add details."

    self.text = {
        "* Raoulias whistles to it's heart's content.",
        "* The power of air is\nin the air.",
        "* Smells like grass.",
    }

    self.low_health_text = "* The dummy looks like it's\nabout to fall over."

    -- Register act called "Smile"
    self:registerAct("Smile")
    -- Register party act with Ralsei called "Tell Story"
    -- (second argument is description, usually empty)
    self:registerAct("Tell Story", "", {"ralsei"})

    self.killable = true

    -- come up with a type for this
    self.resistances = {
        --FIRE = 0.75,
        --ICE = 1.5
    }
end

function raoulias:onAct(battler, name)
    if name == "Smile" then
        -- Give the enemy 100% mercy
        self:addMercy(100)
        -- Change this enemy's dialogue for 1 turn
        self.dialogue_override = "... ^^"
        -- Act text (since it's a list, multiple textboxes)
        return {
            "* You smile.[wait:5]\n* The dummy smiles back.",
            "* It seems the dummy just wanted\nto see you happy."
        }

    elseif name == "Tell Story" then
        -- Loop through all enemies
        for _, enemy in ipairs(Game.battle.enemies) do
            -- Make the enemy tired
            enemy:setTired(true)
        end
        return "* You and Ralsei told the dummy\na bedtime story.\n* The enemies became [color:blue]TIRED[color:reset]..."

    elseif name == "Standard" then --X-Action
        -- Give the enemy 50% mercy
        self:addMercy(50)
        if battler.chara.id == "ralsei" then
            -- R-Action text
            return "* Ralsei bowed politely.\n* The dummy spiritually bowed\nin return."
        elseif battler.chara.id == "susie" then
            -- S-Action: start a cutscene (see scripts/battle/cutscenes/dummy.lua)
            Game.battle:startActCutscene("dummy", "susie_punch")
            return
        else
            -- Text for any other character (like Noelle)
            return "* "..battler.chara:getName().." straightened the\ndummy's hat."
        end
    end

    -- If the act is none of the above, run the base onAct function
    -- (this handles the Check act)
    return super.onAct(self, battler, name)
end

return raoulias