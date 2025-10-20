local Dummy, super = Class(EnemyBattler)

function Dummy:init()
    super.init(self)

    -- Enemy name
    self.name = "Bad Memory"
    -- Sets the actor, which handles the enemy's sprites (see scripts/data/actors/dummy.lua)
    self:setActor("dummy")

    -- Enemy health
    self.max_health = 800
    self.health = 800
    self.attack = 10
    self.defense = 0
    self.money = 0

    self.experience = 5

    self.names = 
    {
        "Bad_Memory",
        "BAD-memory",
        "baD_m3m0rY",
        "84b=WEWOPV",
        "BAd-MemORt"
    }

    -- Mercy given when sparing this enemy before its spareable (20% for basic enemies)
    self.spare_points = 20

    -- List of possible wave ids, randomly picked each turn
    self.waves = {
        "basic",
        "aiming",
        "movingarena"
    }

    -- Dialogue randomly displayed in the enemy's speech bubble
    self.dialogue = {
        "[shake:1]"..(" "):rep(10)
    }

    -- Check text (automatically has "ENEMY NAME - " at the start)
    self.check = "AT ??? DF ???\n* I DON'T LIKE THIS\n* I DON'T LIKE THIS"

    -- Text randomly displayed at the bottom of the screen each turn
    self.text = {
        "* [instant]GET OUT OF MY HEAD[stopinstant][wait:30]\n* [instant]GET OUT OF MY HEAD[stopinstant][wait:30]\n* [instant]GET OUT OF MY HEAD[stopinstant][wait:30]\n* [instant]GET OUT OF MY HEAD[stopinstant][wait:60]\n",
        "*",
        "Line 54",
    }

    self.low_health_text = "* TURN IT OFF"

    self:registerAct("Yell")

    self.killable = true
end

function Dummy:update()
    super.update(self)

    self.name = Utils.pick(self.names)
end

function Dummy:onAct(battler, name)
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

return Dummy