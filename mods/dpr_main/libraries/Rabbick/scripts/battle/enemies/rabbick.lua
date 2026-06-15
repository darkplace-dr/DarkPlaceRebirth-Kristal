local Rabbick, super = Class(EnemyBattler)

function Rabbick:init()
    super.init(self)

    self.name = "Rabbick"
    self:setActor("rabbick")

    self.path = "enemies/rabbick"
    self.default = "idle"

    self.max_health = 120
    self.health = 120
    self.attack = 6
    self.defense = 0
    self.money = 30

    self.spare_points = 20

    self.waves = {
        "rabbick/rabbits",
        "rabbick/carrot_thrower"
    }

    self.check = "AT 8 DF 1\n* This dusty bunny needs a bit \nof spring cleaning."

    self.text = {
        "* Rabbick is looking for a couch \nto get stuck under.",
        "* Rabbick emits a musty groan.",
        "* Rabbick ambiently damages the \nsoil.",
        "* The battlefield is filled with \nthe smell of dusty mustard."
    }

    self.low_health_text = "* Rabbick is starting to look wispy."
    self.spareable_text = "* Rabbick is now nice and clean."

    self:registerAct("Blow On")
    self:registerAct("BreathAll", nil, "ralsei")

    self.text_override = nil
	
    self.dialogue_bubble = "round"
	
    self.blowall = 0
    self.blowing = 0
    self.animsiner = 0
    self.blow_amt = 0
    self.blowtimer = 180
    self.blowbuffer = 3
    self.blown = false
    self.blowanimtimer = 0
    self.blow_wait = 0
	
    self.onoff = 0
    self.shakeamt = 0
    self.originalwidth = self.actor.width
end

function Rabbick:selectWave()
    local waves = self:getNextWaves()

    if waves and #waves > 0 then
        local wave = Utils.pick(waves)
        if #Game.battle.enemies > 2 and wave == "rabbick/rabbit_thrower" then
            wave = "rabbick/rabbits"
        end
        self.selected_wave = wave
        return wave
    end
end

function Rabbick:isXActionShort(battler)
    return true
end

function Rabbick:onShortAct(battler, name)
    if name == "Standard" then --these are actually Ribbick's X-Actions, but ig they also apply to Rabbick as well cause of that secret fight in Chapter 3.
        if battler.chara.id == "susie" then
            self:addMercy(50)
            local msg = Utils.pick{
                "* Susie generates filth!",
                "* Susie shows gum from her shoe!!",
                "* Susie says dirty words!"
            }
            return msg
        elseif battler.chara.id == "ralsei" then
            self:addMercy(25)
            self:setTired(true)
            local msg = Utils.pick{
                "* Ralsei tries tidying up!",
                "* Ralsei uses a feather duster!",
                "* Ralsei croaks sympathetically!"
            }
            return msg
        end
    end
    return nil
end

function Rabbick:onAct(battler, name)
    if name == "Standard" then --these are actually Ribbick's X-Actions, but ig they also apply to Rabbick as well cause of that secret fight in Chapter 3.
        if battler.chara.id == "susie" then
            self:addMercy(50)
            Game.battle:startActCutscene(function(cutscene)
                cutscene:text("* Susie dirties the enemy \nfurther! It seemed to like it!")
            end)
            return
        elseif battler.chara.id == "ralsei" then
            self:addMercy(25)
            self:setTired(true)
            Game.battle:startActCutscene(function(cutscene)
                cutscene:text("* Ralsei tried to clean the \nenemy! It became TIRED...")
            end)
            return
        end
    end
    return super.onAct(self, battler, name)
end

function Rabbick:onActStart(battler, name)
	if name == "Blow On" then
		if self.blown then
			Game.battle:setActText("* "..battler.chara:getName().." breathed on the Rabbick.[wait:5]\n* It blew away entirely...")
			self:spare()
		else
			Game.battle:infoText("* Press "..Input.getText("confirm").." repeatedly to blow \nair!")
			Game.battle:addChild(RabbickBlowAct(self, false))
		end
    elseif name == "BreathAll" then
        local enemies = Utils.filter(Game.battle:getActiveEnemies(), function(enemy) return enemy.id == "rabbick" and not enemy.blown end)
        if #enemies <= 0 then
			local rabbicks = Utils.filter(Game.battle:getActiveEnemies(), function(enemy) return enemy.id == "rabbick" end)
			Game.battle:setActText("* The bunnies were blown away!")
			for _,enemy in ipairs(rabbicks) do
				enemy:spare()
			end
		else
			Game.battle:infoText("* Press "..Input.getText("confirm").." repeatedly to blow \nair!")
			Game.battle:addChild(RabbickBlowAct(enemies, true))
		end
    else
        return super.onActStart(self, battler, name)
	end
end

function Rabbick:blowAnimation()
	local effect = Sprite("enemies/rabbick/dust_orb")
	effect:setOrigin(0.5)
	effect:setScale(2)
	local width = self:getActiveSprite().texture:getWidth()
	local height = self:getActiveSprite().texture:getHeight()
	effect:setPosition(self.x - width + Utils.random(width*2 - 10) + 10, self.y - height*2 + 20 + Utils.random(height*2 - 20))
	effect.layer = self.layer + 1
	effect.physics.speed = 6
	effect.physics.direction = -math.rad(10 + Utils.random(70))
	effect.physics.gravity_direction = math.rad(0)
	effect.physics.gravity = 0.7
	effect.physics.friction = 0.4
	effect.alpha = 0.5
	if self.blown then
		effect.alpha = 1
		effect.layer = self.layer + 2
	end
	effect:setFrame(2)
	effect:play(1/15, false, function(s) s:remove() end)
	Game.battle:addChild(effect)
end

function Rabbick:getEnemyDialogue()
    if self.text_override then
        local dialogue = self.text_override
        self.text_override = nil
        return dialogue
    end

    local dialogue
    if self.blown then
        dialogue = {
            "A soft and\nclean boy.",
            "A refreshing\nboy.",
            "A sweet and\nfresh girl.",
            "A nice and\ntidy girl."
        }
    else
        dialogue = {
            "Snitter\nsnatter\nwhat's the\nmatter",
            "Duruuuu---",
            "Hop,[wait:5] hop",
            "Meow.",
            "Bunnies are\nthe sequel\nto frogs."
        }
    end
    return dialogue[math.random(#dialogue)]
end

function Rabbick:update()
	super.update(self)
	self.overlay_sprite.scale_x = self.sprite.fake_scale_x
	if self.sprite.fake_scale_x <= 0.75 then
		self.overlay_sprite.scale_x = self.sprite.fake_scale_x + 0.25
    end
end

function Rabbick:onHurt(damage, battler)
	super.onHurt(self, damage, battler)
	if self.sprite.fake_scale_x <= 0.75 then
		self.overlay_sprite:setSprite("hurt_2")
    end
end

return Rabbick