local something, super = Class(EnemyBattler)

function something:init()
    super.init(self)

    -- Enemy name
    self.name = "Benchthing"
    -- Sets the actor, which handles the enemy's sprites (see scripts/data/actors/something.lua)
    self:setActor("something")

    -- Enemy health
    self.max_health = 5678
    self.health = 5678
    -- Enemy attack (determines bullet damage)
    self.attack = 10
    -- Enemy defense (usually 0)
    self.defense = 10
    -- Enemy reward
    self.money = 250

    self.experience = 0

    self.service_mercy = 0

    self.temp = 0

    self.tired_percentage = 0.25
	
	self.boss = true
    self.milestone = true

    -- Mercy given when sparing this enemy before its spareable (20% for basic enemies)
    self.spare_points = 2

    -- List of possible wave ids, randomly picked each turn
    self.waves = {
        "something/freeze",
        "something/stomp",
        "something/rush",
        "something/aimstar",
        "something/strike",
        "something/cor",
        "something/cor_h",
        "something/aim",
        "something/moving",
        "something/shoe",
        "something/hammer",
        "something/spear",
        "something/storm",
        "something/chase",
        "something/burn",
        "something/fire",
    }

    -- Dialogue randomly displayed in the enemy's speech bubble
    self.dialogue = {
        "Here goes nothing!",
        "Take that!",
        "Take a load of this!",
        "It's time for a change of pace!",
        "You're useless...\nless than useless.\nYou're sick.",
        "People like you don't deserve to live.",
        "The person they love isn't you at all.",
        "You just gotta live and learn!",
        "They'll hate you as much as you hate yourself.",
        "KRIS loved her and you killed her.",
        "BERDLY loved her and you killed her.",
        "ASRIEL loved her and you killed her.",
        "...",
        "",
        "Prepare for Trouble!",
        "I see what you are planing...",
        "Tick\nTock",
        "To the death!",
        "Sorry if I say something weird.\nMaybe I should shorten the vacation...\nI enjoy being a nightmare.",
        "I can read the future and it doesn't contain you.",
        "And the world kept turning...",
        "Ha! I got something good...",
        "Everyone is watching...\nEveryone...\nEveryone...\nEveryone...",
        "Time to finish\nthe same old story!",
        "Sins are the only thing that can't burn.",
        "Lies are temporary, your secret will be out.",
        "Let's go!",
        "Emergency!\nPeople have been going crazy in town!",
        "Bet you can't dodge this!",
        "You look so funny screaming for your life!",
        "Lol.",
        "Rofl.",
        "Don't dissapoint me.",
        "The girl will break the cage.",
        "Tonight will be until 15 pm.",
        "The banished princess\nwill gain a subject.",
        "The lord controls the\nscreens with her strings.",
    }

    -- Check text (automatically has "ENEMY NAME - " at the start)
    self.check = "AT 10 DF 10\n* A nightmare creature on vacation, has STARRUNE attacks."

    -- Text randomly displayed at the bottom of the screen each turn
    self.text = {
        "* Benchthing is holding back, you can feel a fraction of the true power hidden.",
    }
    -- Text displayed at the bottom of the screen when the enemy has low health
    self.low_health_text = "* Benchthing grows tired. They really won't try, do they?"

    self:registerAct("Lecture")
    self:registerAct("Confess", "Gain\nMercy", nil, 26)
    self:registerAct("Confess X", "Gain\nMercy", "all", 52)
    self:registerAct("Persist EX", "Restore\n100 HP", nil, 50)
    self:registerAct("Allegro", "Deal 20%\nDamage", nil, 100)

    self.killable = false
    
end

function something:onAct(battler, name)
    if name == "Lecture" then
        -- Give the enemy 100% mercy
        self:addMercy(5)
        -- Change this enemy's dialogue for 1 turn
        -- Act text (since it's a list, multiple textboxes)
        return "* You lecture benchthing on the importance of kindness. They don't mind..."

    elseif name == "Allegro" then
        self.temp = math.ceil(self.health/15)
        self:hurt(self.temp, battler)
        self:hurt(self.temp, battler)
        self:hurt(self.temp, battler)
        return "* You swing with extreme speed and accuracy and hit bencthing three times!"

    elseif name == "Confess" then
        -- Give the enemy 100% mercy
        self:addMercy(7)
        -- Change this enemy's dialogue for 1 turn
        -- Act text (since it's a list, multiple textboxes)
        return "* You confess for something you did when you were a young fool."
    elseif name == "Confess X" then
        -- Give the enemy 100% mercy
        self:addMercy(15)
        -- Change this enemy's dialogue for 1 turn
        -- Act text (since it's a list, multiple textboxes)
        return "* You confess for something you did to your allies."
    elseif name == "Persist EX" then
        battler:heal(100)
        if battler.chara.id == "susie" then
            return "* Susie persists and restores health."
        else
            return "* You persist and focus your mind to restore health."
        end

    elseif name == "Standard" then --X-Action
        -- Give the enemy 50% mercy
        self:addMercy(2)
        return "* "..battler.chara:getName().." did something."
    end

    -- If the act is none of the above, run the base onAct function
    -- (this handles the Check act)
    return super.onAct(self, battler, name)
end

return something
