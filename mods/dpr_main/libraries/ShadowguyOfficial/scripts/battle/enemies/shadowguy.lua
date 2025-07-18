local Shadowguy, super = Class(EnemyBattler)

function Shadowguy:init()
    super.init(self)
	
    self.name = "Shadowguy"
    self:setActor("shadowguy")

    self.waves = {
		"shadowguy/sax",
		"shadowguy/tommygun",
	}
	
	self.check = "AT[image:ui/sharp_note_symbol, 9,-3] DF[image:ui/flat_note_symbol, 12,-1]\n* Battling's just a side gig. Playing on stage is the dream!"
	
	self.prev_wave = nil
	
	self.spare_points = 10
	self.attack = 11
	self.health = 421
	self.max_health = self.health
	self.gold = 75
	self.experience = 15
	
    self.text = {
        "* Shadowguy plays the blues, blues, blues.",
        "* Shadowguy snaps their fingers rhythmically.",
        "* Shadowguy rolls up their socks... secretly.",
        "* Shadowguy's got the moves and the groove"
    }
	
	self.low_health_text = "* Shadowguy's blues look bluer and bluer."
	self.tired_text = "* Shadowguy is on the midnight train to Dreamsville."
	self.spareable_text = "* Shadowguy look seriously jazzed."
	
	self:registerAct("Boogie", "Dance,\ndon't\nget hit!")
    self:registerAct("Sharpshoot", "Light\n'em up", "all")
	
	self.sharpshooting = false
	self.sharpshoottimer = 0
	self.sharpshootlength = 0
	self.sharpshootmercy = 0
	
	self.fsiner = 0
	self.spare_after_sharpshoot = false
end

function Shadowguy:update()
	super.update(self)
	self.fsiner = self.fsiner + DTMULT
end

