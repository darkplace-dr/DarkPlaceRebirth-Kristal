local LenHood, super = Class(EnemyBattler)

function LenHood:init()
    super.init(self)

    -- Enemy name
    self.name = "Len's hoodie"
    -- Sets the actor, which handles the enemy's sprites (see scripts/data/actors/dummy.lua)
    self:setActor("len_hood")

    -- Enemy health
    self.max_health = 5950
    self.max_health = self.max_health * (#Game.party / 3)
    self.health = self.max_health
    -- Enemy attack (determines bullet damage)
    self.attack = 14
    -- Enemy defense (usually 0)
    self.defense = 0
    -- Enemy reward
    self.money = 8000

    self.experience = 5

    -- Mercy given when sparing this enemy before its spareable (20% for basic enemies)
    self.spare_points = 0

    -- List of possible wave ids, randomly picked each turn
    self.waves = {
        "len_hood/greenbasictest",
        "len_hood/greenwalktest",
        "len_hood/randomshells",
        "len_hood/randomshells2",
        "len_hood/greenbasictestslow",
        "len_hood/greenbasictestfast",
        "len_hood/randomshit",
        "len_hood/hammertest",
        "len_hood/greentransitiontest",
        "len_hood/randomshells2",
        "len_hood/rainbowshell",
        "len_hood/slhammertest",
    }

    -- Dialogue randomly displayed in the enemy's speech bubble
    self.dialogue = {
        {
            "If you want this\nspear,[wait:5] then you must\nprove yourself worth.",
        },
        {
            "My creator didn't\nbelieve in bad endings.",
            "Could you really take\na diceased's weapon?"
        },
        {
            "Don't you get tired of\nhaving all of these\noptions?",
            "And with so many,[wait:5]\nwhat makes you think\nthis matters?"
        },
        {
            "This is but a mere\ndistraction,[wait:5] isn't it?",
        },
        {
            "You can't hide this\nform forever,[wait:5] you know?",
        },
        {
            "One day or another,[wait:5] you'll\nhave to fight alone.",
            "What will you do then?",
        },
        {
            "When you finally reach\nthat final boss and\nwin this game.",
            "...[wait:5]What will you do?",
        },
        {
            "You know you can't\njust win with trying.",
            "No,[wait:5] that's not\nenough anymore,[wait:5] right?",
        },
        {
            "Winning isn't enough\nanymore, right?",
        },
        {
            "Otherwise,[wait:5] you wouln't\nbe fighting me right\nneow...",
        },
        {
            "So either fight or\nflight,[wait:5] make your choice\nonce and for all.",
            "...[wait:5]or perish trying.",
        },
        {
            "Enough talking.",
        },
    }
    if #Game.party <= 1 then
        self.dialogue[6] = {
            "What drives you forward?",
            "How does your heart\nkeep beating?",
            "...[wait:5]Knowing you have\nno one to bring you up.",
        }
    end

    -- Check text (automatically has "ENEMY NAME - " at the start)
    self.check = "AT 4 DF 0\n* Len's favorite hoodie\n* Out of itself."

    -- Text randomly displayed at the bottom of the screen each turn
    self.text = {
        "* Reading this is not the\nbest use of your time."
    }
    -- Text displayed at the bottom of the screen when the enemy has low health
    self.low_health_text = "* The final showdown is nearing."

    self:registerAct("Return Item")
    -- Register party act with Ralsei called "Tell Story"
    -- (second argument is description, usually empty)
    -- self:registerAct("Tell Story", "", {"ralsei"})

    self.tired_percentage = 0
    self.killable = false

    self.resistances = {
        FIRE = 0.75,
        ICE = 1.5
    }

    self.stolen_items = {}
    self.sprite.flip_x = true

    self.turn = 1
    self.dialogue_offset = {-80, -15}
end

function LenHood:getEnemyDialogue()
    local dialogues = self.dialogue
    local turn = Game.battle.turn_count
    local dialogue = dialogues[turn]
    if turn > #dialogues then
        dialogue = "..."
    end

    if self.final_attack and not self.final_attack_dialogue_triggered then
        self.final_attack_dialogue_triggered = true
        dialogue = {
            "Now,[wait:5] its time.",
            "Time to test if you're\ntruly worth of this power.",
            "Come on now![wait:5]\nshow me everything you've got!",
        }
    end

    if type(dialogue) == "string" then
        dialogue = {dialogue}
    end

    return dialogue
end

function LenHood:getNextWaves()
    local waves = self.waves
    local turn = self.turn
    if turn > #waves then
        turn = turn - 6
    end

    self.turn = turn + 1
    local wave = waves[turn]

    if self.final_attack and not self.final_attack_wave_triggered then
        self.final_attack_wave_triggered = true
        wave = "len_hood/final"
    end

    return {wave}
end

function LenHood:onAct(battler, name)
    if name == "Return Item" then
        
        local storage = Game.inventory.storages["items"]
        local count = Game.inventory:getItemCount(storage)
        if count > 0 then
            self:addMercy(7)
            local index = MathUtils.randomInt(1, count + 1)
            local item = Game.inventory:getItem(storage, index)
            table.insert(self.stolen_items, Game.inventory:removeItemFrom(storage, index))
            -- Act text (since it's a list, multiple textboxes)
            return {
                "* You give your [color:yellow]" .. item.name .. "[color:reset] to " .. self.name .. " to show your appreaciation for these items."
            }
        else
            self:addMercy(5)
            return {
                "* You try to find an item to give...[wait:5]\nbut you had none left.[wait:5]\n* " .. self.name .. " appreciates the effort."
            }
        end

    elseif name == "Refuse" then
        Game.battle:startActCutscene("len_hood", "refuse")
        return

    elseif name == "Standard" then --X-Action
        -- Give the enemy 50% mercy
        self:addMercy(3)
        return "* "..battler.chara:getName().." showed their respects\nfor items."
    end

    -- If the act is none of the above, run the base onAct function
    -- (this handles the Check act)
    return super.onAct(self, battler, name)
end

function LenHood:onDefeat(damage)
    local battle = Game.battle
    battle.music:stop()
    battle.timer:after(1, function()
        battle:setState("TRANSITIONOUT")
    end)
end

return LenHood