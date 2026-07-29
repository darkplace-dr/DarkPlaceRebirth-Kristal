local Friend, super = Class(EnemyBattler)

function Friend:init()
    super.init(self)

    -- Enemy name
    self.name = "Friend"
    -- Sets the actor, which handles the enemy's sprites (see scripts/data/actors/friend.lua)
    self:setActor("room3_friend")

    -- Enemy health
    self.max_health = 5000
    self.health = 5000
    -- Enemy attack (determines bullet damage)
    self.attack = 10
    -- Enemy defense (usually 0)
    self.defense = 3
    -- Enemy reward
    self.money = 100

    self.experience = 5

    -- Mercy given when sparing this enemy before its spareable (20% for basic enemies)
    self.spare_points = -10

    -- List of possible wave ids, randomly picked each turn
    self.waves = {
        "tailofhellstorm",
        "bite2",
        "bite"
    }

    -- Dialogue randomly displayed in the enemy's speech bubble
    self.dialogue = {
        "..."
    }

    -- Check text (automatically has "ENEMY NAME - " at the start)
    self.check = "AT 10 DF 3\n* A cat made of darkness\n* Hungers for protein."

    -- Text randomly displayed at the bottom of the screen each turn
    self.text = {
        "* Catastrophy.",
        "* Encatony.",
        "* Smells like protein.",
    }
    -- Text displayed at the bottom of the screen when the enemy has low health
    self.low_health_text = "* Friend looks weak."

    -- Register act called "Smile"
    self:registerAct("Smile")
    self:registerAct("Pet", "", {"hero"})

    self.killable = true

    self.resistances = {
    }
end

function Friend:onAct(battler, name)
    if name == "Smile" then
        -- Give the enemy 100% mercy
        self:addMercy(10)
        -- Change this enemy's dialogue for 1 turn
        -- Act text (since it's a list, multiple textboxes)
        return {
            "* You smile.[wait:5]\n* Friend smiles back."
        }
    elseif name == "Pet" then
        self:addMercy(20)
        battler:hurt(40) 
        return {
            "* You pet friend... it bites you."
        }
    elseif name == "Standard" then --X-Action
        -- Give the enemy 50% mercy
        self:addMercy(10)
        if battler.chara.id == "dess" then
                    self:addMercy(-20)
            return "* Dess laughed at the cat."
        else
            -- Text for any other character (like Noelle)
            return "* "..battler.chara:getName().." tried talking to friend.\n* It didnt listen."
        end
    end

    -- If the act is none of the above, run the base onAct function
    -- (this handles the Check act)
    return super.onAct(self, battler, name)
end
return Friend