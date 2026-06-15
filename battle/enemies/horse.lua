local Dummy, super = Class(EnemyBattler)

function Dummy:init()
    super.init(self)

    -- Enemy name
    self.name = "Evil horse"
    -- Sets the actor, which handles the enemy's sprites (see scripts/data/actors/dummy.lua)
    self:setActor("horse")

    -- Enemy health
    self.max_health = 450
    self.health = 450
    -- Enemy attack (determines bullet damage)
    self.attack = 7
    -- Enemy defense (usually 0)
    self.defense = 4
    -- Enemy reward
    self.money = 100

    self.experience = 5

    -- Mercy given when sparing this enemy before its spareable (20% for basic enemies)
    self.spare_points = 1

    -- List of possible wave ids, randomly picked each turn
    self.waves = {
        "basic",
        "aiming",
        "movingarena"
    }

    -- Dialogue randomly displayed in the enemy's speech bubble
    self.dialogue = {
        "horse",
        "honse",
        "neigh",
        "nay",
        "that sure was a bad apple am i right lads\nor am i right lads i am right lad\nthat is right lad i am right\nyay that apple was super\nbad and bad apples make me evil\nand i am evil horse now yippee\nthis is horrible is this text off\nthe screen yet also bad apples are\nvery not yummy and\nare the opposite of yummy",
        "that apple was bad"
    }

    -- Check text (automatically has "ENEMY NAME - " at the start)
    self.check = "AT 7 DF 4\n* Why did you give the horse a bad apple\n* It is evil because of that."

    -- Text randomly displayed at the bottom of the screen each turn
    self.text = {
        "* Tha horce brag tu yoo about it's\ngood engilsh.",
        "* The horse tries to eat a regular apple, but realises it tastes horrible.",
        "* Smells like apples.",
        "* The horse thinks about it's past...\n* The past being like 5 minutes ago when you gave it that apple.",
    }
    -- Text displayed at the bottom of the screen when the enemy has low health
    self.low_health_text = "* The horse is very angry.\n* Good thing it's evil."

    -- Register act called "Smile"
    self:registerAct("Appleogise")
    -- Register party act with Ralsei called "Tell Story"
    -- (second argument is description, usually empty)

    self.killable = false
end

function Dummy:onAct(battler, name)
    if name == "Appleogise" then
        -- Give the enemy 100% mercy
        self:addMercy(1)
        -- Change this enemy's dialogue for 1 turn
        self.dialogue_override = "why"
        -- Act text (since it's a list, multiple textboxes)
        return {
            "* You appologise.[wait:5]\n* The horse appl'es.",
            "* It is an evil horse."
        }


    elseif name == "Standard" then --X-Action
        -- Give the enemy 50% mercy
        self:addMercy(1)
        if battler.chara.id == "ralsei" then
            -- R-Action text
            return "* Ralsei bowed politely.\n* The horse is too busy\nbeing evil to notice."
        elseif battler.chara.id == "susie" then
            -- S-Action: start a cutscene (see scripts/battle/cutscenes/dummy.lua)
            return "* Susie was hungry.\n* The horse wonders...\nHow hungry?."
        else
            -- Text for any other character (like Noelle)
            return "* "..battler.chara:getName().." bit an apple.\n* The horse doesn't like that."
        end
    end

    -- If the act is none of the above, run the base onAct function
    -- (this handles the Check act)
    return super.onAct(self, battler, name)
end

return Dummy