local Cloud, super = Class(Bullet)

function Cloud:init(x, y)
    -- Last argument = sprite path
    super.init(self, x, y, "battle/bullets/balthizard/incense_cloud")
    --self:setHitbox(26, 21, 17, 10)
    self.destroy_on_hit = false
    self.scale_x = TableUtils.pick{1, -1}
    self.scale_y = TableUtils.pick{1, -1}
    self.current_angle = math.rad(0);
    self.rotate_ratio = math.rad(1);
    self.distance_goal = 120; --120
    self.distance = 120; --120
    self.individual_value = MathUtils.random(13);
    self.timer = 0;
    self.dietimer = 0;
    self.con = 0;
    self.type = 1;
    self.alpha1 = 0;
    self.alpha2 = 0;

    self.mas = nil
    self.masfx = nil
    self.remove_offscreen = false
    self.iinit = false

    self.fireeeeeee = 0
    self.firetimer = 0
    self.firecoderan = {false, false, false}
    self.fuzzy = false
    self.fireanim = {}
    self.fire_animated = false
    self.cloud_remove = false

    -- The cloud tries to deal a total of 5 damage / frame in 30 FPS
    -- This is eyeballed!!!! I couldnt find the original code
    self.inv_timer = 0.2/30
    self.regraze_timer = 0
    self.manager = nil -- Defined in cloud_manager
end

function Cloud:update()
    super.update(self)
    if(self.iinit == false) then
        local mas = self.wave:spawnBullet("balthizard/cloud_mask", Game.battle.arena.x, Game.battle.arena.y)
        self.mas = mas
        self.mas.wave_masked = true
        self.mas:addFX(MaskFX(self), "cloud_fx")
        self.iinit = true
    end

    if(self.fireeeeeee == 1) then
        self.firetimer = self.firetimer + DTMULT
        if(self.alpha <= 1) then
            self.alpha = self.alpha + 0.2 * DTMULT
        end
        if(self.fuzzy == false) then
            self.sprite:setSprite("battle/bullets/balthizard/could_fuzzy2")
            self.sprite:play(0.5, true)
            self.fuzzy = true
        end
        if(self.firetimer >= 1 and not self.firecoderan[1]) then
           Assets.stopSound("wing")
           Assets.playSound("wing", 2)
           self.firecoderan[1] = true
        end
        if(self.firetimer >= 5 and not self.firecoderan[2]) then
            for i = 1, 4 do
                local dir = math.rad(0) + math.rad(MathUtils.random(180))
                local len = 10 + MathUtils.random(10)
                local fireanim = self.wave:spawnBullet("balthizard/fire_anim", -9999, -9999)
                self.fireanim[i] = fireanim
                self.fireanim[i].len = len
                self.fireanim[i].dir = dir
            end
            self.fire_animated = true
            self.firecoderan[2] = true
        end
        if(self.firetimer >= 15 and not self.firecoderan[3]) then
            self.destroyed_cloud = self.wave:spawnBullet("balthizard/cloud_destroyed", self.x, self.y)
            self.destroyed_cloud.scale_x = self.scale_x
            self.destroyed_cloud.scale_y = self.scale_y
            self.destroyed_cloud.rotation = self.rotation
            for i = 1, 4 do
                self.fireanim[i]:remove()
            end
            self.mas:removeFX("cloud_fx")
            self.mas:remove()
            self:remove()
            self.firecoderan[3] = true
        end
        if(self.fire_animated == true and self.cloud_remove == false) then
            for i = 1, 4 do
                self.fireanim[i].x = self.x + math.cos(self.fireanim[i].dir + self.rotation) * self.fireanim[i].len * DTMULT
                self.fireanim[i].y = self.y + math.sin(self.fireanim[i].dir + self.rotation) * self.fireanim[i].len * DTMULT
            end
        end
    end

    if self.grazed then
        self.regraze_timer = self.regraze_timer + DTMULT
        if self.regraze_timer >= 10 then
            self.grazed = false
            self.regraze_timer = 0
        end
    end
end

function Cloud:getBattlerTarget()
    local target = Game.battle:randomTargetOld()

    if isClass(target) and target:includes(PartyBattler) then
        -- Calculate the average HP of the party.
        -- This is "scr_party_hpaverage", which gets called multiple times in the original script.
        -- We'll only do it once here, just for the slight optimization. This won't affect accuracy.

        -- Speaking of accuracy, this function doesn't work at all!
        -- It contains a bug which causes it to always return 0, unless all party members are at full health.
        -- This is because of a random floor() call.
        -- I won't bother making the code accurate; all that matters is the output.

        local party_average_hp = 1

        for _,battler in ipairs(Game.battle.party) do
            if battler.chara:getHealth() ~= battler.chara:getStat("health") then
                party_average_hp = 0
                break
            end
        end

        -- Retarget... twice.
        if target.chara:getHealth() / target.chara:getStat("health") < (party_average_hp / 2) then
            target = Game.battle:randomTargetOld()
        end
        if target.chara:getHealth() / target.chara:getStat("health") < (party_average_hp / 2) then
            target = Game.battle:randomTargetOld()
        end

        -- If we landed on Kris (or, well, the first party member), and their health is low, retarget (plot armor lol)
        if (target == Game.battle.party[1]) and ((target.chara:getHealth() / target.chara:getStat("health")) < 0.35) then
            target = Game.battle:randomTargetOld()
        end

        -- They got hit, so un-darken them
        target.should_darken = false
        target.targeted = true
    end

    return target
end

function Cloud:onDamage(soul)
    if Game.pp > 0 then
		for i = 1, math.max(DT / self.inv_timer, 1) do
			Game.pp = Game.pp - 0.02
		end

		soul.inv_timer = self.inv_timer

		if self.manager then
			self.manager.hurt_notify_timer = self.manager.hurt_notify_timer - DTMULT
			if self.manager.hurt_notify_timer <= 0 then
				self.manager.hurt_notify_timer = 5
				Assets.playSound("break1", 1, 1.2)
			end
		end
		if Game.pp <= 0 then
			Game.battle:breakSoulShield()
		end
    else
		for i = 1, math.max(DT / self.inv_timer, 1) do
			local battler = self:getBattlerTarget()
			if battler.chara:getHealth() > 1 then
				battler.chara:setHealth(battler.chara:getHealth() - 1)
			else
				Game.battle:hurt(1, false, battler, self:shouldSwoon(1, battler, soul))
			end
		end

		soul.inv_timer = self.inv_timer

		if self.manager then
			self.manager.hurt_notify_timer = self.manager.hurt_notify_timer - DTMULT
			if self.manager.hurt_notify_timer <= 0 then
				self.manager.hurt_notify_timer = 20
				Assets.playSound("hurt")
				Game.battle.camera:shake(4)
			end
		end
	end

    -- This should return all battlers that were hit
    -- But I checked the code and it doesn't seem like this is
    -- even used for anything
    return {}
end

return Cloud