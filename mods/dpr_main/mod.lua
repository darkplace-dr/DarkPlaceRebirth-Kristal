--modRequire("scripts/main/warp_bin")
--modRequire("scripts/main/utils_general")

function Mod:init()
    print("Loaded "..self.info.name.."!")
	
    self.voice_timer = 0
    
    self.border_shaders = {}

    self:setMusicPitches()

    if DELTARUNE_SAVE_ID then
        DeltaruneLoader.load({chapter = 2, completed = true, slot = DELTARUNE_SAVE_ID})
    end

	self:makeSpellsMissAgainstJackenstein()
end

function Mod:makeSpellsMissAgainstJackenstein()
	-- Jackenstein spell changes to make them miss
    local spell = Registry.getSpell("rude_buster")
    HookSystem.hook(spell, "onCast", function (orig, self, user, target)
		local buster_finished = false
		local anim_finished = false
		local function finishAnim()
			anim_finished = true
			if buster_finished then
				Game.battle:finishAction()
			end
		end
		if not user:setAnimation("battle/rude_buster", finishAnim) then
			anim_finished = false
			user:setAnimation("battle/attack", finishAnim)
		end
		Game.battle.timer:after(15/30, function()
			Assets.playSound("rudebuster_swing")
			local x, y = user:getRelativePos(user.width, user.height/2 - 10, Game.battle)
			local tx, ty = target:getRelativePos(target.width/2, target.height/2, Game.battle)
			local blast = RudeBusterBeam(false, x, y, tx, ty, function(damage_bonus, play_sound, miss)
				if miss then					
					target:hurt(0, user)
					buster_finished = true
					if anim_finished then
						Game.battle:finishAction()
					end
				else
					local damage = self:getDamage(user, target, damage_bonus)
					if play_sound then
						Assets.playSound("scytheburst")
					end
					target:flash()
					target:hurt(damage, user)
					buster_finished = true
					if anim_finished then
						Game.battle:finishAction()
					end
				end
			end)
			blast.layer = BATTLE_LAYERS["above_ui"]
			Game.battle:addChild(blast)
		end)
		return false
    end)
    local spell = Registry.getSpell("red_buster")
    HookSystem.hook(spell, "onCast", function (orig, self, user, target) 
		local buster_finished = false
		local anim_finished = false
		local function finishAnim()
			anim_finished = true
			if buster_finished then
				Game.battle:finishAction()
			end
		end
		if not user:setAnimation("battle/rude_buster", finishAnim) then
			anim_finished = false
			user:setAnimation("battle/attack", finishAnim)
		end
		Game.battle.timer:after(15/30, function()
			Assets.playSound("rudebuster_swing")
			local x, y = user:getRelativePos(user.width, user.height/2 - 10, Game.battle)
			local tx, ty = target:getRelativePos(target.width/2, target.height/2, Game.battle)
			local blast = RudeBusterBeam(true, x, y, tx, ty, function(damage_bonus, play_sound, miss)
				if miss then					
					target:hurt(0, user)
					buster_finished = true
					if anim_finished then
						Game.battle:finishAction()
					end
				else
					local damage = self:getDamage(user, target, damage_bonus)
					if play_sound then
						Assets.playSound("scytheburst")
					end
					local flash = target:flash()
					flash.color_mask:setColor(1, 0, 0)
					target:hurt(damage, user)
					buster_finished = true
					if anim_finished then
						Game.battle:finishAction()
					end
				end
			end)
			blast.layer = BATTLE_LAYERS["above_ui"]
			Game.battle:addChild(blast)
		end)
		return false
    end)
    local spell = Registry.getSpell("ice_beam")
    HookSystem.hook(spell, "onCast", function (orig, self, user, target) 
		local target_x, target_y = target:getRelativePos(target.width/2, target.height/2, Game.battle)
		if Game.battle.encounter.is_jackenstein then
			target_y = target_y - 60
		end
		local function finishAnim()
			anim_finished = true
			if buster_finished then
				Game.battle:finishAction()
			end
		end

		local function createParticle(x, y)
			local sprite = Sprite("effects/icespell/snowflake", x, y)
			sprite:setOrigin(0.5, 0.5)
			sprite:setScale(1.5)
			sprite.layer = BATTLE_LAYERS["above_battlers"]
			Game.battle:addChild(sprite)
			return sprite
		end

		user:setAnimation("battle/spell", finishAnim)

		local damage = math.ceil((user.chara:getStat("magic") * 5) + (user.chara:getStat("attack") * 11) - (target.defense * 3))

		local particles = {}
		Game.battle.timer:script(function(wait)
			Assets.playSound("dtrans_square")
			local x, y = user:getRelativePos(user.width, user.height/2 + 5, Game.battle)
			local tx, ty = target:getRelativePos(target.width/2, target.height/2, Game.battle)
			local blast = IceBeamSpell(false, x, y, tx, ty, function(pressed)
				if pressed then
					damage = damage + 50
					Assets.playSound("dtrans_twinkle")
				end
				target:flash()
			end)
			blast.layer = BATTLE_LAYERS["above_ui"]
			Game.battle:addChild(blast)
			wait(0.5)
			wait(1/30)
			Assets.playSound("icespell")
			particles[1] = createParticle(target_x-25, target_y-20)
			wait(3/30)
			particles[2] = createParticle(target_x+25, target_y-20)
			wait(3/30)
			particles[3] = createParticle(target_x, target_y+20)
			wait(3/30)
			Game.battle:addChild(IceSpellBurst(target_x, target_y))
			for _,particle in ipairs(particles) do
				for i = 0, 5 do
					local effect = IceSpellEffect(particle.x, particle.y)
					effect:setScale(0.75)
					effect.physics.direction = math.rad(60 * i)
					effect.physics.speed = 8
					effect.physics.friction = 0.2
					effect.layer = BATTLE_LAYERS["above_battlers"] - 1
					Game.battle:addChild(effect)
				end
			end
			wait(1/30)
			for _,particle in ipairs(particles) do
				particle:remove()
			end
			wait(4/30)

			if Game.battle.encounter.is_jackenstein then
				target:hurt(0, user)
			else
				target:hurt(damage, user, function() target:freeze() end)
			end

			Game.battle:finishActionBy(user)
		end)



		return false
	end)
    local spell = Registry.getSpell("gammabeam")
    HookSystem.hook(spell, "onCast", function (orig, self, user, target) 
		local damage = math.floor(((user.chara:getStat("attack") * 150) / 50 + (user.chara:getStat("magic") * 100) / 50) -
			(target.defense * 3))
		local targetX, targetY = target:getRelativePos(target.width / 2, target.height / 2, Game.battle)
		local userX, userY = user:getRelativePos(user.width, user.height / 2, Game.battle)
		local angle = Utils.angle(userX, userY, targetX, targetY)
		if Game.battle.encounter.is_jackenstein then
			target_y = target_y - 60
		end
		
		local beam_start = Sprite("effects/spells/brenda/gammabeam_start", userX + 32, userY)
		beam_start:setOrigin(0, 0.5)
		beam_start:setScale(2)
		beam_start.rotation = angle
		Assets.playSound("rainbowbeam")
		Game.battle:addChild(beam_start)
		Game.battle.timer:after(0.6, function()
			beam_start:fadeOutAndRemove(0.5)
		end)

		local newX = beam_start.x + 60
		local newY = beam_start.y + angle * 60
		Game.battle.timer:every(1 / 20, function()
			local beam_section = Sprite("effects/spells/brenda/gammabeam_section", newX, newY)
			beam_section:setOrigin(0, 0.5)
			beam_section:setScale(2)
			beam_section.rotation = angle
			Game.battle:addChild(beam_section)
			newX = beam_section.x + 60
			newY = beam_section.y + angle * 60
			Game.battle.timer:after(0.6, function()
				beam_section:fadeOutAndRemove(0.5)
			end)
		end)

		Game.battle.timer:after(0.3, function()
			Game.battle.timer:script(function(wait)
				if Game.battle.encounter.is_jackenstein then
					target:hurt(0, user)
				else
					for _ = 1, 5 do
						if target.health > 0 then
							Assets.stopAndPlaySound("damage")
							target:hurt(damage, user)
							target:shake(6, 0, 0.5)
						end
						wait(0.1)
						if target.health <= 0 then break end
					end
					Game.battle:finishActionBy(user)
				end
			end)
		end)

		return false
	end)
    local spell = Registry.getSpell("shooting_star")
    HookSystem.hook(spell, "onCast", function (orig, self, user, target)
		-- Code the cast effect here
		-- If you return false, you can call Game.battle:finishAction() to finish the spell
		local function createParticle(x, y)
			local sprite = Sprite("effects/stars/attack", x, y)
			sprite:setOrigin(0.5, 0.5)
			sprite:setScale(2)
			sprite:play(3/30)
			sprite.layer = BATTLE_LAYERS["above_battlers"]
			Game.battle:addChild(sprite)
			return sprite
		end

		local userx, usery = user:getRelativePos(user.width/2, user.height/2, Game.battle)
		local targetx, targety = target:getRelativePos(target.width/2, target.height/2, Game.battle)
		if Game.battle.encounter.is_jackenstein then
			targety = targety - 60
		end

		local particles = {}
		local burst = {}
		local burstangle
		local con = 0
		Game.battle.timer:script(function(wait)
			wait(1/30)
			-- Initial star
			-- FIXME: ???
			Assets.playSound("snd_crow")
			particles = createParticle(userx, -25)

			-- Move star to target
			particles:slideTo(targetx, targety, 1)
			wait(1)

			
			
			-- Hide initial star, turns into smaller ones.
			particles.alpha = 0
			for i = 1, 4 do
				burstangle = (math.rad(45 + ((i - 1) * 90)))
				burst[i] = createParticle(particles.x, particles.y)
				burst[i].rotation = burstangle
				burst[i].physics.speed = 3
				burst[i].physics.match_rotation = true
				burst[i]:setScale(1)
				burst[i]:fadeOutAndRemove()
				burst[i]:play(1/15)
			end
			-- Calculate damage and deal it.
			Assets.playSound("stardrop")
			-- yes it's just the iceshock formula, I'm not a mathemetician
			local min_magic = Utils.clamp(user.chara:getStat("magic") - 10, 1, 999)
			local damage = math.ceil((min_magic * 30) + 90 + Utils.random(10))
			particles:remove()
			if Game.battle.encounter.is_jackenstein then
				target:hurt(0, user)
			else
				target:flash()
				target:hurt(damage, user)
			end
			Game.battle:finishAction()
			
		end)

		return false
    end)
    local spell = Registry.getSpell("supersling")
    HookSystem.hook(spell, "onCast", function (orig, self, user, target)
		local damage = math.floor((user.chara:getStat("attack") * 15))

		local function generateSlash(scale_x, miss)
			local cutAnim = Sprite("effects/attack/sling")
			Assets.playSound("scytheburst")
			Assets.playSound("criticalswing", 1.2, 1.3)
			user.overlay_sprite:setAnimation("battle/attack") -- Makes the afterimages use the first frame of the attack animation
			user:toggleOverlay(true)
			local afterimage1 = AfterImage(user, 0.5)
			local afterimage2 = AfterImage(user, 0.6)
			user:toggleOverlay(false)
			afterimage1.physics.speed_x = 2.5
			afterimage2.physics.speed_x = 5
			afterimage2:setLayer(afterimage1.layer - 1)
			user:setAnimation("battle/attack", function()
				user:setAnimation("battle/idle")
			end)
			user:flash()
			cutAnim:setOrigin(0.5, 0.5)
			cutAnim:setScale(2.5 * scale_x, 2.5)
			if miss then
				cutAnim:setPosition(target:getRelativePos(target.width/2, target.height/2-60))
			else
				cutAnim:setPosition(target:getRelativePos(target.width/2, target.height/2))
			end
			cutAnim.layer = target.layer + 0.01
			cutAnim:play(1/15, false, function(s) s:remove() end)
			user.parent:addChild(cutAnim)
			user.parent:addChild(afterimage1)
			user.parent:addChild(afterimage2)
		end

		Game.battle.timer:after(0.1/2, function()
			if Game.battle.encounter.is_jackenstein then
				generateSlash(1, true)
				target:hurt(0, user)
			else
				generateSlash(1, false)
				local mult = 1
				if target.health == target.max_health then
					mult = 0.5
				end
				target:heal(damage)
				if target:canService(self.id) then
					target:addMercy(math.ceil(target.service_mercy*1.3*mult))
				end
				target:onService(self.id)
			end
		end)
    end)
    local spell = Registry.getSpell("jackpot_jab")
    HookSystem.hook(spell, "onCast", function (orig, self, user, target)
		if Game.battle.encounter.is_jackenstein then
			Game:setFlag("LastTurnJJ", true)
			Game.battle.timer:after(0.5, function()
				target:hurt(0, user)
			end)
			if Game:getFlag("JJS4") then
				Game.battle.timer:after(0.4, function()
				target:hurt(0, user)
				end)
			end
			if Game:getFlag("JJS3") then
				Game.battle.timer:after(0.3, function()
				target:hurt(0, user)
				end)
				Game:setFlag("JJS4", true)
			end
			if Game:getFlag("JJS2") then
				Game.battle.timer:after(0.2, function()
				target:hurt(0, user)
				end)
				Game:setFlag("JJS3", true)
			end
			if Game:getFlag("JJS1") then
				Game.battle.timer:after(0.1, function()
				target:hurt(0, user)
				end)
				Game:setFlag("JJS2", true)
			end
			Game:setFlag("JJS1", true)
			Game.battle:finishActionBy(user)
		else
			target:flash()
			Game:setFlag("LastTurnJJ", true)
			local damage = math.ceil(((user.chara:getStat("attack") * 3)))
			Game.battle.timer:after(0.5, function()
				Assets.playSound("scytheburst")
				target:hurt(damage, user)
			end)
			if Game:getFlag("JJS4") then
				Game.battle.timer:after(0.4, function()
					Assets.playSound("scytheburst")
					target:hurt(damage, user)
				end)
			end
			if Game:getFlag("JJS3") then
				Game.battle.timer:after(0.3, function()
					Assets.playSound("scytheburst")
					target:hurt(damage, user)
				end)
				Game:setFlag("JJS4", true)
			end
			if Game:getFlag("JJS2") then
				Game.battle.timer:after(0.2, function()
					Assets.playSound("scytheburst")
					target:hurt(damage, user)
				end)
				Game:setFlag("JJS3", true)
			end
			if Game:getFlag("JJS1") then
				Game.battle.timer:after(0.1, function()
					Assets.playSound("scytheburst")
					target:hurt(damage, user)
				end)
				Game:setFlag("JJS2", true)
			end
			Game:setFlag("JJS1", true)
			Game.battle:finishActionBy(user)
		end
		return false
    end)
    local spell = Registry.getSpell("life_steal")
    HookSystem.hook(spell, "onCast", function (orig, self, user, target)
		if Game.battle.encounter.is_jackenstein then
			Assets.playSound("voice/noel-'")
			Assets.playSound("break1")
			target:hurt(0)
			user:heal(0)
		else
			Assets.playSound("voice/noel-'")
			Assets.playSound("break2")
			target:hurt(user.chara:getStat("magic") * 20 + 10)
			user:heal(user.chara:getStat("magic") * 20 + 10)
		end
    end)
    local spell = Registry.getSpell("xslash")
    HookSystem.hook(spell, "onCast", function (orig, self, user, target)
	local damage = math.floor((((user.chara:getStat("attack") * 150) / 20) - 3 * (target.defense)) * 1.3)

		---@type XSlashSpell
		local spellobj = XSlashSpell(user,target)
		if Game.battle.encounter.is_jackenstein then
			spellobj.y = spellobj.y - 60
		end
		Game.battle:addChild(spellobj):setLayer(BATTLE_LAYERS["above_battlers"])
		spellobj.damage_callback = function(self, hit_action_command)
			local strikedmg = damage
			if Game.battle.encounter.is_jackenstein then
				target:hurt(0, user)
			else
				target:hurt(strikedmg, user)
			end
		end
		return false
    end)
    local spell = Registry.getSpell("ice_shock")
    HookSystem.hook(spell, "onCast", function (orig, self, user, target)
		user.chara:addFlag("iceshocks_used", 1)

		local function createParticle(x, y)
			local sprite = Sprite("effects/icespell/snowflake", x, y)
			sprite:setOrigin(0.5, 0.5)
			sprite:setScale(1.5)
			sprite.layer = BATTLE_LAYERS["above_battlers"]
			Game.battle:addChild(sprite)
			return sprite
		end

		if Game.battle.encounter.is_jackenstein then
			local x, y = target:getRelativePos(target.width / 2, target.height / 2-60, Game.battle)
		else
			local x, y = target:getRelativePos(target.width / 2, target.height / 2, Game.battle)
		end

		local particles = {}
		Game.battle.timer:script(function(wait)
			wait(1 / 30)
			Assets.playSound("icespell")
			particles[1] = createParticle(x - 25, y - 20)
			wait(3 / 30)
			particles[2] = createParticle(x + 25, y - 20)
			wait(3 / 30)
			particles[3] = createParticle(x, y + 20)
			wait(3 / 30)
			Game.battle:addChild(IceSpellBurst(x, y))
			for _, particle in ipairs(particles) do
				for i = 0, 5 do
					local effect = IceSpellEffect(particle.x, particle.y)
					effect:setScale(0.75)
					effect.physics.direction = math.rad(60 * i)
					effect.physics.speed = 8
					effect.physics.friction = 0.2
					effect.layer = BATTLE_LAYERS["above_battlers"] - 1
					Game.battle:addChild(effect)
				end
			end
			wait(1 / 30)
			for _, particle in ipairs(particles) do
				particle:remove()
			end
			wait(4 / 30)

			if Game.battle.encounter.is_jackenstein then
				target:hurt(0, user)
			else
				local damage = self:getDamage(user, target)
				target:hurt(damage, user, function()
					target:freeze()
				end)
			end

			Game.battle:finishActionBy(user)
		end)

		return false
    end)
    local spell = Registry.getSpell("flowershot")
    HookSystem.hook(spell, "onCast", function (orig, self, user, target)
		local userX, userY = user:getRelativePos(user.width, user.height/2, Game.battle)
		Assets.playSound("ceroba_bullet_shot")
		local bigflower = Sprite("effects/spells/ceroba/flower_large", userX+32, userY)
		bigflower:setOrigin(0.5, 0.5)
		bigflower:setScale(2, 2)
		bigflower.layer = BATTLE_LAYERS["above_arena"] + 1
		Game.battle:addChild(bigflower)
		bigflower:play(1/10)
		bigflower:slideToSpeed(320, 180, 20, function()
			Game.battle.timer:after(1, function()
				bigflower:fadeOutAndRemove(0.5)
			end)
		end)
		for _,enemy in ipairs(target) do
			local targetX, targetY = enemy:getRelativePos(enemy.width/2, enemy.height/2, Game.battle)
			Game.battle.timer:script(function(wait)
				wait(1)

				Assets.playSound("ceroba_bullet_shot")
				local flower = Sprite("effects/spells/ceroba/flower_large", bigflower.x, bigflower.y)
				flower:setOrigin(0.5, 0.5)
				flower:setScale(1, 1)
				flower.layer = BATTLE_LAYERS["above_battlers"]
				Game.battle:addChild(flower)
				flower:play(1/10)
				flower:slideToSpeed(targetX, targetY, 20, function()
					local damage = math.ceil(((user.chara:getStat("magic") - 10) * 9) + 30 + Utils.random(10))

					if Game.battle.encounter.is_jackenstein then
						enemy:hurt(0, user)
						Assets.playSound("ceroba_boom")
					else
						enemy:hurt(damage, user)
						Assets.playSound("damage")
						Assets.playSound("ceroba_boom")
						enemy:shake(6, 0, 0.5)
					end
					flower:remove()
					local explosion = Sprite("effects/spells/ceroba/explosion", targetX, targetY)
					explosion:setOrigin(0.5, 0.5)
					explosion:setScale(1, 1)
					explosion.layer = BATTLE_LAYERS["above_battlers"]
					Game.battle:addChild(explosion)
					explosion:play(1/10, false, function(this)
						this:remove()
					end)
				end)

				wait(1/30)
			end)

			Game.battle.timer:after(2.65, function()
				Game.battle:finishActionBy(user)
			end)
		end

		return false
	end)
    local spell = Registry.getSpell("flower_barrage")
    HookSystem.hook(spell, "onCast", function (orig, self, user, target)
		local damage = self:getDamage(user, target)
		self.flowers = {}
		local targetX, targetY = target:getRelativePos(target.width / 2, target.height / 2, Game.battle)
		local positions = {
			{50, -50}, {80, 0}, {50, 50}, {-50, 50}, {-80, 0}, {-50, -50}
		}

		-- Function to create a flower at a specific position
		local function createFlower(index)
			local offsetX, offsetY = unpack(positions[index])
			local flower = Sprite("effects/spells/ceroba/flower")
			flower:setOrigin(0.5, 0.5)
			flower:setScale(2, 2)
			flower:setPosition(targetX + offsetX, targetY + offsetY)
			flower.layer = target.layer + 1
			flower.alpha = 0 -- Start fully transparent
			flower:fadeTo(1, 0.1) -- Fade in over 0.1 seconds
			flower:play(1 / 15, true)
			Game.battle:addChild(flower)
			table.insert(self.flowers, flower)
		end

		-- Create flowers one by one with a delay
		for i = 1, #positions do
			Game.battle.timer:after((i - 1) * 0.1, function()
				createFlower(i)
			end)
		end

		-- After all flowers are created, reel them back (enlarge the circle) and then close in
		Game.battle.timer:after(#positions * 0.1 + 0.35, function()
			Assets.playSound("ceroba_swoosh", 3)

			-- Reel back: enlarge the circle
			for i, flower in ipairs(self.flowers) do
				local offsetX, offsetY = unpack(positions[i])
				local reelBackX = offsetX * 1.5 -- Enlarge the circle by 1.5x
				local reelBackY = offsetY * 1.5
				flower:slideTo(targetX + reelBackX, targetY + reelBackY, 0.3, "out-cubic")
			end

			-- Close in after reeling back
			Game.battle.timer:after(0.3, function()
				for _, flower in ipairs(self.flowers) do
					flower:slideTo(targetX, targetY, 0.1, "in-cubic")
				end
			end)

			-- Remove flowers and create explosion
			Game.battle.timer:after(0.5, function()
				for _, flower in ipairs(self.flowers) do
					flower:remove()
				end
				local explosion = Sprite("effects/spells/ceroba/explosion", targetX, targetY)
				explosion:setOrigin(0.5, 0.5)
				explosion:setScale(2, 2)
				explosion.layer = BATTLE_LAYERS["above_battlers"]
				Game.battle:addChild(explosion)
				Assets.playSound("ceroba_boom")
				explosion:play(1 / 10, false, function(this)
					this:remove()
				end)
			end)
		end)

		-- Deal damage to the target
		Game.battle.timer:after(#positions * 0.1 + 0.85, function()
			if Game.battle.encounter.is_jackenstein then
				target:hurt(0, user)
			else
				target:hurt(damage, user)
			end
		end)

		-- Finish the action
		Game.battle.timer:after(#positions * 0.1 + 1, function()
			Game.battle:finishActionBy(user)
		end)

		return false
    end)
    local spell = Registry.getSpell("multiflare")
    HookSystem.hook(spell, "onCast", function (orig, self, user, target)
		user:setAnimation("battle/multiflare")

		Game.battle.timer:after(1/4, function()
			for i = 1, 10, 1 do
				Game.battle.timer:after((i * 0.15), function()
					if #Game.battle:getActiveEnemies() >= 1 then
						target = Game.battle:getActiveEnemies()[love.math.random(1,#Game.battle:getActiveEnemies())]

						if target.id == "darkclone/brenda" then
							local skillknow = false
							for _, v in ipairs(target.usedskills) do
								if v == "multiflare" then
									skillknow = true
								end
							end
							if skillknow == false then
								table.insert(target.usedskills, "multiflare")
							end
							if target.powder then
								target.defense = Game:getPartyMember("brenda"):getStat("defense") + Game:getPartyMember("brenda"):getStat("magic") / 2
								target.powder_immunity = true
							end
						end

						Assets.playSound("noise")
						local x, y = user:getRelativePos(user.width, user.height/2 - 4, Game.battle)
						local tx, ty = target:getRelativePos(target.width/2, target.height/2, Game.battle)
						if Game.battle.encounter.is_jackenstein then
							ty = ty - 60
						end
						local flare = MultiFlareFireball(x, y, tx, ty, function(miss)
							if miss	then
								target:hurt(0, user)
							else
								local damage = self:getDamage(user, target)
								target:hurt(damage, user)
								if target.powder then
									Assets.playSound("bomb")
								end
							end
						end)
						flare.layer = BATTLE_LAYERS["above_ui"]
						Game.battle:addChild(flare)
					end
				end)
			end
		end)

		Game.battle.timer:after(3, function()
			Game.battle:finishActionBy(user)
		end)

		return false
    end)
    local spell = Registry.getSpell("starshot")
    HookSystem.hook(spell, "onCast", function (orig, self, user, target)
		local targetX, targetY = target:getRelativePos(target.width/2, target.height/2, Game.battle)
		if Game.battle.encounter.is_jackenstein then
			targetY = targetY - 60
		end
		local userX, userY = user:getRelativePos(user.width, user.height/2, Game.battle)

		user:setAnimation("battle/snap")

		Game.battle.timer:script(function(wait)
			wait(10/30)

			Game.battle.starbasic = Sprite("effects/spells/dess/star_basic", userX+32, userY)
			Game.battle.starbasic:setOrigin(0.5, 0.5)
			Game.battle.starbasic:setScale(2)
			Game.battle.starbasic.layer = BATTLE_LAYERS["above_battlers"]
			Game.battle:addChild(Game.battle.starbasic)
			local xx, yy = Game.battle.starbasic.x, Game.battle.starbasic.y
			Game.battle.starbasic:slideToSpeed(targetX, targetY, 20, function()
				if Game.battle.encounter.is_jackenstein then
					local star = Game.battle.starbasic
					local angle = MathUtils.angle(xx, yy, targetX, targetY)
					star.physics.direction = angle
					star.physics.speed = math.abs(math.sin(angle)) * 80
					target:hurt(0, user)
					Game.battle:finishActionBy(user)
					star:fadeOutSpeedAndRemove(0.02)
				else
					local mult = 1 + (0.2 * Game:getBadgeEquipped("stellar_lens"))
					local damage = math.ceil(((user.chara:getStat("magic") * 20) + 100 + (Utils.random(10) * 2)) * mult)
					target:hurt(damage, user)

					Assets.playSound("celestial_hit")
					Assets.playSound("damage")
					target:shake(6, 0, 0.5)

					Game.battle.starbasic:remove()

					Game.battle:finishActionBy(user)
				end
			end)

			Game.battle.timer:every(0.01, function()
				local starparticle = Sprite("effects/spells/dess/rainbow_star", Game.battle.starbasic.x + Utils.random(32), Game.battle.starbasic.y + Utils.random(32))
				starparticle:setOrigin(0.5, 0.5)
				starparticle:setScale(2)
				starparticle.layer = BATTLE_LAYERS["above_battlers"]
				Game.battle:addChild(starparticle)
				starparticle:play(0.1, false)
				starparticle:slideToSpeed(starparticle.x+32, starparticle.y, 2)
				starparticle:fadeOutAndRemove(0.5)
				starparticle.alpha = Game.battle.starbasic.alpha
			end, 50)

			wait(1/30)
			Assets.playSound("wish")
			Assets.playSound("bomb")
		end)

		return false
    end)

    local spell = Registry.getSpell("spearblaster")
    HookSystem.hook(spell, "onCast", function (orig, self, user, target)
		user:setAnimation("battle/super_jump")
		Game.battle.timer:after(1/15 * 3.5, function() Assets.playSound("jump") end)
		Game.battle.timer:after(1/15 * 9.5, function()
			Assets.playSound("bell", 0.5, 0.6)
			Assets.playSound("bell", 0.5, 0.8)
		end)
		Game.battle.timer:after(1/15 * 14.5, function()
			Assets.playSound("criticalswing")
			Game.battle.timer:script(function(wait)
				for i = 1, 10 do
					if not target then -- failsafe
						i = 10
					else
						Assets.stopAndPlaySound("rocket")
						local x, y = user:getRelativePos(user.width + 10, user.height/2 - 10, Game.battle)
						local tx, ty = target:getRelativePos(target.width/2, target.height/2, Game.battle)
						if Game.battle.encounter.is_jackenstein then
							ty = ty - 60
						end
						local bullet = SpearBlasterBullet(x, y, tx, ty, function()
							if target.done_state == nil and not Game.battle.encounter.is_jackenstein then -- failsafe 2
								Assets.stopAndPlaySound("damage")
								target:hurt(self:getDamage(user, target), user)
							end
						end)
						Game.battle:addChild(bullet)
						wait(1/15)
					end
					if i == 10 then
						if Game.battle.encounter.is_jackenstein then
							target:hurt(0, user)
						end
						wait(1.5)
						Game.battle:finishAction()
					end
				end
			end)
		end)
		--Game.battle:finishAction()
		return false
    end)
    local spell = Registry.getSpell("rage")
	HookSystem.hook(spell, "onCast", function (orig, self, user, target)
		local targer = Game.battle:getActiveEnemies()[love.math.random(#Game.battle:getActiveEnemies())]
		user.chara.rage = true
		user.chara.rage_counter = 6
		user:setAnimation("battle/attack")
		Assets.playSound("scytheburst")
		Assets.playSound("criticalswing", 1.2, 1.3)
		
		Game.battle.timer:after(15/30, function()
			local damage = math.ceil(((user.chara:getStat("attack") * 100) / 5) - (targer.defense * 3))
			
			if Game.battle.encounter.is_jackenstein then
				targer:hurt(0, user)
			else
				targer:hurt(damage, user)
				Assets.playSound("damage")
			end
			user:setAnimation("battle/idle")
			Game.battle.timer:after(15/30, function()
				Game.battle:finishAction()
			end)
		end)
		return false
	end)
    local spell = Registry.getSpell("fireball")
	HookSystem.hook(spell, "onCast", function (orig, self, user, target)
		local damage = math.floor((((user.chara:getStat("attack") * 400) / 20) - 3 * (target.defense)) * 1)
	
		if Game.battle.encounter.is_jackenstein then
			target:hurt(0, user)
		else
			target:hurt(damage, user)
			Assets.playSound("damage")
		end
    end)
    local spell = Registry.getSpell("electric_havoc")
	HookSystem.hook(spell, "onCast", function (orig, self, user, target)
		local damage = 200
		
		if target.defense >= 99 then
			damage = 0
		end

		local function shock(scale_x, miss)
			local cutAnim = Sprite("party/jamm/dark/special/shock")
			cutAnim:setOrigin(0.5, 1)
			cutAnim:setScale(2 * scale_x, 2)
			if miss then
				cutAnim:setPosition(target:getRelativePos(target.width/2, target.height/2-60))
			else
				cutAnim:setPosition(target:getRelativePos(target.width/2, target.height/2))
			end
			cutAnim.layer = target.layer + 0.01
			user.parent:addChild(cutAnim)
			Assets.playSound("shock", 1, 1)
			Game.stage.timer:tween(0.5, cutAnim, {alpha = 0}, "linear", function()
				cutAnim:remove()
			end)
		end

		if Game.battle.encounter.is_jackenstein then
			Game.battle.timer:after(0.25, function()
				shock(1, true)
				target:hurt(0, user)
				Game.battle.timer:after(0.25, function()
					shock(-1, true)
					target:hurt(0, user)
					Game.battle.timer:after(0.25, function()
						shock(1, true)
						target:hurt(0, user)
					end)
				end)
			end)
		else
			Game.battle.timer:after(0.25, function()
			shock(1, false)
				target:hurt(damage, user)
				Game.battle.timer:after(0.25, function()
					shock(-1, false)
					target:hurt(damage, user)
					Game.battle.timer:after(0.25, function()
						shock(1, false)
						target:hurt(damage, user)
					end)
				end)
			end)
		end
    end)
    local spell = Registry.getSpell("darksling")
	HookSystem.hook(spell, "onCast", function (orig, self, user, target)
		local damage = math.floor((((user.chara:getStat("attack") * 400) / 20) - 3 * (target.defense)) * 1.3)
		if target.boss then
			damage = math.floor((((user.chara:getStat("attack") * 130) / 20) - 3 * (target.defense)) * 1.7)
		end

		local function generateSlash(scale_x, miss)
			local cutAnim = Sprite("effects/attack/sling")
			Assets.playSound("scytheburst")
			Assets.playSound("criticalswing", 1.2, 1.3)
			user.overlay_sprite:setAnimation("battle/attack") -- Makes the afterimages use the first frame of the attack animation
			user:toggleOverlay(true)
			local afterimage1 = AfterImage(user, 0.5)
			local afterimage2 = AfterImage(user, 0.6)
			user:toggleOverlay(false)
			afterimage1.physics.speed_x = 2.5
			afterimage2.physics.speed_x = 5
			afterimage2:setLayer(afterimage1.layer - 1)
			user:setAnimation("battle/attack", function()
				user:setAnimation("battle/idle")
			end)
			user:flash()
			cutAnim:setOrigin(0.5, 0.5)
			cutAnim:setScale(2.5 * scale_x, 2.5)
			if miss then
				cutAnim:setPosition(target:getRelativePos(target.width/2, target.height/2-60))
			else
				cutAnim:setPosition(target:getRelativePos(target.width/2, target.height/2))
			end
			cutAnim:setPosition(target:getRelativePos(target.width/2, target.height/2))
			cutAnim.layer = target.layer + 0.01
			cutAnim:play(1/15, false, function(s) s:remove() end)
			user.parent:addChild(cutAnim)
			user.parent:addChild(afterimage1)
			user.parent:addChild(afterimage2)
		end

		if Game.battle.encounter.is_jackenstein then
			generateSlash(1,true)
			target:hurt(0, user)
		else
			generateSlash(1,false)
			target:hurt(damage, user)
		end
    end)
    local spell = Registry.getSpell("darksling")
	HookSystem.hook(spell, "onCast", function (orig, self, user, target)
		local damage = math.floor((((user.chara:getStat("attack") * 4)) - 3 * target.defense))

		local function generateSlash(scale_x, miss)
			local cutAnim = Sprite("effects/attack/sling")
			Assets.playSound("scytheburst")
			Assets.playSound("criticalswing", 1.2, 1.3)
			user.overlay_sprite:setAnimation("battle/attack") -- Makes the afterimages use the first frame of the attack animation
			user:toggleOverlay(true)
			local afterimage1 = AfterImage(user, 0.5)
			local afterimage2 = AfterImage(user, 0.6)
			user:toggleOverlay(false)
			afterimage1.physics.speed_x = 2.5
			afterimage2.physics.speed_x = 5
			afterimage2:setLayer(afterimage1.layer - 1)
			user:setAnimation("battle/attack", function()
				user:setAnimation("battle/idle")
			end)
			user:flash()
			cutAnim:setOrigin(0.5, 0.5)
			cutAnim:setScale(2.5 * scale_x, 2.5)
			if miss then
				cutAnim:setPosition(target:getRelativePos(target.width/2, target.height/2-60))
			else
				cutAnim:setPosition(target:getRelativePos(target.width/2, target.height/2))
			end
			cutAnim.layer = target.layer + 0.01
			cutAnim:play(1/15, false, function(s) s:remove() end)
			user.parent:addChild(cutAnim)
			user.parent:addChild(afterimage1)
			user.parent:addChild(afterimage2)
		end

		if Game.battle.encounter.is_jackenstein then
			generateSlash(1,true)
			target:hurt(0, user)
		else
			generateSlash(1,false)
			target:hurt(damage, user)
			if target.health > 0 then
				if target.tired then
					Assets.playSound("spell_pacify")

					target:spare(true)

					local pacify_x, pacify_y = target:getRelativePos(target.width/2, target.height/2)
					local z_count = 0
					local z_parent = target.parent
					Game.battle.timer:every(1/15, function()
						z_count = z_count + 1
						local z = SpareZ(z_count * -40, pacify_x, pacify_y)
						z.layer = target.layer + 0.002
						z_parent:addChild(z)
					end, 8)
				else
					local recolor = target:addFX(RecolorFX())
					Game.battle.timer:during(8/30, function()
						recolor.color = Utils.lerp(recolor.color, {0, 0, 1}, 0.12 * DTMULT)
					end, function()
						Game.battle.timer:during(8/30, function()
							recolor.color = Utils.lerp(recolor.color, {1, 1, 1}, 0.16 * DTMULT)
						end, function()
							target:removeFX(recolor)
						end)
					end)
				end
			end
		end
    end)
    local spell = Registry.getSpell("chainslash")
	HookSystem.hook(spell, "onCast", function (orig, self, user, target)
		local damage = ((((user.chara:getStat("attack") * 150) / 20) - 3 * (target.defense)) * 1.3)
		damage = damage / 2

		---@type XSlashSpell
		local spellobj = XSlashSpell(user,target)	
		if Game.battle.encounter.is_jackenstein then
			spellobj.y = spellobj.y - 60
		end
		spellobj.slashes_count = 1
		spellobj.clock = -0.5
		spellobj.damage_delay = 1/30
		local chain = 0
		Game.battle:addChild(spellobj):setLayer(BATTLE_LAYERS["above_battlers"])

		Assets.playSound("back_attack")
		spellobj.damage_callback = function(spellf, hit_action_command)
			damage = math.max(user.chara:getStat("attack"), damage - 5)
			local strikedmg = damage
			if hit_action_command then
				Assets.playSound("bell", 1, Utils.clampMap(chain, 0, 10, 0.5, 0.8))
				chain = chain + 1
				spellf.slashes_count = spellf.slashes_count + 1
			else
				strikedmg = 0
				-- stat tracking? oh god it really is power bounce
				local flag = "spell#"..self.id..":".."max_combo"
				Game:setFlag(flag, math.max(chain, Game:getFlag(flag,0)))
			end
			spellf.action_command_threshold = math.max(1/15, spellf.action_command_threshold * 0.95)
			if spellf.target.parent then
				if Game.battle.encounter.is_jackenstein then
					target:hurt(0, user)
				else
					target:hurt(math.floor(strikedmg), user)
				end
				target.hit_count = 0
			end
		end
		return false
    end)
end

function Mod:postInit(new_file)
    if DELTARUNE_SAVE_ID then
        local save = DeltaruneLoader.getCompletion(2,DELTARUNE_SAVE_ID)
        self:loadDeltaruneFile(save)
        Game.save_id = DELTARUNE_SAVE_ID
        DELTARUNE_SAVE_ID = nil
    end
    local items_list = {
        {
            result = "soulmantle",
            item1 = "flarewings",
            item2 = "discarded_robe"
        },
        {
            result = "dd_burger",
            item1 = "darkburger",
            item2 = "darkburger"
        },
        {
            result = "silver_card",
            item1 = "amber_card",
            item2 = "amber_card"
        },
        {
            result = "twinribbon",
            item1 = "pink_ribbon",
            item2 = "white_ribbon"
        },
        {
            result = "spikeband",
            item1 = "glowwrist",
            item2 = "ironshackle"
        },
        {
            result = "tensionbow",
            item1 = "bshotbowtie",
            item2 = "tensionbit"
        },
        {
            result = "peanut",
            item1 = "nut",
            item2 = "nut"
        },
        {
            result = "quadnut",
            item1 = "peanut",
            item2 = "peanut"
        },
    }
    Kristal.callEvent("setItemsList", items_list)

    if new_file then
        Game:setFlag("library_love", 1)
        Game:setFlag("library_experience", 0)
        Game:setFlag("library_kills", 0)
		
        if Game:isSpecialMode "SUPER" then
            Game.inventory:addItem("chaos_emeralds")
        end
        local baseParty = {}
        if Game:isSpecialMode "DESS" then
            Game:setFlag("Dess_Mode", true)

            table.insert(baseParty, "dess") -- :heckyeah:
            Game:setFlag("_unlockedPartyMembers", baseParty)
            Game:addPartyMember("dess")
            Game:removePartyMember("hero")
        else
            table.insert(baseParty, "hero") -- should be just Hero for now
            Game:setFlag("_unlockedPartyMembers", baseParty)
        end

        Game.world:startCutscene("_main.introcutscene")
    end
    
    if not Game:getFlag("FUN") then
        local random = love.math.random(1,100)
        Game:setFlag("FUN", random)
    end
	
	Game:setFlag("devDinerBorderState", nil)
    self:initializeImportantFlags(new_file)
end

function Mod:initializeImportantFlags(new_file)
    self.pc_gifts_data = {
        UNDERTALE = {
            file = "undertale.ini",
            item_id = "heart_locket",
            prefix_os = {Windows = "Local/UNDERTALE", Linux = "%XDG_CONFIG_HOME%/UNDERTALE", OS_X = "com.tobyfox.undertale"},
            wine_steam_appid = 391540
        },
        DELTARUNE = {
            file = "dr.ini",
            item_id = "egg",
            prefix_os = {Windows = "Local/DELTARUNE", Linux = "%XDG_CONFIG_HOME%/DELTARUNE", OS_X = "com.tobyfox.deltarune"},
            wine_steam_appid = 1690940
        },
        UTY = {
            name = "UNDERTALE YELLOW",
            file = {"Save.sav", "Save02.sav", "Controls.sav", "tempsave.sav"},
            item_id = "wildrevolver",
            prefix_os = {Windows = "Local/Undertale_Yellow", Linux = "%XDG_CONFIG_HOME%/Undertale_Yellow"}
        },
        PT = {
            name = "PIZZA TOWER",
            file = {"saves/saveData1.ini", "saves/saveData2.ini", "saves/saveData3.ini"},
            item_id = "pizza_toque",
            -- Not sure what the Mac OS_X or Linux directories for PT are.
            -- If anyone else knows tho, feel free to add them in here lol.
            prefix_os = {Windows = "Roaming/PizzaTower_GM2"},
            wine_steam_appid = 2231450
        },
        BOB = {
            name = "Born of Bread",
            file = {"Saved/SaveGames/Settings.sav"},
            item_id = "soupladle",
            -- Not sure what the Mac OS_X or Linux directories for BOB are.
            -- If anyone else knows tho, feel free to add them in here lol.
            prefix_os = {Windows = "Local/BornOfBread"},
            wine_steam_appid = 1555140
        },
        YATC = {
            name = "You Are The Code",
            file = {"logs/godot.log"},
            item_id = "binariband",
            -- Not sure what the Mac OS_X or Linux directories for YATC are.
            -- If anyone else knows tho, feel free to add them in here lol.
            prefix_os = {Windows = "Roaming/thinkwithgames/YouAreTheCode"},
            wine_steam_appid = 3333330
        },
        PROJECTCAT = {
            name = "Project Cat",
            file = {"Frost-Garb_ProjectCat/player.json"},
            item_id = "marketkey",
            prefix_os = {Windows = "Roaming/LOVE"},
        },
        OVERTIME = {
            file = {"Mercenaries.sav", "Progress.sav", "Story.sav", "undertale_save", "Universal.sav"},
            party_id = "pauling",
            -- Not sure what the Mac OS_X or Linux directories for Overtime are.
            -- If anyone else knows tho, feel free to add them in here lol.
            prefix_os = {Windows = "Local/Overtime"}
        },

        -- Use "KR_" as a prefix to check for a Kristal Mod instead
        KR_frozen_heart = {item_id = "angelring"},
        KR_wii_bios = {item_id = "wiimote"},
        ["KR_acj_deoxynn/act1"] = {name = "Deoxynn Act 1", item_id = "victory_bell"}
    }
    local function generateStatusTable(data)
        local status = {}
        for game, info in pairs(data) do
            status[game] = info.received or false
        end
        return status
    end
    if Game:getFlag("pc_gifts_data") then
        assert(not new_file)
        Game:setFlag("pc_gifts_status", generateStatusTable(Game:getFlag("pc_gifts_data")))
        Game:setFlag("pc_gifts_data", nil)
    end
    if not Game:getFlag("pc_gifts_status") then
        Game:setFlag("pc_gifts_status", generateStatusTable(self.pc_gifts_data))
    else
        Game:setFlag("pc_gifts_status", Utils.merge(generateStatusTable(self.pc_gifts_data), Game:getFlag("pc_gifts_status")))
    end
end

function Mod:postLoad()
    -- Switch to the very cool debug mode!...?

    if not Game:getFlag("FUN") then
        local random = love.math.random(1,100)
        Game:setFlag("FUN", random)
    end

    if (Game:getFlag("FUN") >= 90 or Game.save_name == "JOEY") and love.math.random() < 0.1 then
        if Game.world and Game.world:hasCutscene() then
            Game.world:stopCutscene()
        end
        Game:setFlag("FUN", love.math.random(1,100))
        local save_data = Utils.copy(Game:save(Game.world.player:getPosition()), true)
        Kristal.clearModState()
        Kristal.DebugSystem:refresh()
        Kristal.setState("Debug", save_data)
    end
	
	self.mic_controller = MicController()
	Game.stage:addChild(self.mic_controller)
	if Game:getFlag("microphone_id") then
		self.mic_controller.mic_id = Game:getFlag("microphone_id", 1)
	end
	if Game:getFlag("microphone_right_click") then
		self.mic_controller.right_click_mic = Game:getFlag("microphone_right_click", 0)
	end
	if Game:getFlag("microphone_sensitivity") then
		self.mic_controller.mic_sensitivity = Game:getFlag("microphone_sensitivity", 0.5)
	end
	if Game:getFlag("mic_active", false) then
		Mod:enableMicAccess(self.mic_controller.mic_id)
	end
end

function Mod:enableMicAccess(id)
	Game:setFlag("mic_active", true)
	self.mic_controller:startRecordMic(id or 1)
end

function Mod:disableMicAccess()
	Game:setFlag("mic_active", false)
	self.mic_controller:startRecordMic()
end

function Mod:openMicMenu()
	if not Game:getFlag("mic_active", false) then
		Mod:enableMicAccess(1)
	end
	Game.world:openMenu(MicMenu())
end

function Mod:preUpdate()
    self.voice_timer = Utils.approach(self.voice_timer, 0, DTMULT)
end

function Mod:unload()
	if self.mic_controller then
		-- I have no idea if this will even fix the potential memory leak but it's worth a shot
		self.mic_controller.cleaning_up = true
		self.mic_controller.mic_recording = false
		if self.mic_controller.mic_data then
			self.mic_controller.mic_data:release()
			self.mic_controller.mic_data = nil
		end
		if self.mic_controller.mic_inputs then
			for _, inputs in ipairs(self.mic_controller.mic_inputs) do
				inputs:release()
			end
		end
		self.mic_controller:remove()
		collectgarbage()
	end
end

function Mod:addGlobalEXP(exp)
    Game:setFlag("library_experience", Utils.clamp(Game:getFlag("library_experience", 0) + exp, 0, 99999))

    local max_love = #Kristal.getLibConfig("library_main", "global_xp_requirements")
    local leveled_up = false
    while
        Game:getFlag("library_experience") >= Kristal.callEvent("getGlobalNextLvRequiredEXP")
        and Game:getFlag("library_love", 1) < max_love
    do
        leveled_up = true
        Game:addFlag("library_love", 1)
        for _,party in ipairs(Game.party) do
            party:onLevelUpLVLib(Game:getFlag("library_love"))
        end
    end

    return leveled_up
end

function Mod:setMusicPitches()

    MUSIC_PITCHES["deltarune/THE_HOLY"] = 0.9
    MUSIC_PITCHES["deltarune/cybercity"] = 0.97
    MUSIC_PITCHES["deltarune/cybercity_alt"] = 1.2
    MUSIC_PITCHES["deltarune/tv_results_screen"] = 0.4
end

function Mod:getGlobalNextLvRequiredEXP()
    return Kristal.getLibConfig("library_main", "global_xp_requirements")[Game:getFlag("library_love") + 1] or 0
end

function Mod:getGlobalNextLv()
    return Utils.clamp(Kristal.callEvent("getGlobalNextLvRequiredEXP") - Game:getFlag("library_experience"), 0, 99999)
end

function Mod:unlockQuest(quest, silent)
    if not silent and Game.stage then
        local popup = Game.stage:addChild(QuestCreatedPopup(quest))
        popup.layer = 1500
    end
end

function Mod:onMapMusic(map, music)
    -- Diner music
    local cur_song = Game:getFlag("curJukeBoxSong")

    if music == "dev" then
        if cur_song then
            return cur_song
        elseif Game:isDessMode() then
            return "gimmieyourwalletmiss"
        else
            return "deltarune/greenroom_detune"
        end
    end

    -- Cyber City music	
	local can_kill = Game:getFlag("can_kill", false)
    if music == "deltarune/cybercity" and can_kill == true then
        return "deltarune/cybercity_alt"
    end
    --TV World music
    if map.id:find("floortv/") and can_kill == true then
        return "deltarune/tv_results_screen"
    end
end

function Mod:onMapBorder(map, border)
	if border == "green_room" and map.id:find("floortv/") and Game:getFlag("can_kill", false) then
		return "green_room_blue"
	end
end

---@param file DeltaruneSave
function Mod:loadDeltaruneFile(file)
    -- TODO: Load items into custom storages, and
    -- give the player access to that stuff much later in the game.
    file:load()
    if file.failed_snowgrave then
    elseif file.snowgrave then
        Game:setFlag("POST_SNOWGRAVE", true)
    end
end

-- Necessery for Jeku and Noel's interaction in the former's shop
-- as the function in Noel's actor is not called in that case
function Mod:onTextSound(voice, node, text)
    if voice == "noel" and Game.shop then
        Assets.playSound("voice/noel/"..string.lower(node.character), 1, 1)
        return true
    end
    if voice == "rx1" then
        if self.voice_timer == 0 then
            local snd = Assets.playSound(Utils.pick{"voice/rx1", "voice/rx2", "voice/rx3"})
            self.voice_timer = 2
        end
        return true
    end
end

function Mod:onJukeboxPlay(song)
    Game:setFlag("curJukeBoxSong", song.file)
end
