local Len, super = Class(EnemyBattler)

function Len:init()
    super.init(self)
    self.hits = 1

    -- Enemy name
    self.name = "Len"
    self.pathname = "len"
    -- Sets the actor, which handles the enemy's sprites (see scripts/data/actors/dummy.lua)
    self:setActor(self.pathname .. "_real")

    -- Enemy health
    self.max_health = 12500
    self.health = 12500
    -- Enemy attack (determines bullet damage)
    self.attack = 8
    if Game:getFlag("stellarLensEquipped") then
        self.attack = self.attack + self.attack / 80
    end
    -- Enemy defense (usually 0)
    self.defense = 12
    -- Enemy reward
    self.money = 460

    self.experience = 2000

    -- Mercy given when sparing this enemy before its spareable (20% for basic enemies)
    self.spare_points = 0

    -- List of possible wave ids, randomly picked each turn
    self.waves = {
        self.pathname .. "/arenadark",
    }

    -- Dialogue randomly displayed in the enemy's speech bubble
    self.dialogue = {
        "..."
    }

    -- Check text (automatically has "ENEMY NAME - " at the start)
    self.check = "AT" .. (self.attack * 2) .. " DF 200\n* One of the oldest dark kings\n* Completely resigned from your party."

    -- Text randomly displayed at the bottom of the screen each turn
    self.text = {
        "* " .. self.name .. " is focusing on the fight",
        "* The air crackles with darkness",
        "* Freedom dripping from the sink",
        "* Unleashed hero, fighting for what's right",
        "* The hand of justice stands by"
    }
    -- Text displayed at the bottom of the screen when the enemy has low health
    self.low_health_text = "* "  .. self.name .. " is preparing something big!"

    -- Register act called "Reason"
    self:registerAct("Reason")
    -- Register party act with Ralsei called "Tell Story"
    -- (second argument is description, usually empty)
    self:registerAct("Pacify", "", {"susie"})
    self:registerAct("Negotiate", "", {"ralsei"})
    self:registerAct("Mock", "", {"dess"})

    self.killable = true
end

function Len:onAct(battler, name)
    if name == "Reason" then
        -- Change this enemy's dialogue for 1 turn
        self.dialogue_override = "..."
        -- Act text (since it's a list, multiple textboxes)
        return {
            "* You tried to reason with " .. self.name .. ".",
            "* But " .. self.name .. " did not listen.",
        }

    elseif name == "Pacify" then
        local tired = self.tireness
        tired = tired or 0
        tired = tired + 1
        self.tireness = tired
        if tired < 20 then
            Assets.playSound("bell_bounce_short")
            local tiredText = "???"
            if tired < 2 then
                tiredText = "a bit"
            elseif tired < 4 then
                tiredText = "slighly"
            elseif tired < 5 then
                tiredText = "even"
            elseif tired < 9 then
                tiredText = "heavily"
            elseif tired < 12 then
                tiredText = "extremely"
            elseif tired < 15 then
                tiredText = "EXTREMELY"
            elseif tired < 18 then
                tiredText = "VERY EXTREMELY"
            elseif tired == 19 then
                return "* You and Susie use pacify\n* " .. self.name .. " seems about to doze off"
            elseif tired > 19 then
                Assets.playSound("bell")
                return "* You and Susie use pacify\n* " .. self.name .. " is tired"
            end
            return "* You and Susie use pacify\n* " .. self.name .. " gets " .. tiredText .. " more [color:blue]TIRED[color:reset]..."
        else
            if not self.tired then
                Assets.playSound("hypnosis")
                self:setTired(true)
                return "* " .. self.name .. " is now [color:blue]TIRED[color:reset]"
            else
                return "* But " .. self.name .. " was already [color:blue]TIRED[color:reset]"
            end
        end

    elseif name == "Negotiate" then
        Game.battle:startActCutscene(self.pathname, "negotiate")
    elseif name == "Standard" then --X-Action
        -- Give the enemy 50% mercy
        self:addMercy(2)
        local chara = battler.chara
        local id = chara.id
        if id == "ralsei" then
            -- R-Action text
            return "* Ralsei tried to reason with " .. self.name .. "."
        elseif id == "susie" then
            return "* Susie tried to reason with " .. self.name .. "."
        elseif id == "dess" then
            return "* Dess did nothing usefull, it works somehow"
        else
            -- Text for any other character (like Noelle)
            return "* " .. chara:getName() .. " tried to reason with" .. self.name .. "."
        end
    end

    -- If the act is none of the above, run the base onAct function
    -- (this handles the Check act)
    return super.onAct(self, battler, name)
end

function Len:onHurtEnd()
    Game.battle:startCutscene("len","auch")
    self.hits = self.hits + 1
end

function Len:getNextWaves()
    local p = self.pathname .. "/"
    local selwaves = {
        p .. "arenadark",
        p .. "arenadarkfast",
        p .. "darkpillars",
        p .. "darkaimsoul",
        p .. "arenadarkaimsoulmercy"
    }
    self.wave_override = selwaves[self.hits] or (p .. "arenadark")
    print(self.wave_override)
end

function Len:defeat(reason, violent)
    local c
    if reason == "PACIFIED" then
        c = Game.battle:startCutscene("len.pacify", nil, self)
    elseif reaason == "KILLED" and violent then
        c = Game.battle:startCutscene("len.dies", nil, self)
    elseif reason == "FROZEN" and not violent then
        c = Game.battle:startCutscene("len.frozen", nil, self)
    end

    c:after(function()
        Game.battle:setState("ENEMYDIALOGUE")
    end)
end

return Len