function Shadowguy:onAct(battler, name)
    if name == "Boogie" then
        self:addMercy(Utils.round(50/#Game.battle.party))
        return {string.format("* %s boogies past bullets!\n* SHADOWGUY gains mercy until you get hit!", battler.chara:getName()), "* (... but it's not implemented yet.)"}
	end

	return super.onAct(self, battler, name)
end

function Shadowguy:onShortAct(battler, name)
    if name == "Standard" then
        self:addMercy(30)
        return "* " .. battler.chara:getName() .. " danced!"
    end
    return nil
end

function Shadowguy:isXActionShort(battler)
    return true
end

function Shadowguy:onActStart(battler, name)
	if name ~= "Sharpshoot" then
		return super.onActStart(self, battler, name)
	end

	self.sharpshooting = false
	self.sharpshoottimer = 0
	self.sharpshootlength = 0
	self.sharpshoot_mercy = 0
	
	local continueact = true
	local endact = false
	
	local offsets = {
		kris = {0, 0},
		susie = {0, 3},
		ralsei = {7, 0},
		ceroba = {0, -8},
	}
	
	local heart_offsets = {
		kris = {27+34, 33+12},
		susie = {27+49, 42},
		ralsei = {47+32, 50-3},
		ceroba = {27+50, 33+6},
	}
	
    local function getSpriteAndOffset(id)
        local selected_sprite = "party/" .. id:lower() .. "/dark/battle/zoosuit"
        local selected_offset = offsets[id] or {0, 0}
        return selected_sprite, selected_offset[1], selected_offset[2]
    end
	
	for _,battler in ipairs(Game.battle.party) do
		battler:setActSprite(getSpriteAndOffset(battler.chara.id))
		local offset = heart_offsets[battler.chara.id] or {27+34, 33+12}
		battler.heart_point_x = battler.x-(battler.actor:getWidth()/2)*2+offset[1]
		battler.heart_point_y = battler.y-(battler.actor:getHeight())*2+offset[2]
	end
		
	Assets.playSound("boost")
	
	Game.battle:battleText("* Everyone gets ready to knock the enemies' socks off!", function() self.sharpshooting = true end)

	local enemies = Game.battle:getActiveEnemies()
		
	local timer = Timer()
	Game.battle:addChild(timer)
	timer:script(function(wait)
		while not self.sharpshooting do
			wait(1/30)
		end
		
		Game.battle:infoText("* Aim with "..Input.getText("left")..Input.getText("right").." and "..Input.getText("up")..Input.getText("down").."!\n* Fire with "..Input.getText("menu").."!")
		local cursor = SharpshootCursor(0, 240)
		
		Game.battle:addChild(cursor)
		
		for k,enemy in ipairs(enemies) do
			local darken_fx = enemy:addFX(RecolorFX())
			enemy._darken_fx = darken_fx
			
			timer:tween(0.7, darken_fx, {color = {0.45, 0.45, 0.45}})
			enemy.xx = enemy.x
			enemy.yy = enemy.y
			enemy:setAnimation("idle")
			local socks = enemy.sprite.socks
			socks.hittable = true
			socks.spare = false
			socks.sparehp = 9
			socks.visible = true
			socks.copyMov = enemy
			socks.enemy = enemy
			Game.battle:addChild(socks)
		end

		while continueact do
			self.sharpshoottimer = self.sharpshoottimer + DTMULT
			if self.sharpshootlength > 0 then
				self.sharpshootlength = self.sharpshootlength + DTMULT
			end
			if cursor then
				if cursor.fired_heart and self.sharpshootlength == 0 then
					self.sharpshootlength = 1
				end
				cursor.sharpshootlength = self.sharpshootlength
			end
			
			local enemies_spared = 0
			local targets_hit = 0
			for _,target in ipairs(Game.stage:getObjects(SharpshootTarget)) do
				if not target.hittable then
					targets_hit = targets_hit + 1
				end
			end
			for k,enemy in ipairs(enemies) do
				if enemy:isRemoved() or enemy.spare_after_sharpshoot then
					enemies_spared = enemies_spared + 1
					targets_hit = targets_hit + 1
				end
				if enemies_spared >= #Game.battle.enemies or targets_hit >= #Game.battle.enemies then
					endact = true
				end
				enemy.y = enemy.yy + math.sin(self.sharpshoottimer / 15) * 50
				if enemy.id == "shadowguy" then
					enemy.physics.speed_x = math.sin(self.fsiner / 12) * 2
					enemy.physics.speed_y = math.cos(self.fsiner / 12) * 2
				end
			
				if cursor:isRemoved() or self.sharpshootlength >= 180 or endact then
					if cursor then
						cursor.stopshooting = 2
					end
					enemy.physics.speed_x = 0
					enemy.physics.speed_y = 0
					enemy:slideTo(enemy.xx, enemy.yy, 10/30)
					timer:tween(0.7, enemy._darken_fx, {color = {1, 1, 1}}, nil, function()
						enemy:removeFX(enemy._darken_fx)
					end)
					continueact = false
				end
			end
			if continueact then
				wait()
			else
				for _,target in ipairs(Game.stage:getObjects(SharpshootTarget)) do
					if target.enemy then
						if not target.spare then
							target:reset()
						end
						target.enemy:addMercy(target.enemy.sharpshootmercy or 0)
						target.enemy.sharpshootmercy = 0
					end
				end
				wait(10/30)
			end
		end
        Game.battle.battle_ui:clearEncounterText()
		if not cursor:isRemoved() then
			cursor.stopshooting = true
		end
		
		for _,battler in ipairs(Game.battle.party) do
			battler:resetSprite()
		end
		
		for k,enemy in ipairs(enemies) do
			if enemy.mercy >= 100 then
				enemy:setAnimation("spared")
			else
				enemy:setAnimation("idle")
			end
			if enemy.spare_after_sharpshoot then
				enemy:defeat("SPARED", false)
				enemy:onSpared()
				enemy:remove()
			end
		end
		wait(20/30)
		self.sharpshoot_enemies = nil
		timer:remove()
		self.sharpshooting = false
		Game.battle:finishAction()
	end)
end

--- Non-violently defeats the enemy and removes them from battle (if [`exit_on_defeat`](lua://EnemyBattler.exit_on_defeat) is `true`)
---@param pacify?   boolean Whether the enemy was defeated by pacifying them rather than sparing them (defaults to `false`)
function Shadowguy:sharpshootSpare()
    if self.exit_on_defeat then
        Game.battle.spare_sound:stop()
        Game.battle.spare_sound:play()

        local spare_flash = self:addFX(ColorMaskFX())
        spare_flash.amount = 0

        local sparkle_timer = 0
        local parent = self.parent

        Game.battle.timer:during(5/30, function()
            spare_flash.amount = spare_flash.amount + 0.2 * DTMULT
            sparkle_timer = sparkle_timer + DTMULT
            if sparkle_timer >= 0.5 then
                local x, y = Utils.random(0, self.width), Utils.random(0, self.height)
                local sparkle = SpareSparkle(self:getRelativePos(x, y))
                sparkle.layer = self.layer + 0.001
                parent:addChild(sparkle)
                sparkle_timer = sparkle_timer - 0.5
            end
        end, function()
			self.visible = false
            spare_flash.amount = 1
            local img1 = AfterImage(self, 0.7, (1/25) * 0.7)
            local img2 = AfterImage(self, 0.4, (1/30) * 0.4)
            img1:addFX(ColorMaskFX())
            img2:addFX(ColorMaskFX())
            img1.physics.speed_x = 4
            img2.physics.speed_x = 8
            parent:addChild(img1)
            parent:addChild(img2)
        end)

		self.spare_after_sharpshoot = true
    end
end

function Shadowguy:getEnemyDialogue()
    return false
end

function Shadowguy:onDefeat()
    super.onDefeat(self)
	
    local random_scream = love.math.random(1, 100)

    if random_scream > 3 and random_scream <= 12 then
        Assets.playSound("wilhelm", 0.8)
    elseif random_scream > 1 and random_scream <= 3 then
        Assets.playSound("tom_scream")
    elseif random_scream == 1 then
        Assets.playSound("go_alert2")
    else
        Assets.playSound("shadowguy_scream")
    end
end

function Shadowguy:getEncounterText()
	if love.math.random(0, 100) < 4 then
		return "* Smells like old saxophone reeds."
	else
		return super.getEncounterText(self)
	end
end

return Shadowguy