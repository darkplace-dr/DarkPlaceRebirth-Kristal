local Voidspawn, super = Class(EnemyBattler)

function Voidspawn:init()
    super.init(self)

    -- Enemy name
    self.name = "Voidspawn"
    -- Sets the actor, which handles the enemy's sprites (see scripts/data/actors/dummy.lua)
    self:setActor("voidspawn")

    -- Enemy health
    self.max_health = 15000
    self.health = 15000
    -- Enemy attack (determines bullet damage)
    self.attack = 30
    -- Enemy defense (usually 0)
    self.defense = 25
    -- Enemy reward
    self.money = 500

    self.experience = 200

    -- Mercy given when sparing this enemy before its spareable (20% for basic enemies)
    self.spare_points = 0

    self.disable_mercy = true
    self.tired = false
    self.tired_percentage = -1
    self.low_health_percentage = 0.1

    -- List of possible wave ids, randomly picked each turn
    self.waves = {
        --"voidspawn/eyebeam",
        "voidspawn/ram"
    }

    -- Dialogue randomly displayed in the enemy's speech bubble
    self.dialogue = {}

    -- Check text (automatically has "ENEMY NAME - " at the start)
    self.check = "AT 30 DF 200\n* Essence of the void."

    -- Text randomly displayed at the bottom of the screen each turn
    self.text = {
        "* The pain itself is reason why.",
        "* Cornered.",
        "* Smells like          .",
    }
    -- Text displayed at the bottom of the screen when the enemy has low health
    self.low_health_text = "* Voidspawn starts to dissipate."

    self:registerAct("Brighten", "Powerup\nlight", "all", 4)
    self:registerAct("Banish",   "Defeat\nenemy",  nil,   64)

    self.graze_tension = 0.1

    self.resistances = {
        HOLY = 0.25,
        DARK = math.huge
    }
	self.is_active = false
	self.sprite.eye_center = true
	self.sprite.body_alpha = 1
	self.sprite.trail_speed = 0
	self.sprite.trail_dir = math.rad(0)

    self.siner_active = true
end

function Voidspawn:update()
    super.update(self)

    if Game.battle.state ~= "TRANSITION" and Game.battle.state ~= "INTRO" then
		if not self.is_active then
			self.sprite.eye_center = false
			self.sprite:setEyeState("SET", self.x - 10, self.y + 30)
			self.sprite:setBodyState("DARKTRAIL")
			self.is_active = true
			self.sprite.trail_speed = 2
		end
		self.sprite.fly_siner = self.sprite.fly_siner + DTMULT
        if self.siner_active then
            self.sprite.y = MathUtils.lerp(self.sprite.y, -(math.sin(self.sprite.fly_siner / 7)) * 4, 0.75)
        else
            self.sprite.y = MathUtils.lerp(self.sprite.y, 0, 0.5)
        end
	end
end

function Voidspawn:onHurt(damage, battler)
	super.onHurt(self, damage, battler)

	if damage >= 100 then
		self.sprite:setBodyState("CRITHURT")
	else
		self.sprite:setBodyState("HURT")
	end
end

function Voidspawn:onHurtEnd()
    if self.health > 0 then
	    self.sprite:setBodyState("DARKTRAIL")
    end
end

function Voidspawn:onDefeat()
    self.hurt_timer = -1
    self.defeated = true

    self.sprite:kill()
    self.siner_active = false

    if Game:getFlag("can_kill") then
        self:defeat("KILLED", true)
        if Game:hasPartyMember("hero") then
            Game:getPartyMember("hero"):addKarma(1)
        end
    else
        self:defeat("VIOLENCED", true)
    end
end

function Voidspawn:onAct(battler, name)
    if name == "Banish" then
        battler:setAnimation("act")
        Game.battle:startCutscene(function(cutscene)
            cutscene:text("* "..battler.chara:getName().."'s SOUL emitted a brilliant \nlight!")
            battler:flash()

            local bx, by = battler:getRelativePos(battler.width/2 + 4, battler.height/2 + 4)

            local texture = "player/heart_centered"
            if battler.chara.id == "susie" then texture = "player/heart_centered_flip" end -- hacky
            local soul = Game.battle:addChild(TitanSpawnPurifySoul(texture, bx, by, semi, self))
            soul.color = Game:getPartyMember(Game.party[1].id).soul_color or { 1, 0, 0 }
            soul.layer = 501

            cutscene:wait(function() return soul.t >= 500 end)
            cutscene:after(function()
                if #Game.battle.enemies == 0 then
                    Game.battle:setState("VICTORY")
                else
                    Game.battle:finishAction()
                    Game.battle:setState("ACTIONS", "CUTSCENE")
                end
            end)
        end)
        return
    elseif name == "Brighten" then
        for _,party in ipairs(Game.battle.party) do
            party:flash()
        end
        Assets.playSound("boost")
        local bx, by = Game.battle:getSoulLocation()
        local soul = Sprite("effects/soulshine", bx + 5.5, by)
        soul:play(1 / 30, false, function() soul:remove() end)
        soul:setOrigin(0.5)
        soul:setScale(2, 2)
        Game.battle:addChild(soul)
		Game.battle.encounter.light_radius = 63
        return "* "..battler.chara:getName().."'s SOUL shone brighter!"
    elseif name == "Standard" then --X-Action
        return "* "..battler.chara:getName().." didn't know what to do..."
    end

    -- If the act is none of the above, run the base onAct function
    -- (this handles the Check act)
    return super.onAct(self, battler, name)
end

return Voidspawn