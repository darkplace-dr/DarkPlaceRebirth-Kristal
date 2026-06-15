local ShadowguySharpshootAct, super = Class(Object)

function ShadowguySharpshootAct:init(target)
    super.init(self, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
    self:setLayer(BATTLE_LAYERS["below_ui"])

    self.draw_children_below = -1
    self.draw_children_above = -1

    self.sharpshoot_time = 180
	self.start_timer = false
	
	self.sharpshoot_timer = 0
	
    -- Possible states: "INSTRUCTION", "SHARPSHOOTBEGIN", "SHARPSHOOT", "SHARPSHOOTENDING", "SHARPSHOOTEND"
    self.state = "INSTRUCTION"

	self.font = Assets.getFont("main")
	self.heart = Assets.getTexture("player/sharpshoot_heart")
	self.hourglass = Assets.getTexture("ui/hourglass")
	
    self.shoot_target = target or "HATS"
	self.ammo = 30

    self.party_original_x = {}
    self.enemy_original_x = {}

	self.party_offsets = {
		kris = {0, 0},
		susie = {0, 3},
		ralsei = {7, 0},
		ceroba = {-2, -3},
	}
	self.party_heart_offsets = {
		kris = {27+34, 33+12},
		susie = {27+49, 42},
		ralsei = {47+32, 50-3},
		ceroba = {74, 50},
	}	
	self.dont_advance_yet = false
	
    if self.shoot_target == "SOCKS" then
		Game.battle:battleText("* Everyone gets ready to knock the enemies' socks off!", function() self.state = "SHARPSHOOTBEGIN" end)
    else
        Game.battle:battleText("* Everyone gets ready to knock the enemies' hats off!", function() self.state = "SHARPSHOOTBEGIN" end)
    end
	for _,battler in ipairs(Game.battle.party) do
		battler:setActSprite(self:battlerGetSpriteAndOffset(battler.chara.id))
		local offset = self.party_heart_offsets[battler.chara.id] or {27+34, 33+12}
		battler.heart_point_x = battler.x-(battler.actor:getWidth()/2)*2+offset[1]
		battler.heart_point_y = battler.y-(battler.actor:getHeight())*2+offset[2]
	end
	Assets.playSound("boost")
end
	
function ShadowguySharpshootAct:battlerGetSpriteAndOffset(id)
    local selected_sprite = "party/" .. id:lower() .. "/dark/battle/zoosuit"
    local selected_offset = self.party_offsets[id] or {0, 0}
    return selected_sprite, selected_offset[1], selected_offset[2]
end
	
function ShadowguySharpshootAct:handleSharpshootInit()
	self.cursor = SharpshootCursor(0, 240, self)
	Game.battle:addChild(self.cursor)
	for _,enemy in ipairs(Game.battle:getActiveEnemies()) do
		enemy.xx = enemy.x
		enemy.yy = enemy.y
		self:handleEnemyInit(enemy)
	end
end

function ShadowguySharpshootAct:handleSharpshootDone()
	for _,enemy in ipairs(Game.battle:getActiveEnemies()) do
		local last_anim = enemy.sprite.anim
		local last_frame = enemy.sprite.frame
		if enemy.sharpshootmercy and enemy.sharpshootmercy > 0 then
			enemy:addMercy(enemy.sharpshootmercy or 0)
		end
		enemy:setAnimation(last_anim)
		enemy.sprite:setFrame(last_frame)
		enemy.sharpshootmercy = 0
	end	
	Game.battle.battle_ui:clearEncounterText()
	for _,battler in ipairs(Game.battle.party) do
		battler:resetSprite()
	end
	if #Game.battle:getActiveEnemies() == 0 then
		Game.battle.timer:after(1/30, function()
			self.state = "SHARPSHOOTEND"
		end)
	else
		Game.battle.timer:after(21/30, function()
			if not self.dont_advance_yet then
				self.state = "SHARPSHOOTEND"
			end
		end)
	end
	self.state = "SHARPSHOOTENDING"
end

function ShadowguySharpshootAct:handleEnemyInit(enemy)
	if enemy.id == "shadowguy" then
		local darken_fx = enemy:addFX(RecolorFX())
		enemy._darken_fx = darken_fx
		Game.battle.timer:tween(0.7, darken_fx, {color = {0.45, 0.45, 0.45}})
        if enemy.shoot_target == "HATS" then   -- hat
            enemy:setAnimation("idle_nothat")
            local hat = SharpshootTarget("npcs/shadowguy/idle_hat", 0, 0)
			hat:setScale(2)
			hat:setHitbox(20, 4, 20, 12)
			hat.visible = false
			hat.rotation_origin_x = 0.5
			hat.rotation_origin_y = 0.5
			hat.type = "shadowguy_hat"
			hat.rotation = 0
            hat.hittable = true
            hat.spare = false
			if enemy:canSpare() then
				hat.spare = true
			end
            hat.sparehp = 9
            hat.visible = true
			hat.alpha = 1
            hat.enemy = enemy
			Utils.hook(hat, "update", function(orig, obj)
				orig(obj)
				
				if obj.hittable then
					local main = obj.enemy
					
					if main then
						local x, y = main:getRelativePos(0, 0, Game.battle)
						obj.x = x
						obj.y = y
						obj.sprite:setFrame(main.sprite.frame)
					end
				end
			end)
            Game.battle:addChild(hat)
        elseif enemy.shoot_target == "SOCKS" then   -- socks
            enemy:setAnimation("idle")
			local socks = SharpshootTarget("npcs/shadowguy/idle_socks", 0, 0)
			socks:setScale(2)
			socks:setHitbox(7, 49, 32, 9)
			socks.visible = false
			socks.rotation_origin_x = 0.5
			socks.rotation_origin_y = 0.5
			socks.type = "shadowguy_socks"
			socks.rotation = 0
            socks.hittable = true
            socks.spare = false
			if enemy:canSpare() then
				socks.spare = true
			end
            socks.sparehp = 9
            socks.visible = true
			socks.alpha = 1
            socks.enemy = enemy
			Utils.hook(socks, "update", function(orig, obj)
				orig(obj)
				
				if obj.hittable then
					local main = obj.enemy
					
					if main then
						local x, y = main:getRelativePos(0, 0, Game.battle)
						obj.x = x
						obj.y = y
						obj.sprite:setFrame(main.sprite.frame)
					end
				end
			end)
            Game.battle:addChild(socks)
        end
	end
end

function ShadowguySharpshootAct:handleEnemyUpdate(enemy)
	if enemy.id == "shadowguy" then
		enemy.y = enemy.yy + math.sin(self.sharpshoot_timer / 15) * 50
		enemy.physics.speed_x = math.sin(enemy.fsiner / 12) * 2
		enemy.physics.speed_y = math.cos(enemy.fsiner / 12) * 2
	end
end

function ShadowguySharpshootAct:handleEnemyDone(enemy)
	if enemy.id == "shadowguy" then
		if enemy._darken_fx then
			Game.battle.timer:tween(0.7, enemy._darken_fx, {color = {1, 1, 1}}, nil, function()
				enemy:removeFX(enemy._darken_fx)
			end)
		end
		enemy.physics.speed_x = 0
		enemy.physics.speed_y = 0
		enemy:slideTo(enemy.xx, enemy.yy, 10/30)
		Game.battle.timer:after(10/30, function()
			enemy.x = enemy.xx
			enemy.y = enemy.yy
			if enemy.shoot_target == "HATS" and enemy.sprite.anim == "idle_bunny" then
				self.dont_advance_yet = true
				Assets.playSound("slidewhistle")
				local fallhat = ShadowguyHat(enemy, function()
					Game.battle.timer:after(1/30, function()
						self.state = "SHARPSHOOTEND"
					end)
				end)
				fallhat.layer = enemy.layer + 1
				Game.battle:addChild(fallhat)
			end
		end)
	end
end

function ShadowguySharpshootAct:update()
    super.update(self)
	if self.state == "SHARPSHOOTBEGIN" then
		self.state = "SHARPSHOOT"
		self:handleSharpshootInit()		
		Game.battle:infoText("* Aim with "..Input.getText("left")..Input.getText("right").." and "..Input.getText("up")..Input.getText("down").."!\n* Fire with "..Input.getText("menu").."!")
	end
	if self.state == "SHARPSHOOT" then
		self.sharpshoot_timer = self.sharpshoot_timer + DTMULT
		if self.sharpshoot_time > 0 and self.start_timer then
			self.sharpshoot_time = self.sharpshoot_time - DTMULT
		end
		if self.cursor then
			if self.cursor.fired_heart and not self.start_timer then
				self.start_timer = true
			end
		end
		local targets_hit = 0
		local end_act = true
		for _,enemy in ipairs(Game.battle:getActiveEnemies()) do
			if not enemy.sharpshoot_spared then
				end_act = false
			end
			self:handleEnemyUpdate(enemy)
			if self.cursor:isRemoved() or self.sharpshoot_time <= 0 or end_act then
				self:handleEnemyDone(enemy)
			end
		end
		if self.cursor:isRemoved() or self.sharpshoot_time <= 0 or end_act then
			self:handleSharpshootDone()
		end
	end
	if self.state == "SHARPSHOOTEND" then
		for _,target in ipairs(Game.stage:getObjects(SharpshootTarget)) do
			target:remove()
		end
		for _,enemy in ipairs(Game.battle:getActiveEnemies()) do
			enemy:resetSprite()
			if enemy:canSpare() or enemy.temporary_mercy + enemy.mercy >= 100 then
				enemy:onSpareable()
			end
		end
		Game.battle:finishAction()
		self:remove()
	end
end

function ShadowguySharpshootAct:drawStatus()
	if Game.tension >= 100 then -- recreate color bug
		love.graphics.setColor(1,1,0,1)
	else
		love.graphics.setColor(1,1,1,1)
	end
	love.graphics.setFont(self.font)
	love.graphics.print("AMMO", SCREEN_WIDTH/2-self.font:getWidth("AMMO")/2, 10)
	love.graphics.print(tostring(self.ammo).." x", SCREEN_WIDTH/2-15-self.font:getWidth(tostring(self.ammo).." x")/2, 43)
	love.graphics.setColor(1,1,1,1)
	Draw.draw(self.heart, SCREEN_WIDTH/2+26-10, 62-10)
    local b = 180 * (Utils.clamp((self.sharpshoot_time / 180) * 0.911, 0, 1))
	if self.sharpshoot_time > 0 then
		love.graphics.setColor(0,1,1,1)
		love.graphics.rectangle("fill", 240, 290, b, 10)
		love.graphics.setColor(1,1,1,1)
		Draw.draw(self.hourglass, 240-18, 295-18, 0, 2, 2)
	end
	love.graphics.setColor(1,1,1,1)
end

function ShadowguySharpshootAct:draw()
    super.draw(self)

    if self.state == "SHARPSHOOT" then self:drawStatus() end
end

return ShadowguySharpshootAct