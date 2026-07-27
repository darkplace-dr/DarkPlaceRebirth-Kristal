local Dummy, super = Class(EnemyBattler)

function Dummy:init()
    super.init(self)

    -- Enemy name
    self.name = "Friendling"
    -- Sets the actor, which handles the enemy's sprites (see scripts/data/actors/dummy.lua)
    self:setActor("charafriendling")

    -- Enemy health
    self.max_health = 450
    self.health = 450
    -- Enemy attack (determines bullet damage)
    self.attack = 4
    -- Enemy defense (usually 0)
    self.defense = 3
    -- Enemy reward
    self.money = 100

    self.experience = 5

    -- Mercy given when sparing this enemy before its spareable (20% for basic enemies)
    self.spare_points = 10

    -- List of possible wave ids, randomly picked each turn
    self.waves = {
        "chloropurr/leafrise",
    }

    -- Dialogue randomly displayed in the enemy's speech bubble
    self.dialogue = {
        "..."
    }

    -- Check text (automatically has "ENEMY NAME - " at the start)
    self.check = "AT 4 DF 3\n* Wretched smile, neon eyes.\n* Likely won't be the cause of your demise."

    -- Text randomly displayed at the bottom of the screen each turn
    self.text = {
        "* You can't tell the difference between\nit's head and it's body.",
        "* The friendling flashes\na wicked smile.",
        "* The atmosphere smells friendly.",
    }
    -- Text displayed at the bottom of the screen when the enemy has low health
    self.low_health_text = "* The friendling looks\ninjured."

    -- Register act called "Smile"
    self:registerAct("Smile")
    -- Register party act with Ralsei called "Tell Story"
    -- (second argument is description, usually empty)

    self.killable = true

    self.resistances = {
        FIRE = 0.75,
        ICE = 1.5
    }
end

function Dummy:onAct(battler, name)
    if name == "Smile" then
        -- Give the enemy 100% mercy
        self:addMercy(20)
        -- Change this enemy's dialogue for 1 turn
        self.dialogue_override = "..."
        -- Act text (since it's a list, multiple textboxes)
        return {
            "* It smiles.[wait:5]\n* You smile back.",
            "* It seems to have\nhelped soothe it."
        }

    elseif name == "Standard" then --X-Action
        -- Give the enemy 50% mercy
        if battler.chara.id == "pink" then
            -- S-Action: start a cutscene (see scripts/battle/cutscenes/dummy.lua)
            self:addMercy(40)
            return "* Pink pet the friendling.\n* The friendling seems surprised!"
        elseif battler.chara.id == "susie" then
            self:addMercy(30)
            -- S-Action: start a cutscene (see scripts/battle/cutscenes/dummy.lua)
            return "* Susie was wary of the friendling.\n* The friendling enjoys this."
        else
            -- Text for any other character (like Noelle)
            self:addMercy(35)
            return "* "..battler.chara:getName().." gave the friendling a nervous smile."
        end
    end

    -- If the act is none of the above, run the base onAct function
    -- (this handles the Check act)
    return super.onAct(self, battler, name)
end

return Dummy