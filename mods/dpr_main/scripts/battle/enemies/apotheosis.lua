local Apotheosis, super = Class(EnemyBattler)

function Apotheosis:init()
    super.init(self)

    self.name = "Apotheosis"
    self:setActor("voidspawn") -- Placeholder

    self.max_health = 2147483647
    self.health = 2147483647
    self.attack = 60
    self.defense = 0
    self.money = 500

    self.experience = 200

    self.spare_points = 0

    self.disable_mercy = true
    self.tired = false
    self.tired_percentage = -1
    self.low_health_percentage = 0.15
    self.can_freeze = false
    self.boss = true

    self.waves = {
        "voidspawn/eyebeam",
    }

    self.dialogue = {}

    self.check = "AT ??? DF ???\n* A being of pure HOLY energy.\n* This is the end."

    self.text = {
        "* The very air itself eminates with freedom.",
    }
    self.low_health_text = "* Apotheosis is going all out!"

    self:registerAct("Unleash",   "Lower\ndefenses",  nil,   100)

    self.killable = true

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
end

function Apotheosis:update()
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
        self.sprite.y = -(math.sin(self.sprite.fly_siner / 7)) * 4
	end
end

function Apotheosis:onHurt(damage, battler)
	super.onHurt(self, damage, battler)

	if damage >= 100 then
		self.sprite:setBodyState("CRITHURT")
	else
		self.sprite:setBodyState("HURT")
	end
end

function Apotheosis:onHurtEnd()
	self.sprite:setBodyState("DARKTRAIL")
end

function Apotheosis:onAct(battler, name)
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
                Game.battle:finishAction()
                Game.battle:setState("ACTIONS", "CUTSCENE")
            end)
        end)
        return

    elseif name == "Standard" then --X-Action
        return "* "..battler.chara:getName().." didn't know what to do..."
    end

    -- If the act is none of the above, run the base onAct function
    -- (this handles the Check act)
    return super.onAct(self, battler, name)
end

return Apotheosis