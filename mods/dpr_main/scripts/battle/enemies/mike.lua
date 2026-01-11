local MikeTest, super = Class(EnemyBattler)

function MikeTest:init()
    super.init(self)

    -- Enemy name
    self.name = "Mike"
    -- Sets the actor, which handles the enemy's sprites (see scripts/data/actors/dummy.lua)
    self:setActor("ufoofdoom")

    -- Enemy health
    self.max_health = 500
    self.health = 500
    -- Enemy attack (determines bullet damage)
    self.attack = 3
    -- Enemy defense (usually 0)
    self.defense = 0
    -- Enemy reward
    self.money = 50
    self.experience = 13
	self.service_mercy = 10

    -- Mercy given when sparing this enemy before its spareable (20% for basic enemies)
    self.spare_points = 34

    -- List of possible wave ids, randomly picked each turn
    self.waves = {
        "thestars/starsides",
        "thestars/starcircle",
        "thestars/starfade",
    }

    -- Dialogue randomly displayed in the enemy's speech bubble
    self.dialogue = {}

    -- Check text (automatically has "ENEMY NAME - " at the start)
    self.check = ""

    -- Text randomly displayed at the bottom of the screen each turn
    self.text = {
        "* Mike is definitely a test!"
    }
end

function MikeTest:spawnSpeechBubble(text, options)
    options = options or {}
    local bubble
    if not options["style"] and self.dialogue_bubble then
        options["style"] = self.dialogue_bubble
    end
    local x, y
    local spr = self.sprite or self
    if not options["right"] then
        x, y = spr:getRelativePos(0, spr.height/2, Game.battle)
        x, y = x + self.dialogue_offset[1], y + self.dialogue_offset[2]
    else
        x, y = spr:getRelativePos(spr.width, spr.height/2, Game.battle)
        x, y = x - self.dialogue_offset[1], y + self.dialogue_offset[2]
    end
    bubble = SpeechBubble(text, x, y, options, self)
    self.bubble = bubble
    self:onBubbleSpawn(bubble)
    bubble:setCallback(function()
        self:onBubbleRemove(bubble)
        bubble:remove()
        self.bubble = nil
    end)
	bubble.text.mike_mode = true
	bubble.text.mike_advance_time = 75
	bubble.text.mike_extra_time = math.floor((options["speed"] or 2) * 35)
	bubble.text.skippable = options["skip"] or true
    Game.battle:addChild(bubble)
    return bubble
end

return MikeTest
