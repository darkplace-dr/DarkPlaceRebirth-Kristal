local Shadowguy, super = Class(EnemyBattler)

--[[function Shadowguy:selectWave()
    local waves = self:getNextWaves()
	
    if waves and #waves > 0 then
        local wave = Utils.pick(waves)
		
		while wave == self.prev_wave do
			wave = Utils.pick(waves)
		end
		
        self.selected_wave = wave
		self.prev_wave = wave
        return wave
    end
end]]

function Shadowguy:onAct(battler, name)
    if name == "PointHearts" then
        self:addMercy(Utils.round(50/#Game.battle.party))
        return string.format("* %s pointed at Shadowguy!", battler.chara:getName())
	end

	return super.onAct(self, battler, name)
end

function Shadowguy:getXAction(battler)
    return "PointHearts"
end

function Shadowguy:init()
    super.init(self)
	
    self.name = "Shadowguy"
    self:setActor("shadowguy")

    -- if Game:getPartyMember("susie"):getFlag("auto_attack") then
        -- self:registerAct("Warning")
    -- end

    -- self.susie_warned = false

    -- self.asleep = false
    -- self.become_red = false
	
    self.waves = {
		"shadowguy/saxophone",
		"shadowguy/gunfight",
	}
	
	self.check = "AT [image:ui/battle/btn/fight, 0,4] DF [image:ui/battle/btn/defend, 0,4]\n* Battling's just a side gig. Playing on stage is the dream!"
	
	self.prev_wave = nil
	
	self.spare_points = 25
	self.attack = 10
	self.health = 320
	self.max_health = self.health
	self.gold = 96
	self.experience = 15
	
    self.text = {
        "* Shadowguy readies his gun.",
        "* Shadowguy remembers he has a \ncasting soon.",
        "* Shadowguy looks for something impressive.",
        "* Shadowguy looks for his shadow before realizing there isn't one."
    }
	
	self.low_health_text = "* Shadowguy is slowly fading into the darkness."
	
	self:registerAct("PointHearts")
    self:registerAct("PointHeartsX", "", "all")
end

local function shootHearts(self, battler, timer, mark)
	local heart = Sprite("player/shoot_heart", battler.x + 42, battler.y - 46)

    Assets.playSound("groundpound", 0.6)

	if battler.chara.id == "susie" then
		heart.y = heart.y - 9
		heart.x = heart.x - 6
	end
	
	heart:setColor(1, 0, 0)
	heart.layer = 9999
	
	local tween = timer:tween(0.35, heart, {x = 640, y = mark.y}, nil, function()
		heart:remove()	
	end)
	
	local during = tween.during
	local enemies = Game.battle.enemies

	-- What the FUCK
	tween.during = function(...)
		for k,enemy in ipairs(enemies) do
			local hitbox = Hitbox(heart, 0, 0, 10, 10)
			local enemyHitbox = Hitbox(enemy, unpack(enemy.actor.hitbox))
		
			if hitbox:collidesWith(enemyHitbox) then
                Assets.playSound("damage", 0.4)

				local power = 3
				local socks = enemy.sprite.socks
				socks:shake(math.random(-power, power), math.random(-power, power))
				socks.graphics.shake_delay = 1
				socks.hit = socks.hit + 1
				
				heart.physics.speed_x = math.random(-1, 4)
				heart.physics.speed_y = -math.random(2, 4)
				heart.physics.gravity = 1.6
			
				timer:script(function(wait)
					wait(0.2)
					heart.physics.speed_y = -2
					wait(0.15)
					heart:remove()
				end)
			
				tween.during = function() end
				tween.after = function() end
				during = function() end
				break
			end
		end
		
		during(...)
	end
	
	Game.battle:addChild(heart)
end

function Shadowguy:onActStart(battler, name)
	if name ~= "PointHeartsX" then
		return super.onActStart(self, battler, name)
	end
	
	local continueAct = true
	
	local offsets = {
		kris = {8, 0},
		ralsei = {6, 0},
	}
	
    local function getSpriteAndOffset(id)
        local selected_sprite = "party/" .. id:lower() .. "/dark/battle/thriller"
        local selected_offset = offsets[id] or {0, 0}
        return selected_sprite, selected_offset[1], selected_offset[2]
    end
	
	local function setActSprite(self, sprite, ox, oy, speed, loop, after)
		self:setCustomSprite(sprite, ox, oy, speed, loop, after)

		local x = self.x - (self.actor:getWidth()/2 - ox) * 2
		local y = self.y - (self.actor:getHeight() - oy) * 2
		local flash = FlashFade(sprite, x, y)
		flash:setOrigin(0, 0)
		flash:setScale(self:getScale())
		self.parent:addChild(flash)

		local afterimage1 = AfterImage(self, 0.7)
		local afterimage2 = AfterImage(self, 0.9)
		afterimage1.physics.speed_x = 4
		afterimage2.physics.speed_x = 2

		afterimage2.layer = afterimage1.layer - 1

		self:addChild(afterimage1)
		self:addChild(afterimage2)
	end
	
	local enemies = Game.battle.enemies
		
	local mark = Sprite("player/mark", 0, 240)
	mark:setOrigin(0.5)
	mark:setScale(4)
	mark.alpha = 0
	mark.rotation = math.rad(270 + 270)
	
	local timer = Timer()
	Game.battle:addChild(timer)
	Game.battle:addChild(mark)
	
	local t = 1.25
	
	for _,ibattler in ipairs(Game.battle.party) do
		local texture, x, y = getSpriteAndOffset(ibattler.chara.id)

		setActSprite(ibattler, texture, x, y)
	end
	
	-- do
		-- local x = self.x - (self.actor:getWidth() * .5) * 2
		-- local y = self.y - (self.actor:getHeight()) * 2
		-- local flash = FlashFade(self.actor.sprite, x, y)
		-- flash:setOrigin(0, 0)
		-- flash:setScale(self:getScale())
		
		-- self:addChild(flash)
	-- end
	
	for k,enemy in ipairs(enemies) do
		local darken_fx = enemy:addFX(RecolorFX())
		enemy._darken_fx = darken_fx
		
		timer:tween(1, darken_fx, {color = {0.6, 0.6, 0.6}})
		
		local socks = enemy.sprite.socks
		socks.visible = true
		socks.copyMov = enemy
		Game.battle:addChild(socks)
	end
	
	timer:tween(t, mark, {alpha = 1, x = self.x}, 'out-circ', function()
		timer:script(function(wait)
			wait(2)
			timer:tween(0.25, mark, {alpha = 0}, nil, function()
				continueAct = false
			end)
		end)
	end)
	
	timer:tween(t, mark, {rotation = 0, scale_x = 1, scale_y = 1}, 'out-sine', function()
		timer:script(function(wait)
			local enemies = Game.battle.enemies

			while continueAct do
				for _,ibattler in ipairs(Game.battle.party) do
					shootHearts(self, ibattler, timer, mark)
				end
				
				-- for k,enemy in ipairs(enemies) do

				-- end
				
				wait(0.12)
			end
		end)
	end)
	
	timer:script(function(wait)
		while continueAct do
			if Input.down("down") then
				mark.y = mark.y + 10
			elseif Input.down("up") then
				mark.y = mark.y - 10
			end
			
			wait()
		end
	end)
		
	timer:script(function(wait)
		local rot = 0
		local pos = {}
		
		for k,enemy in ipairs(enemies) do
			pos[enemy] = {enemy.x, enemy.y}
		end
		
		while continueAct do
			rot = rot + 0.075
			
			for k,enemy in ipairs(enemies) do
				enemy.physics.speed_x = math.cos(rot) * ((k % 2 == 0 and -1) or 1) * 3
				enemy.physics.speed_y = math.sin(rot) * 1.5
			end
			
			wait()
		end
		
		local t = 0.5
		
		for k,enemy in ipairs(enemies) do
			local socks = enemy.sprite.socks
			
			local count = 20
			
			if socks.hit > count then
				enemy:addMercy(100)

				local socks = Sprite("npcs/shadowguy/socks", socks.x, socks.y)
				socks:setScale(2)
				socks.layer = enemy.layer + 4
				socks.rotation_origin_x = 1
				socks.rotation_origin_y = 1
				socks.physics.speed_x = 14
				socks.physics.speed_y = -4			
				socks.graphics.spin = 0.15
				
				Game.battle:addChild(socks)
			elseif socks.hit <= count and socks.hit ~= 0 then
				enemy:addMercy(50)
			end
			
			socks.visible = false
			socks.copyMov = nil
			socks.hit = 0
			
			timer:tween(t, enemy._darken_fx, {color = {1, 1, 1}}, nil, function()
				enemy:removeFX(enemy._darken_fx)
			end)
			
			enemy.physics.speed_x = 0
			enemy.physics.speed_y = 0
			
			local pos = pos[enemy]
			timer:tween(t, enemy, {x = pos[1], y = pos[2]})	
		end
		
		for _,ibattler in ipairs(Game.battle.party) do
			ibattler:resetSprite()
		end
	
		wait(1)
		
		timer:remove()
		Game.battle:finishAction()
	end)
end

function Shadowguy:getEnemyDialogue()
    local dialogue
	
    if self.mercy >= 100 then
        dialogue = Kristal.getLibConfig("shadowguy", "full_mercy") or Kristal.getLibConfig("shadowguy", "dialogue")
    else
        dialogue = Kristal.getLibConfig("shadowguy", "dialogue")
    end
	
    return dialogue[math.random(#dialogue)]
end

function Shadowguy:onDefeat()
    super.onDefeat(self)

    Assets.playSound("shadowguy_scream")
end

return Shadowguy