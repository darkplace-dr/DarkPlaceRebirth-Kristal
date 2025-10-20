local Warstalker, super = Class(EnemyBattler)

function Warstalker:init()
    super.init(self)

    -- Enemy name
    self.name = "Warstalker"
    -- Sets the actor, which handles the enemy's sprites (see scripts/data/actors/Warstalker.lua)
    self:setActor("warstalker")


    self:setAnimation("talk")

    -- Enemy health
    self.max_health = 0
    self.health = 1500
    -- Enemy attack (determines bullet damage)
    self.attack = 6
    -- Enemy defense (usually 0)
    self.defense = -100
    -- Enemy reward
    self.money = 100

    -- Mercy given when sparing this enemy before its spareable (20% for basic enemies)
    self.spare_points = -20

    -- List of possible wave ids, randomly picked each turn
    self.waves = {
        "dual_movingarena"
    }

    -- Dialogue randomly displayed in the enemy's speech bubble
    self.dialogue = {
        " ",
        "   \n\n",
        "[color:yellow][instant]IIIIIIIIIIIIIIIIIIIIIIIIIIIIIII[stopinstant][wait:10]\n[instant]IIIIIIIIIIIIIIIIIIIIIIIIIIIIIII[stopinstant][wait:10]\n[instant]IIIIIIIIIIIIIIIIIIIIIIIIIIIIIII[stopinstant][wait:10]\n[instant]IIIIIIIIIIIIIIIIIIIIIIIIIIIIIII[stopinstant][wait:10]\n",
        "[shake:10]wARSTALKER",
        "                                \n\n\n\n\n\n\n\n\n\n\n\n\n",
        "[color:yellow]This is off."
    }

    -- Check text (automatically has "ENEMY NAME - " at the start)
    self.check = "AT 6 DF -100 \n* Welcome to Cliffside![wait:10]\n* Watch your step!* Welcome to Cliffside![wait:10]\n* Watch your step!"

    -- Text randomly displayed at the bottom of the screen each turn
    self.text = {
        "[color:yellow]* The[color:white] Warstalker [color:yellow]contorts and shatters.",
        "",
        "* Smells[wait:60][speed:0.5]ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss",
    }
    -- Text displayed at the bottom of the screen when the enemy has low health
    self.low_health_text = "* Warstalker is about\n    s     &    )321gs\n            cat."

    -- Register act called "Smile"
    self:registerAct("Piss-off")
    -- Register party act with Ralsei called "Tell Story"
    -- (second argument is description, usually empty)
    --self:registerAct("Tell Story", "", {"ralsei"})
end

function Warstalker:onAct(battler, name)
    if name == "Piss-off" then --X-Action
        -- Give the enemy 50% mercy
        if battler.chara.id == "hero" then
            self.rage = 1
            return "* Hero tried mimicking the Warstalker's movements.[wait:10]\n* It seems displeased."
        elseif battler.chara.id == "susie" then
            -- S-Action: start a cutscene (see scripts/battle/cutscenes/Warstalker.lua)
            Game.battle:startActCutscene("Warstalker", "susie_punch")
            return
        else
            -- Text for any other character (like Noelle)
            return "* "..battler.chara:getName().." straightened the\nWarstalker's hat."
        end
    end

    -- If the act is none of the above, run the base onAct function
    -- (this handles the Check act)
    return super.onAct(self, battler, name)
end

return Warstalker